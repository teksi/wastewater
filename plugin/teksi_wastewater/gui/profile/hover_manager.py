# -----------------------------------------------------------
#
# Elevation Profile — Hover, Tooltip & Map Highlight Manager
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

from qgis.core import QgsFeatureRequest, QgsProfilePoint
from qgis.gui import QgsHighlight
from qgis.PyQt.QtCore import QPoint, QPointF, Qt
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtWidgets import QLabel

from ...utils.twwlayermanager import TwwLayerManager
from .layer_setup import (
    _feature_attributes,
    _to_float,
    reach_band_px,
    resolve_value_list,
)


class ProfileHoverManager:
    """
    Manages hover interaction for the elevation profile canvas.

    Responsibilities:
    - Mouse event routing (mouseMoveEvent → hover detection)
    - Feature identification via official identify() API + custom manhole hit-test
    - Persistent custom tooltip (QLabel) with rich-text content
    - Map canvas highlight synchronised with profile hover
    """

    # Highlight colors for map canvas feedback
    HIGHLIGHT_COLOR = QColor("#2ECC71")  # Emerald green
    HIGHLIGHT_FILL_COLOR = QColor(46, 204, 113, 60)  # Semi-transparent fill

    MISSING_DATA_HTML = '<span style="color:red">Missing Data</span>'

    # tww_vl dictionary tables for resolving raw integer value-list codes.
    REACH_MATERIAL_VL = "reach_material"
    COVER_MATERIAL_VL = "cover_material"
    COVER_SHAPE_VL = "cover_cover_shape"
    SPECIAL_STRUCTURE_FUNCTION_VL = "special_structure_function"

    # Canonical vw_tww_reach attribute names (see tww_app.vw_tww_reach).
    REACH_OBJ_ID = "obj_id"
    REACH_MATERIAL = "material"
    REACH_CLEAR_HEIGHT = "clear_height"
    REACH_LENGTH_EFFECTIVE = "length_effective"
    REACH_SLOPE_PER_MILL = "_slope_per_mill"
    REACH_RP_FROM_LEVEL = "rp_from_level"
    REACH_RP_TO_LEVEL = "rp_to_level"

    # Canonical main-cover fields on vw_tww_wastewater_structure (co_* from main_co).
    COVER_OBJ_ID = "co_obj_id"
    COVER_LEVEL = "co_level"
    COVER_MATERIAL = "co_material"
    COVER_SHAPE = "co_shape"
    COVER_BRAND = "co_brand"

    # Canonical vw_tww_wastewater_structure fields for manhole hover tooltips.
    MANHOLE_OBJ_ID = "obj_id"
    MANHOLE_WS_TYPE = "ws_type"
    MANHOLE_CO_LEVEL = "co_level"
    MANHOLE_BOTTOM_LEVEL = "wn_bottom_level"
    MANHOLE_COVER_LABEL = "_cover_label"
    MANHOLE_BOTTOM_LABEL = "_bottom_label"
    MANHOLE_INPUT_LABEL = "_input_label"
    MANHOLE_OUTPUT_LABEL = "_output_label"
    MANHOLE_DIMENSION1 = "ma_dimension1"

    # Canonical vw_change_points fields for the change-point tooltip.
    CHANGE_POINT_OBJ_ID = "obj_id"
    CHANGE_POINT_MATERIAL = "change_in_material"
    CHANGE_POINT_CLEAR_HEIGHT = "change_in_clear_height"
    CHANGE_POINT_SLOPE = "change_in_slope"

    def __init__(self, canvas, map_canvas):
        """
        :param canvas: TwwElevationProfileCanvas instance.
        :param map_canvas: QgsMapCanvas from iface (may be None in tests).
        """
        self._canvas = canvas
        self._map_canvas = map_canvas

        # Hover state
        self._last_hover_match = None
        self._last_hover_pos = None
        self._last_hover_global_pos = None
        self._last_tooltip_text = None

        # Map highlight state
        self._current_highlight = None
        self._current_highlight_key = None

        # Persistent tooltip widget (avoids QToolTip auto-timeout)
        self._custom_tooltip = QLabel(None)
        self._custom_tooltip.setWindowFlags(
            Qt.WindowType.ToolTip | Qt.WindowType.FramelessWindowHint | Qt.WindowType.WindowStaysOnTopHint
        )
        self._custom_tooltip.setStyleSheet(
            """
            QLabel {
                background-color: #ffffcc;
                border: 1px solid #000000;
                padding: 4px;
                color: #000000;
                font-family: monospace;
                font-size: 10pt;
            }
        """
        )
        self._custom_tooltip.hide()

    # ------------------------------------------------------------------
    # Setup
    # ------------------------------------------------------------------

    def setup(self):
        """
        Connect canvas signals for hover handling.

        Call once after the canvas has been created.
        """
        if hasattr(self._canvas, "setSnappingEnabled"):
            self._canvas.setSnappingEnabled(True)

    # ------------------------------------------------------------------
    # Event handlers (called by TwwElevationProfileCanvas callbacks)
    # ------------------------------------------------------------------

    def onCanvasMouseMove(self, event):
        """Handle raw mouseMoveEvent forwarded from the canvas."""
        self._last_hover_pos = event.pos()
        self._last_hover_global_pos = self._canvas.mapToGlobal(event.pos())
        self._handleCanvasHover(event.pos())

    def onCanvasLeave(self, _event):
        """Handle leaveEvent forwarded from the canvas."""
        self.clearState()

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def clearState(self):
        """Clear all hover state: tooltip, highlight, last match."""
        self._last_hover_match = None
        self._last_tooltip_text = None
        self._custom_tooltip.hide()
        self._clearHighlight()

    # ------------------------------------------------------------------
    # Internal hover pipeline
    # ------------------------------------------------------------------

    def _handleCanvasHover(self, pos):
        """Handle hover using raw canvas pixel coordinates."""
        if not hasattr(self._canvas, "canvasPointToPlotPoint"):
            return
        # Deliberately NOT calling canvas.snapToPlot() here. Its result is of no
        # use to us — the hit-testing below is our own — but its side effect is
        # QGIS's snapped cross-hairs, whose two 6-decimal readouts cannot be
        # restyled or rounded from Python (PyQGIS exposes no cross-hair API at
        # all). The hover tooltip already reports the elevation at the cursor.

        profile_point = self._canvas.canvasPointToPlotPoint(QPointF(pos))
        if self._isEmptyProfilePoint(profile_point):
            plot_point = None
        else:
            plot_point = self._profilePointToPlotPoint(profile_point)

        # Structures are a pixel-space overlay whose exaggerated shafts can
        # extend beyond the plot area (a cover cap pushed above the top axis).
        # Hit-test them first, before the plot-area check, so the whole drawn
        # shaft — cover included — stays hoverable and a structure under the
        # cursor wins over the reach beneath it.
        # Cover cap first (its band sits on top of the shaft body), so hovering
        # the cover shows a dedicated cover tooltip; the body shows the manhole.
        cover_match = self._identifyCoverDash(plot_point)
        if cover_match is not None:
            self._last_hover_match = cover_match
            cover_point = cover_match.get("plot_point")
            self._showHoverTooltip(cover_point, cover_match)
            self._highlightMatchOnMap(cover_point, cover_match)
            return

        structure_match = self._identifyManholeDash(plot_point)
        if structure_match is not None:
            self._last_hover_match = structure_match
            structure_point = structure_match.get("plot_point")
            self._showHoverTooltip(structure_point, structure_match)
            self._highlightMatchOnMap(structure_point, structure_match)
            return

        # Change-point X marks also sit on the pipe line; check them before the
        # reach so hovering the X wins over the pipe beneath it.
        change_point_match = self._identifyChangePoint(plot_point)
        if change_point_match is not None:
            self._last_hover_match = change_point_match
            change_point = change_point_match.get("plot_point")
            self._showHoverTooltip(change_point, change_point_match)
            self._highlightMatchOnMap(change_point, change_point_match)
            return

        # No structure under the cursor → reach/surface hover, which is only
        # valid inside the plot area. (Structures are checked above because their
        # exaggerated shafts can legitimately stick out beyond it.)
        if plot_point is None:
            self.clearState()
            return
        if hasattr(self._canvas, "plotArea"):
            try:
                plot_area = self._canvas.plotArea()
                if plot_area and not plot_area.contains(QPointF(pos)):
                    self.clearState()
                    return
            except Exception:
                pass
        self._updateHoverMatch(profile_point)

    def _updateHoverMatch(self, profile_point):
        """
        Match the nearest identify() result for a reach/surface hover.

        The overlay hit-tests (cover, manhole, change point) already ran — and
        missed — in _handleCanvasHover before this is called, so only the
        official identify() API is consulted here.
        """
        plot_point = self._profilePointToPlotPoint(profile_point)
        if plot_point is None:
            self.clearState()
            return

        identify_results = []
        if hasattr(self._canvas, "identify") and self._last_hover_pos is not None:
            try:
                canvas_point = QPointF(self._last_hover_pos)
                identify_results = self._canvas.identify(canvas_point)
            except Exception:
                pass

        nearest = self._nearestIdentifyResult(identify_results, plot_point)

        # QGIS identify() on a profile matches a reach by horizontal proximity
        # only, so a cursor far above/below the pipe still hits it. Reject a reach
        # match unless the cursor is actually near the drawn pipe band.
        if (
            nearest is not None
            and self._matchIsReach(nearest)
            and not self._cursorNearReachBand(plot_point)
        ):
            self.clearState()
            return

        if nearest:
            self._last_hover_match = nearest

        self._showHoverTooltip(plot_point, self._last_hover_match)

        if self._last_hover_match:
            self._highlightMatchOnMap(plot_point, self._last_hover_match)
        else:
            self._clearHighlight()

    # ------------------------------------------------------------------
    # Manhole dash hit-test
    # ------------------------------------------------------------------

    @staticmethod
    def _rectPointDistance(rect, point):
        """Pixel distance from a point to a QRectF (0 when the point is inside)."""
        dx = max(rect.left() - point.x(), 0.0, point.x() - rect.right())
        dy = max(rect.top() - point.y(), 0.0, point.y() - rect.bottom())
        return math.hypot(dx, dy)

    def _hoverCanvasCursors(self, plot_point):
        """
        Cursor position(s) in the canvas-point space the hit rects use.

        The rects come from plotPointToCanvasPoint. The raw mouse event.pos() is
        normally the same space, but can differ (view transform / HiDPI scaling),
        which would silently miss every box. So we also round-trip the plot point
        back through plotPointToCanvasPoint, which is guaranteed to land in the
        rects' space; either cursor matching the box counts as a hit.
        """
        cursors = []
        if self._last_hover_pos is not None:
            cursors.append(QPointF(self._last_hover_pos))
        if plot_point is not None and hasattr(self._canvas, "plotPointToCanvasPoint"):
            try:
                converted = self._canvas.plotPointToCanvasPoint(
                    QgsProfilePoint(float(plot_point.x()), float(plot_point.y()))
                )
                if converted is not None and not (
                    hasattr(converted, "isEmpty") and converted.isEmpty()
                ):
                    cursors.append(QPointF(converted.x(), converted.y()))
            except (TypeError, ValueError):
                pass
        return cursors

    def _nearestDashInRects(self, hit_rects, plot_point, tolerance=8.0):
        """
        Nearest dash whose (padded) rect is within ``tolerance`` px of the cursor.

        Hit-tests in CANVAS PIXEL space, because the shafts are drawn in
        exaggerated pixel space (their true levels collapse together at overview
        zoom). The tolerance keeps small shafts / thin cover caps hoverable; the
        cover band uses a tighter tolerance so it doesn't swallow the shaft body.
        Returns the dash, or None.
        """
        if not hit_rects:
            return None
        cursors = self._hoverCanvasCursors(plot_point)
        if not cursors:
            return None

        best_dash = None
        best_dist = None
        for dash, rect in hit_rects:
            if rect is None:
                continue
            dist = min(self._rectPointDistance(rect, c) for c in cursors)
            if dist > tolerance:
                continue
            if best_dist is None or dist < best_dist:
                best_dist = dist
                best_dash = dash
        return best_dash

    def _identifyManholeDash(self, plot_point):
        """Identify the whole-manhole shaft under the cursor (body, not the cap)."""
        if not hasattr(self._canvas, "getManholeDashHitRects"):
            return None
        dash = self._nearestDashInRects(
            self._canvas.getManholeDashHitRects(), plot_point
        )
        if dash is None:
            return None

        dash_distance = dash.get("distance")
        cover_level = dash.get("cover_level")
        bottom_level = dash.get("bottom_level")
        rep_level = cover_level
        if rep_level is None:
            rep_level = bottom_level
        if rep_level is None:
            rep_level = dash.get("invert_level")

        result_point = plot_point
        if dash_distance is not None and rep_level is not None:
            result_point = QPointF(dash_distance, rep_level)

        return {
            "layer": None,
            "result": {
                "feature": None,
                "attributes": {
                    "obj_id": dash.get("obj_id"),
                    "ws_type": dash.get("ws_type", "manhole"),
                    "co_level": cover_level,
                    "wn_bottom_level": bottom_level,
                    "cover_level_missing": dash.get("cover_level_missing", False),
                    "bottom_level_missing": dash.get("bottom_level_missing", False),
                    "_cover_label": dash.get("_cover_label"),
                    "_bottom_label": dash.get("_bottom_label"),
                    "_input_label": dash.get("_input_label"),
                    "_output_label": dash.get("_output_label"),
                    "ma_dimension1": dash.get("dim1_mm"),
                    "ss_function": dash.get("ss_function"),
                    "_is_manhole_dash": True,
                },
                "distance": dash_distance,
                "elevation": rep_level,
            },
            "plot_point": result_point,
            # Cursor is literally inside the drawn box → win over reach identify.
            "distance2": 0.0,
        }

    def _identifyCoverDash(self, plot_point):
        """Identify the cover cap under the cursor → a dedicated cover tooltip."""
        if not hasattr(self._canvas, "getCoverHitRects"):
            return None
        # Tighter tolerance than the body so the cover band stays confined to the
        # cap and doesn't make the manhole body hard to hover.
        dash = self._nearestDashInRects(
            self._canvas.getCoverHitRects(), plot_point, tolerance=4.0
        )
        if dash is None:
            return None

        dash_distance = dash.get("distance")
        cover_level = dash.get("cover_level")
        result_point = plot_point
        if dash_distance is not None and cover_level is not None:
            result_point = QPointF(dash_distance, cover_level)

        return {
            "layer": None,
            "result": {
                "feature": None,
                "attributes": {
                    "co_obj_id": dash.get("co_obj_id"),
                    "co_level": cover_level,
                    "co_material": dash.get("co_material"),
                    "co_shape": dash.get("co_shape"),
                    "co_brand": dash.get("co_brand"),
                    "_is_cover_dash": True,
                },
                "distance": dash_distance,
                "elevation": cover_level,
            },
            "plot_point": result_point,
            "distance2": 0.0,
        }

    def _identifyChangePoint(self, plot_point):
        """Identify the change-point X under the cursor → a change-point tooltip."""
        if not hasattr(self._canvas, "getChangePointHitRects"):
            return None
        change_point = self._nearestDashInRects(
            self._canvas.getChangePointHitRects(), plot_point, tolerance=6.0
        )
        if change_point is None:
            return None

        distance = change_point.get("distance")
        level = change_point.get("level")
        result_point = plot_point
        if distance is not None and level is not None:
            result_point = QPointF(distance, level)

        return {
            "layer": None,
            "result": {
                "feature": None,
                "attributes": {
                    "obj_id": change_point.get("obj_id"),
                    "change_in_material": change_point.get("change_in_material"),
                    "change_in_clear_height": change_point.get("change_in_clear_height"),
                    "change_in_slope": change_point.get("change_in_slope"),
                    "_is_change_point": True,
                },
                "distance": distance,
                "elevation": level,
            },
            "plot_point": result_point,
            "distance2": 0.0,
        }

    # ------------------------------------------------------------------
    # Identify result helpers
    # ------------------------------------------------------------------

    def _matchIsReach(self, match):
        """True when the match resolves to a reach feature."""
        attrs, layer_name, _feature, _layer = self._attrsFromMatch(match)
        return self._isReachHover(layer_name, attrs)

    def _cursorNearReachBand(self, plot_point):
        """
        True when the cursor sits on (or within a few px of) a drawn pipe band.

        identify() only checks horizontal proximity, so this adds the missing
        vertical check in pixel space using the band geometry the canvas drew.
        """
        if plot_point is None or not hasattr(self._canvas, "getReachBands"):
            return True
        bands = self._canvas.getReachBands()
        if not bands:
            return True  # no band data → don't over-filter
        cursors = self._hoverCanvasCursors(plot_point)
        if not cursors:
            return True
        cursor = cursors[-1]  # the round-trip (canvas-space) cursor when available

        distance = plot_point.x()
        margin = 12.0
        for band in bands:
            invert = band.get("invert") or []
            invert_z = self._interpolateInvertZ(invert, distance)
            if invert_z is None:
                continue
            invert_pt = self._canvas.plotPointToCanvasPointSafe(distance, invert_z)
            if invert_pt is None:
                continue
            band_px = reach_band_px(band.get("clear_height_mm")) or 2.0
            # The band is drawn from the invert upward (soffit above = smaller y).
            top = invert_pt.y() - band_px - margin
            bottom = invert_pt.y() + margin
            if top <= cursor.y() <= bottom:
                return True
        return False

    @staticmethod
    def _interpolateInvertZ(invert, distance):
        """Linear-interpolate the invert Z at a distance; None when out of range."""
        if len(invert) < 2:
            return None
        if distance < invert[0][0] or distance > invert[-1][0]:
            return None
        for i in range(len(invert) - 1):
            d0, z0 = invert[i]
            d1, z1 = invert[i + 1]
            if d0 <= distance <= d1:
                if d1 == d0:
                    return z0
                ratio = (distance - d0) / (d1 - d0)
                return z0 + (z1 - z0) * ratio
        return None

    def _nearestIdentifyResult(self, identify_results, plot_point):
        """Pick the nearest identify result to a plot point."""
        if not identify_results:
            return None

        best_match = None
        fallback_match = None

        for identify_result in identify_results:
            if isinstance(identify_result, dict):
                if best_match is None or identify_result["distance2"] < best_match.get(
                    "distance2", float("inf")
                ):
                    best_match = identify_result
                continue

            layer = identify_result.layer() if hasattr(identify_result, "layer") else None
            results = identify_result.results() if hasattr(identify_result, "results") else []
            for result in results:
                candidate_point = self._extractPlotPointFromResult(result)
                if candidate_point is None:
                    if fallback_match is None:
                        fallback_match = {
                            "layer": layer,
                            "result": result,
                            "plot_point": None,
                            "distance2": None,
                        }
                    continue
                dx = plot_point.x() - candidate_point.x()
                dy = plot_point.y() - candidate_point.y()
                distance2 = dx * dx + dy * dy
                if best_match is None or (
                    best_match["distance2"] is not None and distance2 < best_match["distance2"]
                ):
                    best_match = {
                        "layer": layer,
                        "result": result,
                        "plot_point": candidate_point,
                        "distance2": distance2,
                    }

        return best_match or fallback_match

    def _extractPlotPointFromResult(self, result):
        """Try to extract a plot point (distance/elevation) from a QVariantMap result."""
        if not result:
            return None

        profile_point = result.get("profilePoint") or result.get("profile_point")
        if profile_point is not None:
            return self._profilePointToPlotPoint(profile_point)

        if "distance" in result and "elevation" in result:
            return QPointF(float(result["distance"]), float(result["elevation"]))

        if "distance" in result and "z" in result:
            return QPointF(float(result["distance"]), float(result["z"]))

        if "x" in result and "y" in result:
            return QPointF(float(result["x"]), float(result["y"]))

        return None

    def _profilePointToPlotPoint(self, profile_point):
        """Convert QgsProfilePoint to QPointF (distance, elevation)."""
        if profile_point is None:
            return None
        distance = None
        elevation = None
        if hasattr(profile_point, "distance"):
            distance = (
                profile_point.distance()
                if callable(profile_point.distance)
                else profile_point.distance
            )
        if hasattr(profile_point, "elevation"):
            elevation = (
                profile_point.elevation()
                if callable(profile_point.elevation)
                else profile_point.elevation
            )
        if distance is None or elevation is None:
            return None
        return QPointF(float(distance), float(elevation))

    def _isEmptyProfilePoint(self, profile_point):
        if profile_point is None:
            return True
        if hasattr(profile_point, "isEmpty"):
            return profile_point.isEmpty()
        return False

    # ------------------------------------------------------------------
    # Tooltip
    # ------------------------------------------------------------------

    def _showHoverTooltip(self, plot_point, match):
        """Show or update the persistent custom tooltip."""
        should_hide = plot_point is None or match is None

        if should_hide:
            self._custom_tooltip.hide()
            self._last_hover_global_pos = None
            self._last_tooltip_text = None
            return

        text = self._formatHoverSummary(plot_point, match)
        if not text:
            self._custom_tooltip.hide()
            self._last_hover_global_pos = None
            self._last_tooltip_text = None
            return

        from qgis.PyQt.QtGui import QCursor

        current_pos = QCursor.pos()

        # Dedup by the rendered text: a feature change always changes the text
        # (obj_id is on the first line), so no separate identity check is needed.
        need_update = False
        if not self._last_tooltip_text:
            need_update = True
        elif text != self._last_tooltip_text:
            need_update = True
        elif self._last_hover_global_pos:
            dx = abs(current_pos.x() - self._last_hover_global_pos.x())
            dy = abs(current_pos.y() - self._last_hover_global_pos.y())
            if dx > 50 or dy > 50:
                need_update = True

        if need_update:
            self._last_hover_global_pos = current_pos
            self._last_tooltip_text = text
            self._custom_tooltip.setTextFormat(Qt.TextFormat.RichText)
            self._custom_tooltip.setText(text)
            self._custom_tooltip.adjustSize()
            tooltip_pos = QPoint(current_pos.x() + 10, current_pos.y() + 10)
            self._custom_tooltip.move(tooltip_pos)
            self._custom_tooltip.show()
            self._custom_tooltip.raise_()

    def _formatHoverSummary(self, plot_point, match):
        """Build rich-text tooltip content for a hover match."""
        attrs, layer_name, _feature, _layer = self._attrsFromMatch(match)

        lines = []

        is_reach = self._isReachHover(layer_name, attrs)
        is_cover = self._isCoverHover(layer_name, attrs)
        is_manhole = self._isManholeHover(layer_name, attrs)
        is_change_point = self._isChangePointHover(layer_name, attrs)

        if is_reach:
            obj_id = attrs.get(self.REACH_OBJ_ID)
            lines.append(f"Reach {obj_id}" if obj_id else "Reach")

            material = attrs.get(self.REACH_MATERIAL)
            if material is None or material == "":
                lines.append(f"Material: {self.MISSING_DATA_HTML}")
            else:
                material_text = resolve_value_list(self.REACH_MATERIAL_VL, material)
                lines.append(f"Material: {material_text or material}")

            clear_height_mm = _to_float(attrs.get(self.REACH_CLEAR_HEIGHT))
            if clear_height_mm is None:
                lines.append(f"Clear height: {self.MISSING_DATA_HTML}")
            else:
                lines.append(f"Clear height: {clear_height_mm:.0f} mm")

            length = _to_float(attrs.get(self.REACH_LENGTH_EFFECTIVE))
            if length is None:
                lines.append(f"Length: {self.MISSING_DATA_HTML}")
            else:
                lines.append(f"Length: {self._formatMeters(length)}")

            slope_per_mill = _to_float(attrs.get(self.REACH_SLOPE_PER_MILL))
            if slope_per_mill is None:
                lines.append(f"Gradient: {self.MISSING_DATA_HTML}")
            else:
                lines.append(f"Gradient: {slope_per_mill:.0f} \u2030")

            entry_level = _to_float(attrs.get(self.REACH_RP_FROM_LEVEL))
            if entry_level is None:
                lines.append(f"Entry level: {self.MISSING_DATA_HTML}")
            else:
                lines.append(f"Entry level: {self._formatMeters(entry_level, decimals=2)}")

            exit_level = _to_float(attrs.get(self.REACH_RP_TO_LEVEL))
            if exit_level is None:
                lines.append(f"Exit level: {self.MISSING_DATA_HTML}")
            else:
                lines.append(f"Exit level: {self._formatMeters(exit_level, decimals=2)}")

            if plot_point is not None:
                lines.append(f"Elevation at cursor: {plot_point.y():.2f} m")

        elif is_cover:
            cover_obj_id = attrs.get(self.COVER_OBJ_ID)
            lines.append(f"Cover {cover_obj_id}" if cover_obj_id else "Cover")

            level = _to_float(attrs.get(self.COVER_LEVEL))
            if level is None:
                lines.append(f"Level: {self.MISSING_DATA_HTML}")
            else:
                lines.append(f"Level: {self._formatMeters(level, decimals=2)}")

            material = attrs.get(self.COVER_MATERIAL)
            if material is None or material == "":
                lines.append(f"Material: {self.MISSING_DATA_HTML}")
            else:
                material_text = resolve_value_list(self.COVER_MATERIAL_VL, material)
                lines.append(f"Material: {material_text or material}")

            cover_shape = attrs.get(self.COVER_SHAPE)
            if cover_shape is None or cover_shape == "":
                lines.append(f"Cover shape: {self.MISSING_DATA_HTML}")
            else:
                shape_text = resolve_value_list(self.COVER_SHAPE_VL, cover_shape)
                lines.append(f"Cover shape: {shape_text or cover_shape}")

            brand = attrs.get(self.COVER_BRAND)
            if brand is None or brand == "":
                lines.append(f"Brand: {self.MISSING_DATA_HTML}")
            else:
                lines.append(f"Brand: {brand}")

        elif is_manhole:
            ws_type = str(attrs.get(self.MANHOLE_WS_TYPE) or "").lower()
            is_actual_manhole = ws_type == "manhole"
            obj_id = attrs.get(self.MANHOLE_OBJ_ID)

            if is_actual_manhole:
                lines.append(f"Manhole: {obj_id}" if obj_id else "Manhole")
                self._appendManholeLabelLine(
                    lines, "Cover level", attrs.get(self.MANHOLE_COVER_LABEL)
                )
                self._appendManholeLabelLine(
                    lines, "Bottom level", attrs.get(self.MANHOLE_BOTTOM_LABEL)
                )
                self._appendManholeLabelLine(
                    lines, "Entry level", attrs.get(self.MANHOLE_INPUT_LABEL)
                )
                self._appendManholeLabelLine(
                    lines, "Exit level", attrs.get(self.MANHOLE_OUTPUT_LABEL)
                )

                cover_level = self._manholeCoverLevelValue(attrs)
                bottom_level = self._manholeBottomLevelValue(attrs)
                if cover_level is not None and bottom_level is not None:
                    depth = cover_level - bottom_level
                    lines.append(f"Depth: {self._formatMeters(depth, decimals=2)}")
                else:
                    lines.append(f"Depth: {self.MISSING_DATA_HTML}")

                width_mm = _to_float(attrs.get(self.MANHOLE_DIMENSION1))
                if width_mm is None:
                    lines.append(f"Width: {self.MISSING_DATA_HTML}")
                else:
                    lines.append(f"Width: {width_mm:.0f} mm")
            else:
                lines.append(f"Node: {obj_id}" if obj_id else "Node")
                if ws_type:
                    lines.append(f"Type: {ws_type}")
                ss_function = attrs.get("ss_function")
                if ss_function is not None and ss_function != "":
                    function_text = resolve_value_list(
                        self.SPECIAL_STRUCTURE_FUNCTION_VL, ss_function
                    )
                    lines.append(f"Function: {function_text or ss_function}")
                bottom_level = self._manholeBottomLevelValue(attrs)
                if bottom_level is None:
                    lines.append(f"Level: {self.MISSING_DATA_HTML}")
                else:
                    lines.append(f"Level: {bottom_level:.2f} m")

        elif is_change_point:
            obj_id = attrs.get(self.CHANGE_POINT_OBJ_ID)
            lines.append(f"Change point {obj_id}" if obj_id else "Change point")

            if plot_point is not None:
                lines.append(f"Level: {plot_point.y():.2f} m")

            lines.append(
                f"Material change: {self._formatYesNo(attrs.get(self.CHANGE_POINT_MATERIAL))}"
            )
            lines.append(
                "Clear-height change: "
                f"{self._formatYesNo(attrs.get(self.CHANGE_POINT_CLEAR_HEIGHT))}"
            )
            slope_change = _to_float(attrs.get(self.CHANGE_POINT_SLOPE))
            if slope_change is None:
                lines.append("Slope change: No")
            elif slope_change == 0:
                lines.append("Slope change: No")
            else:
                lines.append(f"Slope change: {slope_change:.0f} ‰")
        else:
            if layer_name:
                lines.append(layer_name)

        if (
            plot_point is not None
            and not is_reach
            and not is_cover
            and not is_manhole
            and not is_change_point
        ):
            lines.append(f"distance: {plot_point.x():.2f}")
            lines.append(f"elevation: {plot_point.y():.2f}")

        return "<br>".join(lines)

    # ------------------------------------------------------------------
    # Feature type detection
    # ------------------------------------------------------------------

    def _isReachHover(self, layer_name, attrs):
        layer_name_lower = (layer_name or "").lower()
        if "reach" in layer_name_lower:
            return True
        if "wastewater_node" in layer_name_lower or "manhole" in layer_name_lower:
            return False
        if "cover" in layer_name_lower:
            return False
        if "change_point" in layer_name_lower:
            return False
        return (
            attrs.get(self.REACH_MATERIAL) is not None
            and attrs.get(self.REACH_LENGTH_EFFECTIVE) is not None
        )

    def _isCoverHover(self, layer_name, attrs=None):
        if attrs and attrs.get("_is_cover_dash"):
            return True
        layer_name_lower = (layer_name or "").lower()
        return "cover" in layer_name_lower and "wastewater_node" not in layer_name_lower

    def _isManholeHover(self, layer_name, attrs):
        if attrs and attrs.get("_is_manhole_dash"):
            return True
        layer_name_lower = (layer_name or "").lower()
        if "wastewater_node" in layer_name_lower:
            return True
        if "reach" in layer_name_lower:
            return False
        if "cover" in layer_name_lower and "wastewater" not in layer_name_lower:
            return False
        if "change_point" in layer_name_lower:
            return False
        return str(attrs.get(self.MANHOLE_WS_TYPE) or "").lower() == "manhole"

    def _isChangePointHover(self, layer_name, attrs):
        if attrs and attrs.get("_is_change_point"):
            return True
        return "change_point" in (layer_name or "").lower()

    # ------------------------------------------------------------------
    # Map highlight
    # ------------------------------------------------------------------

    def _highlightMatchOnMap(self, plot_point, match):
        """
        Highlight the hovered feature on the QGIS main map canvas.

        - Reach → highlight on vw_tww_reach by obj_id
        - Cover → highlight on vw_cover by co_obj_id
        - Manhole → highlight associated cover on vw_cover via fk_wastewater_structure
        """
        if self._map_canvas is None:
            return

        attrs, layer_name, _feature, _layer = self._attrsFromMatch(match)

        is_reach = self._isReachHover(layer_name, attrs)
        is_cover = self._isCoverHover(layer_name, attrs)
        is_manhole = self._isManholeHover(layer_name, attrs)
        is_change_point = self._isChangePointHover(layer_name, attrs)

        if is_reach:
            obj_id = attrs.get(self.REACH_OBJ_ID)
            if not obj_id:
                self._clearHighlight()
                return
            highlight_key = f"reach:{obj_id}"
            if highlight_key == self._current_highlight_key:
                return
            self._doHighlightFeature(
                "vw_tww_reach", f'"obj_id" = \'{obj_id}\'', highlight_key
            )
        elif is_cover:
            cover_id = attrs.get(self.COVER_OBJ_ID)
            if not cover_id:
                self._clearHighlight()
                return
            highlight_key = f"cover:{cover_id}"
            if highlight_key == self._current_highlight_key:
                return
            self._doHighlightFeature(
                "vw_cover", f'"obj_id" = \'{cover_id}\'', highlight_key
            )
        elif is_manhole:
            ws_id = attrs.get(self.MANHOLE_OBJ_ID)
            if not ws_id:
                self._clearHighlight()
                return
            highlight_key = f"manhole:{ws_id}"
            if highlight_key == self._current_highlight_key:
                return
            self._doHighlightFeature(
                "vw_cover",
                f'"fk_wastewater_structure" = \'{ws_id}\'',
                highlight_key,
            )
        elif is_change_point:
            cp_id = attrs.get(self.CHANGE_POINT_OBJ_ID)
            if not cp_id:
                self._clearHighlight()
                return
            highlight_key = f"change_point:{cp_id}"
            if highlight_key == self._current_highlight_key:
                return
            self._doHighlightFeature(
                "vw_change_points", f'"obj_id" = \'{cp_id}\'', highlight_key
            )
        else:
            self._clearHighlight()

    def _doHighlightFeature(self, layer_name, filter_expr, highlight_key):
        """
        Create a QgsHighlight on the map canvas for the first matching feature.

        :param layer_name: Name of the layer to query.
        :param filter_expr: QgsFeatureRequest filter expression string.
        :param highlight_key: Unique key to prevent duplicate highlights.
        """
        map_layer = TwwLayerManager.layer(layer_name)
        if map_layer is None:
            self._clearHighlight()
            return

        request = QgsFeatureRequest().setFilterExpression(filter_expr)
        request.setLimit(1)

        feat = None
        for f in map_layer.getFeatures(request):
            feat = f
            break

        if feat is None or feat.geometry() is None or feat.geometry().isEmpty():
            self._clearHighlight()
            return

        self._clearHighlight()
        self._current_highlight = QgsHighlight(self._map_canvas, feat.geometry(), map_layer)
        self._current_highlight.setColor(self.HIGHLIGHT_COLOR)
        self._current_highlight.setFillColor(self.HIGHLIGHT_FILL_COLOR)
        self._current_highlight.setBuffer(0.5)
        self._current_highlight.setMinWidth(2)
        self._current_highlight.setWidth(4)
        self._current_highlight.show()
        self._current_highlight_key = highlight_key

    def _clearHighlight(self):
        """Remove the current map canvas highlight."""
        if self._current_highlight is not None:
            self._current_highlight.hide()
            del self._current_highlight
            self._current_highlight = None
        self._current_highlight_key = None

    # ------------------------------------------------------------------
    # Attribute extraction helpers
    # ------------------------------------------------------------------

    def _attrsFromMatch(self, match):
        """Extract merged attributes, layer name, feature, and layer from a hover match."""
        result = match.get("result") if match else None
        layer = match.get("layer") if match else None
        layer_name = layer.name() if layer and hasattr(layer, "name") else ""
        feature = self._extractResultFeature(result, layer)
        result_attrs = self._extractResultAttributes(result)

        if feature:
            attrs = _feature_attributes(feature)
        else:
            attrs = dict(result_attrs)

        for key, value in result_attrs.items():
            if key not in attrs:
                attrs[key] = value

        return attrs, layer_name, feature, layer

    def _extractResultAttributes(self, result):
        """Extract attribute dict from a QgsElevationProfile identify result."""
        if not result:
            return {}
        if isinstance(result, dict):
            if "attributes" in result and isinstance(result["attributes"], dict):
                return dict(result["attributes"])
            if "feature" in result:
                feature = result.get("feature")
                attrs = _feature_attributes(feature)
                if attrs:
                    return attrs
            return {k: v for k, v in result.items() if not isinstance(v, (dict, list))}
        return {}

    def _extractResultFeature(self, result, layer):
        """Try to resolve the QgsFeature from an identify result."""
        if not result:
            return None
        if isinstance(result, dict):
            feature = result.get("feature")
            if feature is not None:
                return feature
            fid = result.get("featureId") or result.get("fid") or result.get("id")
            if fid is not None and layer is not None and hasattr(layer, "getFeature"):
                try:
                    return layer.getFeature(int(fid))
                except Exception:
                    try:
                        return layer.getFeature(fid)
                    except Exception:
                        return None
        return None

    # ------------------------------------------------------------------
    # Manhole tooltip helpers
    # ------------------------------------------------------------------

    def _manholeCoverLevelValue(self, attrs):
        return _to_float(attrs.get(self.MANHOLE_CO_LEVEL))

    def _manholeBottomLevelValue(self, attrs):
        level = _to_float(attrs.get(self.MANHOLE_BOTTOM_LEVEL))
        if level == 0:
            return None
        return level

    def _appendManholeLabelLine(self, lines, title, label_value):
        text = self._formatLevelLabel(label_value)
        if not text:
            lines.append(f"{title}: {self.MISSING_DATA_HTML}")
        else:
            lines.append(f"{title}: {text}")

    # ------------------------------------------------------------------
    # Formatting helpers
    # ------------------------------------------------------------------

    def _parseLevelLabel(self, label):
        """
        Parse a DB level label into a list of (index, value) tuples.

        The DB stores pre-formatted strings like '\\nC=3401.00' or
        '\\nI1=2736.50\\nI2=2736.50'. We strip the letter prefix and keep
        only the numeric value; a trailing digit on the prefix (I1, I2, …)
        is captured as the index.
        """
        if label is None:
            return []
        entries = []
        for raw in str(label).replace("\r", "\n").split("\n"):
            token = raw.strip()
            if not token:
                continue
            if "=" in token:
                prefix, value = token.split("=", 1)
                prefix = prefix.strip()
                value = value.strip()
                cut = len(prefix)
                while cut > 0 and prefix[cut - 1].isdigit():
                    cut -= 1
                entries.append((prefix[cut:], value))
            else:
                entries.append(("", token))
        return entries

    def _formatLevelLabel(self, label):
        """
        Format a level label inline (no line breaks).

        Single value → just the number; multiple values → '1: v1; 2: v2'.
        """
        entries = self._parseLevelLabel(label)
        if not entries:
            return None
        if len(entries) == 1:
            return entries[0][1]
        parts = []
        for i, (idx, value) in enumerate(entries):
            parts.append(f"{idx or (i + 1)}: {value}")
        return "; ".join(parts)

    def _formatMeters(self, value, decimals=2):
        if value is None:
            return None
        try:
            return f"{float(value):.{decimals}f} m"
        except (TypeError, ValueError):
            return str(value)

    @staticmethod
    def _formatYesNo(value):
        """Render a vw_change_points boolean flag as Yes / No (? when unknown)."""
        if value is None:
            return "?"
        if isinstance(value, str):
            token = value.strip().lower()
            if token in ("true", "t", "1", "yes"):
                return "Yes"
            if token in ("false", "f", "0", "no", ""):
                return "No"
            return value
        return "Yes" if value else "No"
