import logging
import os
import tempfile
import webbrowser
from types import SimpleNamespace

from pkg_resources import parse_version
from qgis import processing
from qgis.core import Qgis, QgsProject, QgsSettings
from qgis.PyQt.QtWidgets import QApplication, QFileDialog, QProgressDialog, QPushButton
from qgis.utils import iface, plugins
from QgisModelBaker.libili2db import globals, ili2dbconfig, ili2dbutils

from ....utils.qgeplayermanager import QgepLayerManager
from .. import config
from ..qgep.export import qgep_export
from ..qgep.import_ import qgep_import
from ..utils.ili2db import (
    create_ili_schema,
    export_xtf_data,
    import_xtf_data,
    validate_xtf_data,
)
from ..utils.various import CmdException, LoggingHandlerContext, logger, make_log_path
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

    if not configure_from_modelbaker(plugin.iface):
        return

    default_folder = QgsSettings().value("qgep_pluging/last_interlis_path", QgsProject.instance().absolutePath())
    file_name, _ = QFileDialog.getOpenFileName(
        None, plugin.tr("Import file"), default_folder, plugin.tr("Interlis transfer files (*.xtf)")
    )
    if not file_name:
        # Operation canceled
        return
    QgsSettings().setValue("qgep_pluging/last_interlis_path", os.path.dirname(file_name))

    # Configure logging
    s = QgsSettings().value("qgep_plugin/logs_next_to_file", False)
    logs_next_to_file = s == True or s == "true"
    if logs_next_to_file:
        base_log_path = file_name
    else:
        base_log_path = None

    progress_dialog = QProgressDialog("", "", 0, 100, plugin.iface.mainWindow())
    progress_dialog.setCancelButton(None)
    progress_dialog.setModal(True)
    progress_dialog.show()

    # Validating the input file
    progress_dialog.setLabelText("Validating the input file...")
    QApplication.processEvents()
    log_path = make_log_path(base_log_path, "ilivalidator")
    try:
        validate_xtf_data(
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
        create_ili_schema(
            config.ABWASSER_SCHEMA,
            config.ABWASSER_ILI_MODEL,
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

    # Export from ili2pg model to file
    progress_dialog.setLabelText("Importing XTF data...")
    QApplication.processEvents()
    log_path = make_log_path(base_log_path, "ili2pg-import")
    try:
        import_xtf_data(
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
    progress_dialog.setLabelText("Converting to QGEP...")
    QApplication.processEvents()
    import_dialog = GuiImport(plugin.iface.mainWindow())
    progress_dialog.setValue(100)

    log_handler = logging.FileHandler(make_log_path(base_log_path, "qgepqwat2ili-import"), mode="w", encoding="utf-8")
    log_handler.setLevel(logging.INFO)
    log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))
    with LoggingHandlerContext(log_handler):
        qgep_import(
            precommit_callback=import_dialog.init_with_session,
        )


def action_export(plugin):
    """
    Is executed when the user clicks the exportAction tool
    """

    if not configure_from_modelbaker(plugin.iface):
        return

    export_dialog = GuiExport(plugin.iface.mainWindow())

    def action_do_export():

        default_folder = QgsSettings().value("qgep_pluging/last_interlis_path", QgsProject.instance().absolutePath())
        file_name, _ = QFileDialog.getSaveFileName(
            None,
            plugin.tr("Export to file"),
            os.path.join(default_folder, "qgep-export.xtf"),
            plugin.tr("Interlis transfer files (*.xtf)"),
        )
        if not file_name:
            # Operation canceled
            return
        QgsSettings().setValue("qgep_pluging/last_interlis_path", os.path.dirname(file_name))

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

        # Prepare the temporary ili2pg model
        progress_dialog.setLabelText("Creating ili schema...")
        QApplication.processEvents()
        log_path = make_log_path(base_log_path, "ili2pg-schemaimport")
        try:
            create_ili_schema(
                config.ABWASSER_SCHEMA,
                config.ABWASSER_ILI_MODEL,
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

        # Export the labels file
        tempdir = tempfile.TemporaryDirectory()
        labels_file_path = None

        if len(export_dialog.selected_labels_scales_indices):
            labels_file_path = os.path.join(tempdir.name, "labels.geojson")

            progress_dialog.setLabelText("Extracting labels...")

            structures_lyr = QgepLayerManager.layer("vw_qgep_wastewater_structure")
            reaches_lyr = QgepLayerManager.layer("vw_qgep_reach")
            if not structures_lyr or not reaches_lyr:
                progress_dialog.close()
                show_failure(
                    "Could not find the vw_qgep_wastewater_structure and/or the vw_qgep_reach layers.",
                    "Make sure your QGEP project is open.",
                    None,
                )
                return

            QApplication.processEvents()
            processing.run(
                "qgep:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": export_dialog.limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "SCALES": export_dialog.selected_labels_scales_indices,
                },
            )
            progress_dialog.setValue(35)

        # Export to the temporary ili2pg model
        progress_dialog.setLabelText("Converting from QGEP...")
        QApplication.processEvents()

        log_handler = logging.FileHandler(make_log_path(file_name, "qgepqwat2ili-export"), mode="w", encoding="utf-8")
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))
        with LoggingHandlerContext(log_handler):
            qgep_export(selection=export_dialog.selected_ids, labels_file=labels_file_path)
        progress_dialog.setValue(50)

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
                export_xtf_data(
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
                validate_xtf_data(
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

        progress_dialog.setValue(100)

        show_success(
            "Sucess",
            f"Data successfully exported to {file_name_base}",
            os.path.dirname(log_path),
        )

    export_dialog.accepted.connect(action_do_export)
    export_dialog.adjustSize()
    export_dialog.show()


def configure_from_modelbaker(iface):
    """
    Configures config.JAVA/ILI2PG paths using modelbaker.
    Returns whether modelbaker is available, and displays instructions if not.
    """
    REQUIRED_VERSION = "v6.4.0"  # TODO : update once https://github.com/opengisch/QgisModelBaker/pull/473 is released
    modelbaker = plugins.get("QgisModelBaker")
    if modelbaker is None:
        iface.messageBar().pushMessage(
            "Error",
            "This feature requires the ModelBaker plugin. Please install and activate it from the plugin manager.",
            level=Qgis.Critical,
        )
        return False

    elif modelbaker.__version__ != "dev" and parse_version(modelbaker.__version__) < parse_version(REQUIRED_VERSION):
        iface.messageBar().pushMessage(
            "Error",
            f"This feature requires a more recent version of the ModelBaker plugin (currently : {modelbaker.__version__}). Please install and activate version {REQUIRED_VERSION} or newer from the plugin manager.",
            level=Qgis.Critical,
        )
        return False

    # We reuse modelbaker's logic to get the java path and ili2pg executables from withing QGIS
    # Maybe we could reuse even more (IliExecutable...) ?

    stdout = SimpleNamespace()
    stdout.emit = logger.info
    stderr = SimpleNamespace()
    stderr.emit = logger.error

    config.JAVA = ili2dbutils.get_java_path(ili2dbconfig.BaseConfiguration())
    config.ILI2PG = ili2dbutils.get_ili2db_bin(globals.DbIliMode.ili2pg, 4, stdout, stderr)

    return True
