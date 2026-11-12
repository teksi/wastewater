from __future__ import annotations
from unittest.mock import Mock
from teksi_wastewater.hooks.services.tww_change_creation_service import TwwChangeCreationService


def test_service_accepts_current_collaborators():
    collaborators={name:Mock() for name in ('canonical_metadata','quarantine_runner','diff_schema_service','live_relation_lookup','review_geometry_converter','effect_projector','change_builder','rights_evaluator','object_provider_factory')}
    service=TwwChangeCreationService(**collaborators)
    for name,value in collaborators.items(): assert getattr(service,name) is value
