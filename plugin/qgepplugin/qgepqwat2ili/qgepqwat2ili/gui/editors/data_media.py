import os

from .base import Editor


class DataMediaEditor(Editor):

    class_name = "data_media"
    widget_name = "data_media.ui"

    def __init__(self, *args, **kwargs):
        self._path_was_changed = False
        super().__init__(*args, **kwargs)

    def init_widget(self):
        self.widget.pushButton.pressed.connect(lambda: self.button_clicked())
        self.update_widget()

    def update_widget(self):
        self.widget.lineEdit.setText(self.obj.path)

    def button_clicked(self):
        self.obj.path = self.widget.lineEdit.text()
        self._path_was_changed = True

        self.update_state()
        self.main_dialog.refresh_editor(self)
        self.main_dialog.update_tree()

    def validate(self):
        if not self._path_was_changed:
            self.validity = Editor.WARNING
            self.message = "Path was not adapted."
        elif not os.path.exists(self.obj.path):
            self.validity = Editor.WARNING
            self.message = "This path does not exist on the current system"
        elif not os.path.isdir(self.obj.path):
            self.validity = Editor.WARNING
            self.message = "This path is not a directory"
        else:
            self.validity = Editor.VALID
            self.message = "No warning"
