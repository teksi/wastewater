from __future__ import annotations

import logging
from collections.abc import (
    Callable,
)
from dataclasses import (
    dataclass,
    field,
)

from sqlalchemy.orm import Session
from teksi_hooks.capabilities.effects import (
    QuarantineEffectProjectorCapability,
)
from teksi_hooks.exceptions import (
    EffectValidationError,
)
from teksi_hooks.models.effects import (
    EffectDocument,
    EffectEvaluationResult,
    EffectEvaluationStatus,
    EffectProjectionResult,
)
from teksi_hooks.models.validation import (
    ValidationFinding,
)
from teksi_wastewater.hooks.capabilities.incremental_import import (
    IncrementalEffectEvaluator,
    IncrementalEffectPersister,
)
from teksi_wastewater.interlis import (
    model_selection,
)
from teksi_wastewater.interlis.utils.various import (
    InterlisImporterExporterError,
)

logger = logging.getLogger(
    __name__,
)


@dataclass(
    slots=True,
)
class InterlisIncrementalImporter:
    """
    Import prepared AGXX quarantine data into canonical live tables.

    Source rows have already been prepared according to persisted review
    decisions:

    - forbidden created rows have been removed;
    - forbidden non-mandatory update attributes have been set to NULL;
    - permitted source values remain available for persistence.

    Projection is delegated completely to a
    ``QuarantineEffectProjectorCapability``. The projector is responsible for:

    - resolving quarantine source relations;
    - loading source objects;
    - applying declarative mappings;
    - resolving source foreign keys;
    - applying canonical-view projections;
    - returning exactly one source-aligned effect document per projected
      source object.

    Processing occurs in two phases:

    1. Project and evaluate every selected source object.
    2. Persist all evaluated documents only when no blocked effect exists.

    This ensures that no live changes are staged when any projected effect is
    blocked.

    The caller owns the live SQLAlchemy session. The importer does not create,
    commit, roll back or close it.
    """

    model: str

    quarantine_effect_projector: QuarantineEffectProjectorCapability

    effect_evaluator: IncrementalEffectEvaluator

    effect_persister: IncrementalEffectPersister

    session_tww: Session | None = field(
        repr=False,
    )

    callback_progress_done: (
        Callable[
            [],
            None,
        ]
        | None
    ) = None

    model_groups: frozenset[str,] = field(
        default_factory=frozenset,
        init=False,
    )

    effect_documents: list[EffectDocument,] = field(
        default_factory=list,
        init=False,
        repr=False,
    )

    evaluation_results: list[EffectEvaluationResult,] = field(
        default_factory=list,
        init=False,
        repr=False,
    )

    pending_effects: list[
        tuple[
            EffectDocument,
            tuple[
                EffectEvaluationResult,
                ...,
            ],
        ],
    ] = field(
        default_factory=list,
        init=False,
        repr=False,
    )

    def __post_init__(
        self,
    ) -> None:
        """
        Resolve and validate the configured incremental model group.
        """
        self.model_groups = frozenset(
            model_selection.groups_for_models(
                self.model,
            )
        )

        incremental_groups = self.model_groups & {
            "ag64",
            "ag96",
        }

        if not incremental_groups:
            raise InterlisImporterExporterError(
                "INTERLIS import aborted",
                ("No incremental import exists for selected " f"model {self.model!r}."),
                None,
            )

        if (
            len(
                incremental_groups,
            )
            != 1
        ):
            raise InterlisImporterExporterError(
                "INTERLIS import aborted",
                (
                    "Incremental import requires exactly one "
                    "AGXX model group. Resolved groups: "
                    f"{sorted(incremental_groups)!r}."
                ),
                None,
            )

    def import_data(
        self,
    ) -> None:
        """
        Project, evaluate and stage one incremental import.

        Projection and evaluation complete before any effects are persisted.
        The caller owns transaction completion.
        """
        self._reset_results()

        source_class_ids = self._source_class_ids()

        try:
            projection_result = self.quarantine_effect_projector.project_effects(
                source_model=self.model,
                source_class_ids=source_class_ids,
            )
        except EffectValidationError:
            raise
        except InterlisImporterExporterError:
            raise
        except Exception as exception:
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Could not project the prepared AGXX "
                    "quarantine data into canonical effects: "
                    f"{exception}"
                ),
                None,
            ) from exception

        self._evaluate_projection_result(
            projection_result,
        )

        self._raise_if_blocked()

        self._persist_pending_effects()

        self._require_live_session().flush()

    def _source_class_ids(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return supported source classes for the selected AGXX model group.

        Class order is significant. The quarantine projector retains this
        order in its projection result.
        """
        if "ag96" in self.model_groups:
            return (
                "GepMassnahme",
                "GepKnoten",
                "GepHaltung",
                "Einzugsgebiet",
                "BautenAusserhalbBaugebiet",
                "Ueberlauf_Foerderaggregat",
                "SBWEinzugsgebiet",
                "VersickerungsbereichAG",
            )

        if "ag64" in self.model_groups:
            return (
                "GepKnoten",
                "GepHaltung",
                "Ueberlauf_Foerderaggregat",
            )

        raise InterlisImporterExporterError(
            "INTERLIS import aborted",
            ("The selected model does not resolve to an " "AG64 or AG96 incremental import."),
            None,
        )

    def _evaluate_projection_result(
        self,
        projection_result: EffectProjectionResult,
    ) -> None:
        """
        Evaluate all documents returned by quarantine projection.

        The projection result guarantees positional alignment between source
        objects and documents. Progress is reported once for every projected
        source object, including source objects whose documents contain no
        effects.
        """
        if len(
            projection_result.documents,
        ) != len(
            projection_result.source_objects,
        ):
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Quarantine projection returned "
                    f"{len(projection_result.documents)} effect "
                    "documents for "
                    f"{len(projection_result.source_objects)} "
                    "source objects."
                ),
                None,
            )

        for (
            source_object,
            document,
        ) in zip(
            projection_result.source_objects,
            projection_result.documents,
            strict=True,
        ):
            del source_object

            self._stage_effect_document(
                document,
            )

            self._check_for_stop()

    def _stage_effect_document(
        self,
        document: EffectDocument,
    ) -> None:
        """
        Evaluate and stage one non-empty effect document.

        No live changes are written until every projected document has been
        evaluated and blocked effects have caused the import to fail.
        """
        if not document.effects:
            return

        evaluations = tuple(
            self.effect_evaluator.evaluate(
                session=self._require_live_session(),
                document=document,
            )
        )

        self._assert_complete_evaluation(
            document=document,
            evaluations=evaluations,
        )

        self.effect_documents.append(
            document,
        )

        self.evaluation_results.extend(
            evaluations,
        )

        self.pending_effects.append(
            (
                document,
                evaluations,
            )
        )

    def _assert_complete_evaluation(
        self,
        *,
        document: EffectDocument,
        evaluations: tuple[
            EffectEvaluationResult,
            ...,
        ],
    ) -> None:
        """
        Require exactly one correctly indexed result per effect.
        """
        if len(
            evaluations,
        ) != len(
            document.effects,
        ):
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Effect evaluation returned "
                    f"{len(evaluations)} results for "
                    f"{len(document.effects)} effects in source "
                    f"{document.source.model!r}."
                    f"{document.source.class_id!r}."
                    f"{document.source.object_id!r}."
                ),
                None,
            )

        expected_indices = tuple(
            range(
                len(
                    document.effects,
                )
            )
        )

        actual_indices = tuple(evaluation.effect_index for evaluation in evaluations)

        if actual_indices != expected_indices:
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Effect evaluation result indices do not "
                    "match document order for source "
                    f"{document.source.model!r}."
                    f"{document.source.class_id!r}."
                    f"{document.source.object_id!r}. Expected "
                    f"{expected_indices!r}, received "
                    f"{actual_indices!r}."
                ),
                None,
            )

    def _raise_if_blocked(
        self,
    ) -> None:
        """
        Raise a finding-backed error if any projected effect is blocked.
        """
        blocked_results = tuple(
            evaluation
            for evaluation in self.evaluation_results
            if (evaluation.status == EffectEvaluationStatus.BLOCKED)
        )

        if not blocked_results:
            return

        findings: list[ValidationFinding,] = []

        for evaluation in blocked_results:
            findings.extend(
                evaluation.findings,
            )

        if findings:
            raise EffectValidationError(
                tuple(
                    findings,
                )
            )

        raise InterlisImporterExporterError(
            "Incremental import aborted",
            (
                f"{len(blocked_results)} blocked effect "
                "evaluations did not provide validation "
                "findings."
            ),
            None,
        )

    def _persist_pending_effects(
        self,
    ) -> None:
        """
        Persist all evaluated documents in the caller-owned live transaction.

        This method runs only after every projected effect has been evaluated
        and no blocked result remains.
        """
        live_session = self._require_live_session()

        for (
            document,
            evaluations,
        ) in self.pending_effects:
            self.effect_persister.persist_effects(
                session=live_session,
                document=document,
                evaluations=evaluations,
            )

    def _reset_results(
        self,
    ) -> None:
        """
        Reset transient results before starting an import.
        """
        self.effect_documents.clear()
        self.evaluation_results.clear()
        self.pending_effects.clear()

    def _require_live_session(
        self,
    ) -> Session:
        """
        Return the initialized caller-owned live session.
        """
        if self.session_tww is None:
            raise RuntimeError("The incremental live session is not initialized.")

        return self.session_tww

    def _check_for_stop(
        self,
    ) -> None:
        """
        Report progress after processing one projected source object.
        """
        if self.callback_progress_done is not None:
            self.callback_progress_done()
