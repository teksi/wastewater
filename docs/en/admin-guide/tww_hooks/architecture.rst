Architecture
============

The hook architecture is split into three layers:

``teksi_hooks``
   Generic hook framework, shared capabilities and service interfaces.

``tww_hooks``
   TWW-specific rights, provider, mapping and evaluation logic.

``teksi_wastewater``
   QGIS plugin integration and adapter implementations.

The ``tww_hooks`` package follows a staged processing model:

Parser
   Converts YAML files into parsed dataclasses.

Resolver
   Converts parsed dataclasses into runtime lookup structures.

Capability
   Provides read-only lookup interfaces for resolved data.

Evaluator
   Applies rights, conditions and validation logic.

Services
   Implement higher-level workflows such as change loading.
