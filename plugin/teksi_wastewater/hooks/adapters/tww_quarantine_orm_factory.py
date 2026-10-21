from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from sqlalchemy.orm import Session

from teksi_wastewater.interlis.utils import (
    tww_sqlalchemy,
)

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
            model_configuration = interlis_models[
                model_group
            ]

        except KeyError as exception:
            raise ValueError(
                "No quarantine ORM model is configured for "
                f"model group {model_group!r}. Available groups: "
                f"{tuple(sorted(interlis_models))!r}."
            ) from exception

        configured_model_name = (
            model_configuration.lang_name(
                model_language,
            )
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

        quarantine_model = (
            model_configuration.quarantine_model(
                schema=import_schema,
            )
        )

        return quarantine_model.classes()



class TwwQuarantineSessionFactory:
    """
    Create caller-owned SQLAlchemy sessions for quarantine persistence.

    Database parameters come from the active TEKSI Wastewater database
    configuration. The ORM classes determine the schema-qualified tables.

    The caller owns commit, rollback, and session closure.
    """

    def __call__(
        self,
        *,
        import_schema: str,
    ) -> Session:
        """
        Return a new session for an existing quarantine schema.

        ``import_schema`` is validated for contract clarity. Schema selection
        itself is encoded in the generated ORM classes.
        """

        if (
            not isinstance(
                import_schema,
                str,
            )
            or not import_schema.strip()
        ):
            raise ValueError(
                "import_schema must be a non-empty string."
            )

        return Session(
            tww_sqlalchemy.create_engine(),
            autocommit=False,
            autoflush=False,
        )