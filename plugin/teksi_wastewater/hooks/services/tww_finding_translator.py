from __future__ import annotations

import logging
from collections.abc import Callable, Mapping, Sequence
from dataclasses import dataclass
from typing import Any, ClassVar

from teksi_hooks.exceptions import Finding
from teksi_hooks.models.review import (
    DiffReviewJob,
)
from teksi_hooks.services.finding_translator import FINDING_MESSAGE_TEMPLATES

from .tww_diff_review_service import (
    DiffReviewDecision,
)

TWW_FINDING_MESSAGE_TEMPLATES: Mapping[
    str,
    str,
] = {
    "invalid_geometry": ("The geometry is invalid."),
    "quarantine_validation_failed": ("Quarantine validation failed: {reason}"),
}


@dataclass(
    slots=True,
)
class TwwDiffFindingsLogger:
    """
    Log permission and validation findings for a review decision.
    """

    translator: TwwFindingTranslator

    logger: logging.Logger

    def log_job_findings(
        self,
        *,
        job: DiffReviewJob,
        decision: DiffReviewDecision,
    ) -> None:
        self.logger.info(
            "Resolving diff review job %s with decision %s.",
            job.job_id,
            decision.value,
        )

        for class_id, features in job.features_by_class.items():
            for feature in features:
                self._log_findings(
                    job_id=job.job_id,
                    class_id=class_id,
                    object_id=feature.object_id,
                    finding_dicts=feature.attributes.get(
                        "permission_findings",
                        (),
                    ),
                    finding_kind="permission",
                )

                self._log_findings(
                    job_id=job.job_id,
                    class_id=class_id,
                    object_id=feature.object_id,
                    finding_dicts=feature.attributes.get(
                        "validation_findings",
                        (),
                    ),
                    finding_kind="validation",
                )

    def _log_findings(
        self,
        *,
        job_id: str,
        class_id: str,
        object_id: str,
        finding_dicts: Sequence[
            Mapping[
                str,
                Any,
            ],
        ],
        finding_kind: str,
    ) -> None:
        for finding_dict in finding_dicts:
            self.logger.info(
                "Diff finding: job=%s class=%s object=%s " "kind=%s code=%s details=%s",
                job_id,
                class_id,
                object_id,
                finding_kind,
                finding_dict.get(
                    "code",
                ),
                finding_dict.get(
                    "details",
                    {},
                ),
            )


@dataclass(slots=True)
class TwwFindingTranslator:
    """
    Translate framework and wastewater finding messages through QGIS.

    Framework-owned templates are extended by wastewater-specific templates.
    The original finding message is used as a fallback when no template exists
    or when the template cannot be formatted with the finding details.
    """

    tr: Callable[
        [
            str,
        ],
        str,
    ]

    templates: ClassVar[Mapping[str, str]] = {
        **FINDING_MESSAGE_TEMPLATES,
        **TWW_FINDING_MESSAGE_TEMPLATES,
    }

    def translate(
        self,
        finding: Finding,
    ) -> str:
        """
        Return the localized presentation message for a finding.
        """

        code = getattr(
            finding,
            "code",
            None,
        )

        if code is None:
            return self.tr(
                finding.message,
            )

        template = self.templates.get(
            code,
        )

        if template is None:
            return self.tr(
                finding.message,
            )

        translated_template = self.tr(
            template,
        )

        try:
            return translated_template.format(
                **finding.details,
            )
        except (
            KeyError,
            IndexError,
            ValueError,
        ):
            return self.tr(
                finding.message,
            )
