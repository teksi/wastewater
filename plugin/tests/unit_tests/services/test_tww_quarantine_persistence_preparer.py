from __future__ import annotations

from unittest.mock import Mock

from teksi_wastewater.hooks.services.tww_quarantine_persistence_preparer import (
    QuarantineAttributeTarget,
    TwwQuarantinePersistencePreparer,
)


def test_constructor_uses_borrowed_session_and_current_dependencies():
    session = Mock()
    preparer = TwwQuarantinePersistencePreparer(
        diff_schema_service=Mock(),
        quarantine_session=session,
        quarantine_classes={},
        model_mapping=Mock(),
        canonical_metadata=Mock(),
        validation_definition=Mock(),
        source_role="base",
    )
    assert preparer.quarantine_session is session
    assert preparer.source_role == "base"


def test_attribute_target_contains_source_and_canonical_identity_fields():
    target = QuarantineAttributeTarget(
        source_class_id="S",
        source_attribute_id="a",
        canonical_class_id="C",
        canonical_attribute_id="b",
        source_identity_attribute_id="tid",
        canonical_identity_attribute_id="obj_id",
    )
    assert target.source_identity_attribute_id == "tid"
    assert target.canonical_identity_attribute_id == "obj_id"
