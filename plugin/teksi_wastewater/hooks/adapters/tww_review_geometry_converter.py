from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass
from typing import Any

from teksi_hooks.capabilities.review import (
    ReviewGeometryConverter,
)
from teksi_hooks.models.canonical_object import (
    CanonicalGeometryFamily,
)
from teksi_hooks.models.review import (
    ReviewGeometry,
)


@dataclass(
    slots=True,
    frozen=True,
)
class TwwReviewGeometryConverter(
    ReviewGeometryConverter,
):
    """
    Convert PostGIS EWKB values to portable review geometries.

    TWW geometry providers must return binary EWKB produced by
    ``ST_AsEWKB()``. Geometry family information is supplied from canonical
    model metadata rather than inferred by decoding the geometry.

    The converter does not transform, linearize, flatten, or otherwise inspect
    the geometry payload.
    """

    families_by_attribute: Mapping[
        tuple[
            str,
            str,
        ],
        CanonicalGeometryFamily,
    ]

    def review_geometry(
        self,
        *,
        class_id: str,
        attribute_id: str,
        value: Any,
    ) -> ReviewGeometry:
        """
        Return one portable review geometry.
        """

        ewkb = self._ewkb(
            value,
            class_id=class_id,
            attribute_id=attribute_id,
        )

        try:
            family = self.families_by_attribute[
                (
                    class_id,
                    attribute_id,
                )
            ]

        except KeyError as exception:
            raise KeyError(
                "No review geometry family is configured for "
                f"{class_id!r}.{attribute_id!r}."
            ) from exception

        return ReviewGeometry(
            ewkb=ewkb,
            family=family,
        )

    def _ewkb(
        self,
        value: Any,
        *,
        class_id: str,
        attribute_id: str,
    ) -> bytes:
        """
        Return one binary EWKB payload.

        PostGIS geometry providers are required to use ``ST_AsEWKB()``.
        """

        if isinstance(
            value,
            memoryview,
        ):
            ewkb = value.tobytes()

        elif isinstance(
            value,
            bytes,
        ):
            ewkb = value

        elif isinstance(
            value,
            bytearray,
        ):
            ewkb = bytes(
                value,
            )

        else:
            raise TypeError(
                "TWW review geometry providers must return "
                "binary EWKB from ST_AsEWKB(). Received "
                f"{type(value)!r} for "
                f"{class_id!r}.{attribute_id!r}."
            )

        if not ewkb:
            raise ValueError(
                "TWW review geometry EWKB must not be empty "
                f"for {class_id!r}.{attribute_id!r}."
            )

        return ewkb