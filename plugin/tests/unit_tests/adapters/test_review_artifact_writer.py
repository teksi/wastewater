from __future__ import annotations

import sys
from datetime import date, datetime
from types import SimpleNamespace

import pytest
from teksi_hooks.models.review import (
    ReviewFeature,
)
from teksi_wastewater.hooks.adapters.tww_review_artifact_writer import (
    TwwReviewArtifactWriter,
)


class FakeGeometry:
    def __init__(
        self,
        wkt: str,
    ) -> None:
        self.wkt = wkt

    def ExportToWkt(
        self,
    ) -> str:
        return self.wkt


class FakeSpatialReference:
    def __init__(
        self,
    ) -> None:
        self.epsg = None

    def ImportFromEPSG(
        self,
        epsg: int,
    ) -> None:
        self.epsg = epsg


class FakeFieldDefn:
    def __init__(
        self,
        name,
        field_type,
    ) -> None:
        self.name = name
        self.field_type = field_type


def _install_fake_osgeo(
    monkeypatch,
    *,
    driver=None,
) -> None:
    ogr = SimpleNamespace(
        GetDriverByName=lambda name: driver,
        CreateGeometryFromWkt=lambda value: FakeGeometry(
            value,
        ),
        CreateGeometryFromWkb=lambda value: FakeGeometry(
            "WKB",
        ),
        FieldDefn=FakeFieldDefn,
        OFTString="string",
        OFTInteger="integer",
        OFTReal="real",
        wkbUnknown="unknown",
    )

    osr = SimpleNamespace(
        SpatialReference=FakeSpatialReference,
    )

    osgeo = SimpleNamespace(
        ogr=ogr,
        osr=osr,
    )

    monkeypatch.setitem(
        sys.modules,
        "osgeo",
        osgeo,
    )
    monkeypatch.setitem(
        sys.modules,
        "osgeo.ogr",
        ogr,
    )
    monkeypatch.setitem(
        sys.modules,
        "osgeo.osr",
        osr,
    )


def test_review_artifact_writer_collects_geometry_attribute_names_in_order() -> None:
    writer = TwwReviewArtifactWriter()

    features = (
        ReviewFeature(
            class_id="reach",
            object_id="one",
            geometries={
                "progression_geometry": "LINESTRING(0 0, 1 1)",
                "secondary_geometry": "POINT(0 0)",
            },
        ),
        ReviewFeature(
            class_id="reach",
            object_id="two",
            geometries={
                "progression_geometry": "LINESTRING(1 1, 2 2)",
                "third_geometry": "POINT(1 1)",
            },
        ),
    )

    assert writer._geometry_attribute_names(
        features,
    ) == (
        "progression_geometry",
        "secondary_geometry",
        "third_geometry",
    )


def test_review_artifact_writer_field_names_include_attributes_and_secondary_geometry_wkt() -> (
    None
):
    writer = TwwReviewArtifactWriter()

    features = (
        ReviewFeature(
            class_id="reach",
            object_id="one",
            attributes={
                "obj_id": "one",
                "status": "active",
            },
            geometries={
                "progression_geometry": "LINESTRING(0 0, 1 1)",
                "secondary_geometry": "POINT(0 0)",
            },
        ),
    )

    field_names = writer._field_names(
        features=features,
        primary_geometry_attribute="progression_geometry",
    )

    assert field_names == (
        "obj_id",
        "secondary_geometry_wkt",
        "status",
    )


def test_review_artifact_writer_field_values_only_reads_attributes() -> None:
    writer = TwwReviewArtifactWriter()

    features = (
        ReviewFeature(
            class_id="reach",
            object_id="one",
            attributes={
                "status": "active",
            },
        ),
        ReviewFeature(
            class_id="reach",
            object_id="two",
            attributes={
                "other": "ignored",
            },
        ),
        ReviewFeature(
            class_id="reach",
            object_id="three",
            attributes={
                "status": "planned",
            },
        ),
    )

    assert writer._field_values(
        features,
        "status",
    ) == (
        "active",
        "planned",
    )


def test_review_artifact_writer_converts_field_values() -> None:
    writer = TwwReviewArtifactWriter()

    assert (
        writer._field_value(
            True,
        )
        == 1
    )

    assert (
        writer._field_value(
            False,
        )
        == 0
    )

    assert (
        writer._field_value(
            date(
                2026,
                1,
                2,
            ),
        )
        == "2026-01-02"
    )

    assert (
        writer._field_value(
            datetime(
                2026,
                1,
                2,
                3,
                4,
                5,
            ),
        )
        == "2026-01-02T03:04:05"
    )

    assert (
        writer._field_value(
            "unchanged",
        )
        == "unchanged"
    )


def test_review_artifact_writer_safe_layer_and_field_names() -> None:
    writer = TwwReviewArtifactWriter()

    assert (
        writer._safe_layer_name(
            "reach.point-test layer",
        )
        == "reach_point_test_layer"
    )

    assert (
        writer._safe_field_name(
            "progression.geometry-test field",
        )
        == "progression_geometry_test_field"
    )


def test_review_artifact_writer_geometry_to_wkt_from_string(
    monkeypatch,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
    )

    writer = TwwReviewArtifactWriter()

    assert (
        writer._geometry_to_wkt(
            "LINESTRING(0 0, 1 1)",
        )
        == "LINESTRING(0 0, 1 1)"
    )


def test_review_artifact_writer_geometry_to_wkt_from_object_with_as_wkt(
    monkeypatch,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
    )

    class QgisLikeGeometry:
        def asWkt(
            self,
        ) -> str:
            return "POINT(1 2)"

    writer = TwwReviewArtifactWriter()

    assert (
        writer._geometry_to_wkt(
            QgisLikeGeometry(),
        )
        == "POINT(1 2)"
    )


def test_review_artifact_writer_geometry_to_wkt_from_object_with_wkt(
    monkeypatch,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
    )

    class ShapelyLikeGeometry:
        wkt = "POINT(3 4)"

    writer = TwwReviewArtifactWriter()

    assert (
        writer._geometry_to_wkt(
            ShapelyLikeGeometry(),
        )
        == "POINT(3 4)"
    )


def test_review_artifact_writer_returns_none_for_unknown_geometry(
    monkeypatch,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
    )

    writer = TwwReviewArtifactWriter()

    assert (
        writer._geometry_to_wkt(
            object(),
        )
        is None
    )


def test_review_artifact_writer_field_definition_uses_integer_for_bool(
    monkeypatch,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
    )

    writer = TwwReviewArtifactWriter()

    field_definition = writer._field_definition(
        field_name="is_created",
        values=(True,),
    )

    assert field_definition.name == "is_created"
    assert field_definition.field_type == "integer"


def test_review_artifact_writer_field_definition_uses_integer_for_int(
    monkeypatch,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
    )

    writer = TwwReviewArtifactWriter()

    field_definition = writer._field_definition(
        field_name="count",
        values=(3,),
    )

    assert field_definition.name == "count"
    assert field_definition.field_type == "integer"


def test_review_artifact_writer_field_definition_uses_real_for_float(
    monkeypatch,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
    )

    writer = TwwReviewArtifactWriter()

    field_definition = writer._field_definition(
        field_name="length",
        values=(12.5,),
    )

    assert field_definition.name == "length"
    assert field_definition.field_type == "real"


def test_review_artifact_writer_field_definition_uses_string_for_dates(
    monkeypatch,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
    )

    writer = TwwReviewArtifactWriter()

    field_definition = writer._field_definition(
        field_name="created_at",
        values=(
            date(
                2026,
                1,
                1,
            ),
        ),
    )

    assert field_definition.name == "created_at"
    assert field_definition.field_type == "string"


def test_review_artifact_writer_write_raises_when_gpkg_driver_is_missing(
    monkeypatch,
    tmp_path,
) -> None:
    _install_fake_osgeo(
        monkeypatch,
        driver=None,
    )

    writer = TwwReviewArtifactWriter()

    with pytest.raises(
        RuntimeError,
        match="GeoPackage driver is not available",
    ):
        writer.write(
            path=tmp_path / "review.gpkg",
            layers={},
        )
