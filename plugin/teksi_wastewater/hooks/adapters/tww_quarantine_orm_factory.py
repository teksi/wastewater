from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from teksi_wastewater.interlis.model_config import (
    interlis_models,
)


@dataclass(
    slots=True,
)
class TwwQuarantineClassesFactory:
    """
    Reconstruct ORM classes for one existing quarantine schema.

    The model group selects the configured ORM factory. Creating the ORM model
    does not recreate or repopulate the PostgreSQL schema.
    """

    def __call__(
        self,
        *,
        source_model: str,
        model_group: str,
        model_language: str,
        import_schema: str,
    ) -> Any:
        """
        Return ORM classes for an existing quarantine schema.
        """

        try:
            model_configuration = interlis_models[model_group]

        except KeyError as exception:
            raise ValueError(
                "No quarantine ORM model is configured for "
                f"model group {model_group!r}. Available groups: "
                f"{tuple(sorted(interlis_models))!r}."
            ) from exception

        configured_model_name = model_configuration.lang_name(
            model_language,
        )

        if configured_model_name != source_model:
            raise ValueError(
                "Persisted source model does not match the "
                "configured model for the persisted group and "
                f"language. Source model: {source_model!r}; "
                f"group: {model_group!r}; language: "
                f"{model_language!r}; configured model: "
                f"{configured_model_name!r}."
            )

        quarantine_model = model_configuration.quarantine_model(
            schema=import_schema,
        )

        return quarantine_model.classes()
