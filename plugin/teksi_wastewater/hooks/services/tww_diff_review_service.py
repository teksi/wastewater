from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass, field
from typing import Any, Protocol

from teksi_hooks.capabilities.canonical_object import (
    CanonicalGeometryCapability,
)
from teksi_hooks.capabilities.persistence import (
    ChangePersistenceCapability,
)
from teksi_hooks.capabilities.review import (
    ChangeObjectProvider,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
)
from teksi_hooks.models.diff_snapshot import (
    DiffSnapshot,
)
from teksi_hooks.models.persistence import (
    ChangePersistenceDocument,
)
from teksi_hooks.models.review import (
    DiffReviewDecision,
    DiffReviewDecisionResult,
    DiffReviewJob,
    DiffSchemaWriteResult,
    ReviewFeature,
)
from teksi_hooks.models.validation import (
    ClassifiedChanges,
)
from teksi_hooks.services.change_review_export import (
    ChangeReviewExportService,
)

from .tww_diff_schema_service import (
    DiffJobMode,
    TwwDiffSchemaService,
)
from .tww_finding_translator import (
    TwwDiffFindingsLogger,
)


class DiffReviewDecision(
    StrEnum,
):
    ACCEPT = "accept"
    REJECT = "reject"


@dataclass(
    frozen=True,
    slots=True,
)
class DiffReviewDecisionResult:
    """
    Result of resolving a pending review job.
    """

    job_id: str
    decision: DiffReviewDecision
    job_status: str
    deletion_plan: DeletionPlan | None = None
    persistence_result: PersistenceResult | None = None


class ChangeObjectProviderFactory(
    Protocol,
):
    """
    Factory for constructing review-feature object providers.
    """

    def change_object_provider(
        self,
        *,
        live_schema: str,
        import_schema: str,
        canonical_metadata: CanonicalModelMetadata,
    ) -> ChangeObjectProvider:
        """
        Create an object provider for one review-job workflow.
        """


@dataclass(
    slots=True,
)
class DiffReviewResult:
    """
    Result of creating and storing a diff review job.
    """

    job_id: str

    features_by_class: dict[
        str,
        list[ReviewFeature],
    ] = field(
        default_factory=dict,
    )

    diff_schema_result: DiffSchemaWriteResult | None = None


@dataclass(
    slots=True,
)
class TwwDiffReviewService:
    """
    Create and resolve TEKSI Wastewater diff review jobs.

    Review creation transforms classified changes into durable review
    features. Acceptance persists the immutable reviewed snapshot using the
    persistence decisions tied to that snapshot.

    Rights are not reevaluated during acceptance. Persistence uses the
    decisions produced during review creation.
    """

    object_provider_factory: ChangeObjectProviderFactory

    diff_schema_service: TwwDiffSchemaService = field(
        default_factory=TwwDiffSchemaService,
    )

    persistence: ChangePersistenceCapability | None = None

    findings_logger: TwwDiffFindingsLogger | None = None

    def create_review_job(
        self,
        *,
        job_id: str,
        job_mode: DiffJobMode,
        classified_changes: ClassifiedChanges,
        canonical_metadata: CanonicalModelMetadata,
        import_schema: str,
        live_schema: str,
        metadata: (
            Mapping[
                str,
                Any,
            ]
            | None
        ) = None,
        validation_success: bool = True,
    ) -> DiffReviewResult:
        """
        Create and store a pending diff review job.
        """

        self._assert_supported_job_mode(
            job_mode,
        )

        object_provider = self.object_provider_factory.change_object_provider(
            live_schema=live_schema,
            import_schema=import_schema,
            canonical_metadata=canonical_metadata,
        )

        review_export_service = ChangeReviewExportService(
            object_provider=object_provider,
            geometry_attribute_names_by_class=(
                self._geometry_attribute_names_by_class(
                    canonical_metadata,
                )
            ),
        )

        exported_features = review_export_service.export(
            classified_changes,
        )

        features_by_class = self._normalize_features_by_class(
            exported_features,
        )

        diff_schema_result = self.diff_schema_service.write(
            job_id=job_id,
            job_mode=job_mode,
            features_by_class=features_by_class,
            metadata=dict(
                metadata or {},
            ),
            validation_success=validation_success,
            job_status="pending",
        )

        return DiffReviewResult(
            job_id=job_id,
            features_by_class=features_by_class,
            diff_schema_result=diff_schema_result,
        )

    def decide(
        self,
        *,
        job_id: str,
        decision: DiffReviewDecision,
    ) -> DiffReviewDecisionResult:
        """
        Resolve one pending review job.
        """

        self._ensure_ready_for_decision(
            decision,
        )

        job = self._pending_job(
            job_id,
        )

        if decision == DiffReviewDecision.REJECT:
            return self._reject_job(
                job,
            )

        if decision == DiffReviewDecision.ACCEPT:
            return self._accept_job(
                job,
            )

        raise ValueError(f"Unsupported review decision: {decision!r}.")

    def reject(
        self,
        *,
        job_id: str,
    ) -> DiffReviewDecisionResult:
        """
        Reject one pending review job.
        """

        return self.decide(
            job_id=job_id,
            decision=DiffReviewDecision.REJECT,
        )

    def accept(
        self,
        *,
        job_id: str,
    ) -> DiffReviewDecisionResult:
        """
        Accept and persist one pending review job.
        """

        return self.decide(
            job_id=job_id,
            decision=DiffReviewDecision.ACCEPT,
        )

    def _reject_job(
        self,
        job: DiffReviewJob,
    ) -> DiffReviewDecisionResult:
        """
        Reject a pending job without modifying live data.
        """

        self.findings_logger.log_job_findings(
            job=job,
            decision=DiffReviewDecision.REJECT,
        )

        self.diff_schema_service.update_job_status(
            job_id=job.job_id,
            expected_status="pending",
            new_status="rejected",
        )

        return DiffReviewDecisionResult(
            job_id=job.job_id,
            decision=DiffReviewDecision.REJECT,
            job_status="rejected",
        )

    def _accept_job(
        self,
        job: DiffReviewJob,
    ) -> DiffReviewDecisionResult:
        """
        Persist and apply a reviewed snapshot.

        The snapshot and persistence document must refer to the same immutable
        snapshot identifier.
        """

        rejected_count = self.diff_schema_service.rejected_row_count(
            job_id=job.job_id,
        )

        if rejected_count:
            raise RuntimeError(
                f"Diff review job {job.job_id!r} cannot be "
                f"accepted because {rejected_count} review rows "
                "are rejected."
            )

        snapshot = self._snapshot(
            job,
        )

        decisions = self._persistence_document(
            job,
        )

        self._assert_matching_snapshot(
            snapshot=snapshot,
            decisions=decisions,
        )

        self.findings_logger.log_job_findings(
            job=job,
            decision=DiffReviewDecision.ACCEPT,
        )

        persistence_result = self.persistence.persist_snapshot(
            snapshot,
            decisions,
        )

        self.diff_schema_service.update_job_status(
            job_id=job.job_id,
            expected_status="pending",
            new_status="applied",
        )

        return DiffReviewDecisionResult(
            job_id=job.job_id,
            decision=DiffReviewDecision.ACCEPT,
            job_status="applied",
            persistence_result=persistence_result,
        )

    def _snapshot(
        self,
        job: DiffReviewJob,
    ) -> DiffSnapshot:
        """
        Load the immutable snapshot associated with a review job.
        """

        snapshot = self.diff_schema_service.diff_snapshot(
            job_id=job.job_id,
        )

        if snapshot is None:
            raise RuntimeError(
                f"Diff review job {job.job_id!r} has no " "persisted diff snapshot."
            )

        return snapshot

    def _persistence_document(
        self,
        job: DiffReviewJob,
    ) -> ChangePersistenceDocument:
        """
        Load persistence decisions associated with a review job.
        """

        document = self.diff_schema_service.persistence_document(
            job_id=job.job_id,
        )

        if document is None:
            raise RuntimeError(
                f"Diff review job {job.job_id!r} has no " "persistence-decision document."
            )

        return document

    def _assert_matching_snapshot(
        self,
        *,
        snapshot: DiffSnapshot,
        decisions: ChangePersistenceDocument,
    ) -> None:
        """
        Ensure decisions cannot be applied to another snapshot.
        """

        if decisions.snapshot_id != snapshot.snapshot_id:
            raise RuntimeError(
                "Persistence decisions do not belong to the reviewed "
                f"snapshot. Snapshot: {snapshot.snapshot_id}; "
                f"decision document: {decisions.snapshot_id}."
            )

    def _pending_job(
        self,
        job_id: str,
    ) -> DiffReviewJob:
        """
        Load and validate one pending review job.
        """

        job = self.diff_schema_service.review_job(
            job_id=job_id,
        )

        if job is None:
            raise ValueError(f"Diff review job {job_id!r} does not exist.")

        if job.job_status != "pending":
            raise RuntimeError(
                f"Diff review job {job_id!r} has status "
                f"{job.job_status!r}; expected 'pending'."
            )

        return job

    def _ensure_ready_for_decision(
        self,
        decision: DiffReviewDecision,
    ) -> None:
        """
        Ensure decision-specific collaborators are available.
        """

        missing = []

        if self.findings_logger is None:
            missing.append(
                "findings_logger",
            )

        if decision == DiffReviewDecision.ACCEPT and self.persistence is None:
            missing.append(
                "persistence",
            )

        if missing:
            raise RuntimeError(
                "TwwDiffReviewService is not ready to resolve "
                f"review jobs. Missing: {', '.join(missing)}"
            )

    def _geometry_attribute_names_by_class(
        self,
        canonical_metadata: CanonicalModelMetadata,
    ) -> dict[
        str,
        tuple[str, ...],
    ]:
        """
        Return canonical geometry attributes grouped by class identifier.
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

    def _normalize_features_by_class(
        self,
        features_by_class: Mapping[
            str,
            list[ReviewFeature],
        ],
    ) -> dict[
        str,
        list[ReviewFeature],
    ]:
        """
        Copy exported features into a mutable storage-ready dictionary.
        """

        return {
            class_id: list(
                features,
            )
            for class_id, features in features_by_class.items()
        }

    def _assert_supported_job_mode(
        self,
        job_mode: DiffJobMode,
    ) -> None:
        """
        Reject review-job modes whose semantics are not implemented.
        """

        if job_mode == DiffJobMode.REFRESH:
            raise NotImplementedError(
                "Diff-job refresh is not implemented yet. " "Use 'create' or 'replace'."
            )
