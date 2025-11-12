from typing import Any

from ...utils.database_utils import DatabaseUtils
from .. import config
from .various import logger, InterlisImporterExporterError


class TWWExportChecker:
    def __init__(self, export_models=None, limit_to_selection=False):
        self.limit_to_selection = limit_to_selection
        self.export_models = export_models

    def run_integrity_checks(self):
        checks = [
            ("subclass_counts", self._check_subclass_counts),
            ("identifier_null", self._check_identifier_null),
            ("check_identifier_null", self._check_identifier_null),
            ("fk_owner_null", self._check_fk_owner_null),
            ("fk_operator_null", self._check_fk_operator_null),
            ("fk_dataowner_null", self._check_fk_dataowner_null),
            ("fk_provider_null", self._check_fk_provider_null),
            ("fk_wastewater_structure_null", self._check_fk_wastewater_structure_null),
            ("fk_wastewater_node_null", self._check_fk_wastewater_node_null),
            ("fk_responsible_entity_null", self._check_fk_responsible_entity_null),
            ("fk_responsible_start_null", self._check_fk_responsible_start_null),
            ("fk_discharge_point_null", self._check_fk_discharge_point_null),
            ("fk_hydraulic_char_data_null", self._check_fk_hydraulic_char_data_null),
            ("building_group_null", self._check_fk_building_group_null),
            ("fk_reach_null", self._check_fk_reach_null),
            ("fk_reach_point_from_null", self._check_fk_reach_point_from_null),
            ("fk_reach_point_to_null", self._check_fk_reach_point_to_null),
            ("fk_pwwf_wastewater_node_null", self._check_fk_pwwf_wastewater_node_null),
            ("fk_catchment_area_null", self._check_fk_catchment_area_null),
            # Add other checks here
        ]
        number_tests_failed = 0
        number_tests_ok = 0
        failed_check_list = []

        for check_name, check_func in checks:
            failed, error_message, _ = check_func()
            if failed:
                number_tests_failed += 1
                failed_check_list.append(f"{check_name}: {error_message}")
            else:
                number_tests_ok += 1

        return {
            "failed": number_tests_failed > 0,
            "failed_checks": "\n".join(failed_check_list),
            "stats": {"failed": number_tests_failed, "ok": number_tests_ok},
        }

    def _check_subclass_counts(self, raise_err=False):
        failed = False
        error_messages = []
        total_issue_count = 0

        # List of all checks to perform
        checks = [
            ("wastewater_networkelement", ["reach", "wastewater_node"]),
            (
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
            ),
            (
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
            ),
            ("overflow", ["pump", "leapingweir", "prank_weir"]),
            (
                "maintenance_event",
                ["maintenance", "examination", "bio_ecol_assessment"],
            ),
            (
                "damage",
                ["damage_channel", "damage_manhole"],
            ),
            (
                "connection_object",
                ["fountain", "individual_surface", "building", "reservoir"],
            ),
            (
                "zone",
                ["infiltration_zone", "drainage_system"],
            ),
        ]

        for parent, children in checks:
            check_failed, msg, count = self._check_subclass_count(
                config.TWW_OD_SCHEMA, parent, children
            )
            failed = failed or check_failed
            if msg:
                error_messages.append(msg)
            total_issue_count += count
        error_message = "; ".join(error_messages) if error_messages else ""
        # logger.debug(f"check_subclass_counts_failed: {check_subclass_counts_failed} last")
        if raise_err and failed:
            raise InterlisImporterExporterError("Subclass Count error", error_message, None)
        return (failed, error_message, total_issue_count)

    def _check_subclass_count(self, schema_name, parent_name, child_list) -> tuple[bool, str, int]:
        """
        Returns: (failed, error message, parent_count)
        """
        errormsg = ""
        logger.info(f"INTEGRITY CHECK {parent_name} subclass data...")
        logger.info("CONNECTING TO DATABASE...")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            cursor.execute(f"SELECT obj_id FROM {schema_name}.{parent_name};")

            parent_rows = cursor.fetchall()
            parent_count = len(parent_rows)
            logger.info(f"Number of {parent_name} datasets: {parent_count}")
            for child_name in child_list:
                cursor.execute(f"SELECT obj_id FROM {schema_name}.{child_name};")
                child_rows = cursor.fetchall()
                logger.info(f"Number of {child_name} datasets: {len(child_rows)}")
                parent_count = parent_count - len(child_rows)

            if parent_count != 0:
                if parent_count > 0:
                    errormsg += f"Too many superclass entries for {schema_name}.{parent_name}"
                else:
                    errormsg += f"Too many subclass entries for {schema_name}.{parent_name}"

                if self.limit_to_selection:
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
                return (True, errormsg, parent_count)
            else:
                logger.info(
                    f"OK: number of subclass elements of class {parent_name} OK in schema {schema_name}!"
                )
                # Return statement added
                return (False, errormsg, parent_count)

    def _check_conditions(
        self,
        check_classes: list[str],
        value_name: str,
        check_val: Any = None,
        check_str: bool = True,
        check_null: bool = True,
        check_true: bool = False,
    ) -> dict[str, tuple[int, list[Any]]]:
        """
        Returns a dict of {class_name: (count, [obj_ids])} for missing values.
        """
        if not check_val:
            check_val = ""
        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()
            column_identifier = DatabaseUtils.wrap_identifier(value_name)
            condition_parts = []
            if check_str:
                condition_parts.append(
                    DatabaseUtils.compose_sql(
                        "{column_name} = %s",
                        column_name=column_identifier,
                    )
                )
            if check_null:
                condition_parts.append(
                    DatabaseUtils.compose_sql(
                        "{column_name} IS NULL",
                        column_name=column_identifier,
                    )
                )
            if check_true:
                condition_parts.append(
                    DatabaseUtils.compose_sql(
                        "{column_name} IS True",
                        column_name=column_identifier,
                    )
                )
            condition = DatabaseUtils.compose_sql(
                "(" + " OR ".join(["{}"] * len(condition_parts)) + ")", *condition_parts
            )
            results = {}
            for _class in check_classes:
                query = DatabaseUtils.compose_sql(
                    """
                    SELECT COUNT(obj_id) as _count, array_agg(obj_id) as _obj_ids
                    FROM tww_od.{table_name}
                    WHERE {condition}
                    """,
                    table_name=DatabaseUtils.wrap_identifier(_class),
                    condition=condition,
                )
                cursor.execute(query, (check_val,))
                result = cursor.fetchone()
                class_count = int(result[0]) if result else 0
                obj_ids_without_val = result[1] if result else []
                results[_class] = (class_count, obj_ids_without_val)
            return results

    def _check_available_export_values(
        self,
        check_classes: list[str],
        value_name: str,
        check_val: Any = None,
        check_str: bool = True,
        check_null: bool = True,
        check_true: bool = False,
    ) -> tuple[bool, str, int]:
        """
        Check if attribute value_name fulfils condition.
        check_classes: List of class names that are to be checked
        value_name: name of the value to be checked
        check_null: bool whether to check for IS NULL
        check_val: value to be checked. Defaults to ''
        Returns: (failed, error_message, issue_count)
        """
        results = self._check_conditions(
            check_classes, value_name, check_val, check_str, check_null, check_true
        )
        error_message = ""
        empty_class_count = 0
        for _class, (class_count, _) in results.items():
            logger.info(
                f"table name: {_class}, value name: {value_name}, class count: {class_count}"
            )
            if class_count == 0:
                error_message += (
                    f"No exportable entries found in table tww_od.{_class} on {value_name} check"
                )
                empty_class_count += 1
        if empty_class_count > 0:
            return (True, error_message, empty_class_count)
        else:
            logger.info("OK: all {value_name} set!")
            return (False, "", 0)

    def _check_value_condition(
        self,
        check_classes: list[str],
        value_name: str,
        check_val: Any = None,
    ) -> tuple[bool, str, int]:
        """
        Check if attribute value_name fulfils condition.
        check_classes: List of class names that are to be checked
        value_name: name of the value to be checked
        check_null: bool whether to check for IS NULL
        check_val: value to be checked. Defaults to ''
        limit_to_selection: bool whether a selection limit is active
        Returns: (failed, error_message, issue_count)
        """
        results = self._check_conditions(
            check_classes=check_classes,
            value_name=value_name,
            check_val=check_val,
        )
        missing_count = 0
        error_message = ""
        for _class, (class_count, obj_ids_without_val) in results.items():
            logger.info(
                f"table name: {_class}, value name: {value_name}, class count: {class_count}"
            )
            if class_count > 0:
                error_message += (
                    f"{class_count} rows in class '{_class}' "
                    f"without {value_name}: {','.join(obj_ids_without_val)}\n"
                )
                missing_count += class_count
        if missing_count > 0:
            errormsg = f"Missing {value_name} in schema tww_od: {missing_count}"
            if self.limit_to_selection:
                logger.warning(
                    f"Overall Subclass Count: {errormsg}. The problem might lie outside the selection"
                )
            else:
                logger.error(f"INTEGRITY CHECK missing {value_name}: {errormsg}")
            return (True, error_message, missing_count)
        else:
            logger.info("OK: all {value_name} set!")
            return (False, "", 0)

    def _check_identifier_null(self):
        """
        Check if attribute identifier is Null
        """
        check_classes = [
            ("organisation"),
        ]
        if config.MODEL_NAME_VSA_KEK in self.export_models:
            check_classes.extend(
                [
                    # VSA-KEK
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )
        if config.MODEL_NAME_SIA405_ABWASSER in self.export_models:
            check_classes.extend(
                [
                    ("wastewater_structure"),
                    ("wastewater_networkelement"),
                    ("structure_part"),
                    ("reach_point"),
                    ("pipe_profile"),
                ]
            )
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    # VSA-DSS
                    # new 2020
                    ("building_group"),
                    ("catchment_area"),
                    ("catchment_area_totals"),
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
                ]
            )
        if config.MODEL_NAME_AG64 in self.export_models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        if config.MODEL_NAME_AG96 in self.export_models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                    ("building_group"),
                    ("catchment_area"),
                    ("measure"),
                    ("catchment_area_totals"),
                    ("zone"),
                ]
            )
        return self._check_value_condition(check_classes, "identifier")

    def _check_fk_owner_null(self):
        """
        Check if MANDATORY fk_owner is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_AG64,
            config.MODEL_NAME_AG96,
        }
        if any(m in check_models for m in self.export_models):
            check_classes = [
                # SIA405 Abwasser
                ("wastewater_structure"),
            ]
        return self._check_value_condition(check_classes, "fk_owner")

    def _check_fk_operator_null(self):
        """
        Check if MANDATORY fk_operator is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_AG64,
            config.MODEL_NAME_AG96,
        }
        if any(m in check_models for m in self.export_models):
            check_classes = [
                # SIA405 Abwasser
                ("wastewater_structure"),
            ]
        return self._check_value_condition(check_classes, "fk_operator")

    def _check_fk_dataowner_null(self):
        """
        Check if MANDATORY fk_dataowner is Null
        """
        check_classes = []
        if config.MODEL_NAME_VSA_KEK in self.export_models:
            check_classes.extend(
                [
                    ("damage"),
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )
        if config.MODEL_NAME_SIA405_ABWASSER in self.export_models:
            check_classes.extend(
                [
                    ("wastewater_structure"),
                    ("wastewater_networkelement"),
                    ("structure_part"),
                    ("reach_point"),
                    ("pipe_profile"),
                ]
            )
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
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
                ]
            )
        if config.MODEL_NAME_AG64 in self.export_models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        if config.MODEL_NAME_AG96 in self.export_models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                    ("building_group"),
                    ("catchment_area"),
                    ("measure"),
                    ("catchment_area_totals"),
                    ("zone"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_dataowner")

    def _check_fk_provider_null(self):
        """
        Check if MANDATORY fk_provider is Null
        """
        check_classes = []
        if config.MODEL_NAME_VSA_KEK in self.export_models:
            check_classes.extend(
                [
                    # VSA-KEK
                    ("damage"),
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )
        if config.MODEL_NAME_SIA405_ABWASSER in self.export_models:
            check_classes.extend(
                [
                    # take out for DSS 2020
                    # ("organisation"),
                    ("wastewater_structure"),
                    ("wastewater_networkelement"),
                    ("structure_part"),
                    ("reach_point"),
                    ("pipe_profile"),
                ]
            )
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
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
                ]
            )
        if config.MODEL_NAME_CABLE in self.export_models:
            check_classes.extend(
                [
                    # sia405cc
                    ("sia405cc_cable"),
                    ("sia405cc_cable_point"),
                ]
            )
        if config.MODEL_NAME_PROTECTION_TUBE in self.export_models:
            check_classes.extend(
                [
                    ("sia405pt_protection_tube"),
                ]
            )
        if config.MODEL_NAME_AG64 in self.export_models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        if config.MODEL_NAME_AG96 in self.export_models:
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                    ("building_group"),
                    ("catchment_area"),
                    ("measure"),
                    ("catchment_area_totals"),
                    ("zone"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_provider")

    def _check_fk_wastewater_structure_null(self):
        """
        Check if MANDATORY fk_wastewater_structure is Null
        """
        check_classes = []
        if config.MODEL_NAME_SIA405_ABWASSER in self.export_models:
            check_classes.extend(
                [
                    ("structure_part"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_wastewater_structure")

    def _check_fk_wastewater_node_null(self):
        """
        Check if MANDATORY fk_wastewater_node is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    ("hydraulic_char_data"),
                    ("overflow"),
                    ("throttle_shut_off_unit"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_wastewater_node")

    def _check_fk_responsible_entity_null(self):
        """
        Check if MANDATORY fk_responsible_entity is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    ("measure"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_responsible_entity")

    def _check_fk_responsible_start_null(self):
        """
        Check if MANDATORY fk_responsible_start is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    ("measure"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_responsible_start")

    def _check_fk_discharge_point_null(self):
        """
        Check if MANDATORY fk_discharge_point is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    ("catchment_area_totals"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_discharge_point")

    def _check_fk_hydraulic_char_data_null(self):
        """
        Check if MANDATORY fk_hydraulic_char_data is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    ("catchment_area_totals"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_hydraulic_char_data")

    def _check_fk_building_group_null(self):
        """
        Check if MANDATORY fk_building_group is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    ("building_group_baugwr"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_building_group")

    def _check_fk_reach_null(self):
        """
        Check if MANDATORY fk_reach is Null
        """
        check_classes = []
        if config.MODEL_NAME_SIA405_ABWASSER in self.export_models:
            check_classes.extend(
                [
                    ("reach_progression_alternative"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_reach")

    def _check_fk_reach_point_from_null(self):
        """
        Check if MANDATORY fk_reach_point_from is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_AG64,
            config.MODEL_NAME_AG96,
        }
        if any(m in check_models for m in self.export_models):
            check_classes = [
                ("reach"),
            ]
        return self._check_value_condition(check_classes, "fk_reach_point_from")

    def _check_fk_reach_point_to_null(self):
        """
        Check if MANDATORY fk_reach_point_to is Null
        """
        check_classes = []
        check_models = {
            config.MODEL_NAME_SIA405_ABWASSER,
            config.MODEL_NAME_AG64,
            config.MODEL_NAME_AG96,
        }
        if any(m in check_models for m in self.export_models):
            check_classes = [
                ("reach"),
            ]
        return self._check_value_condition(check_classes, "fk_reach_point_to")

    def _check_fk_pwwf_wastewater_node_null(self):
        """
        Check if MANDATORY fk_pwwf_wastewater_node is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    ("log_card"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_pwwf_wastewater_node")

    def _check_fk_catchment_area_null(self):
        """
        Check if MANDATORY fk_catchment_area is Null
        """
        check_classes = []
        if config.MODEL_NAME_DSS in self.export_models:
            check_classes.extend(
                [
                    ("surface_runoff_parameters"),
                ]
            )
        return self._check_value_condition(check_classes, "fk_catchment_area")

    def _check_organisation_tww_local_extension_count(self):
        """
        Check if there are organisations with tww_local_extension set
        """
        check_classes = [
            # VSA-KEK
            # SIA405 Abwasser
            # VSA-DSS
            ("organisation"),
        ]
        return self._check_available_export_values(
            check_classes,
            "tww_local_extension",
            check_null=False,
            check_str=False,
            check_true=True,
        )
