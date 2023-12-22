import logging
import os
import tempfile
import webbrowser

from qgis import processing
from qgis.core import Qgis, QgsProject, QgsSettings
from qgis.PyQt.QtWidgets import QApplication, QFileDialog, QProgressDialog, QPushButton
from qgis.utils import iface

from ...utils.twwlayermanager import TwwLayerManager
from .. import config
from ..tww.export import tww_export
from ..tww.import_ import tww_import
from ..utils.ili2db import TwwIliTools
from ..utils.various import CmdException, LoggingHandlerContext, make_log_path
from .gui_export import GuiExport
from .gui_import import GuiImport


def _show_results(title, message, log_path, level):
    widget = iface.messageBar().createMessage(title, message)
    button = QPushButton(widget)
    button.setText("Show logs")
    button.pressed.connect(lambda p=log_path: webbrowser.open(p))
    widget.layout().addWidget(button)
    iface.messageBar().pushWidget(widget, level)


def show_failure(title, message, log_path):
    return _show_results(title, message, log_path, Qgis.Warning)


def show_success(title, message, log_path):
    return _show_results(title, message, log_path, Qgis.Success)


import_dialog = None


def action_import(plugin):
    """
    Is executed when the user clicks the importAction tool
    """
    global import_dialog  # avoid garbage collection

    default_folder = QgsSettings().value(
        "tww_plugin/last_interlis_path", QgsProject.instance().absolutePath()
    )
    file_name, _ = QFileDialog.getOpenFileName(
        None,
        plugin.tr("Import file"),
        default_folder,
        plugin.tr("Interlis transfer files (*.xtf)"),
    )
    if not file_name:
        # Operation canceled
        return
    QgsSettings().setValue("tww_plugin/last_interlis_path", os.path.dirname(file_name))

    # Configure logging
    setting_value = QgsSettings().value("tww_plugin/logs_next_to_file", False)
    logs_next_to_file = setting_value is True or setting_value == "true"
    if logs_next_to_file:
        base_log_path = file_name
    else:
        base_log_path = None

    progress_dialog = QProgressDialog("", "", 0, 100, plugin.iface.mainWindow())
    progress_dialog.setCancelButton(None)
    progress_dialog.setModal(True)
    progress_dialog.show()

    twwIliTools = TwwIliTools()

    # Validating the input file
    progress_dialog.setLabelText("Validating the input file...")
    QApplication.processEvents()
    log_path = make_log_path(base_log_path, "ilivalidator")
    try:
        twwIliTools.validate_xtf_data(
            file_name,
            log_path,
        )
    except CmdException:
        progress_dialog.close()
        show_failure(
            "Invalid file",
            "The input file is not a valid XTF file. Open the logs for more details on the error.",
            log_path,
        )
        return

    # Prepare the temporary ili2pg model
    progress_dialog.setLabelText("Creating ili schema...")
    QApplication.processEvents()
    log_path = make_log_path(base_log_path, "ili2pg-schemaimport")
    try:
        twwIliTools.create_ili_schema(
            config.ABWASSER_SCHEMA,
            [
                config.ABWASSER_ILI_MODEL_NAME,
                config.ABWASSER_ILI_MODEL_NAME_SIA405,
                config.ABWASSER_ILI_MODEL_NAME_DSS,
            ],
            log_path,
            recreate_schema=True,
        )
    except CmdException:
        progress_dialog.close()
        show_failure(
            "Could not create the ili2pg schema",
            "Open the logs for more details on the error.",
            log_path,
        )
        return
    progress_dialog.setValue(33)
    QApplication.processEvents()

    # Export from ili2pg model to file
    progress_dialog.setLabelText("Importing XTF data...")
    QApplication.processEvents()
    log_path = make_log_path(base_log_path, "ili2pg-import")
    try:
        twwIliTools.import_xtf_data(
            config.ABWASSER_SCHEMA,
            file_name,
            log_path,
        )
    except CmdException:
        progress_dialog.close()
        show_failure(
            "Could not import data",
            "Open the logs for more details on the error.",
            log_path,
        )
        return
    progress_dialog.setValue(66)

    # Export to the temporary ili2pg model
    progress_dialog.setLabelText("Converting to Teksi Wastewater...")
    QApplication.processEvents()
    import_dialog = GuiImport(plugin.iface.mainWindow())
    progress_dialog.setValue(100)

    log_handler = logging.FileHandler(
        make_log_path(base_log_path, "tww2ili-import"), mode="w", encoding="utf-8"
    )
    log_handler.setLevel(logging.INFO)
    log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))
    with LoggingHandlerContext(log_handler):
        tww_import(
            precommit_callback=import_dialog.init_with_session,
        )


def action_export(plugin):
    """
    Is executed when the user clicks the exportAction tool
    """

    export_dialog = GuiExport(plugin.iface.mainWindow())

    def action_do_export():
        default_folder = QgsSettings().value(
            "tww_plugin/last_interlis_path", QgsProject.instance().absolutePath()
        )
        file_name, _ = QFileDialog.getSaveFileName(
            None,
            plugin.tr("Export to file"),
            os.path.join(default_folder, "tww-export.xtf"),
            plugin.tr("Interlis transfer files (*.xtf)"),
        )
        if not file_name:
            # Operation canceled
            return
        QgsSettings().setValue("tww_plugin/last_interlis_path", os.path.dirname(file_name))

        # File name without extension (used later for export)
        file_name_base, _ = os.path.splitext(file_name)

        # Configure logging
        if export_dialog.logs_next_to_file:
            base_log_path = file_name
        else:
            base_log_path = None

        progress_dialog = QProgressDialog("", "", 0, 100, plugin.iface.mainWindow())
        progress_dialog.setCancelButton(None)
        progress_dialog.setModal(True)
        progress_dialog.show()

        twwIliTools = TwwIliTools()

        # Prepare the temporary ili2pg model
        progress_dialog.setLabelText("Creating ili schema...")
        QApplication.processEvents()
        log_path = make_log_path(base_log_path, "ili2pg-schemaimport")
        try:
            twwIliTools.create_ili_schema(
                config.ABWASSER_SCHEMA,
                [
                    config.ABWASSER_ILI_MODEL_NAME,
                    config.ABWASSER_ILI_MODEL_NAME_SIA405,
                    config.ABWASSER_ILI_MODEL_NAME_DSS,
                ],
                log_path,
                recreate_schema=True,
            )
        except CmdException:
            progress_dialog.close()
            show_failure(
                "Could not create the ili2pg schema",
                "Open the logs for more details on the error.",
                log_path,
            )
            return
        progress_dialog.setValue(25)
        QApplication.processEvents()

        # Export the labels file
        tempdir = tempfile.TemporaryDirectory()
        labels_file_path = None

        if len(export_dialog.selected_labels_scales_indices):
            labels_file_path = os.path.join(tempdir.name, "labels.geojson")

            progress_dialog.setLabelText("Extracting labels...")
            QApplication.processEvents()

            structures_lyr = TwwLayerManager.layer("vw_tww_wastewater_structure")
            reaches_lyr = TwwLayerManager.layer("vw_tww_reach")
            if not structures_lyr or not reaches_lyr:
                progress_dialog.close()
                show_failure(
                    "Could not find the vw_tww_wastewater_structure and/or the vw_tww_reach layers.",
                    "Make sure your Teksi Wastewater project is open.",
                    None,
                )
                return

            QApplication.processEvents()
            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": export_dialog.limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "SCALES": export_dialog.selected_labels_scales_indices,
                },
            )
            progress_dialog.setValue(35)
            QApplication.processEvents()

        # Export to the temporary ili2pg model
        progress_dialog.setLabelText("Converting from Teksi Wastewater...")
        QApplication.processEvents()

        log_handler = logging.FileHandler(
            make_log_path(file_name, "tww2ili-export"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))
        with LoggingHandlerContext(log_handler):
            tww_export(selection=export_dialog.selected_ids, labels_file=labels_file_path)
        progress_dialog.setValue(50)
        QApplication.processEvents()

        # Cleanup
        tempdir.cleanup()

        for model_name, export_model_name, progress in [
            (config.ABWASSER_ILI_MODEL_NAME, None, 50),
            (config.ABWASSER_ILI_MODEL_NAME_SIA405, config.ABWASSER_ILI_MODEL_NAME_SIA405, 70),
        ]:
            export_file_name = f"{file_name_base}_{model_name}.xtf"

            # Export from ili2pg model to file
            progress_dialog.setLabelText(f"Saving XTF file [{model_name}]...")
            QApplication.processEvents()
            log_path = make_log_path(base_log_path, f"ili2pg-export-{model_name}")
            try:
                twwIliTools.export_xtf_data(
                    config.ABWASSER_SCHEMA,
                    model_name,
                    export_model_name,
                    export_file_name,
                    log_path,
                )
            except CmdException:
                progress_dialog.close()
                show_failure(
                    "Could not export the ili2pg schema",
                    "Open the logs for more details on the error.",
                    log_path,
                )
                continue
            progress_dialog.setValue(progress + 10)
            progress_dialog.setLabelText(f"Validating the network output file [{model_name}]...")
            QApplication.processEvents()
            log_path = make_log_path(base_log_path, f"ilivalidator-{model_name}")
            try:
                twwIliTools.validate_xtf_data(
                    export_file_name,
                    log_path,
                )
            except CmdException:
                progress_dialog.close()
                show_failure(
                    "Invalid file",
                    f"The created file is not a valid {model_name} XTF file.",
                    log_path,
                )
                continue

            progress_dialog.setValue(progress + 20)
            QApplication.processEvents()

        progress_dialog.setValue(100)

        show_success(
            "Sucess",
            f"Data successfully exported to {file_name_base}",
            os.path.dirname(log_path),
        )

    export_dialog.accepted.connect(action_do_export)
    export_dialog.adjustSize()
    export_dialog.show()
