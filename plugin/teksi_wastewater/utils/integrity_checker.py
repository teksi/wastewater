import logging
from typing import Any

from ..interlis import config, model_config
from .database_utils import DatabaseUtils
from .issues import CheckResult, Issue, IssueLevel


class TWWIntegrityChecker:
    def __init__(self, models=[], limit_to_selection=False, logger=None):
        self.limit_to_selection = limit_to_selection
        self.models = models
        self.check_result = CheckResult()
        self.logger = logger or logging.getLogger(__name__)

    def add_issue(
        self,
        message: str,
        level: IssueLevel = IssueLevel.WARNING,
    ):
        self.check_result.add(message, level)

        if level == IssueLevel.ERROR:
            self.logger.error(message)
        elif level == IssueLevel.INFO:
            self.logger.info(message)
        elif level == IssueLevel.DEBUG:
            self.logger.debug(message)
        elif level == IssueLevel.WARNING:
            self.logger.warning(message)
        else:
            raise ValueError("Could not map issue level {level} to IssueLevel entries")  
        
    def run_integrity_checks(self, raise_err: bool = False) -> list[Issue]:
        checks = [
            ("class_counts", self._check_class_counts),
            ("subclass_counts", self._check_subclass_counts),
            ("identifier_null", self._check_identifier_null),
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

        for check_name, check_func in checks:
            failed, error_message, _ = check_func()
            if failed:
                self.add_issue(
                    f"{check_name}: {error_message}",
                    IssueLevel.ERROR,
                )
                # logger.debug(f"check_subclass_counts_failed: {check_subclass_counts_failed} last")
                if raise_err:
                    from ..interlis.utils.various import InterlisImporterExporterError

                    raise InterlisImporterExporterError(
                        f"Error on Check {check_name}: ", error_message, None
                    )

        return self.check_result

    def get_validity_check_issues(self, include_ili: bool = False, logger=None) -> list[Issue]:
        messages = []
        messages = DatabaseUtils.check_oid_prefix()
        messages.extend(DatabaseUtils.check_fk_defaults())

        if not DatabaseUtils.check_symbology_triggers_enabled():
            messages.extend(
                Issue(
                    "Symbology triggers are disabled",
                    IssueLevel.ERROR,
                )
            )

        if include_ili:

            self.run_integrity_checks()
            messages.extend(self.check_result.issues)

        return messages

    @property
    def failed(self) -> bool:
        return any(i.level == IssueLevel.ERROR for i in self.check_result.issues)

    @property
    def failed_checks(self) -> list:
        return [i for i in self.check_result.issues if i.level == IssueLevel.ERROR]

    @property
    def stats(self):
        return {
            "failed": len(self.failed_checks),
            "total": len(self.check_result.issues),
        }

    def _check_class_counts(self) -> tuple[bool, str, int]:
        """
        Log the number of rows in every base table in the TWW object-data schema.

        This is a diagnostic check. Empty classes are valid and therefore do not
        make the integrity check fail.
        """
        schema_name = config.TWW_OD_SCHEMA

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()

            cursor.execute(
                """
                SELECT table_name
                FROM information_schema.tables
                WHERE table_schema = %s
                  AND table_type = 'BASE TABLE'
                ORDER BY table_name;
                """,
                (schema_name,),
            )

            table_names = [row[0] for row in cursor.fetchall()]

            nonempty_class_count = 0
            empty_class_count = 0
            total_object_count = 0

            for table_name in table_names:
                query = DatabaseUtils.compose_sql(
                    """
                    SELECT COUNT(*)
                    FROM {schema_name}.{table_name}
                    """,
                    schema_name=DatabaseUtils.wrap_identifier(
                        schema_name,
                    ),
                    table_name=DatabaseUtils.wrap_identifier(
                        table_name,
                    ),
                )

                cursor.execute(query)
                result = cursor.fetchone()
                object_count = int(result[0]) if result else 0

                total_object_count += object_count

                if object_count:
                    nonempty_class_count += 1
                else:
                    empty_class_count += 1

                self.add_issue(
                    f"Number of {table_name} datasets: {object_count}",
                    level=IssueLevel.INFO,
                )

        self.add_issue(
            (
                f"CLASS COUNT SUMMARY for schema {schema_name}: "
                f"{len(table_names)} tables, "
                f"{nonempty_class_count} nonempty, "
                f"{empty_class_count} empty, "
                f"{total_object_count} total rows."
            ),
            level=IssueLevel.INFO,
        )

        return False, "", 0

    def _check_subclass_counts(self):
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
        ]
        if model_config.interlis_models["vsa_kek"].names.intersection(self.models):
            checks.extend(
                [
                    (
                        "maintenance_event",
                        ["maintenance", "examination", "bio_ecol_assessment"],
                    ),
                    (
                        "damage",
                        ["damage_channel", "damage_manhole"],
                    ),
                ]
            )
        if model_config.interlis_models["dss"].names.intersection(self.models):
            checks.extend(
                [
                    ("overflow", ["pump", "leapingweir", "prank_weir"]),
                    (
                        "connection_object",
                        ["fountain", "individual_surface", "building", "reservoir"],
                    ),
                    (
                        "zone",
                        ["infiltration_zone", "drainage_system"],
                    ),
                ]
            )

        for parent, children in checks:
            check_failed, msg, count = self._check_subclass_count(
                config.TWW_OD_SCHEMA, parent, children
            )
            failed = failed or check_failed
            if msg:
                error_messages.append(msg)
            total_issue_count += count
        error_message = "; ".join(error_messages) if error_messages else ""

        return (failed, error_message, total_issue_count)

    def _check_subclass_count(self, schema_name, parent_name, child_list) -> tuple[bool, str, int]:
        """
        Returns: (failed, error message, parent_count)
        """
        errormsg = ""
        self.add_issue(f"INTEGRITY CHECK {parent_name} subclass data...", level="info")
        self.add_issue("CONNECTING TO DATABASE...", level="info")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()
            cursor.execute(f"SELECT obj_id FROM {schema_name}.{parent_name};")
            parent_rows = cursor.fetchall()
            parent_ids = {row[0] for row in parent_rows}
            self.add_issue(f"Number of {parent_name} datasets: {len(parent_ids)}", level="debug")

            missing_in_subclass = set(parent_ids)
            missing_in_superclass = {}  # Maps subclass name to orphaned IDs

            for child_name in child_list:
                cursor.execute(f"SELECT obj_id FROM {schema_name}.{child_name};")
                child_rows = cursor.fetchall()
                child_ids = {row[0] for row in child_rows}
                self.add_issue(
                    f"Number of {child_name} datasets: {len(child_rows)}", level="debug"
                )

                missing_in_subclass -= child_ids

                orphaned = child_ids - parent_ids
                if orphaned:
                    missing_in_superclass[child_name] = orphaned

            if missing_in_subclass:
                errormsg += (
                    f"Missing subclass entries for {len(missing_in_subclass)} "
                    f"{schema_name}.{parent_name} objects (IDs: {sorted(missing_in_subclass)})\n"
                )
            if missing_in_superclass:
                for child_name, orphaned_ids in missing_in_superclass.items():
                    errormsg += (
                        f"Missing superclass entries for {len(orphaned_ids)} objects in {schema_name}.{child_name} "
                        f"(IDs: {sorted(orphaned_ids)})\n"
                    )

            if missing_in_subclass or missing_in_superclass:
                if self.limit_to_selection:
                    self.add_issue(
                        f"Overall Subclass Count: {errormsg}. The problem might lie outside the selection"
                    )
                else:
                    self.add_issue(f"Subclass Count error: {errormsg}", level="error")
                # Return statement added
                return (True, errormsg, len(missing_in_subclass) + len(missing_in_superclass))
            else:
                self.add_issue(
                    f"OK: number of subclass elements of class {parent_name} OK in schema {schema_name}!",
                    level="info",
                )
                # Return statement added
                return (False, errormsg, len(missing_in_subclass) + len(missing_in_superclass))

    def _check_conditions(
        self,
        check_classes: list[str],
        value_name: str,
        check_val: Any = None,
        check_null: bool = True,
        check_true: bool = False,
    ) -> dict[str, tuple[int, list[Any]]]:
        """
        Returns a dict of {class_name: (count, [obj_ids])} for missing values.
        """
        check_str = check_val is not None
        if not any((check_str, check_null, check_true)):
            raise ValueError("No conditions specified for check_conditions")

        with DatabaseUtils.PsycopgConnection() as connection:
            cursor = connection.cursor()
            column_identifier = DatabaseUtils.wrap_identifier(value_name)
            condition_parts = []
            params = []
            if check_str:

                condition_parts.append(
                    DatabaseUtils.compose_sql(
                        "{column_name} = %s",
                        column_name=column_identifier,
                    )
                )
                params.append(check_val)
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
                cursor.execute(query, params or None)
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
        check_null: bool = True,
        check_true: bool = False,
    ) -> tuple[bool, str, int]:
        """
        Check that each class has at least one row matching the export condition.

        Returns:
            (failed, error_message, empty_class_count)
        """
        results = self._check_conditions(
            check_classes=check_classes,
            value_name=value_name,
            check_val=check_val,
            check_null=check_null,
            check_true=check_true,
        )

        empty_classes = tuple(
            class_name
            for class_name, (matching_count, _) in results.items()
            if matching_count == 0
        )

        if empty_classes:
            error_message = (
                f"No exportable rows matching {value_name!r} were "
                f"found in {len(empty_classes)} of "
                f"{len(results)} checked tables: "
                f"{', '.join(f'tww_od.{name}' for name in empty_classes)}."
            )

            return True, error_message, len(empty_classes)

        self.add_issue(
            (
                f"Export availability check passed for {value_name!r}: "
                f"{len(results)} tables checked."
            ),
            level=IssueLevel.INFO,
        )

        return False, "", 0

    def _check_value_condition(
        self,
        check_classes: list[str],
        value_name: str,
        check_val: Any = None,
    ) -> tuple[bool, str, int]:
        """
        Check mandatory values across the supplied classes.

        A value is considered missing when it is NULL or equals check_val.
        Returns (failed, error_message, missing_row_count).
        """
        results = self._check_conditions(
            check_classes=check_classes,
            value_name=value_name,
            check_val=check_val,
        )

        missing_by_class = {
            class_name: (
                missing_count,
                tuple(obj_ids or ()),
            )
            for class_name, (
                missing_count,
                obj_ids,
            ) in results.items()
            if missing_count > 0
        }

        missing_count = sum(
            class_missing_count for class_missing_count, _ in missing_by_class.values()
        )

        if not missing_count:
            self.add_issue(
                (
                    f"Mandatory-value check passed for {value_name!r}: "
                    f"{len(results)} tables checked."
                ),
                level=IssueLevel.INFO,
            )
            return False, "", 0

        details = []

        for (
            class_name,
            (
                class_missing_count,
                object_ids,
            ),
        ) in missing_by_class.items():
            displayed_ids = tuple(str(object_id) for object_id in object_ids[:20])
            hidden_count = max(
                0,
                len(object_ids) - len(displayed_ids),
            )

            ids_text = ", ".join(
                displayed_ids,
            )

            if hidden_count:
                ids_text += f", ... and {hidden_count} more"

            details.append(
                f"tww_od.{class_name}: "
                f"{class_missing_count} missing" + (f" ({ids_text})" if ids_text else "")
            )

        error_message = (
            f"Missing {value_name!r} in {missing_count} rows "
            f"across {len(missing_by_class)} of "
            f"{len(results)} checked tables: " + "; ".join(details) + "."
        )

        if self.limit_to_selection:
            error_message += (
                " A selection is active, so affected objects may "
                "partly lie outside the selected export."
            )

        return True, error_message, missing_count

    def _check_identifier_null(self):
        """
        Check if attribute identifier is Null or ''
        """
        check_classes = [
            ("organisation"),
        ]
        if model_config.interlis_models["vsa_kek"].names.intersection(self.models):
            check_classes.extend(
                [
                    # VSA-KEK
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )
        if model_config.interlis_models["sia405_abwasser"].names.intersection(self.models):
            check_classes.extend(
                [
                    ("wastewater_structure"),
                    ("wastewater_networkelement"),
                    ("structure_part"),
                    ("reach_point"),
                    ("pipe_profile"),
                ]
            )
        if model_config.interlis_models["dss"].names.intersection(self.models):
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
        if model_config.interlis_models["ag64"].names.intersection(
            self.models
        ) and not model_config.interlis_models["sia405_abwasser"].names.intersection(self.models):
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        if model_config.interlis_models["ag96"].names.intersection(
            self.models
        ) and not model_config.interlis_models["dss"].names.intersection(self.models):
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
        return self._check_value_condition(check_classes, "identifier", "")

    def _check_fk_owner_null(self):
        """
        Check if MANDATORY fk_owner is Null
        """
        check_classes = []
        check_models = (
            model_config.interlis_models["sia405_abwasser"]
            .names.union(model_config.interlis_models["ag64"].names)
            .union(model_config.interlis_models["ag96"].names)
        )
        if any(m in check_models for m in self.models):
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
        check_models = (
            model_config.interlis_models["sia405_abwasser"]
            .names.union(model_config.interlis_models["ag64"].names)
            .union(model_config.interlis_models["ag96"].names)
        )
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["vsa_kek"].names
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    ("damage"),
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )

        check_models = model_config.interlis_models["sia405_abwasser"].names.union(
            model_config.interlis_models["dss"].names
        )
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    ("wastewater_structure"),
                    ("wastewater_networkelement"),
                    ("structure_part"),
                    ("reach_point"),
                    ("pipe_profile"),
                ]
            )
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["ag64"].names
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        check_models = model_config.interlis_models["ag96"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["vsa_kek"].names
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    # VSA-KEK
                    ("damage"),
                    ("data_media"),
                    ("file"),
                    ("maintenance_event"),
                ]
            )
        check_models = model_config.interlis_models["sia405_abwasser"].names.union(
            model_config.interlis_models["dss"].names
        )
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["sia405_cable"].names
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    # sia405cc
                    ("sia405cc_cable"),
                    ("sia405cc_cable_point"),
                ]
            )
        check_models = model_config.interlis_models["sia405_protection_tube"].names
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    ("sia405pt_protection_tube"),
                ]
            )
        check_models = model_config.interlis_models["ag64"].names
        if any(m in check_models for m in self.models):
            check_classes.extend(
                [
                    ("wastewater_networkelement"),
                    ("overflow"),
                ]
            )
        check_models = model_config.interlis_models["ag96"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["sia405_abwasser"].names.union(
            model_config.interlis_models["dss"].names
        )
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["sia405_abwasser"].names.union(
            model_config.interlis_models["dss"].names
        )
        if any(m in check_models for m in self.models):
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
        check_models = (
            model_config.interlis_models["sia405_abwasser"]
            .names.union(model_config.interlis_models["ag64"].names)
            .union(model_config.interlis_models["ag96"].names)
        )
        if any(m in check_models for m in self.models):
            check_classes = [
                ("reach"),
            ]
        return self._check_value_condition(check_classes, "fk_reach_point_from")

    def _check_fk_reach_point_to_null(self):
        """
        Check if MANDATORY fk_reach_point_to is Null
        """
        check_classes = []
        check_models = (
            model_config.interlis_models["sia405_abwasser"]
            .names.union(model_config.interlis_models["ag64"].names)
            .union(model_config.interlis_models["ag96"].names)
        )
        if any(m in check_models for m in self.models):
            check_classes = [
                ("reach"),
            ]
        return self._check_value_condition(check_classes, "fk_reach_point_to")

    def _check_fk_pwwf_wastewater_node_null(self):
        """
        Check if MANDATORY fk_pwwf_wastewater_node is Null
        """
        check_classes = []
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
        check_models = model_config.interlis_models["dss"].names
        if any(m in check_models for m in self.models):
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
            check_val=None,
            check_null=False,
            check_true=True,
        )
