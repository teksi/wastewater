from __future__ import annotations

from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from typing import Any, Protocol

from sqlalchemy.orm import Session

from teksi_hooks.capabilities.effects import (
    CanonicalViewLookupCapability,
)

class SourceReferenceLookupCapability(
    Protocol,
):
    """
    Resolve source-model internal references in batches.

    Implementations own source ORM discovery and querying.
    """

    def referenced_rows_by_t_id(
        self,
        *,
        session: Session,
        source_class_id: str,
        t_ids: Sequence[
            int,
        ],
    ) -> Mapping[
        int,
        Any,
    ]:
        """
        Return source rows indexed by their ili2pg t_id.
        """

        ...


@dataclass(
    slots=True,
    frozen=True,
)
class ProjectionValueCandidate:
    """
    Describe one candidate returned by a projection value-list lookup.

    Ordinary value-list relations normally return one candidate without
    target metadata.

    Projection mapping relations may return multiple candidates for the same
    source-facing value and may identify the canonical target class and
    attribute associated with each candidate.

    The semantic effect projector is responsible for selecting the applicable
    candidate from the current canonical object structure.
    """

    value: Any

    target_class_id: str | None = None

    target_attribute_id: str | None = None

    @property
    def has_target_metadata(
        self,
    ) -> bool:
        """
        Return whether this candidate identifies a canonical target.

        Partial target metadata is invalid and should be rejected when the
        candidate is created by the lookup adapter.
        """

        return (
            self.target_class_id is not None
            and self.target_attribute_id is not None
        )

class TwwCanonicalProjectionLookupCapability(
    CanonicalViewLookupCapability,
    Protocol,
):
    """
    Provide batch canonical lookups required by TWW effect projection.

    Implementations own the canonical SQLAlchemy models and relation
    discovery.
    """

    def organisation_oids_by_agxx_oid(
        self,
        *,
        session: Session,
        agxx_oids: Sequence[
            str,
        ],
    ) -> Mapping[
        str,
        str,
    ]:
        """
        Return canonical TWW organisation OIDs keyed by AGXX OID.
        """

        ...

    def value_codes_by_value(
        self,
        *,
        session: Session,
        relation: str,
        values: Sequence[
            str,
        ],
        value_attribute: str = "value_de",
        code_attribute: str = "code",
    ) -> Mapping[
        str,
        Any,
    ]:
        """
        Resolve source-facing values to canonical value-list codes.
        """

        ...

    def canonical_objects_by_identity(
        self,
        *,
        session: Session,
        class_id: str,
        identity_attribute: str,
        identities: Sequence[
            Any,
        ],
    ) -> Mapping[
        Any,
        Any,
    ]:
        """
        Return canonical objects indexed by one identity attribute.
        """

        ...