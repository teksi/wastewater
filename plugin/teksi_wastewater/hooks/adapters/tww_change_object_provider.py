from __future__ import annotations

from dataclasses import dataclass

from teksi_hooks.capabilities.relation_lookup import (
    RelationLookupCapability,
)
from teksi_hooks.capabilities.review import (
    ChangeObjectProvider,
)
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
    CanonicalObject,
)
from teksi_hooks.models.validation import (
    Change,
    ChangeOperation,
)
from teksi_hooks.services.change_creation_protocols import (
    ChangeObjectProviderFactory,
)
from .tww_relation_lookup_adapter import (
    TwwRelationLookupAdapter,
)


@dataclass(
    slots=True,
)
class TwwChangeObjectProvider:
    """
    Provide review objects directly from the canonical Change state.
    """

    def old_object(
        self,
        change: Change,
    ) -> CanonicalObject | None:
        if change.operation == ChangeOperation.INSERT:
            return None

        return CanonicalObject(
            identity=change.identity,
            values=dict(
                change.old_values,
            ),
            last_modification=(
                change.old_values.get(
                    "last_modification",
                )
            ),
        )

    def new_object(
        self,
        change: Change,
    ) -> CanonicalObject | None:
        if change.operation == ChangeOperation.DELETE:
            return None

        return CanonicalObject(
            identity=change.identity,
            values=dict(
                change.new_values,
            ),
            last_modification=(
                change.new_values.get(
                    "last_modification",
                )
            ),
        )


@dataclass(frozen=True,slots=True)
class TwwChangeObjectProviderFactory(ChangeObjectProviderFactory):
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
        del import_schema
        del canonical_metadata

        return TwwChangeObjectProvider()
