from dataclasses import dataclass
from typing import Any

from teksi_hooks.capabilities.mapping import (
    ModelMappingLookupCapability,
)
from teksi_hooks.services.relation_context_provider import (
    RelationContextProvider,
)
from teksi_wastewater.interlis.model_config import (
    TwwInterlisModelSelection,
)

@dataclass(
    slots=True,
    frozen=True,
)
class TwwSourceRuntimeContext:
    """
    Hold detached and cached runtime services for one imported source.

    SQLAlchemy sessions are deliberately excluded. New operation-scoped
    sessions are supplied when the source is projected or persisted.
    """

    source_role: str

    import_schema: str

    selection_models: TwwInterlisModelSelection

    model_mapping: ModelMappingLookupCapability

    quarantine_classes: Any

    relation_context_provider: (
        RelationContextProvider
    )