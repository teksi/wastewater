from __future__ import annotations

from unittest.mock import Mock

from teksi_hooks.capabilities.connection import DatabaseConnectionFactory

from teksi_wastewater.hooks import diff_persistor_hook as module


def test_persistor_delegates_to_shared_persist_implementation(monkeypatch) -> None:
    connection_factory = Mock(spec=module.TwwDatabaseConnectionFactory)
    context = Mock()
    context.parameters = {"job_id": "job-1"}
    context.capability.return_value = connection_factory
    shared_hook = Mock()
    shared_hook_type = Mock(return_value=shared_hook)
    diff_schema_service = Mock()

    monkeypatch.setattr(module, "DiffCreatorHook", shared_hook_type)
    monkeypatch.setattr(
        module,
        "TwwDiffSchemaService",
        Mock(return_value=diff_schema_service),
    )

    module.Hook().run_hook(context)

    assert shared_hook.connection_factory is connection_factory
    assert shared_hook.job_id == "job-1"
    assert shared_hook.diff_schema_service is diff_schema_service
    shared_hook._persist_existing_job.assert_called_once_with(
        context=context,
    )
