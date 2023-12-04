# tww2ili

This is the toolkit to import/export between TWW/QWAT and their counterpart SIA405 interlis model exchange files.

It can be used as a command line tool or integrated in QGIS plugins.

Note that this currently only supports up to date TWW and QWAT (1.5.6/1.3.6 respectively at the time of writing).

## Command line tool

### Installation

The tool requires **python** (3.6 or newer) and **java** to be available. Then, it can be installed like any other python library:
```
pip install --upgrade tww2ili
```

### Import/export TWW

Import example
```
python -m tww2ili tww import data/test_without_abwasserbauwerkref.xtf
```

Export example
```
python -m tww2ili tww export desktop/my_export.xtf --selection "ch13p7mzRE001221,ch13p7mzWN003445,ch13p7mzWN008122"
```

Full usage
```
usage: python -m tww2ili tww [-h] [--selection SELECTION] [--labels_file LABELS_FILE] [--recreate_schema] [--skip_validation] [--pgservice PGSERVICE] [--log] {import,export} path

ili2TWW entrypoint

positional arguments:
  {import,export}
  path                  path to the input/output .xtf file

optional arguments:
  -h, --help            show this help message and exit
  --selection SELECTION
                        if provided, limits the export to networkelements that are provided in the selection (comma separated list of ids)
                        (default: None)
  --labels_file LABELS_FILE
                        if provided, includes the label positions in the export (the file should be the results of the
                        provided `tww:extractlabels_interlis` QGIS algorithm as geojson) (default: None)
  --recreate_schema     drops schema and reruns ili2pg importschema (default: False)
  --skip_validation     skips running ilivalidator on input/output xtf (required to import invalid files, invalid outputs are still generated)
                        (default: False)
  --pgservice PGSERVICE
                        name of the pgservice to use to connect to the database (default: pg_tww)
  --log                 saves a log file next to the input/output file (default: False)
  --export_sia405       export the model SIA405_ABWASSER_2015_LV95 (instead of default VSA_KEK_2019_LV95) (default: False)
```

### Import/export QWAT

Import example
```
# QWAT import not implemented yet
```

Export example
```
python -m tww2ili qwat export desktop/my_export.xtf
```

Full usage
```
usage: python -m tww2ili qwat [-h] [--recreate_schema] [--skip_validation] [--pgservice PGSERVICE] [--log] [--include_hydraulics] {import,export} path

ili2QWAT entrypoint

positional arguments:
  {import,export}
  path                  path to the input/output .xtf file

optional arguments:
  -h, --help            show this help message and exit
  --recreate_schema     drops schema and reruns ili2pg importschema (default: False)
  --skip_validation     skips running ilivalidator on input/output xtf (required to import invalid files, invalid outputs are still generated)
                        (default: False)
  --include_hydraulics  if provided, exports will include hydraulischer_strang and hydraulischer_node classes (these are currently likely to make the export invalid due to issues with the current ili model) (default: False)
  --pgservice PGSERVICE
                        name of the pgservice to use to connect to the database (default: qwat)
  --log                 saves a log file next to the input/output file (default: False)
```

### Logging

Logging output to a file can be achieved by adding `--log` to your command. The file will be saved next to the input/output xtf.

```
python -m tww2ili tww import data/test_without_abwasserbauwerkref.xtf --log
```

Please include this when reporting issues.

The above logs don't show full errors for ili2db and ilivalidator related outputs. Thus, you may want to look at the native ili2db and ilivalidator related logs, named `tww2ili/yyyymmddhhmmss.STEP.log` in your temporary directory (`/tmp` on linux or `C:\Users\You\AppData\Local\Temp\` on Windows).


## QGIS integration

This will be integrated into the official TWW and QWAT plugin installable through the QGIS plugin manager.


## Dev

Import/export scripts templates can be generated using `python -m tww2ili tpl`. This uses the mapping defined in `datamodels/mapping.py` to auto-generate import script templates, that can then be manually merged into the existing scripts.

Tests are run with
```
python -m unittest tww2ili.tests
```

Style is done with pre-commit
```
pip install pre-commit
pre-commit install
```

## Releases

Releases to PyPi are made automatically via github workflows whenever a new tag matching `v*` is pushed.
