from __future__ import annotations

import logging
from pathlib import Path
from collections.abc import Mapping

from teksi_hooks.models.validation import (
    ValidationDefinition,
)

from ..adapters.tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
)
from ..adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)
from ..adapters.tww_interlis_persistence_adapter import (
    TwwInterlisPersistenceAdapter,
)
from ..adapters.tww_quarantine_orm_factory import (
    TwwQuarantineClassesFactory,
)
from ..adapters.tww_quarantine_runner import (
    TwwQuarantineRunner,
)
from ..adapters.tww_session_manager import (
    TwwSessionManager,
)
from .tww_database_backup_service import (
    TwwDatabaseBackupService,
)
from .tww_diff_schema_service import (
    TwwDiffSchemaService,
)
from .tww_persistence_context_factory import (
    TwwPersistenceContextFactory,
)
from .tww_review_application_service import (
    TwwReviewApplicationService,
)
from .tww_review_persistence_service import (
    TwwReviewPersistenceService,
)
from .tww_source_runtime_context import (
    TwwSourceRuntimeContext,
)


def create_review_application_service(
    *,
    connection_factory: TwwDatabaseConnectionFactory,
    diff_schema_service: TwwDiffSchemaService,
    session_manager: TwwSessionManager,
    canonical_model_adapter: TwwCanonicalModelAdapter,
    quarantine_runner: TwwQuarantineRunner,
    source_runtime_contexts: Mapping[
        str,
        TwwSourceRuntimeContext,
    ],
    model_config_dir: Path,
    validation_definition: ValidationDefinition,
    logger: logging.Logger,
) -> TwwReviewApplicationService:
    """
    Compose the shared accepted-review application workflow.
    """

    persistence_adapter = TwwInterlisPersistenceAdapter(
        quarantine_runner=quarantine_runner,
        source_runtime_contexts=source_runtime_contexts,
    )

    persistence_service = TwwReviewPersistenceService(
        diff_schema_service=diff_schema_service,
        backup_service=(
            TwwDatabaseBackupService(
                connection_factory=(connection_factory),
            )
        ),
        persistence_adapter=(persistence_adapter),
        logger=logger,
    )

    return TwwReviewApplicationService(
        diff_schema_service=diff_schema_service,
        persistence_context_factory=(
            TwwPersistenceContextFactory(
                model_config_dir=model_config_dir,
                quarantine_classes_factory=(TwwQuarantineClassesFactory()),
                logger=logger,
            )
        ),
        session_manager=session_manager,
        persistence_service=persistence_service,
        canonical_model_adapter=(canonical_model_adapter),
        validation_definition=(validation_definition),
    )
