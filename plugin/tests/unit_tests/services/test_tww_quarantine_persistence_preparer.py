# tests/unit/hooks/services/test_tww_quarantine_persistence_preparer.py

from __future__ import annotations

from types import SimpleNamespace
from unittest.mock import Mock

import pytest

from teksi_hooks.models.review import (
    ReviewFeature,
)

from teksi_wastewater.hooks.exceptions import (
    DiffSchemaContractError,
)
from teksi_wastewater.hooks.services.tww_quarantine_persistence_preparer import (
    QuarantineAttributeTarget,
    TwwQuarantinePersistencePreparer,
)


class SourceAttribute:
    """
    Minimal SQLAlchemy-like class attribute for unit tests.
    """

    def __init__(
        self,
        name: str,
    ) -> None:
        self.name = name

    def __eq__(
        self,
        other,
    ):
        return (
            self.name,
            other,
        )


class QuarantineChannel:
    """
    Minimal mapped quarantine class for unit tests.
    """

    __table__ = object()

    obj_id = SourceAttribute(
        "obj_id",
    )

    usage_current = SourceAttribute(
        "usage_current",
    )

    usage_planned = SourceAttribute(
        "usage_planned",
    )

    identifier = SourceAttribute(
        "identifier",
    )


class QuarantineReach:
    """
    Second mapped quarantine class for lookup tests.
    """

    __table__ = object()

    obj_id = SourceAttribute(
        "obj_id",
    )

    material = SourceAttribute(
        "material",
    )


class QuarantineClassWithoutIdentity:
    """
    Quarantine class without an obj_id attribute.
    """

    __table__ = object()

    usage_current = SourceAttribute(
        "usage_current",
    )


class QuarantineClassContainer:
    """
    Attribute-based quarantine class container.
    """

    channel = QuarantineChannel
    reach = QuarantineReach

    ignored_value = "not-an-orm-class"


def _feature(
    *,
    class_id: str = "channel",
    object_id: str = "object-1",
    is_created: bool = False,
    is_altered: bool = True,
    is_deleted: bool = False,
    unpermitted_values=None,
    permission_findings=None,
) -> ReviewFeature:
    return ReviewFeature(
        class_id=class_id,
        object_id=object_id,
        attributes={
            "is_created": is_created,
            "is_altered": is_altered,
            "is_deleted": is_deleted,
            "unpermitted_values": (
                {}
                if unpermitted_values is None
                else unpermitted_values
            ),
            "permission_findings": (
                []
                if permission_findings is None
                else permission_findings
            ),
        },
        geometries={},
    )


def _class_mapping(
    *,
    canonical_class_id: str,
    attributes=None,
    function=None,
):
    return SimpleNamespace(
        canonical_class_id=canonical_class_id,
        attributes=(
            {}
            if attributes is None
            else attributes
        ),
        function=function,
    )


def _attribute_mapping(
    *,
    canonical_class_id: str,
    canonical_attr_id: str,
):
    return SimpleNamespace(
        canonical_class_id=canonical_class_id,
        canonical_attr_id=canonical_attr_id,
    )


def _query(
    *,
    rows,
) -> Mock:
    query = Mock()
    filter_result = Mock()
    limit_result = Mock()

    query.filter.return_value = filter_result
    filter_result.limit.return_value = limit_result
    limit_result.all.return_value = list(
        rows,
    )

    return query


def _service(
    *,
    features_by_class=None,
    quarantine_classes=None,
    class_mappings=None,
    mandatory_attributes=None,
    query_rows=None,
) -> tuple[
    TwwQuarantinePersistencePreparer,
    Mock,
    Mock,
    Mock,
    Mock,
]:
    diff_schema_service = Mock()
    quarantine_session = Mock()
    model_mapping = Mock()
    canonical_metadata = Mock()
    validation_definition = Mock()

    diff_schema_service.review_features.return_value = (
        {}
        if features_by_class is None
        else features_by_class
    )

    configured_class_mappings = (
        {}
        if class_mappings is None
        else class_mappings
    )

    model_mapping.try_class_definition.side_effect = (
        lambda source_class_id: (
            configured_class_mappings.get(
                source_class_id,
            )
        )
    )

    validation_definition.mandatory_for_class.side_effect = (
        lambda canonical_class_id: (
            (
                {}
                if mandatory_attributes is None
                else mandatory_attributes
            ).get(
                canonical_class_id,
                frozenset(),
            )
        )
    )

    rows = (
        []
        if query_rows is None
        else query_rows
    )

    quarantine_session.query.side_effect = (
        lambda _source_class: _query(
            rows=rows,
        )
    )

    service = TwwQuarantinePersistencePreparer(
        diff_schema_service=diff_schema_service,
        quarantine_session=quarantine_session,
        quarantine_classes=(
            {
                "channel": QuarantineChannel,
            }
            if quarantine_classes is None
            else quarantine_classes
        ),
        model_mapping=model_mapping,
        canonical_metadata=canonical_metadata,
        validation_definition=validation_definition,
    )

    return (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    )


def test_prepare_commits_flushes_and_closes_session(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service()

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    diff_schema_service.review_features.assert_called_once_with(
        job_id="job-1",
    )

    quarantine_session.flush.assert_called_once_with()
    quarantine_session.commit.assert_called_once_with()
    quarantine_session.rollback.assert_not_called()
    quarantine_session.close.assert_called_once_with()


def test_prepare_rolls_back_and_closes_session_on_failure(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service()

    diff_schema_service.review_features.side_effect = (
        RuntimeError(
            "Could not load review features.",
        )
    )

    with pytest.raises(
        RuntimeError,
        match="Could not load review features",
    ):
        service.prepare(
            job_id="job-1",
            import_schema="xtf_import",
        )

    quarantine_session.flush.assert_not_called()
    quarantine_session.commit.assert_not_called()
    quarantine_session.rollback.assert_called_once_with()
    quarantine_session.close.assert_called_once_with()


def test_prepare_nulls_unpermitted_non_mandatory_attribute(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
        usage_current="mixed",
    )

    feature = _feature(
        class_id="channel",
        object_id="object-1",
        unpermitted_values={
            "usage_current": "mixed",
        },
    )

    class_mapping = _class_mapping(
        canonical_class_id="channel",
        attributes={
            "usage_current": _attribute_mapping(
                canonical_class_id="channel",
                canonical_attr_id="usage_current",
            ),
        },
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        class_mappings={
            "channel": class_mapping,
        },
        mandatory_attributes={
            "channel": frozenset(),
        },
        query_rows=[
            source_row,
        ],
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    assert source_row.usage_current is None

    validation_definition.mandatory_for_class.assert_called_once_with(
        "channel",
    )

    quarantine_session.flush.assert_called_once_with()
    quarantine_session.commit.assert_called_once_with()
    quarantine_session.rollback.assert_not_called()
    quarantine_session.close.assert_called_once_with()


def test_prepare_preserves_permitted_attribute(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
        usage_current="mixed",
    )

    feature = _feature(
        class_id="channel",
        object_id="object-1",
        unpermitted_values={},
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        query_rows=[
            source_row,
        ],
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    assert source_row.usage_current == "mixed"

    quarantine_session.query.assert_not_called()
    quarantine_session.delete.assert_not_called()
    quarantine_session.commit.assert_called_once_with()


def test_prepare_preserves_mandatory_unpermitted_attribute(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
        identifier="required-value",
    )

    feature = _feature(
        class_id="channel",
        object_id="object-1",
        unpermitted_values={
            "identifier": "submitted-value",
        },
    )

    class_mapping = _class_mapping(
        canonical_class_id="channel",
        attributes={
            "identifier": _attribute_mapping(
                canonical_class_id="channel",
                canonical_attr_id="identifier",
            ),
        },
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        class_mappings={
            "channel": class_mapping,
        },
        mandatory_attributes={
            "channel": frozenset(
                {
                    "identifier",
                }
            ),
        },
        query_rows=[
            source_row,
        ],
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    assert source_row.identifier == "required-value"

    quarantine_session.query.assert_not_called()
    quarantine_session.commit.assert_called_once_with()
    quarantine_session.rollback.assert_not_called()


def test_prepare_nulls_multiple_unpermitted_attributes(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
        usage_current="mixed",
        usage_planned="storm_water",
    )

    feature = _feature(
        class_id="channel",
        object_id="object-1",
        unpermitted_values={
            "usage_current": "mixed",
            "usage_planned": "storm_water",
        },
    )

    class_mapping = _class_mapping(
        canonical_class_id="channel",
        attributes={
            "usage_current": _attribute_mapping(
                canonical_class_id="channel",
                canonical_attr_id="usage_current",
            ),
            "usage_planned": _attribute_mapping(
                canonical_class_id="channel",
                canonical_attr_id="usage_planned",
            ),
        },
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        class_mappings={
            "channel": class_mapping,
        },
        mandatory_attributes={
            "channel": frozenset(),
        },
        query_rows=[
            source_row,
        ],
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    assert source_row.usage_current is None
    assert source_row.usage_planned is None

    assert quarantine_session.query.call_count == 2
    quarantine_session.commit.assert_called_once_with()


def test_prepare_ignores_non_altered_feature_for_attribute_nulling(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
        usage_current="mixed",
    )

    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=False,
        is_altered=False,
        is_deleted=True,
        unpermitted_values={
            "usage_current": "mixed",
        },
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        query_rows=[
            source_row,
        ],
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    assert source_row.usage_current == "mixed"

    quarantine_session.query.assert_not_called()
    quarantine_session.delete.assert_not_called()
    quarantine_session.commit.assert_called_once_with()


def test_prepare_removes_forbidden_created_object(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
    )

    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=True,
        is_altered=False,
        permission_findings=[
            {
                "attribute_name": None,
                "message": "Create is not permitted.",
            },
        ],
    )

    class_mapping = _class_mapping(
        canonical_class_id="channel",
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        class_mappings={
            "channel": class_mapping,
        },
        query_rows=[
            source_row,
        ],
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    quarantine_session.delete.assert_called_once_with(
        source_row,
    )

    quarantine_session.flush.assert_called_once_with()
    quarantine_session.commit.assert_called_once_with()
    quarantine_session.rollback.assert_not_called()


def test_prepare_treats_empty_attribute_name_as_object_level_finding(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
    )

    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=True,
        is_altered=False,
        permission_findings=[
            {
                "attribute_name": "",
            },
        ],
    )

    class_mapping = _class_mapping(
        canonical_class_id="channel",
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        class_mappings={
            "channel": class_mapping,
        },
        query_rows=[
            source_row,
        ],
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    quarantine_session.delete.assert_called_once_with(
        source_row,
    )


def test_prepare_does_not_remove_created_object_for_attribute_finding(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
        usage_current="mixed",
    )

    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=True,
        is_altered=False,
        permission_findings=[
            {
                "attribute_name": "usage_current",
            },
        ],
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        query_rows=[
            source_row,
        ],
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    quarantine_session.delete.assert_not_called()
    quarantine_session.commit.assert_called_once_with()


def test_prepare_rejects_non_array_permission_findings(
) -> None:
    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=True,
        is_altered=False,
        permission_findings={
            "message": "Invalid persisted shape.",
        },
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
    )

    with pytest.raises(
        DiffSchemaContractError,
        match=(
            "permission findings must contain "
            "a JSON array"
        ),
    ):
        service.prepare(
            job_id="job-1",
            import_schema="xtf_import",
        )

    quarantine_session.commit.assert_not_called()
    quarantine_session.rollback.assert_called_once_with()
    quarantine_session.close.assert_called_once_with()


def test_prepare_rejects_non_object_permission_finding(
) -> None:
    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=True,
        is_altered=False,
        permission_findings=[
            "invalid-finding",
        ],
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
    )

    with pytest.raises(
        DiffSchemaContractError,
        match=(
            "Each persisted permission finding must "
            "contain a JSON object"
        ),
    ):
        service.prepare(
            job_id="job-1",
            import_schema="xtf_import",
        )

    quarantine_session.commit.assert_not_called()
    quarantine_session.rollback.assert_called_once_with()
    quarantine_session.close.assert_called_once_with()


def test_prepare_rejects_non_object_unpermitted_values(
) -> None:
    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_altered=True,
        unpermitted_values=[
            "usage_current",
        ],
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
    )

    with pytest.raises(
        DiffSchemaContractError,
        match=(
            "unpermitted values must contain "
            "a JSON object"
        ),
    ):
        service.prepare(
            job_id="job-1",
            import_schema="xtf_import",
        )

    quarantine_session.commit.assert_not_called()
    quarantine_session.rollback.assert_called_once_with()
    quarantine_session.close.assert_called_once_with()


def test_prepare_rejects_missing_attribute_mapping(
) -> None:
    feature = _feature(
        class_id="channel",
        object_id="object-1",
        unpermitted_values={
            "usage_current": "mixed",
        },
    )

    class_mapping = _class_mapping(
        canonical_class_id="channel",
        attributes={},
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                feature,
            ],
        },
        class_mappings={
            "channel": class_mapping,
        },
        mandatory_attributes={
            "channel": frozenset(),
        },
    )

    with pytest.raises(
        DiffSchemaContractError,
        match=(
            "No quarantine attribute mapping exists"
        ),
    ):
        service.prepare(
            job_id="job-1",
            import_schema="xtf_import",
        )

    quarantine_session.commit.assert_not_called()
    quarantine_session.rollback.assert_called_once_with()
    quarantine_session.close.assert_called_once_with()


def test_source_attribute_targets_ignores_unrelated_mapping(
) -> None:
    class_mapping = _class_mapping(
        canonical_class_id="channel",
        attributes={
            "usage_current": _attribute_mapping(
                canonical_class_id="channel",
                canonical_attr_id="usage_current",
            ),
            "usage_planned": _attribute_mapping(
                canonical_class_id="channel",
                canonical_attr_id="usage_planned",
            ),
        },
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        class_mappings={
            "channel": class_mapping,
        },
    )

    targets = service._source_attribute_targets(
        canonical_class_id="channel",
        canonical_attribute_id="usage_current",
    )

    assert targets == (
        QuarantineAttributeTarget(
            source_class_id="channel",
            source_attribute_id="usage_current",
            canonical_class_id="channel",
            canonical_attribute_id="usage_current",
        ),
    )


def test_source_attribute_targets_ignores_function_mapping(
) -> None:
    function_mapping = Mock()

    class_mapping = _class_mapping(
        canonical_class_id="channel",
        attributes={
            "usage_current": _attribute_mapping(
                canonical_class_id="channel",
                canonical_attr_id="usage_current",
            ),
        },
        function=function_mapping,
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        class_mappings={
            "channel": class_mapping,
        },
    )

    targets = service._source_attribute_targets(
        canonical_class_id="channel",
        canonical_attribute_id="usage_current",
    )

    assert targets == ()


def test_source_attribute_targets_ignores_unknown_source_class(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        class_mappings={},
    )

    targets = service._source_attribute_targets(
        canonical_class_id="channel",
        canonical_attribute_id="usage_current",
    )

    assert targets == ()


def test_source_class_ids_returns_mapping_keys(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        quarantine_classes={
            "channel": QuarantineChannel,
            "reach": QuarantineReach,
        },
    )

    result = service._source_class_ids()

    assert result == (
        "channel",
        "reach",
    )


def test_source_class_ids_returns_mapped_container_attributes(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        quarantine_classes=QuarantineClassContainer,
    )

    result = service._source_class_ids()

    assert set(
        result,
    ) == {
        "channel",
        "reach",
    }


def test_source_class_returns_class_from_mapping(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        quarantine_classes={
            "channel": QuarantineChannel,
        },
    )

    result = service._source_class(
        "channel",
    )

    assert result is QuarantineChannel


def test_source_class_returns_class_from_attribute_container(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        quarantine_classes=QuarantineClassContainer,
    )

    result = service._source_class(
        "channel",
    )

    assert result is QuarantineChannel


def test_source_class_rejects_unknown_class(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        quarantine_classes={},
    )

    with pytest.raises(
        DiffSchemaContractError,
        match="Unknown quarantine class",
    ):
        service._source_class(
            "missing_class",
        )


def test_set_source_attribute_null_rejects_unknown_attribute(
) -> None:
    feature = _feature(
        class_id="channel",
        object_id="object-1",
    )

    target = QuarantineAttributeTarget(
        source_class_id="channel",
        source_attribute_id="missing_attribute",
        canonical_class_id="channel",
        canonical_attribute_id="missing_attribute",
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        quarantine_classes={
            "channel": QuarantineChannel,
        },
    )

    with pytest.raises(
        DiffSchemaContractError,
        match="Unknown quarantine attribute",
    ):
        service._set_source_attribute_null(
            job_id="job-1",
            feature=feature,
            target=target,
        )


def test_source_row_rejects_missing_row(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        query_rows=[],
    )

    with pytest.raises(
        DiffSchemaContractError,
        match="No quarantine object exists",
    ):
        service._source_row(
            job_id="job-1",
            source_class=QuarantineChannel,
            source_class_id="channel",
            source_object_id="missing-object",
        )


def test_try_source_row_returns_none_for_missing_row(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        query_rows=[],
    )

    result = service._try_source_row(
        source_class=QuarantineChannel,
        source_object_id="missing-object",
    )

    assert result is None


def test_try_source_row_returns_matching_row(
) -> None:
    source_row = SimpleNamespace(
        obj_id="object-1",
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        query_rows=[
            source_row,
        ],
    )

    result = service._try_source_row(
        source_class=QuarantineChannel,
        source_object_id="object-1",
    )

    assert result is source_row


def test_try_source_row_rejects_ambiguous_rows(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        query_rows=[
            SimpleNamespace(
                obj_id="object-1",
            ),
            SimpleNamespace(
                obj_id="object-1",
            ),
        ],
    )

    with pytest.raises(
        DiffSchemaContractError,
        match="Multiple quarantine objects exist",
    ):
        service._try_source_row(
            source_class=QuarantineChannel,
            source_object_id="object-1",
        )


def test_try_source_row_rejects_class_without_obj_id(
) -> None:
    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service()

    with pytest.raises(
        DiffSchemaContractError,
        match="does not expose an obj_id identity attribute",
    ):
        service._try_source_row(
            source_class=QuarantineClassWithoutIdentity,
            source_object_id="object-1",
        )


def test_delete_created_source_object_rejects_missing_direct_mapping(
) -> None:
    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=True,
        is_altered=False,
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        class_mappings={},
    )

    with pytest.raises(
        DiffSchemaContractError,
        match="No directly mapped quarantine class exists",
    ):
        service._delete_created_source_object(
            job_id="job-1",
            canonical_class_id="channel",
            feature=feature,
        )


def test_delete_created_source_object_rejects_missing_source_row(
) -> None:
    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=True,
        is_altered=False,
    )

    class_mapping = _class_mapping(
        canonical_class_id="channel",
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        class_mappings={
            "channel": class_mapping,
        },
        query_rows=[],
    )

    with pytest.raises(
        DiffSchemaContractError,
        match="No quarantine object exists for forbidden created",
    ):
        service._delete_created_source_object(
            job_id="job-1",
            canonical_class_id="channel",
            feature=feature,
        )


def test_delete_created_source_object_ignores_function_mapping(
) -> None:
    feature = _feature(
        class_id="channel",
        object_id="object-1",
        is_created=True,
        is_altered=False,
    )

    class_mapping = _class_mapping(
        canonical_class_id="channel",
        function=Mock(),
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        class_mappings={
            "channel": class_mapping,
        },
    )

    with pytest.raises(
        DiffSchemaContractError,
        match="No directly mapped quarantine class exists",
    ):
        service._delete_created_source_object(
            job_id="job-1",
            canonical_class_id="channel",
            feature=feature,
        )

    quarantine_session.delete.assert_not_called()


def test_prepare_processes_multiple_feature_classes(
) -> None:
    channel_row = SimpleNamespace(
        obj_id="channel-1",
        usage_current="mixed",
    )

    reach_row = SimpleNamespace(
        obj_id="reach-1",
        material="concrete",
    )

    channel_feature = _feature(
        class_id="channel",
        object_id="channel-1",
        unpermitted_values={
            "usage_current": "mixed",
        },
    )

    reach_feature = _feature(
        class_id="reach",
        object_id="reach-1",
        unpermitted_values={
            "material": "concrete",
        },
    )

    channel_mapping = _class_mapping(
        canonical_class_id="channel",
        attributes={
            "usage_current": _attribute_mapping(
                canonical_class_id="channel",
                canonical_attr_id="usage_current",
            ),
        },
    )

    reach_mapping = _class_mapping(
        canonical_class_id="reach",
        attributes={
            "material": _attribute_mapping(
                canonical_class_id="reach",
                canonical_attr_id="material",
            ),
        },
    )

    (
        service,
        diff_schema_service,
        quarantine_session,
        model_mapping,
        validation_definition,
    ) = _service(
        features_by_class={
            "channel": [
                channel_feature,
            ],
            "reach": [
                reach_feature,
            ],
        },
        quarantine_classes={
            "channel": QuarantineChannel,
            "reach": QuarantineReach,
        },
        class_mappings={
            "channel": channel_mapping,
            "reach": reach_mapping,
        },
        mandatory_attributes={
            "channel": frozenset(),
            "reach": frozenset(),
        },
    )

    def query_for_class(
        source_class,
    ):
        if source_class is QuarantineChannel:
            return _query(
                rows=[
                    channel_row,
                ],
            )

        if source_class is QuarantineReach:
            return _query(
                rows=[
                    reach_row,
                ],
            )

        raise AssertionError(
            f"Unexpected source class {source_class!r}."
        )

    quarantine_session.query.side_effect = (
        query_for_class
    )

    service.prepare(
        job_id="job-1",
        import_schema="xtf_import",
    )

    assert channel_row.usage_current is None
    assert reach_row.material is None

    quarantine_session.flush.assert_called_once_with()
    quarantine_session.commit.assert_called_once_with()
    quarantine_session.rollback.assert_not_called()
    quarantine_session.close.assert_called_once_with()