# -----------------------------------------------------------
#
# Elevation Profile — Layer Setup
# Copyright (C) 2026  TEKSI Contributors and Peter Zhao
# -----------------------------------------------------------
#
# licensed under the terms of GNU GPL 2
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# ---------------------------------------------------------------------

import math
import time

from qgis.core import (
    Qgis,
    QgsExpression,
    QgsFeature,
    QgsFeatureRequest,
    QgsFillSymbol,
    QgsGeometry,
    QgsLineString,
    QgsLineSymbol,
    QgsMarkerSymbol,
    QgsPoint,
    QgsPointXY,
    QgsProject,
    QgsRectangle,
    QgsSimpleLineSymbolLayer,
    QgsVectorLayer,
    QgsVectorLayerElevationProperties,
)
from qgis.PyQt.QtCore import Qt
from qgis.PyQt.QtGui import QColor

from ...utils.database_utils import DatabaseUtils
from ...utils.twwlayermanager import TwwLayerManager

# Narrowest schematic shaft width (px); also the fallback when ma_dimension1 is
# missing, so a manhole with no known width reads as the thinnest, not the widest.
MANHOLE_DEFAULT_PX_WIDTH = 10

# Schematic manhole shaft height (px). Real shaft depth (2-10 m) is sub-pixel
# once a whole network's relief is in view, so the height is exaggerated and
# proportional — clamped to this range — while the bottom stays at the true level.
MANHOLE_MIN_SHAFT_PX = 12.0
MANHOLE_MAX_SHAFT_PX = 70.0

# The shaft is anchored at the pipe invert (rp level) and split into two
# exaggerated segments: invert->cover (up) and invert->floor / sump (down).
# Same px-per-metre gain for both so their ratio stays truthful; small minimums
# keep the cover clearly above and the floor clearly below the pipe.
MANHOLE_VERTICAL_GAIN_PX = 6.0
MANHOLE_MIN_COVER_PX = 10.0
MANHOLE_MIN_SUMP_PX = 3.0


class ProfileLayerSetup:
    """
    Manages data source configuration for the elevation profile canvas.

    Encapsulates temporary memory layer creation (reach Z injection, node
    filtering) and elevation property / symbol configuration for all profile
    layers. Instances are owned by TwwElevationProfileWidget.
    """

    def __init__(self, canvas):
        """
        :param canvas: TwwElevationProfileCanvas instance to configure.
        """
        self._canvas = canvas
        self._temp_reach_layer = None  # Memory layer with Z values for vw_tww_reach
        self._structure_cache = []  # Cached ws features for manhole dash building
        self._reach_source = None  # Original vw_tww_reach layer (for re-filtering)
        self._ws_source = None  # Original vw_tww_wastewater_structure layer
        self._change_point_source = None  # Original vw_change_points layer
        self._change_point_cache = []  # Cached change points for overlay X marks
        # (x, y, z) of every temp-reach vertex plus a 0.1 m coordinate-bucket
        # index, rebuilt whenever the reach features are (updatePathFeatures).
        # Lets _adjacentReachLevel resolve an invert anchor with a lookup
        # instead of scanning the whole temp layer once per structure.
        self._reach_vertices = []
        self._reach_vertex_buckets = {}

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def setup(self, tolerance=10.0):
        """
        Set up data sources for the elevation profile canvas.

        Based on the working configuration tested by the project owner:
        - Use "Capture curve from features" approach
        - Native canvas layer: vw_tww_reach (Absolute clamping, Z from geometry)
        - Structures and change points are drawn by the overlay, not as native
          layers (their markers otherwise collapse onto the pipe invert)

        The temp reach layer is the ONLY canvas layer; it is created empty
        here and filled per selection by updatePathFeatures. Structures are
        not layers at all: a single pass over vw_tww_wastewater_structure
        (in updatePathFeatures) caches per-structure entries for the overlay.
        No fallback — structures without a level are rendered as explicit
        missing-data marks, never guessed. Neither vw_cover nor
        vw_wastewater_node is read.

        :param tolerance: Snapping tolerance in map units for the canvas.
        """
        # 1. CRITICAL: Set project first - this is required by QgsElevationProfileCanvas
        project = QgsProject.instance()
        self._canvas.setProject(project)

        # Sources for the overlay caches (structures, change points). The
        # caches themselves are filled by updatePathFeatures — which always
        # runs right after setup() — so each view is fetched once per
        # selection, not once here for the whole network and again there.
        self._ws_source = TwwLayerManager.layer("vw_tww_wastewater_structure")
        self._change_point_source = TwwLayerManager.layer("vw_change_points")

        # 2. Define the layers to use (based on working configuration)
        # profile_type: 'surface' = Continuous Surface, 'features' = Individual Features
        # Color scheme designed for professional engineering drawings
        layer_configs = [
            (
                "vw_tww_reach",
                "Reach/Pipe segments",
                "features",
                {
                    # The visible pipe is the exaggerated band drawn by
                    # ManholeDashPlotItem; the native QGIS reach line is NOT drawn
                    # (hide_profile_line sets its symbol opacity to 0). QGIS's own
                    # tolerance projection draws a spurious zig-zag/spike at reach
                    # junctions — empirically confirmed 2026-06-30 by recolouring
                    # this line magenta: the magenta spike appeared while the band
                    # (which projects cleanly via lineLocatePoint) did not. The
                    # layer still stays on the canvas so identify and Y-axis auto-
                    # ranging keep working. Colour/width are irrelevant while
                    # hidden but kept sane in case the flag is ever removed.
                    "line": "#1A5276",
                    "line_width": 0.3,
                    "hide_profile_line": True,
                    "fill": "#1A527620",
                    "marker": "#5DADE2",
                    "marker_size": 4,
                    "marker_outline": "#1A5276",
                    "marker_name": "circle",
                    "hollow": False,
                    # The node where two reaches meet is already drawn by the
                    # manhole shaft overlay; a reach vertex marker here just
                    # collapses onto the invert and reads as a stray data point
                    # (same reason vw_wastewater_node/vw_cover are not rendered).
                    "show_markers": False,
                },
            ),
            # vw_wastewater_node, vw_cover and vw_change_points are intentionally
            # NOT rendered as native layers: at network-overview zoom their markers
            # collapse onto the pipe invert (co_level, wn_bottom_level, the change-
            # point level and rp level are all within sub-pixel), where the overlay
            # pipe band then paints over them. The manhole is drawn by the overlay
            # shaft; the change point is drawn by the overlay as a map-style X
            # (see buildChangePointMarkers / ManholeDashPlotItem._drawChangePointX).
        ]

        layers_to_add = []
        first_valid_crs = None

        for layer_name, _description, profile_type, style in layer_configs:
            layer = TwwLayerManager.layer(layer_name)
            if not layer:
                continue

            # Special handling for vw_tww_reach: swap in an (empty) temp layer
            # with LineStringZ geometry — the original has no usable Z values.
            if layer_name == "vw_tww_reach":
                self._reach_source = layer
                self._temp_reach_layer = self._createEmptyReachLayer(layer)
                if self._temp_reach_layer:
                    layer = self._temp_reach_layer

            # Store first valid CRS for canvas
            if first_valid_crs is None and layer.crs().isValid():
                first_valid_crs = layer.crs()

            # 3. Configure elevation properties for each layer
            elevation_props = layer.elevationProperties()
            if elevation_props and isinstance(elevation_props, QgsVectorLayerElevationProperties):
                try:
                    if hasattr(elevation_props, "setEnabled"):
                        elevation_props.setEnabled(True)

                    if hasattr(Qgis, "VectorProfileType"):
                        if profile_type == "surface":
                            elevation_props.setType(Qgis.VectorProfileType.ContinuousSurface)
                        else:
                            elevation_props.setType(Qgis.VectorProfileType.IndividualFeatures)

                    if hasattr(Qgis, "AltitudeClamping"):
                        elevation_props.setClamping(Qgis.AltitudeClamping.Absolute)
                    elif hasattr(elevation_props, "setClamping"):
                        elevation_props.setClamping(0)

                    if hasattr(Qgis, "AltitudeBinding"):
                        elevation_props.setBinding(Qgis.AltitudeBinding.Vertex)

                    # QGIS >= 3.38: Line/Polygon memory layers default to customTolerance=0
                    # (see QgsVectorLayerElevationProperties::setDefaultsFromLayer), which
                    # overrides the canvas tolerance and breaks profile/line intersection —
                    # spurious vertical segments appear at reach vertices. Use canvas tolerance.
                    if hasattr(elevation_props, "setCustomToleranceEnabled"):
                        elevation_props.setCustomToleranceEnabled(False)

                    self._configureLayerSymbols(elevation_props, style, layer_name)
                    layer.triggerRepaint()

                except Exception:
                    pass

            layers_to_add.append(layer)

        if not layers_to_add:
            print("✗ No layers found! Available layers in project:")
            for _layer_id, layer in project.mapLayers().items():
                print(f"    - {layer.name()}")
            return

        if first_valid_crs:
            self._canvas.setCrs(first_valid_crs)
        self._canvas.setLayers(layers_to_add)
        self.applyCanvasTolerance(tolerance)

    def applyCanvasTolerance(self, tolerance=10.0):
        """
        Apply canvas tolerance to all profile layers without calling setLayers().

        Safe to call on every profile refresh (QGIS >= 3.38 compatibility).
        """
        if hasattr(self._canvas, "setTolerance"):
            self._canvas.setTolerance(tolerance)

        if not hasattr(self._canvas, "layers"):
            return
        layers = self._canvas.layers()
        if not layers:
            return

        for layer in layers:
            elevation_props = layer.elevationProperties()
            if not elevation_props or not isinstance(
                elevation_props, QgsVectorLayerElevationProperties
            ):
                continue
            try:
                if hasattr(elevation_props, "setCustomToleranceEnabled"):
                    elevation_props.setCustomToleranceEnabled(False)
            except Exception:
                pass

    def updatePathFeatures(self, reach_ids=None, node_points=None):
        """
        Re-filter the temp layer contents to the currently selected path.

        Reuses the existing layer objects so the canvas is NOT re-wired with
        setLayers() (that crashes an active QgsElevationProfileCanvas). Only the
        features are swapped, which the canvas picks up on the next refresh.

        Without this, QGIS draws every reach/structure within tolerance of the
        profile curve — including side branches that merely share a node with
        the path. When reach_ids / node_points are None the layers keep every
        feature (used by the tree tool and as a safe fallback).

        :param reach_ids: iterable of selected reach obj_ids, or None.
        :param node_points: iterable of QgsPointXY of selected path nodes, or None.
        """
        if self._temp_reach_layer is not None and self._reach_source is not None:
            reach_features = self._reachZFeatures(self._reach_source, reach_ids)
            self._refillLayer(self._temp_reach_layer, reach_features)
            self._rebuildReachVertexIndex(reach_features)

        if self._ws_source is not None:
            self._structure_cache = self._structureEntries(self._ws_source, node_points)

        if self._change_point_source is not None:
            self._change_point_cache = self._changePointEntries(
                self._change_point_source, node_points
            )

    @staticmethod
    def _refillLayer(layer, features):
        """Replace all features of a memory layer in place."""
        provider = layer.dataProvider()
        try:
            provider.truncate()
        except Exception:
            existing = [f.id() for f in layer.getFeatures()]
            if existing:
                provider.deleteFeatures(existing)
        if features:
            provider.addFeatures(features)
        layer.updateExtents()
        layer.triggerRepaint()

    def buildManholeDashes(self, profile_curve_geom, tolerance, default_px_width=None):
        """
        Build manhole shaft overlay data along a profile curve.

        Uses structure entries cached during updatePathFeatures() — no second
        layer scan.

        :param profile_curve_geom: QgsGeometry of the profile path.
        :param tolerance: Max distance from curve in map units.
        :param default_px_width: Fallback shaft width in pixels.
        :return: List of dash dicts for ManholeDashPlotItem.
        """
        if default_px_width is None:
            default_px_width = MANHOLE_DEFAULT_PX_WIDTH
        if profile_curve_geom is None or profile_curve_geom.isEmpty() or not self._structure_cache:
            return []

        dashes = []
        for entry in self._structure_cache:
            geometry = entry["geometry"]
            try:
                distance_along = profile_curve_geom.lineLocatePoint(geometry)
            except Exception:
                continue

            if distance_along is None or distance_along < 0:
                continue

            try:
                if profile_curve_geom.distance(geometry) > tolerance:
                    continue
            except Exception:
                pass

            dim1_mm = entry["dim1_mm"]
            cover_missing = entry["cover_level_missing"]
            bottom_missing = entry["bottom_level_missing"]
            # Pipe-invert level at this structure (rp_from/to_level), taken as the
            # nearest reach vertex Z. This is the TRUE-elevation anchor the shaft
            # is built around: cover sits above it, floor (wn_bottom_level) below
            # it (the sump). None when no Z reach is near → fall back to bottom.
            invert_level = self._adjacentReachLevel(geometry)
            dashes.append(
                {
                    "distance": float(distance_along),
                    "obj_id": entry["obj_id"],
                    "identifier": entry.get("identifier"),
                    "ws_type": entry.get("ws_type"),
                    "cover_level": entry["cover_level"],
                    "bottom_level": entry["bottom_level"],
                    "cover_level_missing": cover_missing,
                    "bottom_level_missing": bottom_missing,
                    "invert_level": invert_level,
                    "dim1_mm": entry["dim1_mm"],
                    "_cover_label": entry.get("_cover_label"),
                    "_bottom_label": entry.get("_bottom_label"),
                    "_input_label": entry.get("_input_label"),
                    "_output_label": entry.get("_output_label"),
                    "co_obj_id": entry.get("co_obj_id"),
                    "co_material": entry.get("co_material"),
                    "co_shape": entry.get("co_shape"),
                    "co_brand": entry.get("co_brand"),
                    "ss_function": entry.get("ss_function"),
                    "width": manhole_dash_width(dim1_mm, default_px_width),
                }
            )

        return dashes

    def _rebuildReachVertexIndex(self, reach_features):
        """
        Cache (x, y, z) for every vertex of the current temp-reach features,
        plus a 0.1 m coordinate-bucket index.

        _adjacentReachLevel used to scan the whole temp layer per structure —
        O(structures × reaches) geometry calls per selection. Structures sit
        exactly on reach endpoints (verified against live data), so a bucket
        hit resolves the invert anchor immediately; a flat scan over all
        cached vertices remains as the nearest-vertex fallback for points not
        exactly on a vertex.
        """
        vertices = []
        buckets = {}
        for feat in reach_features or []:
            geom = feat.geometry()
            if geom is None or geom.isEmpty():
                continue
            for vertex in geom.vertices():
                z_value = vertex.z()
                if z_value is None or math.isnan(z_value):
                    continue
                x, y = vertex.x(), vertex.y()
                vertices.append((x, y, z_value))
                buckets.setdefault((round(x, 1), round(y, 1)), []).append((x, y, z_value))
        self._reach_vertices = vertices
        self._reach_vertex_buckets = buckets

    def _adjacentReachLevel(self, point_geom):
        """
        Invert level to anchor a structure on the profile.

        Taken as the Z of the nearest temp-reach vertex (reach endpoints sit on
        the manhole node), looked up in the index built by
        _rebuildReachVertexIndex. Returns None when no Z-bearing reach exists,
        in which case the canvas skips drawing instead of guessing a position.
        """
        if not self._reach_vertices or point_geom is None:
            return None
        try:
            point = point_geom.asPoint()
        except Exception:
            return None
        px, py = point.x(), point.y()

        # Fast path: the 3x3 bucket neighbourhood covers every vertex within
        # ~0.1 m — the exact-coincidence case. Fall back to all vertices so a
        # structure that is near a reach but not on a vertex still anchors.
        cx, cy = round(px, 1), round(py, 1)
        candidates = []
        for dx in (-0.1, 0.0, 0.1):
            for dy in (-0.1, 0.0, 0.1):
                candidates.extend(
                    self._reach_vertex_buckets.get(
                        (round(cx + dx, 1), round(cy + dy, 1)), ()
                    )
                )
        if not candidates:
            candidates = self._reach_vertices

        best_z = None
        best_sqr = None
        for x, y, z_value in candidates:
            sqr_dist = (x - px) ** 2 + (y - py) ** 2
            if best_sqr is None or sqr_dist < best_sqr:
                best_sqr = sqr_dist
                best_z = z_value
        return best_z

    def buildChangePointMarkers(self, profile_curve_geom, tolerance):
        """
        Build change-point marker data along the profile curve.

        Projects each cached change point onto the curve (lineLocatePoint); the
        X is anchored at the change-point level (= the pipe invert there), with
        the nearest reach-vertex Z as a fallback when the change point has no
        usable Z. Skipped when nothing can anchor it, never guessed.

        :param profile_curve_geom: QgsGeometry of the profile path.
        :param tolerance: Max distance from the curve in map units.
        :return: List of marker dicts for ManholeDashPlotItem.
        """
        if (
            profile_curve_geom is None
            or profile_curve_geom.isEmpty()
            or not self._change_point_cache
        ):
            return []

        markers = []
        for entry in self._change_point_cache:
            geometry = entry["geometry"]
            try:
                distance_along = profile_curve_geom.lineLocatePoint(geometry)
            except Exception:
                continue
            if distance_along is None or distance_along < 0:
                continue
            try:
                if profile_curve_geom.distance(geometry) > tolerance:
                    continue
            except Exception:
                pass

            level = entry.get("level")
            if level is None:
                level = self._adjacentReachLevel(geometry)
            if level is None:
                continue

            markers.append(
                {
                    "distance": float(distance_along),
                    "level": float(level),
                    "obj_id": entry.get("obj_id"),
                    "change_in_material": entry.get("change_in_material"),
                    "change_in_clear_height": entry.get("change_in_clear_height"),
                    "change_in_slope": entry.get("change_in_slope"),
                }
            )
        return markers

    def buildReachBands(self, profile_curve_geom, tolerance):
        """
        Build pipe-band overlay data along the profile curve.

        QGIS renders each reach as a single invert line; to show the pipe height
        the canvas needs the invert *and* the clear height so it can draw the
        soffit above. The invert is anchored to the true level (Z); the soffit
        is offset upward by an exaggerated pixel thickness (see reach_band_px),
        because the real clear height is sub-pixel at network-overview zoom.
        This returns, per reach, the invert vertices as (distance, invert_Z)
        plus raw clear_height in mm (None when missing — only the invert line is
        then drawn, never a fabricated height).

        Reuses the temp reach layer (LineStringZ, Z = interpolated invert).
        """
        if (
            self._temp_reach_layer is None
            or profile_curve_geom is None
            or profile_curve_geom.isEmpty()
        ):
            return []

        bands = []
        for feat in self._temp_reach_layer.getFeatures():
            geom = feat.geometry()
            if geom is None or geom.isEmpty():
                continue
            try:
                if profile_curve_geom.distance(geom) > tolerance:
                    continue
            except Exception:
                pass

            points = []
            for vertex in geom.vertices():
                z_value = vertex.z()
                if z_value is None or math.isnan(z_value):
                    continue
                try:
                    distance_along = profile_curve_geom.lineLocatePoint(
                        QgsGeometry(QgsPoint(vertex.x(), vertex.y()))
                    )
                except Exception:
                    continue
                if distance_along is None or distance_along < 0:
                    continue
                points.append((float(distance_along), float(z_value)))

            if len(points) < 2:
                continue
            points.sort(key=lambda item: item[0])

            attrs = _feature_attributes(feat)
            bands.append(
                {
                    "invert": points,
                    "clear_height_mm": _to_float(attrs.get("clear_height")),
                }
            )

        return bands

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    def _createEmptyReachLayer(self, original_layer):
        """
        Create the temp LineStringZ memory layer for vw_tww_reach (schema only).

        vw_tww_reach geometry has no Z, so profile features are rebuilt with
        interpolated Z by _reachZFeatures. The layer is created EMPTY: the one
        fill per selection happens in updatePathFeatures (setup used to
        pre-fill the whole network here, only for updatePathFeatures to
        immediately truncate and refill it).

        :param original_layer: The original vw_tww_reach layer
        :return: Empty memory layer with LineStringZ geometry
        """
        if original_layer is None:
            return None

        crs = original_layer.crs()
        crs_string = crs.authid() if crs.isValid() else "EPSG:2056"

        mem_layer = QgsVectorLayer(
            f"LineStringZ?crs={crs_string}",
            "reach_with_z",
            "memory",
        )
        provider = mem_layer.dataProvider()
        provider.addAttributes(original_layer.fields().toList())
        mem_layer.updateFields()
        return mem_layer

    def _reachZFeatures(self, original_layer, reach_ids=None):
        """
        Build LineStringZ features from vw_tww_reach, interpolating Z from
        rp_from_level / rp_to_level. Reaches missing either level are dropped.

        :param reach_ids: when not None, only reaches whose obj_id is in this
            set are included — this restricts the profile to the selected path
            instead of every reach that happens to lie near the curve. The
            restriction is pushed into the feature request (_features_by_obj_id),
            so the whole view is never streamed just to discard it here.
        """
        features = []

        for feat in _features_by_obj_id(original_layer, reach_ids):
            from_level = None
            to_level = None

            try:
                from_level = feat["rp_from_level"]
                to_level = feat["rp_to_level"]
            except KeyError:
                pass

            if from_level is None or to_level is None:
                continue

            try:
                from_level = float(from_level)
                to_level = float(to_level)
            except (TypeError, ValueError):
                continue

            geom = feat.geometry()
            if geom is None or geom.isEmpty():
                continue

            vertices = list(geom.vertices())
            if len(vertices) < 2:
                continue

            new_points = []
            total_length = geom.length()

            if total_length > 0 and len(vertices) > 2:
                accumulated_length = 0.0
                for i, vertex in enumerate(vertices):
                    if i == 0:
                        z_value = from_level
                    elif i == len(vertices) - 1:
                        z_value = to_level
                    else:
                        prev_vertex = vertices[i - 1]
                        segment_length = QgsPointXY(prev_vertex.x(), prev_vertex.y()).distance(
                            QgsPointXY(vertex.x(), vertex.y())
                        )
                        accumulated_length += segment_length
                        ratio = accumulated_length / total_length
                        z_value = from_level + (to_level - from_level) * ratio

                    new_points.append(QgsPoint(vertex.x(), vertex.y(), z_value))
            else:
                new_points.append(QgsPoint(vertices[0].x(), vertices[0].y(), from_level))
                new_points.append(QgsPoint(vertices[-1].x(), vertices[-1].y(), to_level))

            new_line = QgsLineString(new_points)
            new_geom = QgsGeometry(new_line)
            new_feat = QgsFeature()
            new_feat.setGeometry(new_geom)
            new_feat.setAttributes(feat.attributes())
            features.append(new_feat)

        return features

    def _structureEntries(self, ws_layer, node_points=None):
        """
        Scan vw_tww_wastewater_structure once and cache per-structure entries.

        Structures are not canvas layers: the ManholeDashPlotItem overlay
        (shaft, cover cap, missing-data marks) and the hover tooltips all read
        this cache. When node_points is not None, a structure is only included
        if its profile point coincides with one of the selected path's node
        points — this keeps side-branch structures out of the profile. That
        exact test still runs here; the path's bounding box is pushed into the
        feature request first (_features_near_path) so only structures near the
        path are fetched at all, instead of the whole network per selection.
        """
        path_points = list(node_points) if node_points is not None else None

        structure_cache = []

        for feat in _features_near_path(ws_layer, path_points):
            attrs = _feature_attributes(feat)
            point_geom = _structure_profile_point(feat)
            if point_geom is None:
                continue

            try:
                point = point_geom.asPoint()
            except Exception:
                continue

            if path_points is not None and not _point_on_path(point, path_points):
                continue

            cover_level, bottom_level, cover_missing, bottom_missing = _manhole_level_state(
                _to_float(attrs.get("co_level")),
                _to_float(attrs.get("wn_bottom_level")),
            )

            # Both-missing structures are kept so the canvas can draw an
            # explicit "no level data" dashed shaft — nothing is fabricated.
            structure_cache.append(
                {
                    "geometry": point_geom,
                    "obj_id": attrs.get("obj_id"),
                    "identifier": attrs.get("identifier"),
                    "ws_type": attrs.get("ws_type"),
                    "cover_level": cover_level,
                    "bottom_level": bottom_level,
                    "cover_level_missing": cover_missing,
                    "bottom_level_missing": bottom_missing,
                    "dim1_mm": _to_float(attrs.get("ma_dimension1")),
                    "_cover_label": attrs.get("_cover_label"),
                    "_bottom_label": attrs.get("_bottom_label"),
                    "_input_label": attrs.get("_input_label"),
                    "_output_label": attrs.get("_output_label"),
                    # Cover attributes for the dedicated cover-cap tooltip.
                    "co_obj_id": attrs.get("co_obj_id"),
                    "co_material": attrs.get("co_material"),
                    "co_shape": attrs.get("co_shape"),
                    "co_brand": attrs.get("co_brand"),
                    # Special-structure function (value-list code) for the tooltip.
                    "ss_function": attrs.get("ss_function"),
                }
            )

        return structure_cache

    def _changePointEntries(self, cp_layer, node_points=None):
        """
        Read vw_change_points into overlay-ready entries.

        A change point is a junction node where reaches meet without a structure.
        Its geometry is a PointZ whose Z is the node level (the pipe invert at
        that node). When ``node_points`` is given, only change points sitting on
        a selected path node are kept — the same path filter as structures.
        """
        if cp_layer is None:
            return []

        path_points = list(node_points) if node_points is not None else None
        entries = []
        # Bounding-box pre-filtered in the request, exactly like the structures
        # above; _point_on_path below still does the exact node test.
        for feat in _features_near_path(cp_layer, path_points):
            geom = feat.geometry()
            if geom is None or geom.isEmpty():
                continue
            try:
                point = geom.asPoint()
            except Exception:
                continue
            if path_points is not None and not _point_on_path(point, path_points):
                continue

            level = None
            try:
                z_value = geom.vertexAt(0).z()
                if z_value is not None and not math.isnan(z_value):
                    level = float(z_value)
            except Exception:
                level = None

            attrs = _feature_attributes(feat)
            entries.append(
                {
                    "geometry": geom,
                    "obj_id": attrs.get("obj_id"),
                    "level": level,
                    "change_in_material": attrs.get("change_in_material"),
                    "change_in_clear_height": attrs.get("change_in_clear_height"),
                    "change_in_slope": attrs.get("change_in_slope"),
                }
            )
        return entries

    def _configureLayerSymbols(self, elevation_props, style, layer_name):
        """
        Configure profile symbols for a layer to improve visual appearance.

        :param elevation_props: QgsVectorLayerElevationProperties
        :param style: dict with 'line', 'line_width', 'fill', 'marker', 'marker_size'.
                      Optional 'hollow': True to create hollow/outline effect for lines.
        :param layer_name: Name of the layer (for logging)
        """
        try:
            if hasattr(elevation_props, "setProfileLineSymbol"):
                if style.get("hollow", False):
                    line_symbol = QgsLineSymbol()
                    line_symbol.deleteSymbolLayer(0)

                    inner_width = style["line_width"]
                    inner_layer = QgsSimpleLineSymbolLayer()
                    inner_layer.setColor(QColor(style.get("line_inner", "#FFFFFF")))
                    inner_layer.setWidth(inner_width)
                    inner_layer.setPenCapStyle(Qt.PenCapStyle.RoundCap)
                    inner_layer.setPenJoinStyle(Qt.PenJoinStyle.RoundJoin)
                    line_symbol.appendSymbolLayer(inner_layer)

                    outline_width = style.get("outline_width", 0.8)
                    outline_layer = QgsSimpleLineSymbolLayer()
                    outline_layer.setColor(QColor(style["line"]))
                    outline_layer.setWidth(outline_width)
                    outline_layer.setOffset(inner_width / 2 - outline_width / 2)
                    outline_layer.setPenCapStyle(Qt.PenCapStyle.RoundCap)
                    outline_layer.setPenJoinStyle(Qt.PenJoinStyle.RoundJoin)
                    line_symbol.appendSymbolLayer(outline_layer)

                    bottom_layer = QgsSimpleLineSymbolLayer()
                    bottom_layer.setColor(QColor(style["line"]))
                    bottom_layer.setWidth(outline_width)
                    bottom_layer.setOffset(-(inner_width / 2 - outline_width / 2))
                    bottom_layer.setPenCapStyle(Qt.PenCapStyle.RoundCap)
                    bottom_layer.setPenJoinStyle(Qt.PenJoinStyle.RoundJoin)
                    line_symbol.appendSymbolLayer(bottom_layer)
                else:
                    line_symbol = QgsLineSymbol.createSimple(
                        {
                            "color": style["line"],
                            "width": str(style["line_width"]),
                            "capstyle": "round",
                            "joinstyle": "round",
                        }
                    )
                # Suppress the native profile line (keep the layer for identify /
                # Y-axis range) — QGIS's tolerance projection draws a spurious
                # zig-zag at junctions; the overlay band is the visible pipe.
                if style.get("hide_profile_line", False):
                    line_symbol.setOpacity(0.0)
                elevation_props.setProfileLineSymbol(line_symbol)

            if hasattr(elevation_props, "setProfileFillSymbol"):
                fill_symbol = QgsFillSymbol.createSimple(
                    {
                        "color": style["fill"],
                        "outline_color": style["line"],
                        "outline_width": "0.5",
                    }
                )
                elevation_props.setProfileFillSymbol(fill_symbol)

            if hasattr(elevation_props, "setProfileMarkerSymbol"):
                marker_symbol = QgsMarkerSymbol.createSimple(
                    {
                        "color": style["marker"],
                        "size": str(style["marker_size"]),
                        "outline_color": style.get("marker_outline", "#FFFFFF"),
                        "outline_width": "0.5",
                        "name": style.get("marker_name", "circle"),
                    }
                )
                # IndividualFeatures profiles have no "show markers" toggle (the
                # QGIS setShow*… methods are surface-plot only), so a reach
                # endpoint marker can't be switched off by a flag — QGIS draws it
                # wherever the feature meets the profile. To honour
                # show_markers=False we make the symbol fully transparent, which
                # keeps the invert line clean (the node is shown by the shaft
                # overlay). Point layers keep their visible marker.
                if not style.get("show_markers", True):
                    marker_symbol.setOpacity(0.0)
                elevation_props.setProfileMarkerSymbol(marker_symbol)

            if hasattr(elevation_props, "setRespectLayerSymbology"):
                elevation_props.setRespectLayerSymbology(False)
        except Exception:
            pass


# ------------------------------------------------------------------
# Module-level utility functions (shared with hover_manager via import)
# ------------------------------------------------------------------


def _feature_attributes(feature):
    """Extract {name: value} dict from a QgsFeature."""
    if feature is None:
        return {}
    try:
        fields = feature.fields()
        names = fields.names() if hasattr(fields, "names") else []
        attrs = {}
        for name in names:
            try:
                attrs[name] = feature.attribute(name)
            except Exception:
                continue
        return attrs
    except Exception:
        return {}


def _features_by_obj_id(layer, obj_ids):
    """
    Features of ``layer`` whose ``obj_id`` is in ``obj_ids``.

    The filter goes into the QgsFeatureRequest so the provider (and, for the
    postgres views, the database) does the work. Fetching the whole view and
    dropping non-matching rows in Python meant a full-network round-trip on
    every profile selection — the same ``obj_id IN (...)`` form is already used
    by TwwElevationProfileWidget.setProfileFromTree.

    :param obj_ids: iterable of obj_ids, or None to keep every feature.
    :return: a feature iterator (empty when ``obj_ids`` is an empty selection).
    """
    if obj_ids is None:
        return layer.getFeatures()
    # Ids come from the DB, but quote them properly rather than concatenating.
    quoted = [QgsExpression.quotedString(str(obj_id)) for obj_id in obj_ids if obj_id]
    if not quoted:
        return iter(())
    request = QgsFeatureRequest()
    request.setFilterExpression(f'"obj_id" IN ({",".join(quoted)})')
    return layer.getFeatures(request)


def _features_near_path(layer, path_points, buffer_m=1.0):
    """
    Features of ``layer`` within the bounding box of the selected path's nodes.

    A COARSE pre-filter only: it lets the provider use its spatial index instead
    of streaming the whole view, and the caller still runs _point_on_path for
    the exact node-coincidence test. ``buffer_m`` is an order of magnitude wider
    than that test's 0.1 m tolerance, so the box can never exclude a structure
    that would have matched.

    The rect is in layer CRS — same assumption _point_on_path already makes when
    it compares structure and path coordinates directly (all TEKSI views share
    the project CRS).

    :param path_points: iterable of QgsPointXY, or None to keep every feature.
    :return: a feature iterator (empty when ``path_points`` is empty).
    """
    if path_points is None:
        return layer.getFeatures()
    xs = [p.x() for p in path_points]
    ys = [p.y() for p in path_points]
    if not xs:
        return iter(())
    rect = QgsRectangle(
        min(xs) - buffer_m,
        min(ys) - buffer_m,
        max(xs) + buffer_m,
        max(ys) + buffer_m,
    )
    return layer.getFeatures(QgsFeatureRequest().setFilterRect(rect))


def _point_on_path(point, path_points, max_sqr_dist=0.01):
    """
    True if ``point`` coincides with one of the selected path's node points.

    A structure's profile point is the main wastewater-node position, which is
    exactly the same coordinate as the corresponding path node, so an exact
    match (within a 0.1 m tolerance) reliably keeps path structures and rejects
    branch structures sitting elsewhere.
    """
    for path_point in path_points:
        try:
            if point.sqrDist(path_point) <= max_sqr_dist:
                return True
        except Exception:
            continue
    return False


def _to_float(value):
    """Safely convert a value to float, returning None on failure."""
    try:
        if value is None:
            return None
        return float(value)
    except (TypeError, ValueError):
        return None


def _structure_profile_point(feat):
    """Return a point QgsGeometry for profile placement, or None."""
    geom = feat.geometry()
    if geom is None or geom.isEmpty():
        return None
    try:
        if geom.type() != Qgis.GeometryType.Point:
            geom = geom.centroid()
        if geom is None or geom.isEmpty():
            return None
        return geom
    except Exception:
        return None


def _manhole_level_state(cover_level, bottom_level):
    """
    Parse cover/bottom levels and missing flags.

    :return: (cover_level, bottom_level, cover_missing, bottom_missing)
    """
    cover_missing = cover_level is None
    bottom_missing = bottom_level is None or bottom_level == 0
    if bottom_missing:
        bottom_level = None
    return cover_level, bottom_level, cover_missing, bottom_missing


def _resolve_manhole_anchors(cover_level, bottom_level):
    """When one level is missing, anchor drawing/hit-test at the known level."""
    anchor_cover = cover_level if cover_level is not None else bottom_level
    anchor_bottom = bottom_level if bottom_level is not None else cover_level
    return anchor_cover, anchor_bottom


def manhole_dash_width(dim1_mm, default_px=MANHOLE_DEFAULT_PX_WIDTH):
    """
    Shaft width in pixels from ma_dimension1 (mm).

    A manhole is ~0.6-0.9 m wide, which on the distance axis (hundreds of
    metres) would be sub-pixel — so width is a *schematic, exaggerated* glyph,
    not to scale. ``dim1_mm / 70`` maps the common 600-900 mm range to a
    10-13 px band; real data barely spreads (median 800 mm), so the band is
    kept narrow to reduce crowding on long paths and the true dimension stays
    in the tooltip. Missing dimension falls back to the narrowest width.
    """
    if dim1_mm is None:
        return default_px
    return max(10.0, min(28.0, float(dim1_mm) / 70.0))


def reach_band_px(clear_height_mm):
    """
    Schematic pipe-band thickness in px from clear_height (mm).

    Uses the SAME vertical exaggeration as the manhole (MANHOLE_VERTICAL_GAIN_PX),
    so a pipe is always drawn smaller than the manhole it connects to — a pipe's
    clear height is physically less than the manhole's depth, so a band taller
    than its manhole (the old clear_height/40 ≈ 25 px/m, ~4× the manhole scale)
    read wrong. A small minimum keeps thin pipes visible. Missing clear_height
    returns None → only the invert line is drawn.
    """
    if clear_height_mm is None:
        return None
    px = (float(clear_height_mm) / 1000.0) * MANHOLE_VERTICAL_GAIN_PX
    return max(4.0, min(MANHOLE_MAX_SHAFT_PX, px))


def manhole_shaft_px(depth_m):
    """
    Schematic manhole shaft height in px from the real depth (cover-bottom, m).

    Fallback used only when the pipe-invert level is unknown; otherwise the
    shaft is split into cover and sump offsets around the invert (see below).
    Exaggerated and proportional so a deeper manhole looks taller at any zoom.
    """
    if depth_m is None or depth_m <= 0:
        return MANHOLE_MIN_SHAFT_PX
    return max(
        MANHOLE_MIN_SHAFT_PX,
        min(MANHOLE_MAX_SHAFT_PX, float(depth_m) * MANHOLE_VERTICAL_GAIN_PX),
    )


def manhole_cover_offset_px(cover_above_invert_m):
    """Exaggerated px from the pipe invert UP to the cover (co_level - rp)."""
    if cover_above_invert_m is None or cover_above_invert_m <= 0:
        return MANHOLE_MIN_COVER_PX
    return max(
        MANHOLE_MIN_COVER_PX,
        min(MANHOLE_MAX_SHAFT_PX, float(cover_above_invert_m) * MANHOLE_VERTICAL_GAIN_PX),
    )


def manhole_sump_offset_px(invert_above_floor_m):
    """Exaggerated px from the pipe invert DOWN to the floor (rp - wn_bottom_level)."""
    if invert_above_floor_m is None or invert_above_floor_m <= 0:
        return MANHOLE_MIN_SUMP_PX
    return max(
        MANHOLE_MIN_SUMP_PX,
        min(MANHOLE_MAX_SHAFT_PX, float(invert_above_floor_m) * MANHOLE_VERTICAL_GAIN_PX),
    )


# ------------------------------------------------------------------
# Value-list (code -> localized term) resolution
# ------------------------------------------------------------------
#
# The TEKSI views expose value-list fields (material, cover shape, ...) as raw
# integer codes — e.g. vw_tww_reach.material = 3639. The tooltips must show the
# human-readable term ("concrete_insitu"), so codes are resolved against the
# tww_vl.<table> dictionaries. Each table is tiny and loaded once, then cached
# for the session; resolution failures fall back to the raw code (never worse
# than before) so a missing DB connection cannot break the tooltip.

_VALUE_LIST_LANGS = ("en", "de", "fr", "it", "ro")
_value_list_cache = {}  # table name -> {code: term}

# After a failed load (DB unreachable), don't retry for this long. Tooltips
# resolve several value lists per format and are rebuilt on mouse move, so
# without this throttle a down DB means one connection attempt (potentially a
# seconds-long timeout) per list per move — freezing the GUI while hovering.
_VALUE_LIST_RETRY_SECONDS = 30.0
_value_list_failed_at = None  # time.monotonic() of the last failed load


def _value_list_language():
    """Return the 2-letter language the TEKSI value lists should be shown in."""
    name = ""
    try:
        from qgis.PyQt.QtCore import QLocale, QSettings

        settings = QSettings()
        if settings.value("locale/overrideFlag", False, type=bool):
            name = settings.value("locale/userLocale", "") or ""
        else:
            name = QLocale.system().name()
    except Exception:
        name = ""
    lang = str(name)[:2].lower()
    return lang if lang in _VALUE_LIST_LANGS else "en"


def _load_value_list(table):
    """Load and cache a ``tww_vl.<table>`` code -> localized term mapping."""
    global _value_list_failed_at

    if table in _value_list_cache:
        return _value_list_cache[table]

    # DB recently unreachable: fail fast until the retry window elapses, so a
    # down DB degrades tooltips to raw codes instead of stalling every hover.
    if (
        _value_list_failed_at is not None
        and time.monotonic() - _value_list_failed_at < _VALUE_LIST_RETRY_SECONDS
    ):
        return {}

    lang = _value_list_language()
    try:
        # value_<lang> with English/German fallbacks for incomplete dictionaries.
        # ``table`` is always a hard-coded constant from the callers below.
        rows = DatabaseUtils.fetchall(
            f"SELECT code, COALESCE(value_{lang}, value_en, value_de) "
            f"FROM tww_vl.{table}"
        )
    except Exception:
        # DB not reachable — not cached (a later hover retries), but throttled
        # via _value_list_failed_at (see _VALUE_LIST_RETRY_SECONDS).
        _value_list_failed_at = time.monotonic()
        return {}

    _value_list_failed_at = None
    mapping = {}
    for code, term in rows or []:
        if code is None or term is None:
            continue
        try:
            mapping[int(code)] = str(term)
        except (TypeError, ValueError):
            continue

    _value_list_cache[table] = mapping
    return mapping


def resolve_value_list(table, code):
    """
    Resolve an integer value-list code to its localized term.

    :param table: the ``tww_vl`` dictionary table name (e.g. ``"reach_material"``).
    :param code: the raw code from the view (int, numeric string, or None).
    :return: the term, or None when the code is empty or cannot be resolved
        (DB unavailable / code absent) — callers then fall back to the raw code.
    """
    if code is None or code == "":
        return None
    try:
        code_int = int(code)
    except (TypeError, ValueError):
        return None
    return _load_value_list(table).get(code_int)
