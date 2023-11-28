# -*- coding: utf-8 -*-
"""
/***************************************************************************
 QGEP-swmm processing provider
                              -------------------
        begin                : 07.2019
        copyright            : (C) 2019 by ig-group.ch
        email                : timothee.produit@ig-group.ch
 ***************************************************************************/

/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/
"""

import codecs
import subprocess
from datetime import datetime, timedelta

MEASURING_POINT_KIND = "Diverse kind of SWMM simulation parameters"
MEASURING_DEVICE_REMARK = "SWMM Simulation"

SWMM_SUMMARY_PARAMETERS = {}
SWMM_SUMMARY_PARAMETERS["average_depth"] = {
    "recorded": True,
    "dimension": "m",
    "qgep_measurement_type": 5734,
}
SWMM_SUMMARY_PARAMETERS["maximum_depth"] = {
    "recorded": True,
    "dimension": "m",
    "qgep_measurement_type": 5734,
}
SWMM_SUMMARY_PARAMETERS["maximum_hgl"] = {
    "recorded": True,
    "dimension": "m",
    "qgep_measurement_type": 5732,
}
SWMM_SUMMARY_PARAMETERS["reported_max_depth"] = {
    "recorded": True,
    "dimension": "m",
    "qgep_measurement_type": 5734,
}
SWMM_SUMMARY_PARAMETERS["maximum_flow"] = {
    "recorded": True,
    "dimension": "l/s",
    "qgep_measurement_type": 5733,
}
SWMM_SUMMARY_PARAMETERS["maximum_velocity"] = {
    "recorded": True,
    "dimension": "m/s",
    "qgep_measurement_type": 5732,
}
SWMM_SUMMARY_PARAMETERS["max_over_full_flow"] = {
    "recorded": True,
    "dimension": "-",
    "qgep_measurement_type": 5733,
}
SWMM_SUMMARY_PARAMETERS["max_over_full_depth"] = {
    "recorded": True,
    "dimension": "-",
    "qgep_measurement_type": 5734,
}

SWMM_RESULTS_PARAMETERS = {}
SWMM_RESULTS_PARAMETERS["flow"] = {
    "recorded": True,
    "dimension": "l/s",
    "qgep_measurement_type": 5733,
}
SWMM_RESULTS_PARAMETERS["velocity"] = {
    "recorded": True,
    "dimension": "m/s",
    "qgep_measurement_type": 5732,
}
SWMM_RESULTS_PARAMETERS["depth"] = {
    "recorded": True,
    "dimension": "m",
    "qgep_measurement_type": 5734,
}
SWMM_RESULTS_PARAMETERS["capacity"] = {
    "recorded": True,
    "dimension": "-",
    "qgep_measurement_type": 5732,
}
SWMM_RESULTS_PARAMETERS["inflow"] = {
    "recorded": True,
    "dimension": "l/s",
    "qgep_measurement_type": 5733,
}
SWMM_RESULTS_PARAMETERS["flooding"] = {
    "recorded": True,
    "dimension": "l/s",
    "qgep_measurement_type": 5733,
}
SWMM_RESULTS_PARAMETERS["head"] = {
    "recorded": True,
    "dimension": "m",
    "qgep_measurement_type": 5732,
}

NON_PHYSICAL_REM = "Non-physical point which materializes swmm simulations"

import psycopg2


class QgepSwmm:
    def __init__(
        self, title, service, state, inpfile, inptemplate, rptfile, binfile, feedback
    ):

        """
        Initiate QgepSwmm

        Parameters:
        title (string): Title of the simulation
        service (string): name of the service to be used to connect to the QGEP database
        state (string): state for which the network is extracted (current or planned)
        inpfile (path): path of the INP file (input file for swmm)
        inptemplate (path): path of the INP file which store simulations parameters
        rptfile (path): path of the OUT file which contains swmm results
        binfile (path): path of the swmm executable
        feedback (pyQGIS feedback)
        """
        self.title = title
        self.service = service
        self.input_file = inpfile
        self.options_template_file = inptemplate
        self.rpt_file = rptfile
        self.bin_file = binfile
        self.feedback = feedback
        self.state = state

    def __enter__(self):
        if self.service is not None:
            self.con = psycopg2.connect(service=self.service)
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.service is not None:
            del self.con

    def feedback_push(self, level, message):
        if self.feedback is not None and message != "" and message is not None:
            if level == "info":
                self.feedback.pushInfo(message)
            elif level == "warning":
                self.feedback.pushWarning(message)
            elif level == "error":
                self.feedback.reportError(message)
            else:
                self.feedback.pushInfo(message)
        return

    def feedback_set_progress(self, progress):
        if self.feedback is not None:
            self.feedback.setProgress(progress)
        return

    def get_swmm_table(self, table_name, state, selected_structures, hierarchy):
        """
        Extract data from the swmm views in the database

        Parameters:
        table_name (string): Name of the view or table
        state (string): current or planned
        selected_structures ([string]): List of obj_id of the selected structures

        Returns:
        dic: table content
        array: table attributes

        """

        # Connects to service and get data and attributes from tableName
        cur = self.con.cursor()

        # Configure the filters
        where_clauses = []
        if state == "planned":
            where_clauses.append("(state = 'planned' OR state = 'current')")
        elif state == "current":
            where_clauses.append("state = 'current'")
        if selected_structures:
            where_clauses.append(
                """
                obj_id in ('{ids}')
                """.format(
                    ids="','".join(selected_structures)
                )
            )
        if hierarchy:
            where_clauses.append(
                """hierarchy = '{hierarchy}'""".format(hierarchy=hierarchy)
            )

        sql = """
        select * from qgep_swmm.vw_{table_name}
        """.format(
            table_name=table_name
        )
        # Add the filters to the sql
        if len(where_clauses) > 0:
            sql = """
                {sql} where {where_clauses}
                """.format(
                sql=sql, where_clauses=" AND ".join(where_clauses)
            )
        try:
            cur.execute(sql)
        except psycopg2.ProgrammingError:
            self.feedback_push("error", "Error while executing: {sql}".format(sql=sql))
            return None, None
        self.feedback_push(
            "info", "Process vw_{table_name}".format(table_name=table_name)
        )
        data = cur.fetchall()
        attributes = [desc[0] for desc in cur.description]
        del cur

        return data, attributes

    def swmm_table(
        self, table_name, hierarchy=None, state=None, selected_structures=[]
    ):
        """
        Write swmm objects extracted from QGEP in swmm input file. Selects according
        to the state planned or current. If the object is a qgep wastewater structure
        when the state is "planned" both "planned" and "operational" wastewater structures are selected

        Parameters:
        table_name (string): Name of the swmm section
        state (string): current or planned
        selected_structre ([string]). List of obj_id of the selected wastewater structures
        ws (boolean): if the origin table is a wastewater structure

        Returns:
        String: table content

        """
        notPrintedFields = [
            "description",
            "tag",
            "geom",
            "state",
            "ws_obj_id",
            "hierarchy",
            "message",
        ]
        # Create commented line which contains the field names
        fields = ""
        data, attributes = self.get_swmm_table(
            table_name, state, selected_structures, hierarchy
        )
        if data is not None:
            for i, field in enumerate(attributes):
                # Does not write values stored in columns descriptions, tags and geom
                if field not in notPrintedFields:
                    fields += field + "\t"

            # Create input paragraph
            tbl = "[" + table_name + "]\n" ";;" + fields + "\n"
            for feature in data:
                for i, v in enumerate(feature):
                    # Write description
                    if attributes[i] == "description" and v is not None:
                        tbl += ";"
                        tbl += str(v)
                        tbl += "\n"

                for i, v in enumerate(feature):
                    # Does not write values stored in columns descriptions, tags and geom
                    if attributes[i] not in notPrintedFields:
                        if v is not None:
                            tbl += str(v) + "\t"
                        else:
                            tbl += "\t"
                    if attributes[i] == "message" and v != "":
                        self.feedback_push("warning", v)
                tbl += "\n"
            tbl += "\n"
            return tbl
        else:
            return "\n"

    def copy_parameters_from_template(self, parameter_name):
        """
        Write swmm objects extracted from template in swmm input file

        Parameters:
        parameter_name (string): Name of the swmm section to be copied

        Returns:
        String: section content

        """
        # Read template
        options_template = open(self.options_template_file, "r").read()
        # Find and extract options
        index_start = options_template.find(
            "[{parameter_name}]".format(parameter_name=parameter_name)
        )
        if index_start == -1:
            # The balise options is not found
            self.feedback_push(
                "info",
                "There is no {parameter_name} in the template file".format(
                    parameter_name=parameter_name
                ),
            )
            return ""
        else:
            # Search for the next opening bracket
            index_stop = options_template[index_start + 1 :].find("[")
            if index_stop == -1:
                # Copies text until the end of the file
                index_stop = len(options_template)
                option_text = options_template[index_start:index_stop] + "\n\n"
            else:
                index_stop = index_start + 1 + index_stop
                option_text = options_template[index_start:index_stop]
            return option_text

    def write_input(self, hierarchy, selected_structures, selected_reaches):
        """
        Write the swmm input file

        """

        # From qgis swmm
        filename = self.input_file
        state = self.state

        selected_ws_re = None
        if selected_structures and selected_reaches:
            selected_ws_re = selected_structures + selected_reaches

        with codecs.open(filename, "w", encoding="utf-8") as f:

            # Title / Notes
            # --------------
            f.write("[TITLE]\n")
            f.write(self.title + "\n\n")

            # Options
            # --------
            f.write(self.copy_parameters_from_template("OPTIONS"))
            f.write(self.copy_parameters_from_template("REPORT"))
            f.write(self.copy_parameters_from_template("FILES"))
            f.write(self.copy_parameters_from_template("EVENTS"))

            # Climatology
            # ------------
            f.write(self.copy_parameters_from_template("HYDROGRAPHS"))
            f.write(self.copy_parameters_from_template("EVAPORATION"))
            f.write(self.copy_parameters_from_template("TEMPERATURE"))

            # Hydrology
            # ----------
            self.feedback_set_progress(5)
            f.write(self.swmm_table("RAINGAGES", hierarchy, state, selected_structures))
            f.write(self.swmm_table("SYMBOLS", hierarchy, state, selected_structures))
            self.feedback_set_progress(10)
            f.write(
                self.swmm_table("SUBCATCHMENTS", hierarchy, state, selected_structures)
            )
            self.feedback_set_progress(15)
            f.write(self.swmm_table("SUBAREAS", hierarchy, state, selected_structures))
            self.feedback_set_progress(20)
            f.write(self.swmm_table("AQUIFERS"))
            self.feedback_set_progress(25)
            f.write(
                self.swmm_table("INFILTRATION", hierarchy, state, selected_structures)
            )
            self.feedback_set_progress(30)
            f.write(self.swmm_table("POLYGONS"))

            f.write(self.copy_parameters_from_template("GROUNDWATER"))
            f.write(self.copy_parameters_from_template("SNOWPACKS"))
            f.write(self.copy_parameters_from_template("HYDROGAPHS"))
            f.write(self.copy_parameters_from_template("LID_CONTROLS"))
            f.write(self.copy_parameters_from_template("LID_USAGE"))

            # Hydraulics: nodes
            # ------------------
            self.feedback_set_progress(35)
            f.write(self.swmm_table("JUNCTIONS", hierarchy, state, selected_ws_re))
            self.feedback_set_progress(40)
            f.write(self.swmm_table("OUTFALLS", hierarchy, state, selected_structures))
            self.feedback_set_progress(45)
            f.write(self.swmm_table("STORAGES", hierarchy, state, selected_structures))
            self.feedback_set_progress(50)
            f.write(self.swmm_table("COORDINATES", hierarchy, state, selected_ws_re))
            self.feedback_set_progress(55)
            f.write(self.swmm_table("DWF", hierarchy, state, selected_structures))

            f.write(self.copy_parameters_from_template("INFLOWS"))
            f.write(self.swmm_table("DIVIDERS"))

            # Hydraulics: links
            # ------------------
            self.feedback_set_progress(60)
            f.write(self.swmm_table("CONDUITS", hierarchy, state, selected_reaches))
            self.feedback_set_progress(65)
            f.write(self.swmm_table("LOSSES", hierarchy, state, selected_structures))
            self.feedback_set_progress(70)
            f.write(self.swmm_table("PUMPS", hierarchy, state, selected_structures))
            f.write(self.swmm_table("ORIFICES", hierarchy, state, selected_structures))
            f.write(self.swmm_table("WEIRS", hierarchy, state, selected_structures))
            self.feedback_set_progress(75)
            f.write(self.swmm_table("XSECTIONS", hierarchy, state, selected_reaches))
            self.feedback_set_progress(80)
            f.write(self.swmm_table("LOSSES", hierarchy, state, selected_structures))
            f.write(self.swmm_table("OUTLETS"))
            self.feedback_set_progress(85)
            f.write(self.swmm_table("VERTICES", hierarchy, state, selected_reaches))
            f.write(self.copy_parameters_from_template("TRANSECTS"))
            f.write(self.copy_parameters_from_template("CONTROLS"))

            # Quality
            # --------
            self.feedback_set_progress(90)
            f.write(self.swmm_table("LANDUSES"))
            self.feedback_set_progress(93)
            f.write(self.swmm_table("COVERAGES", None, None, selected_structures))

            f.write(self.copy_parameters_from_template("POLLUTANTS"))
            f.write(self.copy_parameters_from_template("BUILDUP"))
            f.write(self.copy_parameters_from_template("WASHOFF"))
            f.write(self.copy_parameters_from_template("TREATMENT"))
            f.write(self.copy_parameters_from_template("RDII"))
            f.write(self.copy_parameters_from_template("LOADINGS"))

            # Curves
            # -------
            f.write(self.swmm_table("CURVES"))

            # Time series
            # ------------
            f.write(self.copy_parameters_from_template("TIMESERIES"))

            # Time patterns
            # --------------
            f.write(self.copy_parameters_from_template("PATTERNS"))

            # Map labels
            # -----------
            f.write(self.copy_parameters_from_template("LABELS"))
            self.feedback_set_progress(96)

            # Tags
            # ----
            f.write(self.swmm_table("TAGS", state, selected_ws_re))
        f.close()
        return

    def extract_time_series_indexes(self):
        """
        Extract full time series from swmm report file

        Returns:
        data_indexes (dictionary): dictionary of the object id with data indexes

        """

        o = codecs.open(self.rpt_file, "r", encoding="utf-8")
        line = o.readline()
        title_found = False
        line_number = -1
        data_indexes = {}
        heading_lines = 5
        while line:
            line_number += 1
            line = line.rstrip()
            # Search for the table title
            if line.find("*****") != -1:
                # The following title is found: stop the recording of the indexes
                title_found = False

            if line.find("<<< Link ") != -1 or line.find("<<< Node ") != -1:
                title_found = True
                line_after_title = 0
                obj_id = line.strip().split(" ")[2]
                data_indexes[obj_id] = {}
                data_indexes[obj_id]["title_index"] = line_number
                data_indexes[obj_id]["start_index"] = line_number + heading_lines
                if line.find("Link") != -1:
                    data_indexes[obj_id]["type"] = "link"
                if line.find("Node") != -1:
                    data_indexes[obj_id]["type"] = "node"

            if title_found and line_after_title > heading_lines and line.strip() == "":
                data_indexes[obj_id]["end_index"] = line_number - 1

            if title_found:
                line_after_title += 1

            line = o.readline()
        o.close()
        return data_indexes

    def extract_summary_lines(self, table_title):
        """
        Extract result data from swmm report file

        Parameters:
        table_title (string): Name of the section to be extracted

        Returns:
        Array of array: Extracted computed values

        """

        o = codecs.open(self.rpt_file, "r", encoding="utf-8")

        line = o.readline()
        no_line = 0
        lines = []
        title_found = False
        end_table_found = False
        while line:
            line = line.rstrip()
            # Search for the table title
            if line.find(table_title) != -1:
                title_found = True
                line_after_title = 0

            if title_found and line_after_title > 7 and line == "":
                end_table_found = True

            if title_found and end_table_found is False and line_after_title > 7:
                lines.append(line.split())

            if title_found:
                line_after_title += 1

            no_line += 1
            line = o.readline()
        o.close()

        return lines

    def extract_node_depth_summary(self):
        """
        Extract node depth result data from swmm output file

        Returns:
        dic: Extracted computed values

        """

        data = self.extract_summary_lines("Node Depth Summary")
        result = []
        for d in data:
            curres = {}
            curres["id"] = d[0]
            curres["type"] = d[1]
            curres["average_depth"] = d[2]
            curres["maximum_depth"] = d[3]
            curres["maximum_hgl"] = d[4]
            curres["time_max_day"] = d[5]
            curres["time_max_time"] = d[6]
            curres["reported_max_depth"] = d[7]
            result.append(curres)
        return result

    def extract_link_flow_summary(self):
        """
        Extract link flow result data from swmm output file

        Returns:
        dic: Extracted computed values

        """

        data = self.extract_summary_lines("Link Flow Summary")
        result = []
        for d in data:

            curres = {}
            curres["id"] = d[0]
            curres["type"] = d[1]
            curres["maximum_flow"] = d[2]
            curres["time_max_day"] = d[3]
            curres["time_max_time"] = d[4]
            if d[1] == "CONDUIT":
                curres["maximum_velocity"] = d[5]
                curres["max_over_full_flow"] = d[6]
                curres["max_over_full_depth"] = d[7]
            elif d[1] == "PUMP":
                curres["max_over_full_flow"] = d[5]
                curres["maximum_velocity"] = None
                curres["max_over_full_depth"] = None

            result.append(curres)
        return result

    def execute_swmm(self):
        """
        Execute SWMM

        Parameters:
        dic: Extracted computed values

        """

        command = [self.bin_file, self.input_file, self.rpt_file]
        self.feedback_push("info", "command: " + " ".join(map(str, command)))
        proc = subprocess.run(
            command,
            shell=True,
            stdout=subprocess.PIPE,
            stdin=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True,
        ).stdout

        return proc

    def get_analysis_option(self, parameter):
        o = codecs.open(self.rpt_file, "r", encoding="utf-8")
        line = o.readline()
        while line:
            line = line.rstrip()
            # Search for the analyis option
            if line.find(parameter) != -1:
                value = line.split(".")[-1].strip()
            line = o.readline()
        o.close()
        return value

    def convert_to_datetime(self, str_date):
        date = datetime.strptime(str_date, "%d/%m/%Y %H:%M:%S")
        return date

    def import_full_results(self, sim_description):
        """
        Import the full results from an SWMM report file

        Parameters:
        sim_description (string): Title of the simulation

        """

        simulation_start_date = self.convert_to_datetime(
            self.get_analysis_option("Starting Date")
        )
        simulation_end_date = self.convert_to_datetime(
            self.get_analysis_option("Ending Date")
        )
        simulation_duration = simulation_end_date - simulation_start_date
        measuring_duration = simulation_duration.total_seconds()

        data_indexes = self.extract_time_series_indexes()

        ndata = len(data_indexes.keys())
        self.feedback_push("info", "Import full results")
        counter = 0
        for obj_id in data_indexes.keys():
            counter += 1
            self.feedback_set_progress(counter * 100 / ndata)
            # Create measuring point if necessary
            if data_indexes[obj_id]["type"] == "node":
                mp_obj_id = self.create_measuring_point_node(obj_id, sim_description)
            if data_indexes[obj_id]["type"] == "link":
                mp_obj_id = self.create_measuring_point_link(obj_id, sim_description)
            if mp_obj_id:
                # Create measuring device
                self.create_measuring_device(mp_obj_id)
                # Get measurement data of the current object
                measurement_data = self.get_full_results(
                    data_indexes[obj_id]["start_index"],
                    data_indexes[obj_id]["end_index"],
                    data_indexes[obj_id]["type"],
                )
                # Record each measurement
                m_counter = 0
                for m in measurement_data:
                    m_counter += 1
                    time = self.convert_to_datetime(
                        m["date"] + " " + m["time"]
                    ).isoformat()
                    for k in m.keys():
                        if k in SWMM_RESULTS_PARAMETERS.keys():
                            if SWMM_RESULTS_PARAMETERS[k]["recorded"]:
                                ms_obj_id = self.create_measurement_series(
                                    mp_obj_id,
                                    k,
                                    SWMM_RESULTS_PARAMETERS[k]["dimension"],
                                )
                                self.create_measurement_result(
                                    ms_obj_id,
                                    SWMM_RESULTS_PARAMETERS[k]["qgep_measurement_type"],
                                    measuring_duration,
                                    time,
                                    m[k],
                                )
        return

    def get_full_results(self, start_index, end_index, swmm_type):
        """
        Get the full result of a node or link

        Parameters:
        start_index (integer): Index of the first line containing the data
        end_index (integer): Index of the last line containing the data

        Returns:
        datas: array of dictionnary containing the data
        """
        o = codecs.open(self.rpt_file, "r", encoding="utf-8")
        line = o.readline()
        no_line = -1
        datas = []
        while line:
            no_line += 1
            if no_line >= start_index and no_line < end_index:
                values = line.strip().split()
                data = {}
                if len(values) != 0:
                    data["date"] = values[0]
                    data["time"] = values[1]
                    if swmm_type == "node":
                        data["inflow"] = values[2]
                        data["flooding"] = values[3]
                        data["depth"] = values[4]
                        data["head"] = values[5]
                    if swmm_type == "link":
                        data["flow"] = values[2]
                        data["velocity"] = values[3]
                        data["depth"] = values[4]
                        data["capacity"] = values[5]
                    datas.append(data)
            line = o.readline()
        o.close()
        return datas

    def import_summary(self, sim_description):
        """
        Import the summary results from an SWMM report file

        Parameters:
        sim_description (string): Title of the simulation

        """
        simulation_start_date = self.convert_to_datetime(
            self.get_analysis_option("Starting Date")
        )
        simulation_end_date = self.convert_to_datetime(
            self.get_analysis_option("Ending Date")
        )
        simulation_duration = simulation_end_date - simulation_start_date
        measuring_duration = simulation_duration.total_seconds()
        self.feedback_push("info", "Import nodes summary")
        node_summary = self.extract_node_depth_summary()
        self.record_summary(
            node_summary,
            simulation_start_date,
            sim_description,
            measuring_duration,
            "node",
        )
        self.feedback_push("info", "Import links summary")
        link_summary = self.extract_link_flow_summary()
        self.record_summary(
            link_summary,
            simulation_start_date,
            sim_description,
            measuring_duration,
            "link",
        )

        return

    def convert_max_over_full_flow(self, link_summary):

        """
        Convert max_over_full_flow in percent

        Parameters:
        link_summary (array): data extracted from the summary

        Returns:
        link_summary (array)
        """

        for ws in link_summary:

            ws["max_over_full_flow"] = int(round(float(ws["max_over_full_flow"]))) * 100

        return link_summary

    def import_backflow_level(self):

        """
        Import the backflow level from an SWMM report file
        """
        self.feedback_push("info", "Import backflow level")
        print("1")
        node_summary = self.extract_node_depth_summary()
        print("2")
        self.populate_attribute(
            node_summary, "wastewater_node", "backflow_level", "maximum_hgl"
        )

        return

    def import_hydraulic_load(self):

        """
        Import the hydraulic load from an SWMM report file
        """
        self.feedback_push("info", "Import hydraulic load")
        link_summary = self.extract_link_flow_summary()
        link_summary = self.convert_max_over_full_flow(link_summary)
        self.populate_attribute(
            link_summary,
            "reach",
            "dss2020_hydraulic_load_current",
            "max_over_full_flow",
        )

        return

    def record_summary(
        self, data, simulation_start_date, sim_description, measuring_duration, obj_type
    ):

        """
        Record the node and link summary in the database

        Parameters:
        data (array): data extracted from the summary
        simulation_start_date (datetime): start of the simulation
        sim_description (string): name of the simulation
        measuring_duration (integer): time length of the simulation in seconds
        obj_type (string): link or node

        """

        ndata = len(data)
        # Loop over each line of the node summary
        counter = 0
        for ws in data:
            counter += 1
            if obj_type == "node":
                self.feedback_set_progress(counter * 50 / ndata)
                mp_obj_id = self.create_measuring_point_node(ws["id"], sim_description)
            else:
                self.feedback_set_progress(50 + counter * 50 / ndata)
                mp_obj_id = self.create_measuring_point_link(ws["id"], sim_description)
            if mp_obj_id:
                self.create_measuring_device(mp_obj_id)
                delta = timedelta(
                    days=int(ws["time_max_day"]),
                    hours=int(ws["time_max_time"].split(":")[0]),
                    minutes=int(ws["time_max_time"].split(":")[1]),
                )
                for k in ws.keys():
                    if k in SWMM_SUMMARY_PARAMETERS.keys():
                        if SWMM_SUMMARY_PARAMETERS[k]["recorded"]:
                            ms_obj_id = self.create_measurement_series(
                                mp_obj_id, k, SWMM_SUMMARY_PARAMETERS[k]["dimension"]
                            )
                            time = (simulation_start_date + delta).isoformat()
                            self.create_measurement_result(
                                ms_obj_id,
                                SWMM_SUMMARY_PARAMETERS[k]["qgep_measurement_type"],
                                measuring_duration,
                                time,
                                ws[k],
                            )
        return

    def populate_attribute(self, data, table_name, attribute_name, swmm_attribute):

        """
        Update an attribute of a qgep_od table according to a swmm result

        Parameters:
        data (array): data extracted from the node summary
        table_name (string): name of the destination table
        attribute_name (string): name of the destination attribute
        swmm_attribute (string): name of the swmm attribute (ie. maximum_hgl, max_over_full_flow)
        """

        ndata = len(data)
        cur = self.con.cursor()
        # Loop over each line of the node summary
        counter = 0
        for ws in data:
            counter += 1
            bf_level = ws[swmm_attribute]
            obj_id = ws["id"]
            sql = """
            UPDATE qgep_od.{table_name}
            SET {attribute_name} = {bf_level}
            WHERE obj_id = '{obj_id}'
            RETURNING obj_id;
            """.format(
                table_name=table_name,
                attribute_name=attribute_name,
                bf_level=bf_level,
                obj_id=obj_id,
            )
            try:
                cur.execute(sql)
            except psycopg2.ProgrammingError:
                self.feedback_push(
                    "error", "Error while excecuting: {sql}".format(sql=sql)
                )
                self.feedback_push("error", str(psycopg2.ProgrammingError))
                return None, None
            res = cur.fetchone()
            if res is None:
                self.feedback_push(
                    "info",
                    """{obj_id} in the output file has no correspondance in qgep_od.{table_name}.""".format(
                        obj_id=obj_id, table_name=table_name
                    ),
                )
            self.feedback_set_progress(counter / ndata)
        self.con.commit()

        return

    def create_measuring_point_node(self, node_obj_id, sim_description):

        """
        For a node creates a measuring point or get its id.

        Parameters:
        node_obj_id (string): wastewater node object ID
        sim_description (string): name of the simulation

        Returns:
        me_obj_id: measuring point object ID

        """

        # Connects to service and get data and attributes from tableName
        cur = self.con.cursor()

        # Test if the measuring point exists
        sql = """
        SELECT mp.obj_id
        FROM qgep_od.measuring_point mp
        JOIN qgep_od.wastewater_structure ws on mp.fk_wastewater_structure = ws.obj_id
        WHERE ws.fk_main_wastewater_node = '{node_obj_id}'
        AND mp.remark = '{sim_description}'
        """.format(
            sim_description=sim_description, node_obj_id=node_obj_id
        )
        cur.execute(sql)
        res = cur.fetchone()

        if res is None:
            # Measuring point doesnt exists, must be created
            # 4594 = technical purpose [TO VALIDATE]
            sql = """
            INSERT INTO qgep_od.measuring_point
            (damming_device, identifier, kind,
            purpose, remark, fk_wastewater_structure)
            SELECT 5721, NULL, '{MEASURING_POINT_KIND}', 4594,
            '{sim_description}', ws.obj_id
            FROM qgep_od.wastewater_structure ws
            WHERE fk_main_wastewater_node = '{node_obj_id}'
            RETURNING obj_id
            """.format(
                MEASURING_POINT_KIND=MEASURING_POINT_KIND,
                node_obj_id=node_obj_id,
                sim_description=sim_description,
            )
            try:
                cur.execute(sql)
            except psycopg2.ProgrammingError:
                self.feedback_push(
                    "error", "Error while excecuting: {sql}".format(sql=sql)
                )
                self.feedback_push("error", str(psycopg2.ProgrammingError))
                return None, None
            res = cur.fetchone()
            if res is None:
                mp_obj_id = None
            else:
                mp_obj_id = res[0]
                self.con.commit()
            del cur
        else:
            mp_obj_id = res[0]
        return mp_obj_id

    def create_measuring_point_link(self, reach_obj_id, sim_description):

        """
        For a node creates a measuring point or get its id.

        Parameters:
        reach_obj_id (string): reach object ID
        sim_description (string): name of the simulation

        Returns:
        me_obj_id: measuring point object ID

        """

        # Connects to service and get data and attributes from tableName
        cur = self.con.cursor()

        # Test if the measuring point exists
        sql = """
        SELECT mp.obj_id
        FROM qgep_od.measuring_point mp
        JOIN qgep_od.wastewater_networkelement ne ON
        ne.fk_wastewater_structure = mp.fk_wastewater_structure
        WHERE ne.obj_id = '{reach_obj_id}'
        AND mp.remark = '{sim_description}'
        """.format(
            sim_description=sim_description, reach_obj_id=reach_obj_id
        )
        cur.execute(sql)
        res = cur.fetchone()

        if res is None:
            # Measuring point doesnt exists, must be created
            # 4594 = technical purpose [TO VALIDATE]
            sql = """
            INSERT INTO qgep_od.measuring_point
            (damming_device, identifier, kind, purpose, remark,
            fk_wastewater_structure)
            SELECT 5721, NULL, '{MEASURING_POINT_KIND}', 4594,
            '{sim_description}', ne.fk_wastewater_structure
            FROM qgep_od.wastewater_networkelement ne
            WHERE ne.obj_id = '{reach_obj_id}'
            RETURNING obj_id
            """.format(
                MEASURING_POINT_KIND=MEASURING_POINT_KIND,
                sim_description=sim_description,
                reach_obj_id=reach_obj_id,
            )
            try:
                cur.execute(sql)
            except psycopg2.ProgrammingError:
                self.feedback_push(
                    "error", "Error while excecuting: {sql}".format(sql=sql)
                )
                self.feedback_push("error", str(psycopg2.ProgrammingError))
                return None
            res = cur.fetchone()
            mp_obj_id = res[0]
            self.con.commit()
            del cur
        else:
            mp_obj_id = res[0]
        return mp_obj_id

    def create_measuring_device(self, mp_obj_id):

        """
        For a measuring point creates a measuring device or get its id.

        Parameters:
        mp_obj_id (string): measuring point object ID

        Returns:
        md_obj_id: measuring device object ID

        """

        cur = self.con.cursor()

        # Test if the measuring device exists
        sql = """
        SELECT md.obj_id
        FROM qgep_od.measuring_device md
        WHERE md.fk_measuring_point = '{mp_obj_id}'
        AND remark = '{MEASURING_DEVICE_REMARK}'
        """.format(
            MEASURING_DEVICE_REMARK=MEASURING_DEVICE_REMARK, mp_obj_id=mp_obj_id
        )
        cur.execute(sql)
        res = cur.fetchone()

        if res is None:
            # Measuring device doesnt exists, must be created
            sql = """
            INSERT INTO qgep_od.measuring_device
            (kind, remark, fk_measuring_point)
            VALUES
            (5702, '{MEASURING_DEVICE_REMARK}','{mp_obj_id}')
            RETURNING obj_id
            """.format(
                MEASURING_DEVICE_REMARK=MEASURING_DEVICE_REMARK, mp_obj_id=mp_obj_id
            )
            try:
                cur.execute(sql)
            except psycopg2.ProgrammingError:
                self.feedback_push(
                    "error", "Error while excecuting: {sql}".format(sql=sql)
                )
                self.feedback_push("error", str(psycopg2.ProgrammingError))
                return None, None
            res = cur.fetchone()
            if res is None:
                mp_obj_id = None
            else:
                mp_obj_id = res[0]
                self.con.commit()
            del cur
        else:
            mp_obj_id = res[0]
        return mp_obj_id

    def create_measurement_series(self, mp_obj_id, parameter_name, parameter_dimension):

        """
        Creates a measurement serie or get its id.

        Parameters:
        mp_obj_id (string): measurement point object ID
        parameter_name (string): name of the parameter
        parameter_dimension (string): dimension of the parameter

        Returns:
        mp_obj_id: measuring point object ID

        """

        # Connects to service
        cur = self.con.cursor()

        # Test if the measurement serie exists
        sql = """
        SELECT obj_id FROM qgep_od.measurement_series
        WHERE remark = '{parameter_name}'
        AND fk_measuring_point = '{mp_obj_id}'
        """.format(
            parameter_name=parameter_name, mp_obj_id=mp_obj_id
        )
        cur.execute(sql)
        res = cur.fetchone()

        if res is None:
            # Measuring point doesnt exists, must be created
            # 3217 = other [TO VALIDATE]
            # No dimension, else we would need to create four measurements
            # series l/s m/s m - [TO VALIDATE]
            sql = """
            INSERT INTO qgep_od.measurement_series
            (identifier, dimension, kind, remark, fk_measuring_point)
            VALUES
            (null, '{parameter_dimension}', 3217,
            '{parameter_name}', '{mp_obj_id}')
            RETURNING obj_id
            """.format(
                parameter_dimension=parameter_dimension,
                parameter_name=parameter_name,
                mp_obj_id=mp_obj_id,
            )

            try:
                cur.execute(sql)
            except psycopg2.ProgrammingError:
                self.feedback_push(
                    "error", "Error while excecuting: {sql}".format(sql=sql)
                )
                self.feedback_push("error", str(psycopg2.ProgrammingError))
                return None
            ms_obj_id = cur.fetchone()[0]
            self.con.commit()
        else:
            ms_obj_id = res[0]
        del cur
        return ms_obj_id

    def create_measurement_result(
        self, ms_obj_id, measurement_type, measuring_duration, time, value
    ):

        """
        Creates a measurement result or update it.

        Parameters:
        ms_obj_id (string): measurement serie object ID
        measurement_type (integer): type of measurement 5733=flow, 5734=level, 5732=other
        measuring_duration (integer): Time step of the simulation in seconds
        time (string): timestamp of the recorded result
        value (float): value of the measurement

        Returns:
        mr_obj_id: measurement result object ID

        """

        # Connects to service
        cur = self.con.cursor()

        # Test if the measurement result exists (same measurement serie, same time, same type)
        sql = """
        SELECT obj_id FROM qgep_od.measurement_result
        WHERE fk_measurement_series = '{ms_obj_id}'
        AND time = '{time}'
        AND measurement_type = {measurement_type}
        """.format(
            ms_obj_id=ms_obj_id, time=time, measurement_type=measurement_type
        )
        try:
            cur.execute(sql)
        except psycopg2.ProgrammingError:
            self.feedback_push("error", "Error while excecuting: {sql}".format(sql=sql))
            self.feedback_push("error", (str(psycopg2.ProgrammingError)))
            return None
        res = cur.fetchone()

        if res is None:
            # Measurement result doesnt exists, must be created

            sql = """
            INSERT INTO qgep_od.measurement_result
            (identifier, measurement_type, measuring_duration,
            time, value, fk_measurement_series)
            VALUES
            (null, {measurement_type}, {measuring_duration}, '{time}', {value}, '{ms_obj_id}')
            RETURNING obj_id
            """.format(
                measurement_type=measurement_type,
                measuring_duration=measuring_duration,
                time=time,
                value=value,
                ms_obj_id=ms_obj_id,
            )

            try:
                cur.execute(sql)
            except psycopg2.ProgrammingError:
                self.feedback_push(
                    "error", "Error while excecuting: {sql}".format(sql=sql)
                )
                self.feedback_push("error", (str(psycopg2.ProgrammingError)))
                return None
            mr_obj_id = cur.fetchone()[0]
            self.con.commit()
        else:
            mr_obj_id = res[0]
            # Measurement result exists, must be updated
            sql = """
            UPDATE qgep_od.measurement_result
            SET measuring_duration={measuring_duration}, value={value}
            WHERE obj_id = '{mr_obj_id}'
            RETURNING obj_id
            """.format(
                measuring_duration=measuring_duration, value=value, mr_obj_id=mr_obj_id
            )
            try:
                cur.execute(sql)
            except psycopg2.ProgrammingError:
                self.feedback_push(
                    "error", "Error while excecuting: {sql}".format(sql=sql)
                )
                self.feedback_push("error", (str(psycopg2.ProgrammingError)))
                return None
            mr_obj_id = cur.fetchone()[0]
            self.con.commit()
        del cur
        return mr_obj_id

    def disable_reach_trigger(self):

        """
        Disable triggers on the table qgep_od.reach
        """

        cur = self.con.cursor()

        # Set value for qgep_od.reach.default_coefficient_friction where reach_material is known
        sql = """
        ALTER TABLE qgep_od.reach DISABLE TRIGGER ALL;
        """
        try:
            cur.execute(sql)
        except psycopg2.ProgrammingError:
            self.feedback_push("error", "Error while excecuting: {sql}".format(sql=sql))
            self.feedback_push("error", (str(psycopg2.ProgrammingError)))
            return None
        self.con.commit()
        del cur
        return

    def enable_reach_trigger(self):

        """
        Enable triggers on the table qgep_od.reach
        """

        cur = self.con.cursor()

        # Set value for qgep_od.reach.default_coefficient_friction where reach_material is known
        sql = """
        ALTER TABLE qgep_od.reach ENABLE TRIGGER ALL;
        """
        try:
            cur.execute(sql)
        except psycopg2.ProgrammingError:
            self.feedback_push("error", "Error while excecuting: {sql}".format(sql=sql))
            self.feedback_push("error", (str(psycopg2.ProgrammingError)))
            return None
        self.con.commit()
        del cur
        return

    def set_reach_default_friction(self):

        """
        Set default friction in qgep_od.reach where default friction is not set
        """

        cur = self.con.cursor()

        # Set value for qgep_od.reach.default_coefficient_friction where reach_material is known
        sql = """
        UPDATE qgep_od.reach r
        SET swmm_default_coefficient_of_friction = f.coefficient_of_friction
        FROM qgep_swmm.reach_coefficient_of_friction f
        WHERE r.swmm_default_coefficient_of_friction isnull AND f.fk_material = r.material;
        """
        try:
            cur.execute(sql)
        except psycopg2.ProgrammingError:
            self.feedback_push("error", "Error while excecuting: {sql}".format(sql=sql))
            self.feedback_push("error", (str(psycopg2.ProgrammingError)))
            return None
        self.con.commit()
        del cur
        return

    def overwrite_reach_default_friction(self):

        """
        Reset default friction in qgep_od.reach where default friction
        """

        cur = self.con.cursor()

        # Set value for qgep_od.reach.default_coefficient_friction where reach_material is known
        sql = """
        UPDATE qgep_od.reach r
        SET swmm_default_coefficient_of_friction = f.coefficient_of_friction
        FROM qgep_swmm.reach_coefficient_of_friction f
        WHERE f.fk_material = r.material;
        """
        try:
            cur.execute(sql)
        except psycopg2.ProgrammingError:
            self.feedback_push("error", "Error while excecuting: {sql}".format(sql=sql))
            self.feedback_push("error", (str(psycopg2.ProgrammingError)))
            return None
        self.con.commit()
        del cur
        return
