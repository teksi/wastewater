from qgis.PyQt.QtWidgets import (
    QGraphicsScene,
    QMainWindow,
    QTableWidgetItem,
)

from ..tools.tww_pipe_profile_editor import TwwPipeProfileEditor
from ..utils.ui import get_ui_class

DIALOG_UI = get_ui_class("tww_pipe_profile_editor.ui")


class PipeProfileEditorWindow(QMainWindow, DIALOG_UI):

    def __init__(
        self,
        iface,
        pipe_profile_obj_id,
        parent=None,
    ):
        super().__init__(parent)

        # Create all widgets and actions from the .ui file
        self.setupUi(self)

        self.iface = iface
        self.pipe_profile_obj_id = pipe_profile_obj_id

        # The tool expects window.scene to exist
        self.scene = QGraphicsScene(self)
        self.graphicsView.setScene(self.scene)

        self.editor = TwwPipeProfileEditor(
            iface=iface,
            window=self,
            pipe_profile_obj_id=pipe_profile_obj_id,
        )

        self._connect_signals()
        self.editor.load_profile()

    # ------------------------------------------------------------------
    # Signal wiring
    # ------------------------------------------------------------------

    def _connect_signals(self):
        self.actionDeleteVertex.triggered.connect(self.editor.delete_selected_vertex)

        self.actionAddVertex.triggered.connect(self._add_vertex)

        self.tblVertices.itemSelectionChanged.connect(self._table_selection_changed)

        self.spnX.valueChanged.connect(self._coordinates_changed)

        self.spnY.valueChanged.connect(self._coordinates_changed)

    # ------------------------------------------------------------------
    # Toolbar Actions
    # ------------------------------------------------------------------

    def _add_vertex(self):
        self.editor.add_vertex(
            x=0,
            y=0,
        )

    # ------------------------------------------------------------------
    # Vertex Table
    # ------------------------------------------------------------------

    def update_vertex_table(self):
        vertices = sorted(
            self.editor.vertex_items,
            key=lambda vertex: vertex.sequence,
        )

        self.tblVertices.blockSignals(True)

        try:
            self.tblVertices.setColumnCount(3)
            self.tblVertices.setRowCount(len(vertices))

            self.tblVertices.setHorizontalHeaderLabels(
                [
                    "Seq",
                    "X",
                    "Y",
                ]
            )

            for row, vertex in enumerate(vertices):
                self.tblVertices.setItem(
                    row,
                    0,
                    QTableWidgetItem(str(vertex.sequence)),
                )

                self.tblVertices.setItem(
                    row,
                    1,
                    QTableWidgetItem(f"{vertex.x_coord:.2f}"),
                )

                self.tblVertices.setItem(
                    row,
                    2,
                    QTableWidgetItem(f"{vertex.y_coord:.2f}"),
                )
        finally:
            self.tblVertices.blockSignals(False)

    # ------------------------------------------------------------------
    # Selection synchronization
    # ------------------------------------------------------------------

    def _table_selection_changed(self):
        row = self.tblVertices.currentRow()

        if row < 0:
            return

        vertices = sorted(
            self.editor.vertex_items,
            key=lambda vertex: vertex.sequence,
        )

        if row >= len(vertices):
            return

        selected_vertex = vertices[row]

        for vertex in self.editor.vertex_items:
            vertex.setSelected(False)

        selected_vertex.setSelected(True)
        self.show_vertex(selected_vertex)

    def show_vertex(self, vertex):
        self.spnX.blockSignals(True)
        self.spnY.blockSignals(True)

        try:
            self.spnX.setValue(vertex.x_coord)
            self.spnY.setValue(vertex.y_coord)
        finally:
            self.spnX.blockSignals(False)
            self.spnY.blockSignals(False)

    # ------------------------------------------------------------------
    # Coordinate Editor
    # ------------------------------------------------------------------

    def _selected_vertex(self):
        return next(
            (vertex for vertex in self.editor.vertex_items if vertex.isSelected()),
            None,
        )

    def _coordinates_changed(self):
        vertex = self._selected_vertex()

        if vertex is None:
            return

        vertex.x_coord = self.spnX.value()
        vertex.y_coord = self.spnY.value()

        vertex.update_position()

        self.editor.rebuild_polyline()
        self.update_vertex_table()

    # ------------------------------------------------------------------
    # Graphics helpers
    # ------------------------------------------------------------------

    def fit_to_profile(self):
        if self.editor.profile_line_item is None:
            return

        rect = self.editor.profile_line_item.sceneBoundingRect()

        if rect.isNull() or not rect.isValid():
            return

        self.graphicsView.fitInView(
            rect,
            1,
        )
