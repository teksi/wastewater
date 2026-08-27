from __future__ import annotations

import json

from qgis.PyQt.QtCore import QObject, QPointF
from qgis.PyQt.QtGui import QColor, QBrush, QPainterPath, QPen
from qgis.PyQt.QtWidgets import (
    QGraphicsEllipseItem,
    QGraphicsItem,
    QGraphicsPathItem,
)


from ..utils.database_utils import DatabaseUtils


class VertexItem(QGraphicsEllipseItem):
    """Movable and selectable vertex in the pipe profile scene."""

    SIZE = 8.0

    def __init__(
        self,
        sequence: int,
        x: float,
        y: float,
        editor,
    ):
        radius = self.SIZE / 2.0

        # Center the ellipse around its item position.
        super().__init__(
            -radius,
            -radius,
            self.SIZE,
            self.SIZE,
        )

        self.sequence = sequence
        self.x_coord = float(x)
        self.y_coord = float(y)
        self.editor = editor

        self.setBrush(QBrush(QColor(220, 70, 70)))
        self.setPen(QPen(QColor(80, 30, 30), 0))
        self.setZValue(20)

        self.setFlags(
            QGraphicsItem.ItemIsMovable
            | QGraphicsItem.ItemIsSelectable
            | QGraphicsItem.ItemSendsGeometryChanges
        )

        self.setToolTip(f"Vertex {self.sequence}")
        self.update_position()

    def update_position(self):
        """Update the graphics position from the stored coordinates."""

        self.setPos(
            QPointF(
                self.x_coord,
                self.y_coord,
            )
        )

    def itemChange(self, change, value):
        """Synchronize coordinates when the vertex is moved or selected."""

        result = super().itemChange(change, value)

        if (
            change == QGraphicsItem.ItemPositionHasChanged
            and self.scene() is not None
        ):
            self.x_coord = self.pos().x()
            self.y_coord = self.pos().y()

            self.editor.rebuild_polyline()
            self.editor.update_vertex_table()

            if self.isSelected():
                self.editor.show_vertex(self)

        elif change == QGraphicsItem.ItemSelectedHasChanged:
            if bool(value):
                self.editor.show_vertex(self)

        return result


class TwwPipeProfileEditor(QObject):

    def __init__(
        self,
        iface,
        window,
        pipe_profile_obj_id: str,
    ):
        super().__init__()

        self.iface = iface
        self.window = window
        self.pipe_profile_obj_id = pipe_profile_obj_id

        self.vertex_items: list[VertexItem] = []
        self.profile_line_item = None

    # ------------------------------------------------------------------
    # Load / Save
    # ------------------------------------------------------------------

    def load_profile(self):
        """
        Load profile_geometry from database.
        """

        query = """
            SELECT
                sequence,
                x,
                y
            FROM tww_od.profile_geometry
            WHERE fk_pipe_profile = '{oid}'
            ORDER BY sequence;
        """.format(
            oid=self.pipe_profile_obj_id,
        )

        rows = DatabaseUtils.fetchall(query)

        self.clear_vertices()

        for sequence, x, y in rows:

            vertex = VertexItem(
                sequence=sequence,
                x=x,
                y=y,
                editor=self,
            )

            self.window.scene.addItem(vertex)

            self.vertex_items.append(vertex)

        self.rebuild_polyline()

        if self.vertex_items:
            self.window.fit_to_profile()

        self.update_vertex_table()

    def save_profile(self):

        query = DatabaseUtils.compose_sql(
            """
            SELECT tww_app.persist_pipe_geometry(
                {pipe_profile},
                {geometry}::jsonb
            );
            """,
            pipe_profile=DatabaseUtils.wrap_literal(self.pipe_profile_obj_id),
            geometry=DatabaseUtils.wrap_literal(self.profile_as_json()),
        )

        DatabaseUtils.execute(query)

    # ------------------------------------------------------------------
    # Serialization
    # ------------------------------------------------------------------

    def profile_as_json(self) -> str:

        return json.dumps(
            [
                {
                    "x": v.x_coord,
                    "y": v.y_coord,
                }
                for v in sorted(
                    self.vertex_items,
                    key=lambda v: v.sequence,
                )
            ]
        )

    # ------------------------------------------------------------------
    # Vertex handling
    # ------------------------------------------------------------------

    def clear_vertices(self):

        for vertex in self.vertex_items:
            self.window.scene.removeItem(vertex)

        self.vertex_items.clear()

    def add_vertex(
        self,
        x: float,
        y: float,
    ):

        sequence = len(self.vertex_items) + 1

        vertex = VertexItem(
            sequence=sequence,
            x=x,
            y=y,
            editor=self,
        )

        self.window.scene.addItem(vertex)

        self.vertex_items.append(vertex)

        self.rebuild_polyline()
        self.update_vertex_table()

    def delete_selected_vertex(self):

        selected = next(
            (v for v in self.vertex_items if v.isSelected()),
            None,
        )

        if selected is None:
            return

        self.window.scene.removeItem(selected)

        self.vertex_items.remove(selected)

        self.renumber_vertices()

        self.rebuild_polyline()
        self.update_vertex_table()

    def insert_vertex_after(
        self,
        sequence: int,
        x: float,
        y: float,
    ):

        for vertex in self.vertex_items:

            if vertex.sequence > sequence:
                vertex.sequence += 1

        vertex = VertexItem(
            sequence=sequence + 1,
            x=x,
            y=y,
            editor=self,
        )

        self.window.scene.addItem(vertex)

        self.vertex_items.append(vertex)

        self.renumber_vertices()

        self.rebuild_polyline()
        self.update_vertex_table()

    def move_vertex_up(self):

        selected = next(
            (v for v in self.vertex_items if v.isSelected()),
            None,
        )

        if selected is None:
            return

        vertices = sorted(
            self.vertex_items,
            key=lambda v: v.sequence,
        )

        idx = vertices.index(selected)

        if idx == 0:
            return

        other = vertices[idx - 1]

        selected.sequence, other.sequence = (
            other.sequence,
            selected.sequence,
        )

        self.renumber_vertices()

        self.rebuild_polyline()
        self.update_vertex_table()

    def move_vertex_down(self):

        selected = next(
            (v for v in self.vertex_items if v.isSelected()),
            None,
        )

        if selected is None:
            return

        vertices = sorted(
            self.vertex_items,
            key=lambda v: v.sequence,
        )

        idx = vertices.index(selected)

        if idx == len(vertices) - 1:
            return

        other = vertices[idx + 1]

        selected.sequence, other.sequence = (
            other.sequence,
            selected.sequence,
        )

        self.renumber_vertices()

        self.rebuild_polyline()
        self.update_vertex_table()

    def renumber_vertices(self):

        for i, vertex in enumerate(
            sorted(
                self.vertex_items,
                key=lambda v: v.sequence,
            ),
            start=1,
        ):
            vertex.sequence = i

    # ------------------------------------------------------------------
    # Graphics
    # ------------------------------------------------------------------

    def rebuild_polyline(self):
        """
        Rebuild profile from current vertices.
        """

        if self.profile_line_item is not None:

            self.window.scene.removeItem(self.profile_line_item)

            self.profile_line_item = None

        if not self.vertex_items:
            return

        vertices = sorted(
            self.vertex_items,
            key=lambda v: v.sequence,
        )

        path = QPainterPath()

        first = vertices[0]

        path.moveTo(
            first.x_coord,
            first.y_coord,
        )

        for vertex in vertices[1:]:

            path.lineTo(
                vertex.x_coord,
                vertex.y_coord,
            )

        self.profile_line_item = QGraphicsPathItem(path)

        self.profile_line_item.setPen(
            QPen(
                QColor(50, 50, 50),
                0,
            )
        )

        self.profile_line_item.setZValue(10)

        self.window.scene.addItem(self.profile_line_item)

    # ------------------------------------------------------------------
    # GUI callbacks
    # ------------------------------------------------------------------

    def update_vertex_table(self):

        if hasattr(self.window, "update_vertex_table"):
            self.window.update_vertex_table()

    def show_vertex(self, vertex):

        if hasattr(self.window, "show_vertex"):
            self.window.show_vertex(vertex)
