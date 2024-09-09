# TEKSI Wastewater module (TWW)

NEW TEKSI wastewater module, adapted datamodel to fit Swiss Norm VSA-DSS Release 2020.1 new standard.

This repository holds all code related to the TEKSI Wastewater module (formerly QGEP). <!---  // skip-keyword-check -->

It contains:

 - The datamodel definition in english
 - A QGIS wastewater plugin : TEKSI wastewater
 - A QGIS .qgs project : TEKSI wastewater and General Wastewater Management Plan (GWMP)
 - The documentation : https://teksi.github.io/wastewater/


How to start [testing](https://github.com/teksi/wastewater/discussions/72)

Upcoming first version TEKSI Wastewater 2024.0 is due to end of march 2024.

Migration path from QGEP to TEKSI Wastewater is due to end of summer 2024. <!---  // skip-keyword-check -->

## Local development

1. Open OSGeo4W Shell and run `pip install debugpy`.
2. Clone this repository to your local machine.
3. Open QGIS, go to the _Environment_ section in `Settings > Options - System` and add the following custom variables:

   | Apply  | Variable                 | Value                   |
   | :----- | :----------------------- | :---------------------- |
   | APPEND | QGIS_PLUGINPATH          | {repositoryPath}/plugin |
   | APPEND | QGIS_PLUGIN_USE_DEBUGGER | debugpy                 |

4. Install QGIS plugin _Plugin Reloader_. This will allow you to reload the plugin without restarting QGIS.
5. Follow the _prerequisites_ and _Usage (GUI)_ from https://github.com/wapaAdmin/tww2ag6496/blob/main/docs/en/admin-guide/interlis-io/index.rst

## Local development with VS Code

1. Ensure prerequisites are met according to the [admin guide](docs/en/admin-guide/interlis-io/index.rst).
2. Install [Visual Studio Code](https://code.visualstudio.com/) and the [Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python).
3. Install QGIS in Version 3.34.10 or adapt `qgis.installationRoot` in ['.vscode/settings.json'.](.vscode/settings.json)
4. Install Docker
5. Install debugpy by running Task `Install dependencies` or run `pip install debugpy` in the OSGeo4W Shell.
6. Launch QGIS with Task `Launch QGIS`.
7. Wait for QGIS to start and open the plugin in QGIS.
8. Attach the debugger with Debug: Start Debugging (F5) with configuration `Python: Remote Attach`
