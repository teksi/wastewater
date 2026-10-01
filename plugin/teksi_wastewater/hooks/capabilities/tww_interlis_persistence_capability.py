from dataclasses import dataclass
from typing import Protocol


@dataclass(
    slots=True,
    frozen=True,
)
class TwwInterlisPersistenceResult:
    """
    Result of importing one prepared quarantine schema into live data.
    """

    import_schema: str
    live_schema: str
    source_model: str
    committed: bool


class TwwInterlisPersistenceCapability(
    Protocol,
):
    """
    Persist prepared quarantine data through a model-specific adapter.
    """

    def persist_quarantine(
        self,
        *,
        import_schema: str,
        live_schema: str,
        source_model: str,
    ) -> TwwInterlisPersistenceResult:
        """
        Persist prepared quarantine data.
        """

        ...


class TwwQuarantinePreparer(
    Protocol,
):
    """
    Prepare quarantine data for persistence.

    Implementations apply stored review decisions to the quarantine schema.
    This includes removing or nulling values that are not authorized for
    persistence while retaining findings in tww_diff.
    """

    def prepare(
        self,
        *,
        job_id: str,
        import_schema: str,
    ) -> None:
        """
        Prepare one quarantine schema for import into live data.
        """

        ...
