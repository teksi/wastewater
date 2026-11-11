from __future__ import annotations

import logging
from collections.abc import Sequence
from dataclasses import dataclass, field, replace
from pathlib import Path
from typing import Any

from teksi_hooks.capabilities.effects import (
    CanonicalViewLookupCapability,
)
from teksi_hooks.capabilities.mapping import (
    ModelMappingLookupCapability,
)
from teksi_hooks.exceptions import (
    Severity,
)
from teksi_hooks.models.validation import (
    ValidationFinding,
)
from teksi_hooks.services.relation_context_provider import (
    RelationContextProvider,
)

from ...interlis import config
from ...interlis.interlis_importer_exporter import (
    InterlisImporterExporter,
)
from ...interlis.interlis_model_mapping.interlis_incremental_importer import (
    InterlisIncrementalImporter,
)
from ...interlis.model_config import (
    TwwInterlisModelSelection,
)
from ...interlis.utils.ili2db import (
    InterlisTools,
)
from ...interlis.utils.sessions import InterlisImportSessions
from ..capabilities.incremental_import import (
    IncrementalEffectEvaluator,
    IncrementalEffectPersister,
)
from ..capabilities.tww_canonical_projection_capability import (
    TwwCanonicalProjectionLookupCapability,
)
from ..exceptions import (
    QuarantineValidationError,
)
from ..projectors.tww_canonical_view_effect_projector import (
    TwwCanonicalViewEffectProjector,
)
from ..projectors.tww_quarantine_effect_projector import (
    TwwQuarantineEffectProjector,
)
from .tww_canonical_model_adapter import TwwCanonicalModelAdapter
from .tww_interlis_service_adapter import (
    TwwInterlisContext,
)
from .tww_session_manager import (
    TwwSessionContext,
)
from .tww_source_reference_lookup_adapter import (
    TwwSourceReferenceLookupAdapter,
)


@dataclass(
    slots=True,
)
class TwwQuarantineRunner:
    """
    Plugin-side runner for TEKSI Wastewater quarantine workflows.

    The runner owns workflow-level orchestration:

    - XTF to import-side quarantine schema;
    - import-side quarantine schema to live data;
    - live data to export-side quarantine schema;
    - export-side quarantine schema to XTF;
    - quarantine validation as ValidationFinding objects.

    Low-level import and export mechanics remain in
    ``InterlisImporterExporter``.
    """

    canonical_model_adapter: TwwCanonicalModelAdapter

    importer_exporter: InterlisImporterExporter = field(
        default_factory=InterlisImporterExporter,
    )

    interlis_tools: InterlisTools = field(
        default_factory=InterlisTools,
    )

    logger: logging.Logger = field(
        default_factory=lambda: logging.getLogger(
            __name__,
        ),
        repr=False,
    )

    canonical_projection_lookup: CanonicalViewLookupCapability | None = None

    incremental_effect_evaluator: IncrementalEffectEvaluator | None = None

    incremental_effect_persister: IncrementalEffectPersister | None = None

    def import_xtf_to_quarantine(
        self,
        xtf_file: Path,
        context: TwwInterlisContext | None = None,
        schema: str = config.IMPORT_SCHEMA,
    ) -> TwwInterlisModelSelection:
        """
        Import an external XTF into the import-side quarantine schema.

        Returns the complete selected INTERLIS model description.
        """

        context = self._context(
            context,
            schema=schema,
        )

        context.apply(
            self.importer_exporter,
        )

        _ = self.importer_exporter.interlis_import_to_quarantine(
            xtf_file_input=str(
                xtf_file,
            ),
            logs_next_to_file=(context.logs_next_to_file),
            filter_nulls=context.filter_nulls,
            srid=context.srid,
            import_orgs=context.import_orgs,
            orgs_path=context.orgs_path,
            allow_schema_recreation=(context.allow_schema_recreation),
        )
        return

    def import_quarantine_to_live(
        self,
        *,
        source_role: str,
        import_schema: str,
        live_schema: str | None = None,
        selection_models: TwwInterlisModelSelection,
        session_context: TwwSessionContext,
        model_mapping: ModelMappingLookupCapability | None = None,
        quarantine_classes: Any | None = None,
        relation_context_provider: RelationContextProvider | None = None,
        filter_nulls: bool = True,
    ) -> None:
        """
        Import one existing prepared quarantine schema into live TWW data.

        Baseline and incremental sources use separate implementations.
        """

        if source_role == "base":
            self._import_base_quarantine_to_live(
                import_schema=import_schema,
                selection_models=selection_models,
                filter_nulls=filter_nulls,
                session_context=session_context,
            )

            return

        if source_role == "incremental":
            if model_mapping is None:
                raise ValueError(
                    "Incremental quarantine persistence requires an " "effective model mapping."
                )

            if relation_context_provider is None:
                raise ValueError(
                    "Incremental quarantine persistence requires a " "relation-context provider."
                )

            if quarantine_classes is None:
                raise ValueError(
                    "Incremental quarantine persistence requires " "quarantine ORM classes."
                )
            incremental_context = session_context.for_incremental_source()
            self._import_incremental_quarantine_to_live(
                selection_models=selection_models,
                model_mapping=model_mapping,
                quarantine_classes=quarantine_classes,
                relation_context_provider=relation_context_provider,
                session_context=incremental_context,
            )

            return

        raise ValueError("Unsupported quarantine persistence source role " f"{source_role!r}.")

    def export_live_to_quarantine(
        self,
        xtf_file: Path | None,
        export_models: Sequence[str,],
        context: TwwInterlisContext | None = None,
        schema: str = config.EXPORT_SCHEMA,
    ) -> TwwInterlisModelSelection:
        """
        Export live data into the export-side quarantine schema.

        Export-specific filtering or cleanup can happen after this method and
        before ``export_quarantine_to_xtf()``.
        """

        context = self._context(
            context,
            schema=schema,
        )

        context.apply(
            self.importer_exporter,
        )

        return self.importer_exporter.interlis_export_live_to_quarantine(
            xtf_file_output=(
                str(
                    xtf_file,
                )
                if xtf_file is not None
                else None
            ),
            export_models=tuple(
                export_models,
            ),
            logs_next_to_file=(context.logs_next_to_file),
            limit_to_selection=(context.limit_to_selection),
            export_orientation=(context.export_orientation),
            labels_file=(
                str(
                    context.labels_file,
                )
                if context.labels_file is not None
                else None
            ),
            selected_labels_scales_indices=list(
                context.selected_label_scale_indices,
            ),
            selected_ids=list(
                context.selected_ids,
            ),
            include_unplaced=context.include_unplaced,
            import_orgs=context.import_orgs,
            allow_schema_recreation=(context.allow_schema_recreation),
        )

    def export_quarantine_to_xtf(
        self,
        xtf_file: Path,
        export_models: Sequence[str,],
        context: TwwInterlisContext | None = None,
        validation_log_path: Path | None = None,
        schema: str = config.EXPORT_SCHEMA,
    ) -> None:
        """
        Validate export-side quarantine and export it to XTF.
        """

        context = self._context(
            context,
            schema=schema,
        )

        validation_log_path = self._validation_log_path(
            validation_log_path=(validation_log_path),
            xtf_file=xtf_file,
            name="validate_export_quarantine",
        )

        context.apply(
            self.importer_exporter,
        )

        self.validate_quarantine_or_raise(
            model_names=export_models,
            log_path=validation_log_path,
            srid=context.srid,
            schema=schema,
        )

        self.importer_exporter.interlis_export_from_quarantine_to_xtf(
            xtf_file_output=str(
                xtf_file,
            ),
            export_models=tuple(
                export_models,
            ),
            logs_next_to_file=(context.logs_next_to_file),
        )

    def validate_quarantine(
        self,
        model_names: Sequence[str,],
        log_path: Path,
        srid: int = 2056,
        schema: str = config.IMPORT_SCHEMA,
    ) -> tuple[
        ValidationFinding,
        ...,
    ]:
        """
        Validate a quarantine schema using ili2pg ``--validate``.

        Returns an empty tuple when validation succeeds.
        """

        findings: list[ValidationFinding,] = []

        for model_name in model_names:
            self.logger.info(
                "Validating quarantine schema %r with model %r.",
                schema,
                model_name,
            )

            model_log_path = self._log_path_for_model(
                log_path=log_path,
                model_name=model_name,
            )

            try:
                self.interlis_tools.validate_db_data(
                    schema=schema,
                    model_name=model_name,
                    log_path=str(
                        model_log_path,
                    ),
                    srid=srid,
                )

            except Exception as exception:
                model_findings = self._validation_findings_from_log(
                    model_log_path,
                )

                if model_findings:
                    findings.extend(
                        model_findings,
                    )
                    continue

                findings.append(
                    ValidationFinding(
                        code=("quarantine_validation_failed"),
                        severity=Severity.ERROR,
                        message=str(
                            exception,
                        ),
                        attribute_name=None,
                    )
                )

        return tuple(
            findings,
        )

    def validate_quarantine_or_raise(
        self,
        model_names: Sequence[str,],
        log_path: Path,
        srid: int = 2056,
        schema: str = config.IMPORT_SCHEMA,
    ) -> None:
        """
        Validate quarantine and raise on validation errors.
        """

        findings = self.validate_quarantine(
            model_names=model_names,
            log_path=log_path,
            srid=srid,
            schema=schema,
        )

        errors = tuple(finding for finding in findings if finding.severity == Severity.ERROR)

        if errors:
            raise QuarantineValidationError(
                findings=errors,
                log_path=str(
                    log_path,
                ),
            )

    def assert_incremental_ready(
        self,
    ) -> None:
        """
        Require all incremental-persistence collaborators.

        This method should be called before the baseline phase of a combined
        application begins.
        """

        self._incremental_dependencies()

    def _import_base_quarantine_to_live(
        self,
        *,
        import_schema: str,
        selection_models: TwwInterlisModelSelection,
        session_context: TwwSessionContext,
        filter_nulls: bool,
    ) -> None:
        """
        Import a prepared baseline quarantine schema using the legacy
        intermediate-schema importer.
        """

        context = TwwInterlisContext(
            schema=import_schema,
            srid=2056,
            logs_next_to_file=False,
            filter_nulls=filter_nulls,
            import_orgs=False,
            orgs_path=None,
            allow_schema_recreation=False,
        )
        base_context = session_context.for_base_source()

        import_sessions = InterlisImportSessions(
            quarantine=base_context.quarantine,
            live=base_context.live,
        )
        context.apply(
            self.importer_exporter,
        )

        self.importer_exporter.interlis_import_from_quarantine_to_live(
            selection_models=selection_models,
            logs_next_to_file=False,
            filter_nulls=filter_nulls,
            srid=context.srid,
            sessions=import_sessions,
            show_selection_dialog=False,
        )

    def _import_incremental_quarantine_to_live(
        self,
        *,
        selection_models: TwwInterlisModelSelection,
        model_mapping: ModelMappingLookupCapability,
        relation_context_provider: RelationContextProvider,
        session_context: TwwSessionContext,
        quarantine_classes: Any,
    ) -> None:
        """
        Apply one prepared incremental quarantine schema.

        The runner owns all SQLAlchemy sessions and the live transaction.

        The incremental quarantine session is distinct from the base quarantine
        session. A source-specific session context exposes that session through
        ``quarantine`` so projection services do not need to know whether they
        are processing a base or incremental source.

        ``InterlisIncrementalImporter`` and its collaborators borrow the sessions
        while projecting, evaluating and staging effects. They must not commit,
        roll back, close or replace those sessions.
        """
        (
            canonical_projection_lookup,
            effect_evaluator,
            effect_persister,
        ) = self._incremental_dependencies()

        canonical_view_effect_projector = TwwCanonicalViewEffectProjector(
            canonical_lookup=(canonical_projection_lookup),
            source_lookup=(
                TwwSourceReferenceLookupAdapter(
                    model_classes=quarantine_classes,
                )
            ),
            session_context=session_context,
        )

        quarantine_effect_projector = TwwQuarantineEffectProjector(
            model_mapping=model_mapping,
            session_context=session_context,
            relation_context_provider=(relation_context_provider),
            canonical_view_effect_projector=(canonical_view_effect_projector),
            canonical_lookup=canonical_projection_lookup,
            canonical_metadata=(self.canonical_model_adapter.canonical_model()),
            logger=self.logger,
        )

        incremental_importer = InterlisIncrementalImporter(
            model=selection_models.import_model,
            quarantine_effect_projector=(quarantine_effect_projector),
            effect_evaluator=effect_evaluator,
            effect_persister=effect_persister,
            session_tww=session_context.live,
        )

        incremental_importer.import_data()

    def _validation_findings_from_log(
        self,
        log_path: Path,
    ) -> tuple[
        ValidationFinding,
        ...,
    ]:
        """
        Extract validation findings from an ili2pg validation log.
        """

        if not log_path.exists():
            return ()

        findings: list[ValidationFinding,] = []

        for line in log_path.read_text(
            encoding="utf-8",
            errors="replace",
        ).splitlines():
            message = line.strip()

            if not message:
                continue

            if not self._looks_like_validation_error(
                message,
            ):
                continue

            findings.append(
                ValidationFinding(
                    code="quarantine_validation_failed",
                    severity=Severity.ERROR,
                    message=message,
                    attribute_name=None,
                )
            )

        return tuple(
            findings,
        )

    def _looks_like_validation_error(
        self,
        message: str,
    ) -> bool:
        lowered = message.lower()

        return (
            lowered.startswith(
                "error",
            )
            or "validation failed" in lowered
            or "invalid" in lowered
        )

    def _log_path_for_model(
        self,
        log_path: Path,
        model_name: str,
    ) -> Path:
        safe_model_name = (
            model_name.replace(
                " ",
                "_",
            )
            .replace(
                ".",
                "_",
            )
            .replace(
                ":",
                "_",
            )
            .replace(
                "/",
                "_",
            )
        )

        return log_path.with_name(f"{log_path.stem}_{safe_model_name}" f"{log_path.suffix}")

    def _context(
        self,
        context: TwwInterlisContext | None,
        schema: str,
    ) -> TwwInterlisContext:
        if context is None:
            return TwwInterlisContext(
                schema=schema,
                srid=2056,
                logs_next_to_file=False,
                filter_nulls=True,
            )

        return replace(
            context,
            schema=schema,
        )

    def _validation_log_path(
        self,
        *,
        validation_log_path: Path | None,
        xtf_file: Path | None = None,
        name: str,
    ) -> Path:
        if validation_log_path is not None:
            return validation_log_path

        if xtf_file is not None:
            return xtf_file.with_name(f"{xtf_file.stem}_{name}.log")

        return Path(f"{name}.log")

    def _incremental_dependencies(
        self,
    ) -> tuple[
        TwwCanonicalProjectionLookupCapability,
        IncrementalEffectEvaluator,
        IncrementalEffectPersister,
    ]:
        """
        Return collaborators required for incremental persistence.
        """

        missing: list[str,] = []

        if self.canonical_projection_lookup is None:
            missing.append(
                "canonical_projection_lookup",
            )

        if self.incremental_effect_evaluator is None:
            missing.append(
                "incremental_effect_evaluator",
            )

        if self.incremental_effect_persister is None:
            missing.append(
                "incremental_effect_persister",
            )

        if missing:
            raise RuntimeError(
                "Incremental quarantine persistence is not "
                "configured. Missing: "
                + ", ".join(
                    missing,
                )
            )

        return (
            self.canonical_projection_lookup,
            self.incremental_effect_evaluator,
            self.incremental_effect_persister,
        )
