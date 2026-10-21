from __future__ import annotations

import logging
from collections.abc import Callable
from dataclasses import dataclass, field
from typing import Any

from sqlalchemy import text
from sqlalchemy.orm import Session

from teksi_hooks.capabilities.mapping import (
    ModelMappingLookupCapability,
)
from teksi_hooks.exceptions import (
    EffectValidationError,
)
from teksi_hooks.models.canonical_object import (
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    EffectDocument,
    EffectEvaluationResult,
    EffectEvaluationStatus,
    EffectSource,
    UpdateAttributeEffect,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
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
    Import prepared AGXX quarantine data into canonical live tables.

    Source rows have already been prepared according to the persisted review
    decisions:

    - forbidden created rows have been removed;
    - forbidden non-mandatory update attributes have been set to NULL;
    - permitted source values remain available for persistence.

    The effective model mapping determines whether one source class uses:

    - ordinary declarative attribute mappings;
    - a function-backed effect document.

    Both mapping paths produce canonical effect documents.

    Processing occurs in two phases:

    1. Project and evaluate every effect document.
    2. Persist all remediable effects only when no blocked effect exists.

    The importer does not use writable AGXX compatibility views or their
    INSTEAD OF triggers.

    The quarantine runner owns the quarantine and live SQLAlchemy sessions.

    The importer temporarily borrows those sessions while projecting,
    evaluating, and staging effects. It does not create, commit, roll back, or
    close either session.

    """

    model: str

    model_classes_interlis: Any

    model_mapping: ModelMappingLookupCapability

    function_effect_resolver: FunctionEffectResolver

    effect_evaluator: IncrementalEffectEvaluator

    effect_persister: IncrementalEffectPersister

    session_interlis: Session= field(
        repr=False,
    )

    session_tww: Session = field(
        repr=False,
    )

    callback_progress_done: (
        Callable[
            [],
            None,
        ]
        | None
    ) = None

    filter_nulls: bool = True

    model_groups: frozenset[
        str,
    ] = field(
        default_factory=frozenset,
        init=False,
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

    def import_data(
        self,
    ) -> None:
        """
        Project, evaluate, and stage one incremental import.

        Both sessions are owned by the caller.
        """

        try:
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

            self.session_tww.flush()

        finally:
            # Release only the borrowed references.
            #
            # The runner still owns both sessions and remains responsible for
            # commit, rollback, and closure.
            self.session_interlis = None
            self.session_tww = None

    def _reset_results(
        self,
    ) -> None:
        """
        Reset transient results before starting an import.
        """

        self.effect_documents.clear()
        self.evaluation_results.clear()
        self.pending_effects.clear()

    def _import_ag96(
        self,
    ) -> None:
        """
        Import supported AG96 source classes.
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
            source_class_id=(
                "BautenAusserhalbBaugebiet"
            ),
            orm_class_name=(
                "bautenausserhalbbaugebiet"
            ),
        )

        self._import_source_class(
            source_class_id=(
                "Ueberlauf_Foerderaggregat"
            ),
            orm_class_name=(
                "ueberlauf_foerderaggregat"
            ),
        )

        self._import_source_class(
            source_class_id="SBWEinzugsgebiet",
            orm_class_name="sbw_einzugsgebiet",
        )

        self._import_source_class(
            source_class_id=(
                "VersickerungsbereichAG"
            ),
            orm_class_name=(
                "versickerungsbereichag"
            ),
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
            source_class_id=(
                "Ueberlauf_Foerderaggregat"
            ),
            orm_class_name=(
                "ueberlauf_foerderaggregat"
            ),
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

        logger.info(
            "Importer received identities for source class %r: %r.",
            source_class_id,
            {
                canonical_class_id: {
                    "source_attribute": (
                        identity.source_attribute
                    ),
                    "canonical_attribute": (
                        identity.canonical_attribute
                    ),
                }
                for (
                    canonical_class_id,
                    identity,
                ) in class_mapping.identities.items()
            },
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

        self._project_direct_mapped_row(
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
        Resolve and stage one function-backed source row.
        """

        document = (
            self.function_effect_resolver
            .resolve_effects(
                source_class_id=source_class_id,
                source_row=source_row,
                session=(
                    self._require_interlis_session()
                ),
                class_mapping=class_mapping,
            )
        )

        self._assert_effect_source(
            source_class_id=source_class_id,
            source_row=source_row,
            document=document,
        )

        self._stage_effect_document(
            document,
        )

    def _project_direct_mapped_row(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        class_mapping: ClassMapping,
    ) -> None:
        """
        Project one declaratively mapped source row to canonical effects.

        Null source values are omitted when ``filter_nulls`` is enabled. This
        excludes attributes neutralized by quarantine preparation.

        Direct internal ili2pg foreign keys are rejected. They must already
        have been resolved during projection or handled through function-backed
        mappings.
        """

        effects: list[
            UpdateAttributeEffect,
        ] = []

        identities_by_target_class: dict[
            str,
            CanonicalObjectIdentity,
        ] = {}

        for (
            source_attribute_id,
            attribute_mapping,
        ) in class_mapping.attributes.items():
            canonical_attribute_id = (
                attribute_mapping.canonical_attr_id
            )

            if canonical_attribute_id is None:
                continue

            target_class_id = (
                attribute_mapping.canonical_class_id
                or class_mapping.canonical_class_id
            )

            if target_class_id is None:
                raise InterlisImporterExporterError(
                    "Incremental import aborted",
                    (
                        "No canonical target class is defined "
                        f"for {source_class_id!r}."
                        f"{source_attribute_id!r}."
                    ),
                    None,
                )

            identity = (
                identities_by_target_class.get(
                    target_class_id,
                )
            )

            if identity is None:
                identity = self._canonical_identity(
                    source_class_id=source_class_id,
                    source_row=source_row,
                    class_mapping=class_mapping,
                    target_class_id=target_class_id,
                )

                identities_by_target_class[
                    target_class_id
                ] = identity

            source_value = self._source_attribute_value(
                source_class_id=source_class_id,
                source_row=source_row,
                source_attribute_id=(
                    source_attribute_id
                ),
            )

            if (
                source_value is None
                and self.filter_nulls
            ):
                continue

            canonical_value = (
                self._canonical_attribute_value(
                    source_class_id=source_class_id,
                    source_attribute_id=(
                        source_attribute_id
                    ),
                    source_value=source_value,
                    attribute_mapping=(
                        attribute_mapping
                    ),
                )
            )

            effects.append(
                UpdateAttributeEffect(
                    identity=identity,
                    attribute_id=(
                        canonical_attribute_id
                    ),
                    value=canonical_value,
                )
            )

        if not effects:
            return

        document = EffectDocument(
            source=EffectSource(
                model=self.model,
                class_id=source_class_id,
                object_id=self._source_object_id(
                    source_row,
                ),
            ),
            effects=tuple(
                effects,
            ),
        )

        self._stage_effect_document(
            document,
        )

    def _stage_effect_document(
        self,
        document: EffectDocument,
    ) -> None:
        """
        Evaluate and stage one effect document.

        Direct and function-backed mappings share this path. No live writes are
        performed until all source rows have been projected and no blocked
        evaluations remain.
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

    def _persist_pending_effects(
        self,
    ) -> None:
        """
        Stage all projected effect documents in the live transaction.

        This method is called only after all documents have been evaluated and
        blocked effects have caused the import to fail.
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

    def _canonical_identity(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        class_mapping: ClassMapping,
        target_class_id: str,
    ) -> CanonicalObjectIdentity:
        """
        Build the canonical identity for one declarative target class.
        """

        identity_mapping = (
            class_mapping.identities.get(
                target_class_id,
            )
        )

        if identity_mapping is None:
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "No canonical identity mapping exists for "
                    f"source class {source_class_id!r} and "
                    f"target class {target_class_id!r}."
                ),
                None,
            )

        source_identity_value = (
            self._source_attribute_value(
                source_class_id=source_class_id,
                source_row=source_row,
                source_attribute_id=(
                    identity_mapping.source_attribute
                ),
            )
        )

        if source_identity_value is None:
            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Source identity attribute "
                    f"{identity_mapping.source_attribute!r} "
                    "is NULL for source class "
                    f"{source_class_id!r} and canonical target "
                    f"{target_class_id!r}."
                ),
                None,
            )

        return CanonicalObjectIdentity(
            class_id=target_class_id,
            attributes={
                identity_mapping.canonical_attribute: (
                    source_identity_value
                ),
            },
        )

    def _source_attribute_value(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        source_attribute_id: str,
    ) -> Any:
        """
        Return one mapped source value from an ORM row.
        """

        if not hasattr(
            source_row,
            source_attribute_id,
        ):
            from sqlalchemy import inspect

            mapper = inspect(
                    type(
                        source_row,
                    )
                )

            available_attributes = tuple(
                sorted(
                    attribute.key
                    for attribute in mapper.column_attrs
                )
            )

            raise InterlisImporterExporterError(
                "Incremental import aborted",
                (
                    "Source row for class "
                    f"{source_class_id!r} does not expose mapped "
                    f"attribute {source_attribute_id!r}. Available "
                    f"mapped attributes: {available_attributes!r}."
                ),
                None,
            )

        return getattr(
            source_row,
            source_attribute_id,
        )

    def _canonical_attribute_value(
        self,
        *,
        source_class_id: str,
        source_attribute_id: str,
        source_value: Any,
        attribute_mapping: AttributeMapping,
    ) -> Any:
        """
        Convert one direct source value to its canonical representation.

        Ordinary values pass through unchanged. Configured value mappings
        replace source codes with canonical values.

        Integer foreign-key values are internal ili2pg ``t_id`` references and
        may not be written directly into canonical identity attributes.
        """

        if source_value is None:
            return None

        if attribute_mapping.foreign_key is not None:
            return self._canonical_foreign_key_value(
                source_class_id=source_class_id,
                source_attribute_id=(
                    source_attribute_id
                ),
                source_value=source_value,
            )

        value_mapping = (
            self.model_mapping.try_value_mapping(
                source_class_id,
                source_attribute_id,
                str(
                    source_value,
                ),
            )
        )

        if value_mapping is None:
            value_mapping = (
                attribute_mapping.values.get(
                    str(
                        source_value,
                    )
                )
            )

        if value_mapping is None:
            return source_value

        return value_mapping.canonical_value_id

    def _canonical_foreign_key_value(
        self,
        *,
        source_class_id: str,
        source_attribute_id: str,
        source_value: Any,
    ) -> Any:
        """
        Return a canonical direct foreign-key value.

        Non-integer values are already external or canonical identifiers and
        pass through unchanged.

        Integer values are ili2pg ``t_id`` references and cannot be written to
        canonical identity attributes without source-reference resolution.
        """

        if source_value is None:
            return None

        if not isinstance(
            source_value,
            int,
        ):
            return source_value

        raise InterlisImporterExporterError(
            "Incremental import aborted",
            (
                "Direct incremental attribute mapping produced "
                "an unresolved ili2pg foreign key for "
                f"{source_class_id!r}."
                f"{source_attribute_id!r}: "
                f"t_id={source_value!r}. The relation must be "
                "resolved during projection or handled through "
                "a function-backed mapping."
            ),
            None,
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
                    f"source class "
                    f"{document.source.class_id!r}; expected "
                    f"{source_class_id!r}."
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
                    f"source object "
                    f"{document.source.object_id!r}; expected "
                    f"{expected_object_id!r}."
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
                    "Effect evaluation result indices do not "
                    "match document order. Expected "
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
            for evaluation
            in self.evaluation_results
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
                f"{len(blocked_results)} blocked effect "
                "evaluations did not provide validation "
                "findings."
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

        if (
            not isinstance(
                resolved,
                str,
            )
            or not resolved.strip()
        ):
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

        if isinstance(
            self.model_classes_interlis,
            dict,
        ):
            source_class = (
                self.model_classes_interlis.get(
                    orm_class_name,
                )
            )

        else:
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

        return self._require_interlis_session().query(
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
                "The incremental quarantine session is not "
                "initialized."
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
                "The incremental live session is not "
                "initialized."
            )

        return self.session_tww

    def _check_for_stop(
        self,
    ) -> None:
        """
        Report progress after processing one incremental source row.
        """

        if self.callback_progress_done is not None:
            self.callback_progress_done()