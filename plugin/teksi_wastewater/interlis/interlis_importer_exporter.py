import logging
import os
import tempfile
from pathlib import Path

from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QApplication, QMessageBox

from ..utils.database_utils import DatabaseUtils
from . import config
from .gui.interlis_import_selection_dialog import InterlisImportSelectionDialog
from .interlis_model_mapping.interlis_exporter_to_intermediate_schema import (
    InterlisExporterToIntermediateSchema,
    InterlisExporterToIntermediateSchemaError,
)
from .interlis_model_mapping.interlis_importer_to_intermediate_schema import (
    InterlisImporterToIntermediateSchema,
)
from .interlis_model_mapping.model_interlis_ag64 import ModelInterlisAG64
from .interlis_model_mapping.model_interlis_ag96 import ModelInterlisAG96
from .interlis_model_mapping.model_interlis_dss import ModelInterlisDss
from .interlis_model_mapping.model_interlis_sia405_abwasser import (
    ModelInterlisSia405Abwasser,
)
from .interlis_model_mapping.model_interlis_sia405_base_abwasser import (
    ModelInterlisSia405BaseAbwasser,
)
from .interlis_model_mapping.model_interlis_vsa_kek import ModelInterlisVsaKek
from .interlis_model_mapping.model_tww import ModelTwwSys, ModelTwwVl
from .interlis_model_mapping.model_tww_ag6496 import ModelTwwAG6496
from .interlis_model_mapping.model_tww_od import ModelTwwOd
from .utils.ili2db import InterlisTools
from .utils.various import CmdException, LoggingHandlerContext, logger, make_log_path


class InterlisImporterExporterStopped(Exception):
    pass


class InterlisImporterExporterError(Exception):
    def __init__(self, error, additional_text, log_path):
        self.error = error
        self.additional_text = additional_text
        self.log_path = log_path


class InterlisImporterExporter:

    def __init__(self, progress_done_callback=None):
        self.progress_done_callback = progress_done_callback
        self.interlisTools = InterlisTools()
        self.base_log_path = None

        self.model_classes_interlis = None
        self.model_classes_tww_od = None
        self.model_classes_tww_vl = None
        self.model_classes_tww_sys = None
        self.model_classes_tww_app = None

        self.filter_nulls = None
        self.srid = 2056
        self.current_progress = 0

    def interlis_import(
        self,
        xtf_file_input,
        show_selection_dialog=False,
        logs_next_to_file=True,
        filter_nulls=True,
        srid: int = None,
    ):
        # Configure logging
        if logs_next_to_file:
            self.base_log_path = xtf_file_input
        else:
            self.base_log_path = None

        self.filter_nulls = filter_nulls

        if srid:
            self.srid = srid

        # Validating the input file
        self._progress_done(5, "Validating the input file...")
        self._import_validate_xtf_file(xtf_file_input)

        # Get model to import from xtf file
        self._progress_done(10, "Extract model from xtf...")
        import_models = self.interlisTools.get_xtf_models(xtf_file_input)

        import_model = ""
        if config.MODEL_NAME_SIA405_BASE_ABWASSER in import_models:
            import_model = config.MODEL_NAME_SIA405_BASE_ABWASSER

        # override base model if necessary
        if config.MODEL_NAME_VSA_KEK in import_models:
            import_model = config.MODEL_NAME_VSA_KEK
        elif config.MODEL_NAME_SIA405_ABWASSER in import_models:
            import_model = config.MODEL_NAME_SIA405_ABWASSER
        elif config.MODEL_NAME_DSS in import_models:
            import_model = config.MODEL_NAME_DSS

        elif config.MODEL_NAME_SIA405_BASE_ABWASSER in import_models:
            import_model = config.MODEL_NAME_SIA405_ABWASSER
        elif config.MODEL_NAME_AG96 in import_models:
            import_model = config.MODEL_NAME_AG96
        elif config.MODEL_NAME_AG64 in import_models:
            import_model = config.MODEL_NAME_AG64

        if not import_model:
            error_text = f"No supported model was found among '{import_models}'."
            if len(import_models) == 1:
                error_text = f"The model '{import_models[0]}' is not supported."
            raise InterlisImporterExporterError("Import error", error_text, None)
        logger.info(
            f"Model '{import_model}' was choosen for import among found models '{import_models}'"
        )

        # Prepare the temporary ili2pg model
        self._progress_done(15, "Creating ili schema...")
        self._clear_ili_schema(recreate_tables=True)

        self._progress_done(20)
        self._create_ili_schema(
            [import_model], ext_columns_no_constraints=True, create_basket_col=True
        )

        # Import from xtf file to ili2pg model
        self._progress_done(30, "Importing XTF data...")
        self._import_xtf_file(xtf_file_input=xtf_file_input)

        # Disable symbology triggers
        self._progress_done(35, "Disable symbology and modification triggers...")
        self._import_disable_symbology_and_modification_triggers()

        try:
            # Import from the temporary ili2pg model
            self._progress_done(40, "Converting to TEKSI Wastewater...")
            tww_session = self._import_from_intermediate_schema(import_model)

            if show_selection_dialog:
                self._progress_done(90, "Import objects selection...")
                import_dialog = InterlisImportSelectionDialog()
                import_dialog.init_with_session(tww_session)
                QApplication.restoreOverrideCursor()
                if import_dialog.exec_() == import_dialog.Rejected:
                    tww_session.rollback()
                    tww_session.close()
                    raise InterlisImporterExporterStopped()
                QApplication.setOverrideCursor(Qt.WaitCursor)
            else:
                self._progress_done(90, "Commit session...")
                tww_session.commit()
            tww_session.close()

            # Update the sequence values
            self._progress_done(92, "Update sequence values...")
            self._import_set_od_sequences()

            # Update main_cover and main_wastewater_node
            self._progress_done(95, "Update main cover and refresh materialized views...")
            self._import_update_main_cover_and_refresh_mat_views()

            # Validate subclasses after import
            self._check_subclass_counts()

            # Update organisations
            self._progress_done(96, "Set organisations filter...")
            self._import_manage_organisations()

            # Reenable symbology triggers
            self._progress_done(97, "Reenable symbology and modification triggers...")
            self._import_enable_symbology_and_modification_triggers()

        except Exception as exception:
            # Make sure to re-enable triggers in case an exception occourred
            try:
                self._import_enable_symbology_and_modification_triggers()
            except Exception as enable_trigger_exception:
                logger.error(
                    f"Symbology triggers couldn't be re-enabled because an exception occourred: '{enable_trigger_exception}'"
                )

            # Raise the original exception for further error handling
            raise exception

        self._progress_done(100)
        logger.info("INTERLIS import finished.")

    def interlis_export(
        self,
        xtf_file_output,
        export_models,
        logs_next_to_file=True,
        user_interaction=False,
        limit_to_selection=False,
        export_orientation=90.0,
        labels_file=None,
        selected_labels_scales_indices=[],
        selected_ids=None,
        srid: int = None,
    ):

        flag_export_check_failed = False
        flag_test = True

        if srid:
            self.srid = srid

        if export_models[0] == "SIA405_Base_Abwasser_1_LV95":
            if self._check_organisation_tww_local_extension_count(limit_to_selection):
                errormsg = "INTERLIS export has been stopped as there have been no organisations for exporting!"
                logger.info(
                    "INTERLIS export has been stopped as there have been no organisations for exporting!"
                )
                # self._progress_done(100, "Export aborted...")
                # return
                raise InterlisImporterExporterError(
                    "INTERLIS Export aborted!",
                    errormsg,
                    None,
                )
                exit
            else:
                logger.info("INTERLIS export continued as organisations are available!")
                logger.info(f"Debug.print export_model '{export_models[0]}, case False'")
        else:
            logger.info(f"Debug.print export_model '{export_models[0]}'")

        # go thru all available checks and register if check failed or not.
        if flag_test:
            number_tests_failed = 0
            number_tests_ok = 0

            failed_check_list = "failed : "
            # Validate subclasses before export

            if self._check_subclass_counts(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_subclass_counts, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1

            # logger.debug(
            # f" _check_subclass_counts: flag_export_check_failed {flag_export_check_failed}"
            # )

            # Check if attribute identifier is Null before export
            # flag_export_check_failed added
            # flag_export_check_failed = flag_export_check_failed and self._check_identifier_null(limit_to_selection)
            if self._check_identifier_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_identifier_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1

            # logger.debug(
            # f" _check_identifier_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # Check if MANDATORY fk_owner is Null  before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_owner_null(limit_to_selection)
            if self._check_fk_owner_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_owner_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1

            # logger.debug(
            # f" _check_fk_owner_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # Check if MANDATORY fk_operator is Null  before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_operator_null(limit_to_selection)
            if self._check_fk_operator_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_operator_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1

            # logger.debug(
            # f" _check_fk_operator_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # Check if MANDATORY fk_dataowner is Null  before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_dataowner_null(limit_to_selection)
            if self._check_fk_dataowner_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_dataowner_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1

            # logger.debug(
            # f" _check_fk_dataowner_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # take out again
            # flag_export_check_failed = True

            # Check if MANDATORY fk_provider is Null  before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_provider_null(limit_to_selection)
            if self._check_fk_provider_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_provider_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1

            # logger.debug(
            # f" _check_fk_provider_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_wastewater_structure is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_wastewater_structure_null(limit_to_selection)
            if self._check_fk_wastewater_structure_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_wastewater_structure_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_wastewater_structure_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_wastewater_node is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_wastewater_node_null(limit_to_selection)
            if self._check_fk_wastewater_node_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_wastewater_node_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_wastewater_node_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_responsible_entity is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_responsible_entity_null(limit_to_selection)
            if self._check_fk_responsible_entity_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_responsible_entity_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_responsible_entity_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_responsible_start is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_responsible_start_null(limit_to_selection)
            if self._check_fk_responsible_start_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_responsible_start_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_responsible_start_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_discharge_point is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_discharge_point_null(limit_to_selection)
            if self._check_fk_discharge_point_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_discharge_point_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_discharge_point_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_hydraulic_char_data is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_hydraulic_char_data_null(limit_to_selection)
            if self._check_fk_hydraulic_char_data_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_hydraulic_char_data_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_hydraulic_char_data_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_building_group is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_building_group_null(limit_to_selection)
            if self._check_fk_building_group_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_building_group_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_building_group_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_reach is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_reach_null(limit_to_selection)
            if self._check_fk_reach_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_reach_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_reach_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_reach_point_from is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_reach_point_from_null(limit_to_selection)
            if self._check_fk_reach_point_from_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_reach_point_from_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_reach_point_from_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_reach_point_to is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_reach_point_to_null(limit_to_selection)
            if self._check_fk_reach_point_to_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_reach_point_to_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_reach_point_to_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_pwwf_wastewater_node is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_pwwf_wastewater_node_null(limit_to_selection)
            if self._check_fk_pwwf_wastewater_node_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_pwwf_wastewater_node_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_pwwf_wastewater_node_null: flag_export_check_failed {flag_export_check_failed}"
            # )

            # new in TEKSI
            # Check if MANDATORY fk_catchment_area is Null before export
            # flag_export_check_failed = flag_export_check_failed and self._check_fk_catchment_area_null(limit_to_selection)
            if self._check_fk_catchment_area_null(limit_to_selection):
                flag_export_check_failed = True
                failed_check_list = failed_check_list + "check_fk_catchment_area_null, "
                number_tests_failed = number_tests_failed + 1
            else:
                number_tests_ok = number_tests_ok + 1
            # logger.debug(
            # f" _check_fk_catchment_area_null: flag_export_check_failed {flag_export_check_failed}"
            # )

        # logger.debug(f"After checks: flag_export_check_failed {flag_export_check_failed}")
        total_checks = number_tests_failed + number_tests_ok

        if flag_export_check_failed:
            if user_interaction:
                logger.debug("Adding QMessageBox ...")
                # Add Message box to ask if export should still be continued or not

                mb = QMessageBox()

                # TypeError: warning(parent: Optional[QWidget], title: Optional[str], text: Optional[str], buttons: Union[QMessageBox.StandardButtons, QMessageBox.StandardButton] = QMessageBox.Ok, defaultButton: QMessageBox.StandardButton = QMessageBox.NoButton): not enough arguments

                # mb = QMessageBox.warning(
                # self,
                # 'Stop exporting',
                # 'Do you want to quit?',
                # QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
                # )
                mb.setWindowTitle("Stop exporting")
                mb.setIcon(QMessageBox.Warning)
                mb.setText(
                    "Stop exporting: Some export checks failed - check the logs for details. (if you have a selection you can still try (click Cancel) "
                )
                mb.setInformativeText(
                    f" {number_tests_failed} of {total_checks} {failed_check_list}"
                )
                mb.setStandardButtons(QMessageBox.Ok | QMessageBox.Cancel)
                return_value = mb.exec()
                if return_value == QMessageBox.Ok:
                    errormsg = "INTERLIS export has been stopped due to failing export checks - see logs for details."
                    logger.info(
                        "INTERLIS export has been stopped due to failing export checks - see logs for details."
                    )
                    # self._progress_done(100, "Export aborted...")
                    # return
                    raise InterlisImporterExporterError(
                        "INTERLIS Export aborted!",
                        errormsg,
                        None,
                    )
                    exit
                elif return_value == QMessageBox.Cancel:

                    # File name without extension (used later for export)
                    file_name_base, _ = os.path.splitext(xtf_file_output)

                    # Configure logging
                    if logs_next_to_file:
                        self.base_log_path = xtf_file_output
                    else:
                        self.base_log_path = None

                    self._progress_done(5, "Clearing ili schema...")
                    self._clear_ili_schema(recreate_tables=True)

                    self._progress_done(15, "Creating ili schema...")
                    create_basket_col = False
                    if config.MODEL_NAME_VSA_KEK in export_models:
                        create_basket_col = True
                    self._create_ili_schema(export_models, create_basket_col=create_basket_col)

                    # Export the labels file
                    tempdir = tempfile.TemporaryDirectory()
                    labels_file_path = None
                    if len(selected_labels_scales_indices):
                        self._progress_done(25)
                        labels_file_path = os.path.join(tempdir.name, "labels.geojson")
                        self._export_labels_file(
                            limit_to_selection=limit_to_selection,
                            selected_labels_scales_indices=selected_labels_scales_indices,
                            labels_file_path=labels_file_path,
                            export_model=export_models[0],
                        )

                    # Export to the temporary ili2pg model
                    self._progress_done(35, "Converting from TEKSI Wastewater...")
                    self._export_to_intermediate_schema(
                        export_model=export_models[0],
                        file_name=xtf_file_output,
                        selected_ids=selected_ids,
                        export_orientation=export_orientation,
                        labels_file_path=labels_file_path,
                        basket_enabled=create_basket_col,
                    )
                    tempdir.cleanup()  # Cleanup

                    self._progress_done(60)
                    self._export_xtf_files(file_name_base, export_models)

                    self._progress_done(100)
                    logger.info("INTERLIS export finished.")
            else:
                logger.info(f" {number_tests_failed} of {total_checks} {failed_check_list}")
                logger.info(
                    "INTERLIS export has been stopped due to failing export checks - see logs for details."
                )
                exit
        # no problems with export checks
        else:
            # File name without extension (used later for export)
            file_name_base, _ = os.path.splitext(xtf_file_output)

            # Configure logging
            if logs_next_to_file:
                self.base_log_path = xtf_file_output
            else:
                self.base_log_path = None

            self._progress_done(5, "Clearing ili schema...")
            self._clear_ili_schema(recreate_tables=True)

            self._progress_done(15, "Creating ili schema...")
            create_basket_col = False
            if config.MODEL_NAME_VSA_KEK in export_models:
                create_basket_col = True
            self._create_ili_schema(export_models, create_basket_col=create_basket_col)

            # Export the labels file
            tempdir = tempfile.TemporaryDirectory()
            labels_file_path = None
            if len(selected_labels_scales_indices):
                self._progress_done(20)
                labels_file_path = os.path.join(tempdir.name, "labels.geojson")
                self._export_labels_file(
                    limit_to_selection=limit_to_selection,
                    selected_labels_scales_indices=selected_labels_scales_indices,
                    labels_file_path=labels_file_path,
                    export_model=export_models[0],
                )

            self._progress_done(25, "Creating ili schema...")
            create_basket_col = False
            if config.MODEL_NAME_VSA_KEK in export_models:
                create_basket_col = True
            self._create_ili_schema(export_models, create_basket_col=create_basket_col)

            # Export the labels file
            tempdir = tempfile.TemporaryDirectory()
            if len(selected_labels_scales_indices):
                self._progress_done(30)
                if not labels_file:
                    labels_file = os.path.join(tempdir.name, "labels.geojson")
                    self._export_labels_file(
                        limit_to_selection=limit_to_selection,
                        selected_labels_scales_indices=selected_labels_scales_indices,
                        labels_file_path=labels_file,
                        export_model=export_models[0],
                        export_orientation=export_orientation,
                    )

            if export_models[0] == config.MODEL_NAME_AG96:
                file_path = "data/Organisationstabelle_AG96.xtf"
                abs_file_path = Path(__file__).parent.resolve() / file_path
                logger.info("Importing AG-96 organisation to intermediate schema")
                self._import_xtf_file(abs_file_path)
            elif export_models[0] == config.MODEL_NAME_AG64:
                file_path = "data/Organisationstabelle_AG64.xtf"
                abs_file_path = Path(__file__).parent.resolve() / file_path
                logger.info("Importing AG-64 organisation to intermediate schema")
                self._import_xtf_file(abs_file_path)

            # Export to the temporary ili2pg model
            self._progress_done(35, "Converting from TEKSI Wastewater...")
            self._export_to_intermediate_schema(
                export_model=export_models[0],
                file_name=xtf_file_output,
                selected_ids=selected_ids,
                export_orientation=export_orientation,
                labels_file_path=labels_file,
                basket_enabled=create_basket_col,
            )
            tempdir.cleanup()  # Cleanup

            self._progress_done(75)
            self._export_xtf_files(file_name_base, export_models)

            self._progress_done(100)
            logger.info("INTERLIS export finished.")

    def _import_validate_xtf_file(self, xtf_file_input):
        log_path = make_log_path(self.base_log_path, "ilivalidator")
        try:
            self.interlisTools.validate_xtf_data(
                xtf_file_input,
                log_path,
            )
        except CmdException:
            raise InterlisImporterExporterError(
                "Invalid file",
                "The input file is not a valid XTF file. Open the logs for more details on the error.",
                log_path,
            )

    def _import_xtf_file(self, xtf_file_input):
        log_path = make_log_path(self.base_log_path, "ili2pg-import")
        try:
            self.interlisTools.import_xtf_data(
                config.ABWASSER_SCHEMA,
                xtf_file_input,
                log_path,
                self.srid,
            )
        except CmdException:
            raise InterlisImporterExporterError(
                "Could not import data",
                "Open the logs for more details on the error.",
                log_path,
            )

    def _import_from_intermediate_schema(self, import_model):
        log_handler = logging.FileHandler(
            make_log_path(self.base_log_path, "tww2ili-import"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        self._init_model_classes(import_model)

        interlisImporterToIntermediateSchema = InterlisImporterToIntermediateSchema(
            model=import_model,
            model_classes_interlis=self.model_classes_interlis,
            model_classes_tww_od=self.model_classes_tww_od,
            model_classes_tww_vl=self.model_classes_tww_vl,
            model_classes_tww_app=self.model_classes_tww_app,
            callback_progress_done=self._progress_done_intermediate_schema,
            filter_nulls=self.filter_nulls,
        )

        with LoggingHandlerContext(log_handler):
            interlisImporterToIntermediateSchema.tww_import(skip_closing_tww_session=True)

        return interlisImporterToIntermediateSchema.session_tww

    def _import_set_od_sequences(self):
        logger.info("Set Sequence values")
        DatabaseUtils.execute("SELECT tww_app.reset_od_seqval();")

    def _import_manage_organisations(self):
        logger.info("Update organisation tww_active")
        DatabaseUtils.execute("SELECT tww_app.set_organisations_active();")

    def _import_update_main_cover_and_refresh_mat_views(self):
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            logger.info("Update wastewater structure fk_main_cover")
            cursor.execute("SELECT tww_app.wastewater_structure_update_fk_main_cover('', True);")

            logger.info("Update wastewater structure fk_main_wastewater_node")
            cursor.execute(
                "SELECT tww_app.wastewater_structure_update_fk_main_wastewater_node('', True);"
            )

            logger.info("Refresh materialized views")
            cursor.execute("SELECT tww_app.network_refresh_network_simple();")

    def _import_disable_symbology_and_modification_triggers(self):
        DatabaseUtils.disable_symbology_triggers()
        DatabaseUtils.disable_modification_triggers()

    def _import_enable_symbology_and_modification_triggers(self):
        DatabaseUtils.enable_symbology_triggers()
        DatabaseUtils.update_symbology()
        DatabaseUtils.enable_modification_triggers()

    def _export_labels_file(
        self,
        limit_to_selection,
        selected_labels_scales_indices,
        labels_file_path,
        export_model,
        export_orientation=90.0,
    ):
        self._progress_done(self.current_progress, "Extracting labels...")

        try:
            # We only import now to avoid useless exception if dependencies aren't met
            from qgis import processing

            from ..utils.twwlayermanager import TwwLayerManager
        except ImportError:
            raise InterlisImporterExporterError(
                "Export labels error",
                "Could not load export labels as qgis.processing module is not available.",
                None,
            )

        structures_lyr = TwwLayerManager.layer("vw_tww_wastewater_structure")
        reaches_lyr = TwwLayerManager.layer("vw_tww_reach")
        if not structures_lyr or not reaches_lyr:
            raise InterlisImporterExporterError(
                "Could not find the vw_tww_wastewater_structure and/or the vw_tww_reach layers.",
                "Make sure your TEKSI Wastewater project is open.",
                None,
            )

        self._progress_done(self.current_progress + 2)
        if export_model == config.MODEL_NAME_AG96:
            catch_lyr = TwwLayerManager.layer("vw_tww_catchment_area")
            meas_pt_lyr = TwwLayerManager.layer("measure_point")
            meas_lin_lyr = TwwLayerManager.layer("measure_line")
            meas_ply_lyr = TwwLayerManager.layer("measure_polygon")
            building_group_lyr = TwwLayerManager.layer("building_group")

            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "CATCHMENT_LAYER": catch_lyr,
                    "MEASURE_POINT_LAYER": meas_pt_lyr,
                    "MEASURE_LINE_LAYER": meas_lin_lyr,
                    "MEASURE_POLYGON_LAYER": meas_ply_lyr,
                    "BUILDING_GROUP_LAYER": building_group_lyr,
                    "SCALES": selected_labels_scales_indices,
                    "REPLACE_WS_WITH_WN": True,
                },
            )
        elif export_model == config.MODEL_NAME_DSS:
            catch_lyr = TwwLayerManager.layer("vw_tww_catchment_area")

            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "CATCHMENT_LAYER": catch_lyr,
                    "SCALES": selected_labels_scales_indices,
                },
            )
        elif export_model == config.MODEL_NAME_AG64:
            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "SCALES": selected_labels_scales_indices,
                    "REPLACE_WS_WITH_WN": True,
                },
            )
        else:
            processing.run(
                "tww:extractlabels_interlis",
                {
                    "OUTPUT": labels_file_path,
                    "RESTRICT_TO_SELECTION": limit_to_selection,
                    "EXPORT_ORIENTATION": export_orientation,
                    "STRUCTURE_VIEW_LAYER": structures_lyr,
                    "REACH_VIEW_LAYER": reaches_lyr,
                    "SCALES": selected_labels_scales_indices,
                },
            )

    def _export_to_intermediate_schema(
        self,
        export_model,
        file_name=None,
        selected_ids=None,
        export_orientation=90.0,
        labels_file_path=None,
        basket_enabled=False,
    ):
        log_handler = logging.FileHandler(
            make_log_path(file_name, "tww2ili-export"), mode="w", encoding="utf-8"
        )
        log_handler.setLevel(logging.INFO)
        log_handler.setFormatter(logging.Formatter("%(levelname)-8s %(message)s"))

        self._init_model_classes(export_model)

        twwInterlisExporter = InterlisExporterToIntermediateSchema(
            model=export_model,
            model_classes_interlis=self.model_classes_interlis,
            model_classes_tww_od=self.model_classes_tww_od,
            model_classes_tww_vl=self.model_classes_tww_vl,
            model_classes_tww_sys=self.model_classes_tww_sys,
            model_classes_tww_app=self.model_classes_tww_app,
            labels_orientation_offset=export_orientation,
            selection=selected_ids,
            labels_file=labels_file_path,
            basket_enabled=basket_enabled,
            callback_progress_done=self._progress_done_intermediate_schema,
        )

        with LoggingHandlerContext(log_handler):
            try:
                twwInterlisExporter.tww_export()
            except (
                InterlisExporterToIntermediateSchemaError
            ) as interlisExporterToIntermediateSchemaError:
                raise InterlisImporterExporterError(
                    "Could not export to the interlis schema",
                    f"{interlisExporterToIntermediateSchemaError}",
                    None,
                )

    def _export_xtf_files(self, file_name_base, export_models):
        progress_step = (100 - self.current_progress) / (2 * len(export_models))
        progress_step = int(progress_step)

        xtf_export_errors = []
        for index, export_model_name in enumerate(export_models):
            export_file_name = f"{file_name_base}_{export_model_name}.xtf"

            # Export from ili2pg model to file
            self._progress_done(self.current_progress, f"Saving XTF for '{export_model_name}'...")
            log_path = make_log_path(self.base_log_path, f"ili2pg-export-{export_model_name}")
            try:
                self.interlisTools.export_xtf_data(
                    schema=config.ABWASSER_SCHEMA,
                    xtf_file=export_file_name,
                    log_path=log_path,
                    model_name=export_model_name,
                    export_model_name=export_model_name,
                    srid=self.srid,
                )
            except CmdException:
                xtf_export_errors.append(
                    InterlisImporterExporterError(
                        error=f"Could not export the model '{export_model_name}' from ili2pg schema",
                        additional_text="Open the logs for more details on the error.",
                        log_path=log_path,
                    )
                )
                continue

            self._progress_done(
                self.current_progress + progress_step,
                f"Validating XTF for '{export_model_name}'...",
            )
            log_path = make_log_path(self.base_log_path, f"ilivalidator-{export_model_name}")
            try:
                self.interlisTools.validate_xtf_data(
                    export_file_name,
                    log_path,
                )
            except CmdException:
                xtf_export_errors.append(
                    InterlisImporterExporterError(
                        error=f"Validation of exported file '{export_file_name}' failed",
                        additional_text=f"The created file is not a valid {export_model_name} XTF file.",
                        log_path=log_path,
                    )
                )
                continue

            self._progress_done(self.current_progress + progress_step)

        # In case some export had an error raise the first one
        if xtf_export_errors:
            raise xtf_export_errors[0]

    def _clear_ili_schema(self, recreate_tables=False):
        logger.info("CONNECTING TO DATABASE...")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            cursor.execute(
                f"SELECT schema_name FROM information_schema.schemata WHERE schema_name = '{config.ABWASSER_SCHEMA}';"
            )
            if cursor.rowcount == 0:
                cursor.execute(f"CREATE SCHEMA {config.ABWASSER_SCHEMA} CASCADE;")
            else:
                cursor.execute(
                    f"SELECT table_name FROM information_schema.tables WHERE table_schema = '{config.ABWASSER_SCHEMA}';"
                )
                logger.info(f"Truncating all tables in schema {config.ABWASSER_SCHEMA}")
                rows = cursor.fetchall()
                for row in rows:
                    cursor.execute(f"TRUNCATE TABLE {config.ABWASSER_SCHEMA}.{row[0]} CASCADE;")
                if recreate_tables:
                    logger.info(f"Deleting all tables in schema {config.ABWASSER_SCHEMA} ")
                    for row in rows:
                        cursor.execute(f"DROP TABLE {config.ABWASSER_SCHEMA}.{row[0]} CASCADE;")

    def _create_ili_schema(
        self, models, ext_columns_no_constraints=False, create_basket_col=False
    ):
        log_path = make_log_path(self.base_log_path, "ili2pg-schemaimport")
        try:
            self.interlisTools.import_ili_schema(
                config.ABWASSER_SCHEMA,
                models,
                log_path,
                ext_columns_no_constraints=ext_columns_no_constraints,
                create_basket_col=create_basket_col,
                srid=self.srid,
            )
        except CmdException:
            raise InterlisImporterExporterError(
                "Could not create the ili2pg schema",
                "Open the logs for more details on the error.",
                log_path,
            )

    def _check_subclass_counts(self, limit_to_selection=False):

        check_subclass_counts_failed = False
        check_subclass_counts_failed = check_subclass_counts_failed and self._check_subclass_count(
            config.TWW_OD_SCHEMA,
            "wastewater_networkelement",
            ["reach", "wastewater_node"],
            limit_to_selection,
        )
        # logger.debug(f"check_subclass_counts_failed: {check_subclass_counts_failed} 1")
        check_subclass_counts_failed = check_subclass_counts_failed and self._check_subclass_count(
            config.TWW_OD_SCHEMA,
            "wastewater_structure",
            [
                "channel",
                "manhole",
                "special_structure",
                "infiltration_installation",
                "discharge_point",
                "wwtp_structure",
                "small_treatment_plant",
                "drainless_toilet",
            ],
            limit_to_selection,
        )
        # logger.debug(f"check_subclass_counts_failed: {check_subclass_counts_failed} 2")
        check_subclass_counts_failed = check_subclass_counts_failed and self._check_subclass_count(
            config.TWW_OD_SCHEMA,
            "structure_part",
            [
                "benching",
                "tank_emptying",
                "tank_cleaning",
                "cover",
                "access_aid",
                "electric_equipment",
                "electromechanical_equipment",
                "solids_retention",
                "backflow_prevention",
                "flushing_nozzle",
                "dryweather_flume",
                "dryweather_downspout",
            ],
            limit_to_selection,
        )
        check_subclass_counts_failed = check_subclass_counts_failed and self._check_subclass_count(
            config.TWW_OD_SCHEMA,
            "overflow",
            ["pump", "leapingweir", "prank_weir"],
            limit_to_selection,
        )
        check_subclass_counts_failed = check_subclass_counts_failed and self._check_subclass_count(
            config.TWW_OD_SCHEMA,
            "maintenance_event",
            ["maintenance", "examination", "bio_ecol_assessment"],
            limit_to_selection,
        )
        check_subclass_counts_failed = check_subclass_counts_failed and self._check_subclass_count(
            config.TWW_OD_SCHEMA,
            "damage",
            ["damage_channel", "damage_manhole"],
            limit_to_selection,
        )
        check_subclass_counts_failed = check_subclass_counts_failed and self._check_subclass_count(
            config.TWW_OD_SCHEMA,
            "connection_object",
            ["fountain", "individual_surface", "building", "reservoir"],
            limit_to_selection,
        )
        check_subclass_counts_failed = check_subclass_counts_failed and self._check_subclass_count(
            config.TWW_OD_SCHEMA,
            "zone",
            ["infiltration_zone", "drainage_system"],
            limit_to_selection,
        )
        # logger.debug(f"check_subclass_counts_failed: {check_subclass_counts_failed} last")
        return check_subclass_counts_failed

    def _check_subclass_count(self, schema_name, parent_name, child_list, limit_to_selection):
        logger.info(f"INTEGRITY CHECK {parent_name} subclass data...")
        logger.info("CONNECTING TO DATABASE...")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            cursor.execute(f"SELECT obj_id FROM {schema_name}.{parent_name};")
            parent_rows = cursor.fetchall()
            if len(parent_rows) > 0:
                parent_count = len(parent_rows)
                logger.info(f"Number of {parent_name} datasets: {parent_count}")
                for child_name in child_list:
                    cursor.execute(f"SELECT obj_id FROM {schema_name}.{child_name};")
                    child_rows = cursor.fetchall()
                    logger.info(f"Number of {child_name} datasets: {len(child_rows)}")
                    parent_count = parent_count - len(child_rows)

                if parent_count == 0:
                    logger.info(
                        f"OK: number of subclass elements of class {parent_name} OK in schema {schema_name}!"
                    )
                    # Return statement added
                    return True
                else:
                    if parent_count > 0:
                        errormsg = f"Too many superclass entries for {schema_name}.{parent_name}"
                    else:
                        errormsg = f"Too many subclass entries for {schema_name}.{parent_name}"

                    if limit_to_selection:
                        logger.warning(
                            f"Overall Subclass Count: {errormsg}. The problem might lie outside the selection"
                        )
                    else:
                        logger.error(f"Subclass Count error: {errormsg}")
                        raise InterlisImporterExporterError(
                            "Subclass Count error",
                            errormsg,
                            None,
                        )
                    # Return statement added
                    return False

    # def _check_identifier_null(self, check_fail, limit_to_selection=False):
    def _check_identifier_null(self, limit_to_selection=False):
        """
        Check if attribute identifier is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing identifiers...")

            cursor = connection.cursor()

            missing_identifier_count = 0
            # add classes to be checked
            for notsubclass in [
                # VSA-KEK
                ("data_media"),
                ("file"),
                ("maintenance_event"),
                # SIA405 Abwasser
                ("organisation"),
                ("wastewater_structure"),
                ("wastewater_networkelement"),
                ("structure_part"),
                ("reach_point"),
                ("pipe_profile"),
                # VSA-DSS
                # new 2020
                ("building_group"),
                ("catchment_area"),
                ("connection_object"),
                ("control_center"),
                # only VSA-DSS 2015
                # ("hazard_source"),
                ("hydr_geometry"),
                ("hydraulic_char_data"),
                # new 2020
                ("measure"),
                ("measurement_result"),
                ("measurement_series"),
                ("measuring_device"),
                ("measuring_point"),
                ("mechanical_pretreatment"),
                ("overflow"),
                ("overflow_char"),
                ("retention_body"),
                # only VSA-DSS 2015
                # ("river_bank"),
                # ("river_bed"),
                # ("sector_water_body"),
                ("sludge_treatment"),
                # ("substance"),
                ("surface_runoff_parameters"),
                # ("surface_water_bodies"),
                ("throttle_shut_off_unit"),
                ("waste_water_treatment"),
                ("waste_water_treatment_plant"),
                # only VSA-DSS 2015
                # ("water_catchment"),
                # ("water_control_structure"),
                # ("water_course_segment"),
                ("wwtp_energy_use"),
                ("zone"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) as _count, array_agg(obj_id) as _obj_ids FROM tww_od.{notsubclass} WHERE identifier is null or identifier ='';"
                )

                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/

                try:
                    # class_identifier_count = int(cursor.fetchone()[0])
                    result = cursor.fetchone()
                    class_identifier_count = int(result[0])  # _count
                    obj_ids_without_identifier = result[1]
                except Exception:
                    class_identifier_count = 0
                    logger.debug(
                        f"Number of datasets in class '{notsubclass}' without identifier could not be identified (TypeError: 'NoneType' object is not subscriptable). Automatically set class_identifier_count = 0"
                    )
                else:
                    logger.info(
                        # f"Number of datasets in class '{notsubclass}' without identifier : {class_identifier_count}"
                        # f"{'No' if class_identifier_count else class_identifier_count} row{'s' if class_identifier_count != 1 else ''} in class '{notsubclass}' without identifier{': ' + obj_ids_without_identifier if obj_ids_without_identifier else ''}"
                        f"{'No' if class_identifier_count == 0 else class_identifier_count} row{'s' if class_identifier_count != 1 else ''} in class '{notsubclass}' without identifier{': ' + ','.join(obj_ids_without_identifier) if obj_ids_without_identifier else ''}"
                    )

                # if cursor.fetchone() is None:
                if class_identifier_count == 0:
                    missing_identifier_count = missing_identifier_count
                else:
                    # missing_identifier_count = missing_identifier_count + int(cursor.fetchone()[0])
                    missing_identifier_count = missing_identifier_count + class_identifier_count

                # add for testing
                logger.debug(f"missing_identifier_count : {missing_identifier_count}")

            if missing_identifier_count == 0:
                logger.info(f"OK: all identifiers set in tww_od.{notsubclass}!")
                return False
            else:
                pass
                # logger.info(f"ERROR: Missing identifiers in tww_od.{notsubclass}: {missing_identifier_count}")
                errormsg = f"Missing identifiers in schema tww_od: {missing_identifier_count}"
                if limit_to_selection:
                    logger.warning(
                        f"Overall Subclass Count: {errormsg}. The problem might lie outside the selection"
                    )
                else:
                    logger.error(f"INTEGRITY CHECK missing identifiers: {errormsg}")
                    # raise InterlisImporterExporterError(
                    # "INTEGRITY CHECK missing identifiers - see tww tab for details",
                    # errormsg,
                    # None,
                    # )
                # added check_fail 30.6.2025
                # logger.error(f"check_fail: {check_fail}")
                return True

    def _check_fk_owner_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_owner is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing MANDATORY owner references fk_owner...")

            cursor = connection.cursor()

            missing_fk_owner_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # SIA405 Abwasser
                ("wastewater_structure"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_owner is null or fk_owner ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_owner_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_owner : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_owner : {class_fk_owner_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_owner_count == 0:
                    missing_fk_owner_count = missing_fk_owner_count
                else:
                    # missing_fk_owner_count = missing_fk_owner_count + int(cursor.fetchone()[0])
                    missing_fk_owner_count = missing_fk_owner_count + class_fk_owner_count

                # add for testing
                logger.debug(f"missing_fk_owner_count : {missing_fk_owner_count}")

            if missing_fk_owner_count == 0:
                check_fk_owner_null = False
                logger.info(f"OK: all mandatory fk_owner set in tww_od.{notsubclass}!")
            else:
                check_fk_owner_null = True
                logger.info(
                    # f"ERROR: Missing mandatory fk_owner in tww_od.{notsubclass}: {missing_fk_owner_count}"
                    f"ERROR: {missing_fk_owner_count} missing mandatory fk_operator in tww_od classes"
                )
            # Return statement added
            logger.debug(f"missing_fk_owner_count : {missing_fk_owner_count}")
            return check_fk_owner_null

    def _check_fk_operator_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_operator is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing MANDATORY operator references fk_operator...")

            cursor = connection.cursor()

            missing_fk_operator_count = 0

            # add MANDATORY classes to be checked
            for notsubclass in [
                # SIA405 Abwasser
                ("wastewater_structure"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_operator is null or fk_operator ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_operator : {cursor.fetchone()[0]}"
                )

                if cursor.fetchone() is None:
                    missing_fk_operator_count = missing_fk_operator_count
                else:
                    missing_fk_operator_count = missing_fk_operator_count + int(
                        cursor.fetchone()[0]
                    )
                # add for testing
                logger.debug(f"missing_fk_operator_count : {missing_fk_operator_count}")

            if missing_fk_operator_count == 0:
                logger.info(f"OK: all mandatory fk_operator set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_operator in tww_od.{notsubclass}: {missing_fk_operator_count}"
                    f"ERROR: {missing_fk_operator_count} missing mandatory fk_operator in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_dataowner_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_dataowner is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing dataowner references fk_dataowner...")

            cursor = connection.cursor()

            missing_fk_dataowner_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                ("damage"),
                ("data_media"),
                ("file"),
                ("maintenance_event"),
                # SIA405 Abwasser
                # take out for DSS 2020
                # ("organisation"),
                ("wastewater_structure"),
                ("wastewater_networkelement"),
                ("structure_part"),
                ("reach_point"),
                ("pipe_profile"),
                # VSA-DSS
                # new 2020
                ("building_group"),
                ("building_group_baugwr"),
                ("catchment_area"),
                ("connection_object"),
                ("control_center"),
                # new 2020
                ("disposal"),
                ("farm"),
                # only VSA-DSS 2015
                # ("hazard_source"),
                ("hq_relation"),
                ("hydraulic_char_data"),
                ("hydr_geometry"),
                ("hydr_geom_relation"),
                # new 2020
                ("log_card"),
                # maintenance_event see VSA-KEK
                # new 2020
                ("measure"),
                ("measurement_result"),
                ("measurement_series"),
                ("measuring_device"),
                ("measuring_point"),
                ("mechanical_pretreatment"),
                ("mutation"),
                ("overflow"),
                ("overflow_char"),
                ("profile_geometry"),
                ("retention_body"),
                # only VSA-DSS 2015
                # ("river_bank"),
                # ("river_bed"),
                # ("sector_water_body"),
                ("sludge_treatment"),
                # ("substance"),
                ("surface_runoff_parameters"),
                # only VSA-DSS 2015
                # ("surface_water_bodies"),
                ("throttle_shut_off_unit"),
                ("waste_water_treatment"),
                ("waste_water_treatment_plant"),
                # only VSA-DSS 2015
                # ("water_catchment"),
                # ("water_control_structure"),
                # ("water_course_segment"),
                ("wwtp_energy_use"),
                ("zone"),
                # sia405cc
                ("sia405cc_cable"),
                ("sia405cc_cable_point"),
                ("sia405pt_protection_tube"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_dataowner is null or fk_dataowner ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_dataowner_count = int(cursor.fetchone()[0])

                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_dataowner : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_dataowner : {class_fk_dataowner_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_dataowner_count == 0:
                    missing_fk_dataowner_count = missing_fk_dataowner_count
                else:
                    # missing_fk_dataowner_count = missing_fk_dataowner_count + int(cursor.fetchone()[0])
                    missing_fk_dataowner_count = (
                        missing_fk_dataowner_count + class_fk_dataowner_count
                    )

                # add for testing
                logger.debug(f"missing_fk_dataowner_count : {missing_fk_dataowner_count}")

            if missing_fk_dataowner_count == 0:
                logger.info(f"OK: all mandatory fk_dataowner set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_dataowner in tww_od.{notsubclass}: {missing_fk_dataowner_count}"
                    f"ERROR: {missing_fk_dataowner_count} missing mandatory fk_dataowner in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_provider_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_provider is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing provider references fk_provider...")

            cursor = connection.cursor()

            missing_fk_provider_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                ("damage"),
                ("data_media"),
                ("file"),
                ("maintenance_event"),
                # SIA405 Abwasser
                # take out for DSS 2020
                # ("organisation"),
                ("wastewater_structure"),
                ("wastewater_networkelement"),
                ("structure_part"),
                ("reach_point"),
                ("pipe_profile"),
                # VSA-DSS
                # new 2020
                ("building_group"),
                ("building_group_baugwr"),
                ("catchment_area"),
                ("connection_object"),
                ("control_center"),
                # new 2020
                ("disposal"),
                ("farm"),
                # only VSA-DSS 2015
                # ("hazard_source"),
                ("hq_relation"),
                ("hydraulic_char_data"),
                ("hydr_geometry"),
                ("hydr_geom_relation"),
                # new 2020
                ("log_card"),
                # maintenance_event see VSA-KEK
                # new 2020
                ("measure"),
                ("measurement_result"),
                ("measurement_series"),
                ("measuring_device"),
                ("measuring_point"),
                ("mechanical_pretreatment"),
                ("mutation"),
                ("overflow"),
                ("overflow_char"),
                ("profile_geometry"),
                ("retention_body"),
                # only VSA-DSS 2015
                # ("river_bank"),
                # ("river_bed"),
                # ("sector_water_body"),
                ("sludge_treatment"),
                # ("substance"),
                ("surface_runoff_parameters"),
                # ("surface_water_bodies"),
                ("throttle_shut_off_unit"),
                ("waste_water_treatment"),
                ("waste_water_treatment_plant"),
                # only VSA-DSS 2015
                # ("water_catchment"),
                # ("water_control_structure"),
                # ("water_course_segment"),
                ("wwtp_energy_use"),
                ("zone"),
                # sia405cc
                ("sia405cc_cable"),
                ("sia405cc_cable_point"),
                ("sia405pt_protection_tube"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_provider is null or fk_provider ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_provider_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_provider : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_provider : {class_fk_provider_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_provider_count == 0:
                    missing_fk_provider_count = missing_fk_provider_count
                else:
                    # missing_fk_provider_count = missing_fk_provider_count + int(cursor.fetchone()[0])
                    missing_fk_provider_count = missing_fk_provider_count + class_fk_provider_count

                # add for testing
                logger.debug(f"missing_fk_provider_count : {missing_fk_provider_count}")

            if missing_fk_provider_count == 0:
                logger.info(f"OK: all mandatory fk_provider set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_provider in tww_od.{notsubclass}: {missing_fk_provider_count}"
                    f"ERROR: {missing_fk_provider_count} missing mandatory fk_provider in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_wastewater_structure_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_wastewater_structure is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info(
                "INTEGRITY CHECK missing wastewater_structure references fk_wastewater_structure..."
            )

            cursor = connection.cursor()

            missing_fk_wastewater_structure_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                ("structure_part"),
                # VSA-DSS
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_wastewater_structure is null or fk_wastewater_structure ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_wastewater_structure_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_wastewater_structure : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_wastewater_structure : {class_fk_wastewater_structure_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_wastewater_structure_count == 0:
                    missing_fk_wastewater_structure_count = missing_fk_wastewater_structure_count
                else:
                    # missing_fk_wastewater_structure_count = missing_fk_wastewater_structure_count + int(cursor.fetchone()[0])
                    missing_fk_wastewater_structure_count = (
                        missing_fk_wastewater_structure_count + class_fk_wastewater_structure_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_wastewater_structure_count : {missing_fk_wastewater_structure_count}"
                )

            if missing_fk_wastewater_structure_count == 0:
                logger.info(
                    f"OK: all mandatory fk_wastewater_structure set in tww_od.{notsubclass}!"
                )
                # Return statement added
                return False
            else:
                logger.error(
                    f"ERROR: Missing mandatory fk_wastewater_structure in tww_od.{notsubclass}: {missing_fk_wastewater_structure_count}"
                )
                # Return statement added
                return True

    def _check_fk_wastewater_node_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_wastewater_node is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing wastewater_node references fk_wastewater_node...")

            cursor = connection.cursor()

            missing_fk_wastewater_node_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                # VSA-DSS
                ("hydraulic_char_data"),
                ("overflow"),
                ("throttle_shut_off_unit"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_wastewater_node is null or fk_wastewater_node ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_wastewater_node_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_wastewater_node : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_wastewater_node : {class_fk_wastewater_node_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_wastewater_node_count == 0:
                    missing_fk_wastewater_node_count = missing_fk_wastewater_node_count
                else:
                    # missing_fk_wastewater_node_count = missing_fk_wastewater_node_count + int(cursor.fetchone()[0])
                    missing_fk_wastewater_node_count = (
                        missing_fk_wastewater_node_count + class_fk_wastewater_node_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_wastewater_node_count : {missing_fk_wastewater_node_count}"
                )

            if missing_fk_wastewater_node_count == 0:
                logger.info(f"OK: all mandatory fk_wastewater_node set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_wastewater_node in tww_od.{notsubclass}: {missing_fk_wastewater_node_count}"
                    f"ERROR: {missing_fk_wastewater_node_count} missing mandatory fk_wastewater_node in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_responsible_entity_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_responsible_entity is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info(
                "INTEGRITY CHECK missing responsible_entity references fk_responsible_entity..."
            )

            cursor = connection.cursor()

            missing_fk_responsible_entity_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                # VSA-DSS
                ("measure"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_responsible_entity is null or fk_responsible_entity ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_responsible_entity_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_responsible_entity : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_responsible_entity : {class_fk_responsible_entity_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_responsible_entity_count == 0:
                    missing_fk_responsible_entity_count = missing_fk_responsible_entity_count
                else:
                    # missing_fk_responsible_entity_count = missing_fk_responsible_entity_count + int(cursor.fetchone()[0])
                    missing_fk_responsible_entity_count = (
                        missing_fk_responsible_entity_count + class_fk_responsible_entity_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_responsible_entity_count : {missing_fk_responsible_entity_count}"
                )

            if missing_fk_responsible_entity_count == 0:
                logger.info(
                    f"OK: all mandatory fk_responsible_entity set in tww_od.{notsubclass}!"
                )
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_responsible_entity in tww_od.{notsubclass}: {missing_fk_responsible_entity_count}"
                    f"ERROR: {missing_fk_responsible_entity_count} missing mandatory fk_responsible_entity in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_responsible_start_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_responsible_start is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info(
                "INTEGRITY CHECK missing responsible_start references fk_responsible_start..."
            )

            cursor = connection.cursor()

            missing_fk_responsible_start_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                # VSA-DSS
                ("measure"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_responsible_start is null or fk_responsible_start ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_responsible_start_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_responsible_start : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_responsible_start : {class_fk_responsible_start_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_responsible_start_count == 0:
                    missing_fk_responsible_start_count = missing_fk_responsible_start_count
                else:
                    # missing_fk_responsible_start_count = missing_fk_responsible_start_count + int(cursor.fetchone()[0])
                    missing_fk_responsible_start_count = (
                        missing_fk_responsible_start_count + class_fk_responsible_start_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_responsible_start_count : {missing_fk_responsible_start_count}"
                )

            if missing_fk_responsible_start_count == 0:
                logger.info(f"OK: all mandatory fk_responsible_start set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_responsible_start in tww_od.{notsubclass}: {missing_fk_responsible_start_count}"
                    f"ERROR: {missing_fk_responsible_start_count} missing mandatory fk_responsible_start in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_discharge_point_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_discharge_point is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing discharge_point references fk_discharge_point...")

            cursor = connection.cursor()

            missing_fk_discharge_point_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                # VSA-DSS
                ("catchment_area_totals"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_discharge_point is null or fk_discharge_point ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_discharge_point_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_discharge_point : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_discharge_point : {class_fk_discharge_point_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_discharge_point_count == 0:
                    missing_fk_discharge_point_count = missing_fk_discharge_point_count
                else:
                    # missing_fk_discharge_point_count = missing_fk_discharge_point_count + int(cursor.fetchone()[0])
                    missing_fk_discharge_point_count = (
                        missing_fk_discharge_point_count + class_fk_discharge_point_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_discharge_point_count : {missing_fk_discharge_point_count}"
                )

            if missing_fk_discharge_point_count == 0:
                logger.info(f"OK: all mandatory fk_discharge_point set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_discharge_point in tww_od.{notsubclass}: {missing_fk_discharge_point_count}"
                    f"ERROR: {missing_fk_discharge_point_count} missing mandatory fk_discharge_point in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_hydraulic_char_data_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_hydraulic_char_data is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info(
                "INTEGRITY CHECK missing hydraulic_char_data references fk_hydraulic_char_data..."
            )

            cursor = connection.cursor()

            missing_fk_hydraulic_char_data_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                # VSA-DSS
                ("catchment_area_totals"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_hydraulic_char_data is null or fk_hydraulic_char_data ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_hydraulic_char_data_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_hydraulic_char_data : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_hydraulic_char_data : {class_fk_hydraulic_char_data_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_hydraulic_char_data_count == 0:
                    missing_fk_hydraulic_char_data_count = missing_fk_hydraulic_char_data_count
                else:
                    # missing_fk_hydraulic_char_data_count = missing_fk_hydraulic_char_data_count + int(cursor.fetchone()[0])
                    missing_fk_hydraulic_char_data_count = (
                        missing_fk_hydraulic_char_data_count + class_fk_hydraulic_char_data_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_hydraulic_char_data_count : {missing_fk_hydraulic_char_data_count}"
                )

            if missing_fk_hydraulic_char_data_count == 0:
                logger.info(
                    f"OK: all mandatory fk_hydraulic_char_data set in tww_od.{notsubclass}!"
                )
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_hydraulic_char_data in tww_od.{notsubclass}: {missing_fk_hydraulic_char_data_count}"
                    f"ERROR: {missing_fk_hydraulic_char_data_count} missing mandatory fk_hydraulic_char_data in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_building_group_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_building_group is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing building_group references fk_building_group...")

            cursor = connection.cursor()

            missing_fk_building_group_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                # VSA-DSS
                ("building_group_baugwr"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_building_group is null or fk_building_group ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_building_group_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_building_group : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_building_group : {class_fk_building_group_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_building_group_count == 0:
                    missing_fk_building_group_count = missing_fk_building_group_count
                else:
                    # missing_fk_building_group_count = missing_fk_building_group_count + int(cursor.fetchone()[0])
                    missing_fk_building_group_count = (
                        missing_fk_building_group_count + class_fk_building_group_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_building_group_count : {missing_fk_building_group_count}"
                )

            if missing_fk_building_group_count == 0:
                logger.info(f"OK: all mandatory fk_building_group set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_building_group in tww_od.{notsubclass}: {missing_fk_building_group_count}"
                    f"ERROR: {missing_fk_building_group_count} missing mandatory fk_building_group in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_reach_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_reach is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing reach references fk_reach...")

            cursor = connection.cursor()

            missing_fk_reach_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                ("reach_progression_alternative"),
                # VSA-DSS
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_reach is null or fk_reach ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_reach_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_reach : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_reach : {class_fk_reach_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_reach_count == 0:
                    missing_fk_reach_count = missing_fk_reach_count
                else:
                    # missing_fk_reach_count = missing_fk_reach_count + int(cursor.fetchone()[0])
                    missing_fk_reach_count = missing_fk_reach_count + class_fk_reach_count

                # add for testing
                logger.debug(f"missing_fk_reach_count : {missing_fk_reach_count}")

            if missing_fk_reach_count == 0:
                logger.info(f"OK: all mandatory fk_reach set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_reach in tww_od.{notsubclass}: {missing_fk_reach_count}"
                    f"ERROR: {missing_fk_reach_count} missing mandatory fk_reach in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_reach_point_from_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_reach_point_from is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info(
                "INTEGRITY CHECK missing reach_point_from references fk_reach_point_from..."
            )

            cursor = connection.cursor()

            missing_fk_reach_point_from_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                ("reach"),
                # VSA-DSS
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_reach_point_from is null or fk_reach_point_from ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_reach_point_from_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_reach_point_from : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_reach_point_from : {class_fk_reach_point_from_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_reach_point_from_count == 0:
                    missing_fk_reach_point_from_count = missing_fk_reach_point_from_count
                else:
                    # missing_fk_reach_point_from_count = missing_fk_reach_point_from_count + int(cursor.fetchone()[0])
                    missing_fk_reach_point_from_count = (
                        missing_fk_reach_point_from_count + class_fk_reach_point_from_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_reach_point_from_count : {missing_fk_reach_point_from_count}"
                )

            if missing_fk_reach_point_from_count == 0:
                logger.info(f"OK: all mandatory fk_reach_point_from set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_reach_point_from in tww_od.{notsubclass}: {missing_fk_reach_point_from_count}"
                    f"ERROR: {missing_fk_reach_point_from_count} missing mandatory fk_reach_point_from in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_reach_point_to_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_reach_point_to is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing reach_point_to references fk_reach_point_to...")

            cursor = connection.cursor()

            missing_fk_reach_point_to_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                ("reach"),
                # VSA-DSS
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_reach_point_to is null or fk_reach_point_to ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_reach_point_to_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_reach_point_to : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_reach_point_to : {class_fk_reach_point_to_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_reach_point_to_count == 0:
                    missing_fk_reach_point_to_count = missing_fk_reach_point_to_count
                else:
                    # missing_fk_reach_point_to_count = missing_fk_reach_point_to_count + int(cursor.fetchone()[0])
                    missing_fk_reach_point_to_count = (
                        missing_fk_reach_point_to_count + class_fk_reach_point_to_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_reach_point_to_count : {missing_fk_reach_point_to_count}"
                )

            if missing_fk_reach_point_to_count == 0:
                logger.info(f"OK: all mandatory fk_reach_point_to set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_reach_point_to in tww_od.{notsubclass}: {missing_fk_reach_point_to_count}"
                    f"ERROR: {missing_fk_reach_point_to_count} missing mandatory fk_reach_point_to in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_pwwf_wastewater_node_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_pwwf_wastewater_node is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info(
                "INTEGRITY CHECK missing pwwf_wastewater_node references fk_pwwf_wastewater_node..."
            )

            cursor = connection.cursor()

            missing_fk_pwwf_wastewater_node_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                # VSA-DSS
                ("log_card"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_pwwf_wastewater_node is null or fk_pwwf_wastewater_node ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_pwwf_wastewater_node_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_pwwf_wastewater_node : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_pwwf_wastewater_node : {class_fk_pwwf_wastewater_node_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_pwwf_wastewater_node_count == 0:
                    missing_fk_pwwf_wastewater_node_count = missing_fk_pwwf_wastewater_node_count
                else:
                    # missing_fk_pwwf_wastewater_node_count = missing_fk_pwwf_wastewater_node_count + int(cursor.fetchone()[0])
                    missing_fk_pwwf_wastewater_node_count = (
                        missing_fk_pwwf_wastewater_node_count + class_fk_pwwf_wastewater_node_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_pwwf_wastewater_node_count : {missing_fk_pwwf_wastewater_node_count}"
                )

            if missing_fk_pwwf_wastewater_node_count == 0:
                logger.info(
                    f"OK: all mandatory fk_pwwf_wastewater_node set in tww_od.{notsubclass}!"
                )
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_pwwf_wastewater_node in tww_od.{notsubclass}: {missing_fk_pwwf_wastewater_node_count}"
                    f"ERROR: {missing_fk_pwwf_wastewater_node_count} missing mandatory fk_pwwf_wastewater_node in tww_od classes"
                )
                # Return statement added
                return True

    def _check_fk_catchment_area_null(self, limit_to_selection=False):
        """
        Check if MANDATORY fk_catchment_area is Null
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK missing catchment_area references fk_catchment_area...")

            cursor = connection.cursor()

            missing_fk_catchment_area_count = 0
            # add MANDATORY classes to be checked
            for notsubclass in [
                # VSA-KEK
                # SIA405 Abwasser
                # VSA-DSS
                ("surface_runoff_parameters"),
            ]:
                cursor.execute(
                    f"SELECT COUNT(obj_id) FROM tww_od.{notsubclass} WHERE fk_catchment_area is null or fk_catchment_area ='';"
                )
                # use cursor.fetchone()[0] instead of cursor.rowcount
                # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/
                class_fk_catchment_area_count = int(cursor.fetchone()[0])
                # logger.info(
                #    f"Number of datasets in class '{notsubclass}' without fk_catchment_area : {cursor.fetchone()[0]}"
                # )
                logger.info(
                    f"Number of datasets in class '{notsubclass}' without fk_catchment_area : {class_fk_catchment_area_count}"
                )

                # if cursor.fetchone() is None:
                if class_fk_catchment_area_count == 0:
                    missing_fk_catchment_area_count = missing_fk_catchment_area_count
                else:
                    # missing_fk_catchment_area_count = missing_fk_catchment_area_count + int(cursor.fetchone()[0])
                    missing_fk_catchment_area_count = (
                        missing_fk_catchment_area_count + class_fk_catchment_area_count
                    )

                # add for testing
                logger.debug(
                    f"missing_fk_catchment_area_count : {missing_fk_catchment_area_count}"
                )

            if missing_fk_catchment_area_count == 0:
                logger.info(f"OK: all mandatory fk_catchment_area set in tww_od.{notsubclass}!")
                # Return statement added
                return False
            else:
                logger.error(
                    # f"ERROR: Missing mandatory fk_catchment_area in tww_od.{notsubclass}: {missing_fk_catchment_area_count}"
                    f"ERROR: {missing_fk_catchment_area_count} missing mandatory fk_catchment_area in tww_od classes"
                )
                # Return statement added
                return True

    def _check_organisation_tww_local_extension_count(self, limit_to_selection=False):
        """
        Check if there are organisations with tww_local_extension set
        """
        with DatabaseUtils.PsycopgConnection() as connection:
            logger.info("-----")
            logger.info("INTEGRITY CHECK organisation.tww_local_extension = true...")

            cursor = connection.cursor()

            organisation_tww_local_extension_count = 0
            cursor.execute(
                "SELECT COUNT(obj_id) as _count, array_agg(obj_id) as _obj_ids FROM tww_od.organisation WHERE organisation.tww_local_extension = true;"
            )

            # use cursor.fetchone()[0] instead of cursor.rowcount
            # add variable and store result of cursor.fetchone()[0] as the next call will give None value instead of count https://pynative.com/python-cursor-fetchall-fetchmany-fetchone-to-read-rows-from-table/

            try:
                result = cursor.fetchone()
                organisation_tww_local_extension_count = int(result[0])  # _count
                # obj_ids_tww_local_extension_count = result[1]
            except Exception:
                organisation_tww_local_extension_count = 0
                logger.debug(
                    "Number of datasets in class organisation with tww_local_extension = true could not be identified (TypeError: 'NoneType' object is not subscriptable). Automatically set organisation_twww_local_extension_count = 0"
                )
            else:
                logger.info(
                    f"Number of datasets in class organisation with tww_local_extension = true : {organisation_tww_local_extension_count}"
                )

            if organisation_tww_local_extension_count != 0:
                return False
            else:
                return True

    def _init_model_classes(self, model):
        ModelInterlis = None
        if model == config.MODEL_NAME_AG96:
            ModelInterlis = ModelInterlisAG96
        elif model == config.MODEL_NAME_AG64:
            ModelInterlis = ModelInterlisAG64
        elif model == config.MODEL_NAME_SIA405_BASE_ABWASSER:
            ModelInterlis = ModelInterlisSia405BaseAbwasser
        elif model == config.MODEL_NAME_SIA405_ABWASSER:
            ModelInterlis = ModelInterlisSia405Abwasser
        elif model == config.MODEL_NAME_DSS:
            ModelInterlis = ModelInterlisDss
        elif model == config.MODEL_NAME_VSA_KEK:
            ModelInterlis = ModelInterlisVsaKek
        self.model_classes_interlis = ModelInterlis().classes()
        self._progress_done(self.current_progress + 1)

        if self.model_classes_tww_od is None:
            self.model_classes_tww_od = ModelTwwOd().classes()
            self._progress_done(self.current_progress + 1)

        if self.model_classes_tww_vl is None:
            self.model_classes_tww_vl = ModelTwwVl().classes()
            self._progress_done(self.current_progress + 1)

        if self.model_classes_tww_sys is None:
            self.model_classes_tww_sys = ModelTwwSys().classes()
            self._progress_done(self.current_progress + 1)

        if (
            model == config.MODEL_NAME_AG96 or model == config.MODEL_NAME_AG64
        ) and self.model_classes_tww_app is None:
            self.model_classes_tww_app = ModelTwwAG6496().classes()
            self._progress_done(self.current_progress + 1)

    def _progress_done_intermediate_schema(self):
        self._progress_done(self.current_progress + 0.5)

    def _progress_done(self, progress, text=None):
        self.current_progress = progress
        if self.progress_done_callback:
            self.progress_done_callback(int(progress), text)
