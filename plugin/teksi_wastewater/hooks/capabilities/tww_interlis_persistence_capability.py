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