from __future__ import annotations

from dataclasses import dataclass

from teksi_hooks.capabilities.relation_lookup import (
    RelationLookupCapability,
)
from teksi_hooks.capabilities.review import (
    ChangeObjectProvider,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
    CanonicalObject,
)
from teksi_hooks.models.validation import (
    Change,
)

from .tww_relation_lookup_adapter import (
    TwwRelationLookupAdapter,
)


@dataclass(slots=True)
class TwwChangeObjectProvider(
    ChangeObjectProvider,
):
    """
    Plugin-side provider for canonical object state used during review export.

    The provider supplies old and new canonical objects. Transformation into
    ReviewFeature instances is handled by the hook-side
    ChangeReviewExportService.
    """

    live_lookup: RelationLookupCapability

    new_lookup: RelationLookupCapability | None = None

    def old_object(
        self,
        change: Change,
    ) -> CanonicalObject | None:
        """
        Return the current persisted canonical object.
        """

        return self.live_lookup.current_object(
            change.identity,
        )

    def new_object(
        self,
        change: Change,
    ) -> CanonicalObject | None:
        """
        Return the proposed canonical object represented by the change.
        """

        if self.new_lookup is not None:
            current = self.new_lookup.current_object(
                change.identity,
            )

            if current is not None:
                return current

        return CanonicalObject(
            identity=change.identity,
            values=dict(
                change.new_values,
            ),
        )


@dataclass(slots=True)
class TwwChangeObjectProviderFactory:
    """
    Create canonical object providers for review-feature generation.

    The provider reads old canonical values from the live schema.

    Proposed values are already represented by Change.new_values, so no
    canonical lookup against the source-model quarantine schema is required.
    """

    def change_object_provider(
        self,
        *,
        live_schema: str,
        import_schema: str,
        canonical_metadata: CanonicalModelMetadata,
    ) -> ChangeObjectProvider:
        """
        Return a provider for one change-creation workflow.

        ``import_schema`` and ``canonical_metadata`` remain part of the
        factory protocol for future implementations. The current provider
        obtains proposed values directly from Change.new_values.
        """

        return TwwChangeObjectProvider(
            live_lookup=TwwRelationLookupAdapter(
                schema=live_schema,
            ),
            new_lookup=None,
        )
