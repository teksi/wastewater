# teksi_wastewater/interlis/interlis_model_mapping/
# interlis_incremental_importer.py

from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass, field
import logging
from typing import Any

from sqlalchemy import text
from sqlalchemy.orm import Session

from teksi_hooks.capabilities.mapping import (
    ModelMappingLookupCapability,
)
from teksi_hooks.exceptions import (
    EffectValidationError,
)
from teksi_hooks.models.effects import (
    EffectDocument,
    EffectEvaluationResult,
    EffectEvaluationStatus,
)
from teksi_hooks.models.mapping import (
    ClassMapping,
)
from teksi_hooks.models.validation import (
    ValidationFinding,
)

from teksi_wastewater.hooks.capabilities.incremental_import import (
    FunctionEffectResolver,
    IncrementalEffectEvaluator,
    IncrementalEffectPersister,
)
from teksi_wastewater.interlis import (
    model_selection,
    utils,
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
    Import prepared AGXX quarantine data directly into canonical live tables.

    Source rows have already been filtered according to provider rights.
    Forbidden created rows have been removed and forbidden update attributes
    have been set to NULL.

    The effective model mapping determines whether a source class uses direct
    declarative mapping or a function-backed effect document.

    Function-backed source rows are processed in two phases:

    1. Resolve and evaluate all effect documents.
    2. Persist all effect documents only if none contains blocked effects.

    The importer does not use writable AGXX compatibility views or their
    INSTEAD OF triggers.
    """

    model: str

    model_classes_interlis: Any

    model_classes_tww_od: Any

    model_classes_tww_vl: Any

    model_classes_tww_app: Any

    model_mapping: ModelMappingLookupCapability

    function_effect_resolver: FunctionEffectResolver

    effect_evaluator: IncrementalEffectEvaluator

    effect_persister: IncrementalEffectPersister

    callback_progress_done: Callable[
        [],
        None,
    ] | None = None

    filter_nulls: bool = True

    model_groups: frozenset[
        str,
    ] = field(
        default_factory=frozenset,
        init=False,
    )

    session_interlis: Session | None = field(
        default=None,
        init=False,
        repr=False,
    )

    session_tww: Session | None = field(
        default=None,
        init=False,
        repr=False,
    )

    effect_documents: list[
        EffectDocument,
    ] = field(
        default_factory=list,
        init=False,
        repr=False,
    )

    evaluation_results: list[
        EffectEvaluationResult,
    ] = field(
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

        incremental_groups = (
            self.model_groups
            & {
                "ag64",
                "ag96",
            }
        )

        if not incremental_groups:
            raise InterlisImporterExporterError(
                "INTERLIS import aborted",
                (
                    "No incremental import exists for selected "
                    f"model {self.model!r}."
                ),
                None,
            )

        if len(
            incremental_groups,
        ) != 1:
            raise InterlisImporterExporterError(
                "INTERLIS import aborted",
                (
                    "Incremental import requires exactly one AGXX "
                    "model group. Resolved groups: "
                    f"{sorted(incremental_groups)!r}."
                ),
                None,
            )

        if self.model_classes_tww_app is None:
            raise InterlisImporterExporterError(
                "INTERLIS import aborted",
                (
                    "Incremental AGXX import requires the "
                    "TWW AG64/96 application ORM model."
                ),
                None,
            )

    def tww_import(
        self,
        *,
        skip_closing_tww_session: bool = False,
    ) -> None:
        """
        Stage one incremental import.

        When ``skip_closing_tww_session`` is true, the live session remains
        open and uncommitted for the caller.

        The quarantine session is always closed before this method returns
        successfully.

        If processing fails, both sessions are rolled back or closed where
        applicable.
        """

        try:
            self._tww_import(
                skip_closing_tww_session=(
                    skip_closing_tww_session
                ),
            )

        except Exception:
            self._cleanup_after_failure()
            raise

    def _tww_import(
        self,
        *,
        skip_closing_tww_session: bool,
    ) -> None:
        """
        Initialize sessions and execute the selected AGXX import.
        """

        self._reset_results()

        engine = (
            utils.tww_sqlalchemy.create_engine()
        )

        self.session_interlis = Session(
            engine,
            autocommit=False,
            autoflush=False,
        )

        self.session_tww = Session(
            engine,
            autocommit=False,
            autoflush=False,
        )

        self.session_tww.execute(
            text(
                "SET CONSTRAINTS ALL DEFERRED;"
            )
        )

        if "ag96" in self.model_groups:
            self._import_ag96()

        elif "ag64" in self.model_groups:
            self._import_ag64()

        else:
            raise InterlisImporterExporterError(
                "INTERLIS import aborted",
                (
                    "The selected model does not resolve to an "
                    "AG64 or AG96 incremental import."
                ),
                None,
            )

        self._raise_if_blocked()

        self._persist_pending_effects()

        self._require_live_session().flush()

        self.close_sessions(
            skip_closing_tww_session=(
                skip_closing_tww_session
            ),
        )

    def _reset_results(
        self,
    ) -> None:
        """
        Reset transient results before starting an import.

        One importer instance is normally used for a single import, but
        clearing these values avoids carrying stale results if it is reused.
        """

        self.effect_documents.clear()
        self.evaluation_results.clear()
        self.pending_effects.clear()

    def _import_ag96(
        self,
    ) -> None:
        """
        Import supported AG96 source classes.

        Function-backed source classes can be enabled immediately. Directly
        mapped source classes require implementation of the direct mapping
        persistence path.
        """

        self._import_source_class(
            source_class_id="GepMassnahme",
            orm_class_name="gepmassnahme",
        )

        self._import_source_class(
            source_class_id="GepKnoten",
            orm_class_name="abwasserbauwerk",
        )

        self._import_source_class(
            source_class_id="GepHaltung",
            orm_class_name="haltung",
        )

        self._import_source_class(
            source_class_id="Einzugsgebiet",
            orm_class_name="einzugsgebiet",
        )

        self._import_source_class(
            source_class_id="BautenAusserhalbBaugebiet",
            orm_class_name="bautenausserhalbbaugebiet",
        )

        self._import_source_class(
            source_class_id="Ueberlauf_Foerderaggregat",
            orm_class_name="ueberlauf_foerderaggregat",
        )

        self._import_source_class(
            source_class_id="SBWEinzugsgebiet",
            orm_class_name="sbw_einzugsgebiet",
        )

        self._import_source_class(
            source_class_id="VersickerungsbereichAG",
            orm_class_name="versickerungsbereichag",
        )

    def _import_ag64(
        self,
    ) -> None:
        """
        Import supported AG64 source classes.
        """

        self._import_source_class(
            source_class_id="GepKnoten",
            orm_class_name="abwasserbauwerk",
        )

        self._import_source_class(
            source_class_id="GepHaltung",
            orm_class_name="haltung",
        )

        self._import_source_class(
            source_class_id="Ueberlauf_Foerderaggregat",
            orm_class_name="ueberlauf_foerderaggregat",
        )

    def _import_source_class(
        self,
        *,
        source_class_id: str,
        orm_class_name: str,
    ) -> None:
        """
        Import all quarantine rows for one mapped source class.
        """

        source_class = self._source_class(
            orm_class_name,
        )

        class_mapping = (
            self.model_mapping.class_definition(
                source_class_id,
            )
        )

        for source_row in self._source_rows(
            source_class,
        ):
            self._import_source_row(
                source_class_id=source_class_id,
                source_row=source_row,
                class_mapping=class_mapping,
            )

            self._check_for_stop()

    def _import_source_row(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        class_mapping: ClassMapping,
    ) -> None:
        """
        Project one declarative or function-backed source row.
        """

        if class_mapping.function is not None:
            self._project_function_mapped_row(
                source_class_id=source_class_id,
                source_row=source_row,
                class_mapping=class_mapping,
            )

            return

        self._import_direct_mapped_row(
            source_class_id=source_class_id,
            source_row=source_row,
            class_mapping=class_mapping,
        )

    def _project_function_mapped_row(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        class_mapping: ClassMapping,
    ) -> None:
        """
        Resolve and evaluate one function-backed source row.

        Persistence is deferred until all source rows have been evaluated and
        no blocked effects remain.
        """

        document = (
            self.function_effect_resolver
            .resolve_effects(
                source_class_id=source_class_id,
                source_row=source_row,
                class_mapping=class_mapping,
            )
        )

        self._assert_effect_source(
            source_class_id=source_class_id,
            source_row=source_row,
            document=document,
        )

        evaluations = tuple(
            self.effect_evaluator.evaluate(
                document,
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

    def _persist_pending_effects(
        self,
    ) -> None:
        """
        Stage all projected effect documents.

        This method is called only after all documents have been evaluated and
        blocked effects have caused the import to fail.
        """

        for (
            document,
            evaluations,
        ) in self.pending_effects:
            self.effect_persister.persist_effects(
                document=document,
                evaluations=evaluations,
            )

    def _import_direct_mapped_row(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        class_mapping: ClassMapping,
    ) -> None:
        """
        Import one declaratively mapped source row.

        Direct mapping must write directly to canonical TWW tables. It must
        not use legacy AGXX compatibility views or their INSTEAD OF triggers.
        """

        raise NotImplementedError(
            "Direct incremental mapping is not implemented for "
            f"source class {source_class_id!r}."
        )

    def _assert_effect_source(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        document: EffectDocument,
    ) -> None:
        """
        Require the effect document to describe the current source row.
        """

        expected_object_id = self._source_object_id(
            source_row,
        )

        if (
            document.source.class_id
            != source_class_id
        ):
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Function-backed effect document identifies "
                    f"source class {document.source.class_id!r}; "
                    f"expected {source_class_id!r}."
                ),
                None,
            )

        if (
            document.source.object_id
            != expected_object_id
        ):
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Function-backed effect document identifies "
                    f"source object {document.source.object_id!r}; "
                    f"expected {expected_object_id!r}."
                ),
                None,
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
                    f"{len(document.effects)} effects."
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

        actual_indices = tuple(
            evaluation.effect_index
            for evaluation in evaluations
        )

        if actual_indices != expected_indices:
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Effect evaluation result indices do not match "
                    "document order. Expected "
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
            if (
                evaluation.status
                == EffectEvaluationStatus.BLOCKED
            )
        )

        if not blocked_results:
            return

        findings: list[
            ValidationFinding,
        ] = []

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
                f"{len(blocked_results)} blocked effect evaluations "
                "did not provide validation findings."
            ),
            None,
        )

    def _source_object_id(
        self,
        source_row: Any,
    ) -> str:
        """
        Return the AG64 or AG96 source identity.
        """

        t_ili_tid = getattr(
            source_row,
            "t_ili_tid",
            None,
        )

        obj_id = getattr(
            source_row,
            "obj_id",
            None,
        )

        resolved = (
            t_ili_tid
            or obj_id
        )

        if not isinstance(
            resolved,
            str,
        ) or not resolved.strip():
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "AGXX source row does not contain a valid "
                    "t_ili_tid or obj_id."
                ),
                None,
            )

        return resolved

    def _source_class(
        self,
        orm_class_name: str,
    ) -> Any:
        """
        Return one quarantine ORM class.
        """

        source_class = getattr(
            self.model_classes_interlis,
            orm_class_name,
            None,
        )

        if source_class is None:
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "The quarantine ORM model does not expose "
                    f"class {orm_class_name!r}."
                ),
                None,
            )

        return source_class

    def _source_rows(
        self,
        source_class: Any,
    ):
        """
        Return source rows for one quarantine ORM class.
        """

        session_interlis = (
            self._require_interlis_session()
        )

        return session_interlis.query(
            source_class,
        )

    def _require_interlis_session(
        self,
    ) -> Session:
        """
        Return the initialized quarantine session.
        """

        if self.session_interlis is None:
            raise RuntimeError(
                "The incremental quarantine session is not initialized."
            )

        return self.session_interlis

    def _require_live_session(
        self,
    ) -> Session:
        """
        Return the initialized live session.
        """

        if self.session_tww is None:
            raise RuntimeError(
                "The incremental live session is not initialized."
            )

        return self.session_tww

    def close_sessions(
        self,
        *,
        skip_closing_tww_session: bool = False,
    ) -> None:
        """
        Close the quarantine session and optionally commit the live session.

        When the live session remains open, ownership is transferred to the
        caller. The importer retains the session reference so the caller may
        retrieve it from ``session_tww``.
        """

        session_tww = (
            self._require_live_session()
        )

        session_interlis = (
            self._require_interlis_session()
        )

        try:
            if not skip_closing_tww_session:
                try:
                    session_tww.commit()

                except Exception:
                    session_tww.rollback()
                    raise

                finally:
                    session_tww.close()
                    self.session_tww = None

        finally:
            session_interlis.close()
            self.session_interlis = None

    def _cleanup_after_failure(
        self,
    ) -> None:
        """
        Roll back and close initialized sessions after failure.
        """

        if self.session_tww is not None:
            try:
                self.session_tww.rollback()

            except Exception:
                logger.exception(
                    "Could not roll back incremental live session."
                )

            try:
                self.session_tww.close()

            except Exception:
                logger.exception(
                    "Could not close incremental live session."
                )

            self.session_tww = None

        if self.session_interlis is not None:
            try:
                self.session_interlis.close()

            except Exception:
                logger.exception(
                    "Could not close incremental quarantine session."
                )

            self.session_interlis = None

    def _check_for_stop(
        self,
    ) -> None:
        """
        Report progress after processing one incremental source row.
        """

        if self.callback_progress_done is not None:
            self.callback_progress_done()