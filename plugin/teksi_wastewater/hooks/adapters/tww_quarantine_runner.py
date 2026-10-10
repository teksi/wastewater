from __future__ import annotations

import logging
from collections.abc import Sequence
from dataclasses import dataclass, field, replace
from pathlib import Path

from teksi_hooks.exceptions import (
    Severity,
)
from teksi_hooks.models.validation import (
    ValidationFinding,
)

from ...interlis import config
from ...interlis.interlis_importer_exporter import (
    InterlisImporterExporter,
)
from ...interlis.model_config import TwwInterlisModelSelection
from ...interlis.utils.ili2db import (
    InterlisTools,
)
from ..exceptions import (
    QuarantineValidationError,
)
from .tww_interlis_service_adapter import (
    TwwInterlisContext,
)


@dataclass(slots=True)
class TwwQuarantineRunner:
    """
    Plugin-side runner for TEKSI Wastewater quarantine workflows.

    The runner owns workflow-level orchestration:

    - XTF to import-side quarantine schema
    - import-side quarantine schema to live data
    - live data to export-side quarantine schema
    - export-side quarantine schema to XTF
    - quarantine validation as ValidationFinding objects

    Low-level import/export mechanics remain in InterlisImporterExporter.
    """

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

    def import_xtf_to_quarantine(
        self,
        xtf_file: Path,
        context: TwwInterlisContext | None = None,
        schema: str = config.IMPORT_SCHEMA,
    ) -> tuple[
        str,
        tuple[str, ...],
    ]:
        """
        Import an external XTF into the import-side quarantine schema.

        Returns:
            import_model:
                Selected effective INTERLIS model name.

            created_models:
                Model names used to create the ili2pg quarantine schema.
        """

        context = self._context(
            context,
            schema=schema,
        )

        context.apply(
            self.importer_exporter,
        )

        return self.importer_exporter.interlis_import_to_quarantine(
            xtf_file_input=str(
                xtf_file,
            ),
            logs_next_to_file=context.logs_next_to_file,
            filter_nulls=context.filter_nulls,
            srid=context.srid,
            import_orgs=context.import_orgs,
            orgs_path=context.orgs_path,
        )

    def import_quarantine_to_live(
        self,
        xtf_file: Path | None = None,
        context: TwwInterlisContext | None = None,
        validation_log_path: Path | None = None,
        schema: str = config.IMPORT_SCHEMA,
        selection_models: TwwInterlisModelSelection | None = None,
    ) -> None:
        """
        Validate import-side quarantine and then import it into live data.

        The model is read from the original XTF so that the same selected
        import model can be used for database validation and conversion.
        """

        context = self._context(
            context,
            schema=schema,
        )

        context.apply(
            self.importer_exporter,
        )

        if selection_models is None and xtf_file is not None:
            selection_models = self.importer_exporter.find_import_ilimodels(
                str(
                    xtf_file,
                )
            )

        validation_log_path = self._validation_log_path(
            validation_log_path=validation_log_path,
            xtf_file=xtf_file,
            name="validate_import_quarantine",
        )

        self.validate_quarantine_or_raise(
            model_names=selection_models.validation_models,
            log_path=validation_log_path,
            srid=context.srid,
            schema=schema,
        )

        self.importer_exporter.interlis_import_from_quarantine_to_live(
            selection_models=selection_models,
            logs_next_to_file=context.logs_next_to_file,
            filter_nulls=context.filter_nulls,
            srid=context.srid,
            show_selection_dialog=context.show_selection_dialog,
        )

    def export_live_to_quarantine(
        self,
        xtf_file: Path | None,
        export_models: Sequence[str],
        context: TwwInterlisContext | None = None,
        schema: str = config.EXPORT_SCHEMA,
    ) -> TwwInterlisModelSelection:
        """
        Export live data into the export-side quarantine schema.

        Export-specific filtering or cleanup can happen after this method and
        before export_quarantine_to_xtf().
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
            logs_next_to_file=context.logs_next_to_file,
            limit_to_selection=context.limit_to_selection,
            export_orientation=context.export_orientation,
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
        )

    def export_quarantine_to_xtf(
        self,
        xtf_file: Path,
        export_models: Sequence[str],
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
            validation_log_path=validation_log_path,
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
            logs_next_to_file=context.logs_next_to_file,
        )

    def validate_quarantine(
        self,
        model_names: Sequence[str],
        log_path: Path,
        srid: int = 2056,
        schema: str = config.IMPORT_SCHEMA,
    ) -> tuple[ValidationFinding, ...]:
        """
        Validate a quarantine schema using ili2pg --validate.

        Returns an empty tuple if validation succeeds.
        Returns ValidationFinding objects if validation fails.
        """

        findings: list[ValidationFinding] = []

        for model_name in model_names:
            self.logger.info(
                "Validating quarantine schema %r with models %r.",
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
                        code="quarantine_validation_failed",
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
        model_names: Sequence[str],
        log_path: Path,
        srid: int = 2056,
        schema: str = config.IMPORT_SCHEMA,
    ) -> None:
        """
        Validate quarantine and raise QuarantineValidationError on errors.
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

    def _validation_findings_from_log(
        self,
        log_path: Path,
    ) -> tuple[ValidationFinding, ...]:
        """
        Extract validation findings from an ili2pg validation log.
        """

        if not log_path.exists():
            return ()

        findings: list[ValidationFinding] = []

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

        if lowered.startswith(
            "error",
        ):
            return True

        if "validation failed" in lowered:
            return True

        if "invalid" in lowered:
            return True

        return False

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

        return log_path.with_name(f"{log_path.stem}_{safe_model_name}{log_path.suffix}")

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
