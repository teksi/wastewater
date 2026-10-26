from __future__ import annotations

from collections.abc import (
    Mapping,
    Sequence,
)
from dataclasses import dataclass
from typing import Any

from sqlalchemy import select
from teksi_hooks.models.mapping import (
    ProjectionReferenceDiscriminator,
)

from ..capabilities.tww_canonical_projection_capability import (
    SourceReferenceLookupCapability,
)


@dataclass(
    slots=True,
)
class TwwSourceReferenceLookupAdapter(
    SourceReferenceLookupCapability,
):
    """
    Resolve internal references in an imported INTERLIS source model.

    The adapter owns source ORM class discovery within the supplied
    quarantine class collection. Database sessions remain caller-owned.

    Source references are normally integer ili2pg ``t_id`` values. Referenced
    rows are returned indexed by ``t_id`` so the semantic projector can read
    the configured external identity attribute, normally ``t_ili_tid``.

    The adapter does not:

    - commit, roll back, flush, or close the supplied session;
    - interpret canonical target classes or attributes;
    - construct canonical effects;
    - convert referenced source identities to canonical identities.
    """

    model_classes: Any

    def rows_by_t_id(
        self,
        *,
        session: Any,
        source_class_id: str,
        t_ids: Sequence[int,],
        discriminator: ProjectionReferenceDiscriminator | None = None,
    ) -> Mapping[
        int,
        Any,
    ]:
        """
        Return referenced source rows indexed by ili2pg ``t_id``.

        The requested logical source class is resolved from the configured
        quarantine ORM class collection.

        When a discriminator is supplied, only rows whose configured
        discriminator attribute equals its configured value are returned.

        Every requested ``t_id`` must resolve to exactly one row. Missing,
        duplicate, or malformed rows cause projection to fail immediately.
        """

        unique_t_ids = self._unique_t_ids(
            t_ids,
        )

        if not unique_t_ids:
            return {}

        source_class = self._source_class(
            source_class_id,
        )

        t_id_column = getattr(
            source_class,
            "t_id",
            None,
        )

        if t_id_column is None:
            raise ValueError(
                "Referenced source class "
                f"{source_class_id!r} does not expose the "
                "ili2pg `t_id` attribute."
            )

        statement = select(
            source_class,
        ).where(
            t_id_column.in_(
                unique_t_ids,
            )
        )

        if discriminator is not None:
            discriminator_column = getattr(
                source_class,
                discriminator.attribute,
                None,
            )

            if discriminator_column is None:
                raise ValueError(
                    "Referenced source class "
                    f"{source_class_id!r} does not expose "
                    "configured discriminator attribute "
                    f"{discriminator.attribute!r}."
                )

            statement = statement.where(discriminator_column == discriminator.value)

        rows = tuple(
            session.scalars(
                statement,
            )
        )

        rows_by_t_id: dict[
            int,
            Any,
        ] = {}

        for row in rows:
            row_t_id = getattr(
                row,
                "t_id",
                None,
            )

            if not isinstance(
                row_t_id,
                int,
            ):
                raise ValueError(
                    "Referenced source row from class "
                    f"{source_class_id!r} does not expose a "
                    "valid integer `t_id`."
                )

            if row_t_id in rows_by_t_id:
                raise ValueError(
                    "Source reference lookup returned several "
                    "rows for source class "
                    f"{source_class_id!r} and t_id "
                    f"{row_t_id!r}."
                )

            rows_by_t_id[row_t_id] = row

        missing_t_ids = tuple(t_id for t_id in unique_t_ids if t_id not in rows_by_t_id)

        if missing_t_ids:
            discriminator_description = (
                ""
                if discriminator is None
                else (
                    " using discriminator "
                    f"{discriminator.attribute!r}="
                    f"{discriminator.value!r}"
                )
            )

            raise ValueError(
                "Could not resolve source references for "
                f"class {source_class_id!r}"
                f"{discriminator_description}. Missing t_id "
                f"values: {missing_t_ids!r}."
            )

        return rows_by_t_id

    def _source_class(
        self,
        source_class_id: str,
    ) -> Any:
        """
        Return one quarantine ORM class.

        Resolution first tries exact mapping or namespace keys. When that
        fails, mapped class names and physical table names are compared using
        a normalized representation.

        Normalization is intentionally limited to case and underscores. It
        does not perform language translation or fuzzy matching.
        """

        exact_match = self._exact_source_class(
            source_class_id,
        )

        if exact_match is not None:
            return exact_match

        normalized_source_class_id = self._normalized_identifier(
            source_class_id,
        )

        matches: list[Any,] = []

        for (
            configured_name,
            candidate,
        ) in self._class_candidates():
            candidate_identifiers = {
                configured_name,
                getattr(
                    candidate,
                    "__name__",
                    "",
                ),
            }

            table = getattr(
                candidate,
                "__table__",
                None,
            )

            if table is not None:
                candidate_identifiers.add(
                    str(
                        table.name,
                    )
                )

            if any(
                self._normalized_identifier(
                    identifier,
                )
                == normalized_source_class_id
                for identifier in candidate_identifiers
                if identifier
            ):
                matches.append(
                    candidate,
                )

        unique_matches = tuple(
            dict.fromkeys(
                matches,
            )
        )

        if not unique_matches:
            available_classes = tuple(
                sorted(
                    configured_name
                    for (
                        configured_name,
                        _candidate,
                    ) in self._class_candidates()
                )
            )

            raise KeyError(
                "The quarantine ORM model does not expose "
                f"source class {source_class_id!r}. Available "
                "class identifiers: "
                f"{available_classes!r}."
            )

        if (
            len(
                unique_matches,
            )
            != 1
        ):
            matching_classes = tuple(
                sorted(
                    self._class_description(
                        candidate,
                    )
                    for candidate in unique_matches
                )
            )

            raise RuntimeError(
                "Several quarantine ORM classes match "
                f"source class {source_class_id!r}: "
                f"{matching_classes!r}."
            )

        return unique_matches[0]

    def _exact_source_class(
        self,
        source_class_id: str,
    ) -> Any | None:
        """
        Return an exact class-collection match when available.
        """

        if isinstance(
            self.model_classes,
            Mapping,
        ):
            return self.model_classes.get(
                source_class_id,
            )

        return getattr(
            self.model_classes,
            source_class_id,
            None,
        )

    def _class_candidates(
        self,
    ) -> tuple[
        tuple[
            str,
            Any,
        ],
        ...,
    ]:
        """
        Return configured quarantine ORM class candidates.

        Both mapping-style collections and SQLAlchemy automap-style class
        namespaces are supported.
        """

        if isinstance(
            self.model_classes,
            Mapping,
        ):
            candidates = tuple(
                (
                    str(
                        configured_name,
                    ),
                    candidate,
                )
                for (
                    configured_name,
                    candidate,
                ) in self.model_classes.items()
                if self._is_mapped_class(
                    candidate,
                )
            )

        else:
            candidates = tuple(
                (
                    attribute_name,
                    candidate,
                )
                for attribute_name in dir(
                    self.model_classes,
                )
                if not attribute_name.startswith(
                    "_",
                )
                for candidate in (
                    getattr(
                        self.model_classes,
                        attribute_name,
                    ),
                )
                if self._is_mapped_class(
                    candidate,
                )
            )

        return candidates

    def _is_mapped_class(
        self,
        candidate: Any,
    ) -> bool:
        """
        Return whether one candidate exposes SQLAlchemy table metadata.
        """

        return (
            getattr(
                candidate,
                "__table__",
                None,
            )
            is not None
        )

    def _class_description(
        self,
        candidate: Any,
    ) -> str:
        """
        Return a diagnostic description of one mapped source class.
        """

        table = getattr(
            candidate,
            "__table__",
            None,
        )

        if table is None:
            return str(
                getattr(
                    candidate,
                    "__name__",
                    candidate,
                )
            )

        schema_name = getattr(
            table,
            "schema",
            None,
        )

        table_name = str(
            table.name,
        )

        if schema_name:
            return f"{schema_name}." f"{table_name}"

        return table_name

    def _normalized_identifier(
        self,
        value: str,
    ) -> str:
        """
        Normalize a source identifier for controlled class lookup.
        """

        return (
            str(
                value,
            )
            .replace(
                "_",
                "",
            )
            .strip()
            .casefold()
        )

    def _unique_t_ids(
        self,
        t_ids: Sequence[int,],
    ) -> tuple[
        int,
        ...,
    ]:
        """
        Validate and deduplicate requested ili2pg identifiers.
        """

        unique_t_ids: dict[
            int,
            None,
        ] = {}

        for t_id in t_ids:
            if not isinstance(
                t_id,
                int,
            ) or isinstance(
                t_id,
                bool,
            ):
                raise TypeError(
                    "Source reference t_id values must be " f"integers, received {t_id!r}."
                )

            unique_t_ids[t_id] = None

        return tuple(
            unique_t_ids,
        )
