from __future__ import annotations

import logging
from pathlib import Path

from teksi_hooks.models.validation import (
    ValidationDefinition,
)

from ..adapters.tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
)
from ..adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)
from ..adapters.tww_incremental_effect_persister import (
    TwwIncrementalEffectPersister,
)
from ..adapters.tww_interlis_persistence_adapter import (
    TwwInterlisPersistenceAdapter,
)
from ..adapters.tww_quarantine_orm_factory import (
    TwwQuarantineClassesFactory,
    TwwQuarantineSessionFactory,
)
from ..adapters.tww_quarantine_runner import (
    TwwQuarantineRunner,
)
from ..evaluators.tww_incremental_effect_evaluator import (
    TwwIncrementalEffectEvaluator,
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


def create_review_application_service(
    *,
    connection_factory: TwwDatabaseConnectionFactory,
    diff_schema_service: TwwDiffSchemaService,
    model_config_dir: Path,
    validation_definition: ValidationDefinition,
    logger: logging.Logger,
) -> TwwReviewApplicationService:
    """
    Compose the shared accepted-review application workflow.
    """

    connection_factory.apply_to_database_config()

    canonical_model_adapter = (
        TwwCanonicalModelAdapter(
            connection_factory=connection_factory,
        )
    )

    quarantine_runner = TwwQuarantineRunner(
        logger=logger,
        canonical_projection_lookup=(
            canonical_model_adapter
        ),
        incremental_effect_evaluator=(
            TwwIncrementalEffectEvaluator()
        ),
        incremental_effect_persister=(
            TwwIncrementalEffectPersister()
        ),
    )

    persistence_adapter = (
        TwwInterlisPersistenceAdapter(
            quarantine_runner=quarantine_runner,
        )
    )

    persistence_service = (
        TwwReviewPersistenceService(
            diff_schema_service=diff_schema_service,
            backup_service=(
                TwwDatabaseBackupService(
                    connection_factory=(
                        connection_factory
                    ),
                )
            ),
            persistence_adapter=(
                persistence_adapter
            ),
            logger=logger,
        )
    )

    return TwwReviewApplicationService(
        diff_schema_service=diff_schema_service,
        persistence_context_factory=(
            TwwPersistenceContextFactory(
                connection_factory=(
                    connection_factory
                ),
                model_config_dir=model_config_dir,
                quarantine_classes_factory=(
                    TwwQuarantineClassesFactory()
                ),
                quarantine_session_factory=(
                    TwwQuarantineSessionFactory()
                ),
                logger=logger,
            )
        ),
        persistence_service=persistence_service,
        canonical_model_adapter=(
            canonical_model_adapter
        ),
        validation_definition=validation_definition,
    )