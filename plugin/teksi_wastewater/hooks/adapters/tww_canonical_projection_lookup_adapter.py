from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Mapping, Sequence

from sqlalchemy import select
from sqlalchemy.orm import Session


from teksi_hooks.models.mapping import (
    CanonicalViewMapping,
)
from teksi_wastewater.hooks.capabilities.tww_canonical_projection_capability import (
    ProjectionValueCandidate,
    TwwCanonicalProjectionLookupCapability,
)
from .tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
)


@dataclass(
    slots=True,
)
class TwwCanonicalProjectionLookupAdapter(
    TwwCanonicalProjectionLookupCapability,
):
    """
    Provide session-backed canonical lookups for TWW effect projection.

    The canonical model adapter owns canonical ORM and comparison-view
    discovery. This adapter performs the database queries required by semantic
    TWW projections.

    All supplied sessions are borrowed from the enclosing workflow. This
    adapter does not create, commit, roll back, or close sessions.
    """

    canonical_model_adapter: (
        TwwCanonicalModelAdapter
    )

    organisation_view_schema: str = "tww_app"

    organisation_view_name: str = (
        "vw_agxx_organisation"
    )

    organisation_agxx_attribute: str = "obj_id"

    organisation_oid_attribute: str = "_tww_obj_id"

    value_list_classes: Mapping[
        str,
        Any,
    ] | None = None


    def canonical_view_class(
        self,
        view,
    ) -> Any:
        """
        Return the mapped ORM class for one canonical comparison view.
        """

        return (
            self.canonical_model_adapter
            .canonical_view_class(
                view,
            )
        )

    def canonical_view_rows_by_identity(
        self,
        *,
        view,
        identities: Sequence[
            Any,
        ],
        session: Session,
    ) -> dict[
        Any,
        Any,
    ]:
        """
        Return canonical comparison rows keyed by configured identity.
        """

        return (
            self.canonical_model_adapter
            .canonical_view_rows_by_identity(
                view=view,
                identities=identities,
                session=session,
            )
        )

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
        Return canonical organisation OIDs keyed by AGXX organisation OID.

        ``obj_id`` is the AGXX-facing identity exposed by
        ``tww_app.vw_agxx_organisation``.

        ``_tww_obj_id`` is the corresponding canonical
        ``tww_od.organisation.obj_id``.
        """
        unique_agxx_oids = tuple(
            dict.fromkeys(
                agxx_oid.strip()
                for agxx_oid in agxx_oids
                if (
                    isinstance(
                        agxx_oid,
                        str,
                    )
                    and agxx_oid.strip()
                )
            )
        )

        if not unique_agxx_oids:
            return {}

        organisation_view = (
            self.canonical_model_adapter
            .canonical_view_class(
                CanonicalViewMapping(
                    schema=(
                        self.organisation_view_schema
                    ),
                    name=(
                        self.organisation_view_name
                    ),
                    target_identity_attribute=(
                        self.organisation_agxx_attribute
                    ),
                )
            )
        )

        agxx_column = getattr(
            organisation_view,
            self.organisation_agxx_attribute,
            None,
        )

        if agxx_column is None:
            raise AttributeError(
                "Canonical AGXX organisation view "
                f"{self.organisation_view_schema!r}."
                f"{self.organisation_view_name!r} does not expose "
                f"{self.organisation_agxx_attribute!r}."
            )

        oid_column = getattr(
            organisation_view,
            self.organisation_oid_attribute,
            None,
        )

        if oid_column is None:
            raise AttributeError(
                "Canonical AGXX organisation view "
                f"{self.organisation_view_schema!r}."
                f"{self.organisation_view_name!r} does not expose "
                f"{self.organisation_oid_attribute!r}."
            )

        rows = session.execute(
            select(
                agxx_column,
                oid_column,
            ).where(
                agxx_column.in_(
                    unique_agxx_oids,
                )
            )
        )

        result: dict[
            str,
            str,
        ] = {}

        for (
            agxx_oid,
            organisation_oid,
        ) in rows:
            if (
                agxx_oid is None
                or organisation_oid is None
            ):
                continue

            normalized_agxx_oid = str(
                agxx_oid,
            ).strip()

            normalized_organisation_oid = str(
                organisation_oid,
            ).strip()

            if (
                not normalized_agxx_oid
                or not normalized_organisation_oid
            ):
                continue

            existing = result.get(
                normalized_agxx_oid,
            )

            if (
                existing is not None
                and existing
                != normalized_organisation_oid
            ):
                raise RuntimeError(
                    "Several canonical organisations exist "
                    "for AGXX OID "
                    f"{normalized_agxx_oid!r}: "
                    f"{existing!r} and "
                    f"{normalized_organisation_oid!r}."
                )

            result[
                normalized_agxx_oid
            ] = normalized_organisation_oid

        return result

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
        tuple[
            ProjectionValueCandidate,
            ...,
        ],
    ]:
        """
        Resolve source-facing values to canonical projection candidates.

        Ordinary value-list relations return one candidate per source-facing
        value.

        Relations exposing both ``target_class`` and ``target_attribute`` return
        candidates carrying semantic target metadata. These relations may return
        several candidates for one source-facing value.
        """
        value_list_class = self._value_list_class(
            relation,
        )

        value_column = getattr(
            value_list_class,
            value_attribute,
            None,
        )

        if value_column is None:
            raise AttributeError(
                "Value-list relation "
                f"{relation!r} does not expose value "
                f"attribute {value_attribute!r}."
            )

        code_column = getattr(
            value_list_class,
            code_attribute,
            None,
        )

        if code_column is None:
            raise AttributeError(
                "Value-list relation "
                f"{relation!r} does not expose code "
                f"attribute {code_attribute!r}."
            )

        target_class_column = getattr(
            value_list_class,
            "target_class",
            None,
        )

        target_attribute_column = getattr(
            value_list_class,
            "target_attribute",
            None,
        )

        if (
            target_class_column is None
        ) != (
            target_attribute_column is None
        ):
            raise AttributeError(
                "Value-list relation "
                f"{relation!r} must expose either both "
                "`target_class` and `target_attribute`, "
                "or neither."
            )

        unique_values = tuple(
            dict.fromkeys(
                str(
                    value,
                )
                for value in values
                if value is not None
            )
        )

        if not unique_values:
            return {}

        if target_class_column is None:
            rows = session.execute(
                select(
                    value_column,
                    code_column,
                ).where(
                    value_column.in_(
                        unique_values,
                    )
                )
            )

            result: dict[
                str,
                tuple[
                    ProjectionValueCandidate,
                    ...,
                ],
            ] = {}

            for (
                source_value,
                canonical_code,
            ) in rows:
                if source_value is None:
                    continue

                normalized_value = str(
                    source_value,
                )

                candidate = ProjectionValueCandidate(
                    value=canonical_code,
                )

                existing = result.get(
                    normalized_value,
                )

                if (
                    existing is not None
                    and existing != (
                        candidate,
                    )
                ):
                    raise RuntimeError(
                        "Value-list relation "
                        f"{relation!r} returned several codes "
                        f"for ordinary value "
                        f"{normalized_value!r}."
                    )

                result[
                    normalized_value
                ] = (
                    candidate,
                )

            return result

        rows = session.execute(
            select(
                value_column,
                code_column,
                target_class_column,
                target_attribute_column,
            ).where(
                value_column.in_(
                    unique_values,
                )
            )
        )

        candidate_lists: dict[
            str,
            list[
                ProjectionValueCandidate,
            ],
        ] = {}

        for (
            source_value,
            canonical_code,
            target_class_id,
            target_attribute_id,
        ) in rows:
            if source_value is None:
                continue

            normalized_value = str(
                source_value,
            )

            normalized_target_class_id = None

            if target_class_id is not None:
                normalized_target_class_id = str(
                    target_class_id,
                ).strip()

                if not normalized_target_class_id:
                    normalized_target_class_id = None

                elif "." in normalized_target_class_id:
                    normalized_target_class_id = (
                        normalized_target_class_id
                        .rsplit(
                            ".",
                            maxsplit=1,
                        )[
                            -1
                        ]
                    )

            normalized_target_attribute_id = None

            if target_attribute_id is not None:
                normalized_target_attribute_id = str(
                    target_attribute_id,
                ).strip()

                if not normalized_target_attribute_id:
                    normalized_target_attribute_id = None

            candidate = ProjectionValueCandidate(
                value=canonical_code,
                target_class_id=(
                    normalized_target_class_id
                ),
                target_attribute_id=(
                    normalized_target_attribute_id
                ),
            )

            candidates = candidate_lists.setdefault(
                normalized_value,
                [],
            )

            if candidate not in candidates:
                candidates.append(
                    candidate,
                )

        return {
            source_value: tuple(
                candidates,
            )
            for (
                source_value,
                candidates,
            ) in candidate_lists.items()
        }

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

        canonical_class = (
            self.canonical_model_adapter
            .canonical_class(
                class_id,
            )
        )

        identity_column = getattr(
            canonical_class,
            identity_attribute,
            None,
        )

        if identity_column is None:
            raise AttributeError(
                "Canonical class "
                f"{class_id!r} does not expose identity "
                f"attribute {identity_attribute!r}."
            )

        unique_identities = tuple(
            dict.fromkeys(
                identity
                for identity in identities
                if identity is not None
            )
        )

        if not unique_identities:
            return {}

        rows = tuple(
            session.scalars(
                select(
                    canonical_class,
                ).where(
                    identity_column.in_(
                        unique_identities,
                    )
                )
            )
        )

        result: dict[
            Any,
            Any,
        ] = {}

        for row in rows:
            identity = getattr(
                row,
                identity_attribute,
            )

            if identity in result:
                raise RuntimeError(
                    "Canonical class "
                    f"{class_id!r} returned several objects "
                    f"for identity {identity!r}."
                )

            result[
                identity
            ] = row

        return result

    def _value_list_class(
        self,
        relation: str,
    ) -> Any:
        """
        Return the mapped class for one schema-qualified value-list relation.
        """

        if self.value_list_classes is None:
            raise RuntimeError(
                "No canonical value-list ORM classes "
                "are configured."
            )

        candidates = (
            relation,
            relation.rsplit(
                ".",
                maxsplit=1,
            )[-1],
        )

        for candidate in candidates:
            value_list_class = (
                self.value_list_classes.get(
                    candidate,
                )
            )

            if value_list_class is not None:
                return value_list_class

        raise KeyError(
            "No canonical value-list ORM class exists "
            f"for relation {relation!r}."
        )
