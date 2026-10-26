from __future__ import annotations

from collections.abc import Mapping, Sequence
from dataclasses import dataclass
from datetime import date, datetime
from pathlib import Path
from typing import Any

from teksi_hooks.capabilities.review import (
    ReviewArtifactWriter,
)
from teksi_hooks.models.review import (
    ReviewFeature,
)


@dataclass(slots=True)
class TwwReviewArtifactWriter(
    ReviewArtifactWriter,
):
    """
    Plugin-side review artifact writer.

    The current implementation writes GeoPackages using GDAL/OGR.

    Logical strategy:
    - one layer per canonical class;
    - feature attributes are written as normal fields;
    - the first available geometry is written as the layer geometry;
    - additional geometry attributes are written as WKT fields.

    This keeps the hook-side review model generic while allowing the plugin
    to decide how GeoPackage limitations are handled.
    """

    srid: int = 2056

    def write(
        self,
        path: Path,
        layers: Mapping[
            str,
            Sequence[ReviewFeature,],
        ],
    ) -> None:
        from osgeo import ogr, osr

        path.parent.mkdir(
            parents=True,
            exist_ok=True,
        )

        if path.exists():
            path.unlink()

        driver = ogr.GetDriverByName(
            "GPKG",
        )

        if driver is None:
            raise RuntimeError("GDAL/OGR GeoPackage driver is not available.")

        data_source = driver.CreateDataSource(
            str(
                path,
            )
        )

        if data_source is None:
            raise RuntimeError(f"Could not create GeoPackage: {path}")

        try:
            spatial_reference = osr.SpatialReference()
            spatial_reference.ImportFromEPSG(
                self.srid,
            )

            for class_id, features in layers.items():
                self._write_layer(
                    data_source=data_source,
                    layer_name=self._safe_layer_name(
                        class_id,
                    ),
                    features=features,
                    spatial_reference=spatial_reference,
                )
        finally:
            data_source = None

    def _write_layer(
        self,
        *,
        data_source,
        layer_name: str,
        features: Sequence[ReviewFeature,],
        spatial_reference,
    ) -> None:
        from osgeo import ogr

        geometry_attribute_names = self._geometry_attribute_names(
            features,
        )

        primary_geometry_attribute = (
            geometry_attribute_names[0] if geometry_attribute_names else None
        )

        layer = data_source.CreateLayer(
            layer_name,
            spatial_reference,
            ogr.wkbUnknown,
        )

        if layer is None:
            raise RuntimeError(f"Could not create GeoPackage layer: {layer_name}")

        field_names = self._field_names(
            features=features,
            primary_geometry_attribute=primary_geometry_attribute,
        )

        for field_name in field_names:
            layer.CreateField(
                self._field_definition(
                    field_name=field_name,
                    values=self._field_values(
                        features,
                        field_name,
                    ),
                )
            )

        for review_feature in features:
            self._write_feature(
                layer=layer,
                review_feature=review_feature,
                field_names=field_names,
                primary_geometry_attribute=primary_geometry_attribute,
            )

    def _write_feature(
        self,
        *,
        layer,
        review_feature: ReviewFeature,
        field_names: Sequence[str,],
        primary_geometry_attribute: str | None,
    ) -> None:
        from osgeo import ogr

        feature_definition = layer.GetLayerDefn()
        feature = ogr.Feature(
            feature_definition,
        )

        merged_attributes = dict(
            review_feature.attributes,
        )

        for geometry_attribute_name, geometry_value in review_feature.geometries.items():
            if geometry_attribute_name == primary_geometry_attribute:
                continue

            merged_attributes[f"{geometry_attribute_name}_wkt"] = self._geometry_to_wkt(
                geometry_value,
            )

        for field_name in field_names:
            value = merged_attributes.get(
                field_name,
            )

            if value is None:
                continue

            feature.SetField(
                field_name,
                self._field_value(
                    value,
                ),
            )

        if primary_geometry_attribute is not None:
            geometry = self._ogr_geometry(
                review_feature.geometries.get(
                    primary_geometry_attribute,
                )
            )

            if geometry is not None:
                feature.SetGeometry(
                    geometry,
                )

        layer.CreateFeature(
            feature,
        )

        feature = None

    def _field_names(
        self,
        *,
        features: Sequence[ReviewFeature,],
        primary_geometry_attribute: str | None,
    ) -> tuple[str, ...]:
        field_names = set()

        for feature in features:
            field_names.update(
                feature.attributes,
            )

            for geometry_attribute_name in feature.geometries:
                if geometry_attribute_name == primary_geometry_attribute:
                    continue

                field_names.add(f"{geometry_attribute_name}_wkt")

        return tuple(
            sorted(
                field_names,
            )
        )

    def _geometry_attribute_names(
        self,
        features: Sequence[ReviewFeature,],
    ) -> tuple[str, ...]:
        names = []

        for feature in features:
            for geometry_attribute_name in feature.geometries:
                if geometry_attribute_name not in names:
                    names.append(
                        geometry_attribute_name,
                    )

        return tuple(
            names,
        )

    def _field_values(
        self,
        features: Sequence[ReviewFeature,],
        field_name: str,
    ) -> tuple[Any, ...]:
        values = []

        for feature in features:
            if field_name in feature.attributes:
                values.append(feature.attributes[field_name])

        return tuple(
            values,
        )

    def _field_definition(
        self,
        *,
        field_name: str,
        values: Sequence[Any,],
    ):
        from osgeo import ogr

        ogr_type = ogr.OFTString

        for value in values:
            if value is None:
                continue

            if isinstance(
                value,
                bool,
            ):
                ogr_type = ogr.OFTInteger
                break

            if isinstance(
                value,
                int,
            ):
                ogr_type = ogr.OFTInteger
                break

            if isinstance(
                value,
                float,
            ):
                ogr_type = ogr.OFTReal
                break

            if isinstance(
                value,
                (
                    date,
                    datetime,
                ),
            ):
                ogr_type = ogr.OFTString
                break

            ogr_type = ogr.OFTString
            break

        field_definition = ogr.FieldDefn(
            self._safe_field_name(
                field_name,
            ),
            ogr_type,
        )

        return field_definition

    def _field_value(
        self,
        value: Any,
    ) -> Any:
        if isinstance(
            value,
            bool,
        ):
            return int(
                value,
            )

        if isinstance(
            value,
            (
                date,
                datetime,
            ),
        ):
            return value.isoformat()

        return value

    def _ogr_geometry(
        self,
        value: Any,
    ):
        from osgeo import ogr

        if value is None:
            return None

        if hasattr(
            value,
            "ExportToWkt",
        ):
            return value

        if hasattr(
            value,
            "asWkt",
        ):
            return ogr.CreateGeometryFromWkt(
                value.asWkt(),
            )

        if hasattr(
            value,
            "wkt",
        ):
            return ogr.CreateGeometryFromWkt(
                value.wkt,
            )

        if isinstance(
            value,
            bytes,
        ):
            return ogr.CreateGeometryFromWkb(
                value,
            )

        if isinstance(
            value,
            str,
        ):
            return ogr.CreateGeometryFromWkt(
                value,
            )

        return None

    def _geometry_to_wkt(
        self,
        value: Any,
    ) -> str | None:
        geometry = self._ogr_geometry(
            value,
        )

        if geometry is None:
            return None

        return geometry.ExportToWkt()

    def _safe_layer_name(
        self,
        name: str,
    ) -> str:
        return (
            name.replace(
                ".",
                "_",
            )
            .replace(
                "-",
                "_",
            )
            .replace(
                " ",
                "_",
            )
        )

    def _safe_field_name(
        self,
        name: str,
    ) -> str:
        return (
            name.replace(
                ".",
                "_",
            )
            .replace(
                "-",
                "_",
            )
            .replace(
                " ",
                "_",
            )
        )
