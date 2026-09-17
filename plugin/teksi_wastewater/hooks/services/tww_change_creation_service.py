from __future__ import annotations

from collections import defaultdict
from collections.abc import Mapping, Sequence
from dataclasses import dataclass, field, replace
from pathlib import Path
from typing import Any

from teksi_hooks.capabilities.canonical_object import (
    CanonicalGeometryCapability,
)
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.capabilities.relation_lookup import (
    RelationLookupCapability,
)
from teksi_hooks.evaluators.rights import (
    RightsEvaluationContext,
    RightsEvaluator,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    Effect,
    EffectDocument,
    EnforceExistsEffect,
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)
from teksi_hooks.models.persistence import (
    DiffJobMode,
)
from teksi_hooks.models.review import (
    ChangeCreationResult,
    PreparedSource,
)
from teksi_hooks.models.validation import (
    Change,
)
from teksi_hooks.services.change_builder import (
    ChangeBuilder,
)
from teksi_hooks.services.change_classifier import (
    ChangeClassifier,
)
from teksi_hooks.services.change_creation_protocols import (
    ChangeObjectProviderFactory,
    QuarantineEffectProjector,
)
from teksi_hooks.services.change_review_export import (
    ChangeReviewExportService,
)

from ...interlis import config
from ..adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
)
from ..adapters.tww_quarantine_runner import (
    TwwQuarantineRunner,
)
from ..adapters.tww_relation_lookup_adapter import (
    TwwRelationLookupAdapter,
)
from .tww_diff_schema_service import (
    TwwDiffSchemaService,
)


@dataclass(slots=True)
class TwwChangeCreationService:
    """
    Prepare and persist a TWW diff review job from imported wastewater data.

    Each invocation processes exactly one XTF source. A source has one of
    two roles:

    - ``base``;
    - ``incremental``.

    A base source with ``persist_job=False`` is imported, validated,
    projected and staged as a ``PreparedSource``. It is not persisted as a
    reviewable diff job.

    A subsequent incremental source with the same job identifier retrieves
    the prepared base source and overlays its effects. The combined changes
    are classified and persisted as one pending review job.

    A base-only workflow uses ``persist_job=True`` and is persisted directly
    as a pending review job.

    Accepted changes are applied to the live schema by a separate workflow.
    """

    connection_factory: DatabaseConnectionFactory

    canonical_metadata: CanonicalModelMetadata

    quarantine_runner: TwwQuarantineRunner = field(
        default_factory=TwwQuarantineRunner,
    )

    effect_projector: QuarantineEffectProjector | None = None

    change_builder: ChangeBuilder = field(
        default_factory=ChangeBuilder,
    )

    diff_schema_service: TwwDiffSchemaService = field(
        default_factory=TwwDiffSchemaService,
    )

    rights_evaluator: RightsEvaluator | None = None

    object_provider_factory: ChangeObjectProviderFactory | None = None

    live_relation_lookup: RelationLookupCapability | None = None

    def create_diff_job_from_xtf(
        self,
        *,
        job_id: str,
        job_mode: DiffJobMode,
        xtf_file: Path,
        rights_context: RightsEvaluationContext,
        orgs_path: Path | None = None,
        context: TwwInterlisContext | None = None,
        validation_log_path: Path | None = None,
        import_schema: str = config.IMPORT_SCHEMA,
        live_schema: str = config.TWW_OD_SCHEMA,
        metadata: Mapping[str, Any] | None = None,
    ) -> ChangeCreationResult:
        """
        Import and process one XTF workflow source.

        Workflow behavior is controlled through metadata.

        ``source_role``
            Either ``base`` or ``incremental``.

        ``persist_job``
            If false, stage the source as a prepared result. If true, persist
            the final result as a pending review job.
        """

        self._ensure_ready_for_diff_job()

        self._assert_supported_job_mode(
            job_mode,
        )

        workflow_metadata = self._workflow_metadata(
            job_id=job_id,
            job_mode=job_mode,
            rights_context=rights_context,
            import_schema=import_schema,
            live_schema=live_schema,
            metadata=metadata,
            source_file=xtf_file,
        )

        source_role = self._source_role(
            workflow_metadata,
        )

        persist_job = self._persist_job(
            workflow_metadata,
        )

        self._validate_workflow_transition(
            source_role=source_role,
            persist_job=persist_job,
        )

        import_context = self._import_context(
            context=context,
            schema=import_schema,
            orgs_path=orgs_path,
        )

        (
            import_model,
            created_models,
        ) = self.quarantine_runner.import_xtf_to_quarantine(
            xtf_file=xtf_file,
            context=import_context,
            schema=import_schema,
        )

        created_models = tuple(
            created_models,
        )

        self.quarantine_runner.validate_quarantine_or_raise(
            model_names=(import_model,),
            log_path=self._validation_log_path(
                validation_log_path=validation_log_path,
                xtf_file=xtf_file,
                name="validate_import_quarantine",
            ),
            schema=import_schema,
        )

        workflow_metadata.update(
            {
                "source_model": import_model,
                "created_models": list(
                    created_models,
                ),
            }
        )

        if orgs_path is not None:
            workflow_metadata["orgs_path"] = str(
                orgs_path,
            )

        return self.create_diff_job_from_quarantine(
            job_id=job_id,
            job_mode=job_mode,
            source_model=import_model,
            rights_context=rights_context,
            created_models=created_models,
            import_schema=import_schema,
            live_schema=live_schema,
            metadata=workflow_metadata,
        )

    def create_diff_job_from_quarantine(
        self,
        *,
        job_id: str,
        job_mode: DiffJobMode,
        source_model: str,
        rights_context: RightsEvaluationContext,
        created_models: Sequence[str,] = (),
        import_schema: str = config.IMPORT_SCHEMA,
        live_schema: str = config.TWW_OD_SCHEMA,
        metadata: (
            Mapping[
                str,
                Any,
            ]
            | None
        ) = None,
    ) -> ChangeCreationResult:
        """
        Process one populated quarantine source.

        A non-persisting base invocation stages its projected effect document.

        A persisting incremental invocation overlays its effects on the staged
        base document and writes one combined pending review job.

        A persisting base invocation writes a pending review job directly.

        Final job metadata contains explicit source-specific persistence inputs:

        - base_source_model;
        - base_import_schema;
        - base_mapping_model_id;
        - base_created_models;
        - incremental_source_model;
        - incremental_import_schema;
        - incremental_mapping_model_id;
        - incremental_created_models.
        """

        self._ensure_ready_for_diff_job()

        self._assert_supported_job_mode(
            job_mode,
        )

        workflow_metadata = self._workflow_metadata(
            job_id=job_id,
            job_mode=job_mode,
            rights_context=rights_context,
            import_schema=import_schema,
            live_schema=live_schema,
            metadata=metadata,
        )

        source_role = self._source_role(
            workflow_metadata,
        )

        persist_job = self._persist_job(
            workflow_metadata,
        )

        self._validate_workflow_transition(
            source_role=source_role,
            persist_job=persist_job,
        )

        source_document = self.effect_projector.effect_document_from_quarantine(
            schema=import_schema,
            source_model=source_model,
            canonical_metadata=(self.canonical_metadata),
        )

        created_models_tuple = tuple(
            created_models,
        )

        if source_role == "base":
            effect_document = source_document

            base_source_model = source_model
            base_import_schema = import_schema
            base_mapping_model_id = workflow_metadata.get(
                "mapping_model_id",
            )
            base_created_models = created_models_tuple

            incremental_source_model = None
            incremental_import_schema = None
            incremental_mapping_model_id = None
            incremental_created_models: tuple[
                str,
                ...,
            ] = ()

            workflow_metadata.update(
                {
                    "base_source_model": (base_source_model),
                    "base_import_schema": (base_import_schema),
                    "base_mapping_model_id": (base_mapping_model_id),
                    "base_created_models": list(
                        base_created_models,
                    ),
                    "incremental_source_model": None,
                    "incremental_import_schema": None,
                    "incremental_mapping_model_id": None,
                    "incremental_created_models": [],
                }
            )

        else:
            prepared_source = self.diff_schema_service.prepared_source(
                job_id=job_id,
            )

            base_metadata = dict(
                prepared_source.metadata,
            )

            base_import_schema = self._required_metadata_string(
                metadata=base_metadata,
                key="base_import_schema",
                fallback_key="import_schema",
            )

            base_source_model = self._required_metadata_string(
                metadata=base_metadata,
                key="base_source_model",
                fallback_value=(prepared_source.source_model),
            )

            base_mapping_model_id = base_metadata.get(
                "base_mapping_model_id",
                base_metadata.get(
                    "mapping_model_id",
                ),
            )

            base_created_models = tuple(
                base_metadata.get(
                    "base_created_models",
                    prepared_source.created_models,
                )
            )

            incremental_source_model = source_model
            incremental_import_schema = import_schema
            incremental_mapping_model_id = workflow_metadata.get(
                "mapping_model_id",
            )
            incremental_created_models = created_models_tuple

            effect_document = self._merge_effect_documents(
                base_document=(prepared_source.effect_document),
                incremental_document=(source_document),
            )

            workflow_metadata.update(
                {
                    "base_source_model": (base_source_model),
                    "base_import_schema": (base_import_schema),
                    "base_mapping_model_id": (base_mapping_model_id),
                    "base_created_models": list(
                        base_created_models,
                    ),
                    "incremental_source_model": (incremental_source_model),
                    "incremental_import_schema": (incremental_import_schema),
                    "incremental_mapping_model_id": (incremental_mapping_model_id),
                    "incremental_created_models": list(
                        incremental_created_models,
                    ),
                    "base_source_metadata": (base_metadata),
                }
            )

        if not persist_job:
            prepared_source = PreparedSource(
                source_model=source_model,
                created_models=(created_models_tuple),
                effect_document=(effect_document),
                metadata=dict(
                    workflow_metadata,
                ),
            )

            self.diff_schema_service.prepare_source(
                job_id=job_id,
                source=prepared_source,
            )

            return self._prepared_result(
                job_id=job_id,
                source_model=source_model,
                created_models=(created_models_tuple),
                effect_document=(effect_document),
                rights_context=rights_context,
                import_schema=import_schema,
                live_schema=live_schema,
                metadata=workflow_metadata,
            )

        result = self._persist_pending_job(
            job_id=job_id,
            job_mode=job_mode,
            effect_document=effect_document,
            rights_context=rights_context,
            import_schema=import_schema,
            live_schema=live_schema,
            base_source_model=(base_source_model),
            base_created_models=(base_created_models),
            incremental_source_model=(incremental_source_model),
            incremental_created_models=(incremental_created_models),
            metadata=workflow_metadata,
        )

        if source_role == "incremental":
            self.diff_schema_service.clear_prepared_source(
                job_id=job_id,
            )

        return result

    def _prepared_result(
        self,
        *,
        job_id: str,
        source_model: str,
        created_models: Sequence[str],
        effect_document: EffectDocument,
        rights_context: RightsEvaluationContext,
        import_schema: str,
        live_schema: str,
        metadata: Mapping[str, Any],
    ) -> ChangeCreationResult:
        """
        Return an unpersisted prepared result for one base source.
        """

        changes = self._build_changes(
            effect_document=effect_document,
            relation_lookup=(
                self._live_relation_lookup(
                    live_schema,
                )
            ),
        )

        classified_changes = ChangeClassifier(
            rights_evaluator=(self.rights_evaluator),
        ).classify(
            changes=changes,
            context=rights_context,
            metadata=dict(
                metadata,
            ),
        )

        features_by_class = self._review_features(
            classified_changes=(classified_changes),
            live_schema=live_schema,
            import_schema=import_schema,
        )

        return ChangeCreationResult(
            job_id=job_id,
            import_model=source_model,
            incremental_import_model=None,
            created_models=list(
                created_models,
            ),
            incremental_created_models=[],
            effect_document=effect_document,
            changes=list(
                changes,
            ),
            classified_changes=classified_changes,
            features_by_class=features_by_class,
            diff_schema_result=None,
            validation_findings=(
                self._validation_findings(
                    classified_changes,
                )
            ),
        )

    def _persist_pending_job(
        self,
        *,
        job_id: str,
        job_mode: DiffJobMode,
        effect_document: EffectDocument,
        rights_context: RightsEvaluationContext,
        import_schema: str,
        live_schema: str,
        base_source_model: str,
        base_created_models: Sequence[str],
        incremental_source_model: str | None,
        incremental_created_models: Sequence[str],
        metadata: Mapping[str, Any],
    ) -> ChangeCreationResult:
        """
        Build and persist one pending review job.
        """

        changes = self._build_changes(
            effect_document=effect_document,
            relation_lookup=(
                self._live_relation_lookup(
                    live_schema,
                )
            ),
        )

        classified_changes = ChangeClassifier(
            rights_evaluator=(self.rights_evaluator),
        ).classify(
            changes=changes,
            context=rights_context,
            metadata=dict(
                metadata,
            ),
        )

        features_by_class = self._review_features(
            classified_changes=(classified_changes),
            live_schema=live_schema,
            import_schema=import_schema,
        )

        diff_schema_result = self.diff_schema_service.write(
            job_id=job_id,
            job_mode=job_mode,
            features_by_class=(features_by_class),
            metadata=dict(
                metadata,
            ),
            validation_success=True,
            job_status="pending",
        )

        return ChangeCreationResult(
            job_id=job_id,
            import_model=base_source_model,
            incremental_import_model=(incremental_source_model),
            created_models=list(
                base_created_models,
            ),
            incremental_created_models=list(
                incremental_created_models,
            ),
            effect_document=effect_document,
            changes=list(
                changes,
            ),
            classified_changes=classified_changes,
            features_by_class=features_by_class,
            diff_schema_result=diff_schema_result,
            validation_findings=(
                self._validation_findings(
                    classified_changes,
                )
            ),
        )

    def _review_features(
        self,
        *,
        classified_changes,
        live_schema: str,
        import_schema: str,
    ):
        """
        Export classified changes to review features.
        """

        object_provider = self.object_provider_factory.change_object_provider(
            live_schema=live_schema,
            import_schema=import_schema,
            canonical_metadata=(self.canonical_metadata),
        )

        review_service = ChangeReviewExportService(
            object_provider=object_provider,
            geometry_attribute_names_by_class=(
                self._geometry_attribute_map(
                    self.canonical_metadata,
                )
            ),
        )

        return review_service.export(
            classified_changes,
        )

    def _workflow_metadata(
        self,
        *,
        job_id: str,
        job_mode: DiffJobMode,
        rights_context: RightsEvaluationContext,
        import_schema: str,
        live_schema: str,
        metadata: Mapping[str, Any] | None,
        source_file: Path | None = None,
    ) -> dict[str, Any]:
        """
        Return normalized workflow metadata.
        """

        workflow_metadata = {
            **dict(
                metadata or {},
            ),
            "job_id": job_id,
            "job_mode": job_mode.value,
            "import_schema": import_schema,
            "live_schema": live_schema,
            "provider_oid": str(
                rights_context.provider_oid,
            ),
            "dataowner_oid": str(
                rights_context.dataowner_oid,
            ),
        }

        if source_file is not None:
            workflow_metadata["source_file"] = str(
                source_file,
            )

        return workflow_metadata

    def _source_role(
        self,
        metadata: Mapping[str, Any],
    ) -> str:
        """
        Return and validate the workflow source role.
        """

        source_role = metadata.get(
            "source_role",
            "base",
        )

        if not isinstance(
            source_role,
            str,
        ):
            raise TypeError("metadata['source_role'] must be a string.")

        if source_role not in {
            "base",
            "incremental",
        }:
            raise ValueError(
                "metadata['source_role'] must be either "
                f"'base' or 'incremental', got "
                f"{source_role!r}."
            )

        return source_role

    def _persist_job(
        self,
        metadata: Mapping[str, Any],
    ) -> bool:
        """
        Return and validate the final-persistence flag.
        """

        persist_job = metadata.get(
            "persist_job",
            True,
        )

        if not isinstance(
            persist_job,
            bool,
        ):
            raise TypeError("metadata['persist_job'] must be a boolean.")

        return persist_job

    def _validate_workflow_transition(
        self,
        *,
        source_role: str,
        persist_job: bool,
    ) -> None:
        """
        Validate supported prepared-to-pending workflow transitions.
        """

        if source_role == "incremental" and not persist_job:
            raise ValueError(
                "An incremental source must finalize the "
                "workflow. Use "
                "metadata['persist_job']=True."
            )

    def _merge_effect_documents(
        self,
        *,
        base_document: EffectDocument,
        incremental_document: EffectDocument,
    ) -> EffectDocument:
        """
        Overlay incremental effects onto a prepared base effect document.

        Update effects are keyed by canonical identity and attribute.
        Incremental updates replace matching base updates.

        Existence constraints are keyed only by canonical identity. The last
        constraint for an identity wins, including when EnforceExistsEffect is
        replaced by EnforceNotExistsEffect or vice versa.
        """

        update_effects: dict[
            tuple[
                tuple,
                str,
            ],
            UpdateAttributeEffect,
        ] = {}

        constraint_effects: dict[
            tuple,
            Effect,
        ] = {}

        ordered_keys: list[
            tuple[
                str,
                Any,
            ],
        ] = []

        def add_effect(
            effect: Effect,
        ) -> None:
            identity_key = effect.identity.key()

            if isinstance(
                effect,
                UpdateAttributeEffect,
            ):
                payload_key = (
                    identity_key,
                    effect.attribute_id,
                )

                order_key = (
                    "update",
                    payload_key,
                )

                if order_key not in ordered_keys:
                    ordered_keys.append(
                        order_key,
                    )

                update_effects[payload_key] = effect

                return

            if isinstance(
                effect,
                (
                    EnforceExistsEffect,
                    EnforceNotExistsEffect,
                ),
            ):
                payload_key = identity_key

                order_key = (
                    "constraint",
                    payload_key,
                )

                if order_key not in ordered_keys:
                    ordered_keys.append(
                        order_key,
                    )

                constraint_effects[payload_key] = effect

                return

            raise TypeError("Unsupported effect type: " f"{type(effect)!r}")

        for effect in base_document.effects:
            add_effect(
                effect,
            )

        for effect in incremental_document.effects:
            add_effect(
                effect,
            )

        merged_effects: list[Effect,] = []

        for (
            effect_kind,
            effect_key,
        ) in ordered_keys:
            if effect_kind == "update":
                merged_effects.append(update_effects[effect_key])

            else:
                merged_effects.append(constraint_effects[effect_key])

        return EffectDocument(
            source=incremental_document.source,
            effects=tuple(
                merged_effects,
            ),
            created_at=(incremental_document.created_at),
            version=max(
                base_document.version,
                incremental_document.version,
            ),
        )

    def _build_changes(
        self,
        *,
        effect_document: EffectDocument,
        relation_lookup: RelationLookupCapability,
    ) -> tuple[
        Change,
        ...,
    ]:
        """
        Build row-level changes from update effects.

        Existence effects are constraints and do not directly produce
        ``Change`` objects.
        """

        effects_by_identity: dict[
            tuple,
            list[UpdateAttributeEffect],
        ] = defaultdict(
            list,
        )

        identities: dict[
            tuple,
            CanonicalObjectIdentity,
        ] = {}

        for effect in effect_document.effects:
            if not isinstance(
                effect,
                UpdateAttributeEffect,
            ):
                continue

            identity_key = effect.identity.key()

            identities[identity_key] = effect.identity

            effects_by_identity[identity_key].append(
                effect,
            )

        changes: list[Change] = []

        for (
            identity_key,
            effects,
        ) in effects_by_identity.items():
            identity = identities[identity_key]

            current_object = relation_lookup.current_object(
                identity,
            )

            changes.append(
                self.change_builder.build(
                    current_object=(current_object),
                    effects=tuple(
                        effects,
                    ),
                )
            )

        return tuple(
            changes,
        )

    def _validation_findings(
        self,
        classified_changes,
    ) -> list:
        """
        Return all validation findings from classified changes.
        """

        return [
            finding
            for classified_change in classified_changes.changes
            for finding in classified_change.validation_findings
        ]

    def _live_relation_lookup(
        self,
        live_schema: str,
    ) -> RelationLookupCapability:
        """
        Return the relation lookup for live canonical objects.
        """

        if self.live_relation_lookup is not None:
            return self.live_relation_lookup

        return TwwRelationLookupAdapter(
            schema=live_schema,
            connection_factory=(self.connection_factory),
        )

    def _geometry_attribute_map(
        self,
        canonical_metadata: CanonicalModelMetadata,
    ) -> dict[
        str,
        tuple[
            str,
            ...,
        ],
    ]:
        """
        Return geometry attribute identifiers keyed by canonical class.
        """

        geometry_capability = CanonicalGeometryCapability(
            metadata=canonical_metadata,
        )

        return {
            class_id: (
                geometry_capability.geometry_attribute_names(
                    class_id,
                )
            )
            for class_id in canonical_metadata.classes
        }

    def _import_context(
        self,
        *,
        context: TwwInterlisContext | None,
        schema: str,
        orgs_path: Path | None,
    ) -> TwwInterlisContext:
        """
        Return the import context for one source quarantine schema.
        """

        if context is None:
            return TwwInterlisContext(
                schema=schema,
                import_orgs=(orgs_path is not None),
                orgs_path=orgs_path,
            )

        return replace(
            context,
            schema=schema,
            import_orgs=(orgs_path is not None),
            orgs_path=orgs_path,
        )

    def _assert_supported_job_mode(
        self,
        job_mode: DiffJobMode,
    ) -> None:
        """
        Reject workflow modes that are not implemented.
        """

        if job_mode == DiffJobMode.REFRESH:
            raise NotImplementedError(
                "Diff-job refresh is not implemented yet. " "Use 'create' or 'replace'."
            )

    def _ensure_ready_for_diff_job(
        self,
    ) -> None:
        """
        Ensure all required collaborators are configured.
        """

        missing: list[str] = []

        if self.effect_projector is None:
            missing.append(
                "effect_projector",
            )

        if self.rights_evaluator is None:
            missing.append(
                "rights_evaluator",
            )

        if self.object_provider_factory is None:
            missing.append(
                "object_provider_factory",
            )

        if missing:
            raise RuntimeError(
                "TwwChangeCreationService is not ready for "
                "diff-job creation. Missing: "
                + ", ".join(
                    missing,
                )
            )

    def _validation_log_path(
        self,
        *,
        validation_log_path: Path | None,
        xtf_file: Path,
        name: str,
    ) -> Path:
        """
        Return the quarantine validation log path.
        """

        if validation_log_path is not None:
            return validation_log_path

        return xtf_file.with_name(f"{xtf_file.stem}_{name}.log")

    def _required_metadata_string(
        self,
        *,
        metadata: Mapping[
            str,
            Any,
        ],
        key: str,
        fallback_key: str | None = None,
        fallback_value: str | None = None,
    ) -> str:
        """
        Return one required non-empty metadata string.

        A fallback metadata key or explicit fallback value may be supplied for
        compatibility with prepared sources created before source-specific
        metadata keys were normalized.
        """

        value = metadata.get(
            key,
        )

        if (
            value
            in (
                None,
                "",
            )
            and fallback_key is not None
        ):
            value = metadata.get(
                fallback_key,
            )

        if (
            value
            in (
                None,
                "",
            )
            and fallback_value is not None
        ):
            value = fallback_value

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise ValueError(
                "Prepared source metadata does not contain " f"a valid {key!r} value."
            )

        return value
