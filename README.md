# FUTURE TEKSI Wastewater module

[DEV] Future TEKSI wastewater module, adapted datamodel to fit VSA 2020 new standard

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
