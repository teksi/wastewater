# This template file can be used to run the qgep-swmm functionalities
# outside from QGIS

from QgepSwmm import QgepSwmm

# Title of the simulation
TITLE = "titre"
# Name of the service used to connect to the database
PGSERVICE = "pg_qgep"
# State of the simulation [current, planned]
STATE = "current"
# Path of the input INP file
INPUT = "C:/temp/input.inp"
# Path of the input template INP file
TEMPLATEINP = "C:/temp/swmm_template.inp"
# Path of the output report file
REPORT = "C:/temp/summary.rpt"
# Path of SWMM executable
SWMM = "C:/Program Files (x86)/EPA SWMM 5.1.013/swmm5.exe"

with QgepSwmm(
    TITLE,
    PGSERVICE,
    STATE,
    INPUT,
    TEMPLATEINP,
    REPORT,
    SWMM,
    None,
) as qs:
    # Commands examples

    # Export INP file
    qs.write_input()
    # Run SWMM
    qs.execute_swmm()
    # Import summary
    qs.import_summary("SWMM simulation, T100, current")
    # Import full results
    qs.import_full_results("SWMM simulation, T100, current")
