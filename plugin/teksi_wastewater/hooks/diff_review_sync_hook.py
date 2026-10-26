from __future__ import annotations

from pathlib import Path
from typing import Any
from collections.abc import Mapping

import yaml
from teksi_hooks.capabilities.conditions import (
    ConditionsCapability,
)
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.capabilities.privilege import (
    ResolvedProviderCapability,
)
from teksi_hooks.capabilities.rights import (
    DerivedRightsCapability,
    RightsCapability,
    SubclassRightsCapability,
)
from teksi_hooks.evaluators.rights import (
    RightsEvaluationBaseContext,
    RightsEvaluator,
)
from teksi_hooks.exceptions import (
    RightsEvaluationError,
)
from teksi_hooks.hook import (
    HookBase,
    HookContext,
    HookMetadata,
)
from teksi_hooks.models.oid import (
    Standardoid,
)
from teksi_hooks.parser.provider_rights_parser import (
    ProviderRightsParser,
)
from teksi_hooks.parser.rights_parser import (
    RightsParser,
)
from teksi_hooks.parser.validation_parser import (
    ValidationParser,
)
from teksi_hooks.resolver.provider_resolver import (
    ProviderResolver,
)
from teksi_hooks.resolver.rights_resolver import (
    RightsResolver,
)
from teksi_wastewater.hooks.adapters.tww_change_object_provider import (
    TwwChangeObjectProviderFactory,
)
from teksi_wastewater.hooks.adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)
from teksi_wastewater.hooks.adapters.tww_relation_lookup_adapter import (
    TwwRelationLookupAdapter,
)
from teksi_wastewater.hooks.services.tww_diff_job_refresh_service import (
    TwwDiffJobRefreshService,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    TwwDiffSchemaService,
)
from teksi_wastewater.interlis import (
    config,
)


class Hook(
    HookBase,
):
    """
    Refresh one pending TWW diff review job.

    The hook does not rerun ili2pg. It compares the retained proposed state
    and current live state with the state represented by the pending review
    job, then updates generated findings and review values for affected
    objects.
    """

    required_capabilities = frozenset(
        {
            DatabaseConnectionFactory,
        }
    )

    @property
    def metadata(
        self,
    ) -> HookMetadata:
        return HookMetadata(
            name="Refresh Pending TWW Diff Review Job",
            description=(
                "Refreshes one pending tww_diff review job against "
                "updated live and retained quarantine data without "
                "rerunning the XTF import."
            ),
        )

    def run_hook(
        self,
        context: HookContext,
    ) -> None:
        parameters = context.parameters

        context.logger.info("Starting pending diff review refresh hook.")

        connection_factory = context.capability(
            DatabaseConnectionFactory,
        )

        if not isinstance(
            connection_factory,
            TwwDatabaseConnectionFactory,
        ):
            raise TypeError("The TWW diff refresh hook requires " "TwwDatabaseConnectionFactory.")

        job_id = self._required_string(
            parameters=parameters,
            key="job_id",
        )

        hook_config_dir = self._required_path(
            parameters=parameters,
            key="hook_config_dir",
        )

        rights_profile = self._optional_string(
            parameters=parameters,
            key="rights_profile",
            default="default",
        )

        dry_run = self._optional_boolean(
            parameters=parameters,
            key="dry_run",
            default=False,
        )

        force = self._optional_boolean(
            parameters=parameters,
            key="force",
            default=False,
        )

        diff_schema_service = TwwDiffSchemaService(
            connection_factory=connection_factory,
        )

        job = diff_schema_service.require_review_job(
            job_id=job_id,
            include_features=True,
        )

        if job.job_status != "pending":
            raise DiffJobStateError(
                job_id=job_id,
                expected_status="pending",
                actual_status=job.job_status,
            )

        live_schema = (
            job.get(
                "live_schema",
            )
            or config.TWW_OD_SCHEMA
        )

        provider_oid = Standardoid(
            self._metadata_string(
                job=job,
                key="provider_oid",
            )
        )

        dataowner_oid = Standardoid(
            self._metadata_string(
                job=job,
                key="dataowner_oid",
            )
        )

        validation_definition = ValidationParser().parse_file(
            self._model_config_dir() / "validations.yaml",
        )

        (
            provider_rights_path,
            rights_definition_path,
        ) = self._eval_rights_profile(
            config_dir=hook_config_dir,
            rights_profile=rights_profile,
        )

        rights_definition = RightsParser().parse_file(
            rights_definition_path,
        )

        raw_provider_rights = ProviderRightsParser(
            oid_type=Standardoid,
        ).parse_file(
            provider_rights_path,
        )

        resolved_providers = ProviderResolver().resolve_all(
            providers=raw_provider_rights,
        )

        try:
            resolved_provider = resolved_providers[provider_oid]

        except KeyError as exception:
            raise RightsEvaluationError.from_message(
                "No provider-rights definition exists for " f"provider {provider_oid!s}."
            ) from exception

        resolved_rights = RightsResolver().resolve(
            definition=rights_definition,
            validation_definition=validation_definition,
        )

        live_relation_lookup = TwwRelationLookupAdapter(
            schema=live_schema,
            connection_factory=connection_factory,
        )

        rights_evaluator = RightsEvaluator(
            rights=RightsCapability(
                resolved_rights,
            ),
            provider=ResolvedProviderCapability(
                resolved_provider,
            ),
            conditions=ConditionsCapability(),
            derived_rights=DerivedRightsCapability(
                resolved_rights,
            ),
            relation_lookup=live_relation_lookup,
            subclass_rights=SubclassRightsCapability(
                resolved_rights,
            ),
        )

        rights_base_context = RightsEvaluationBaseContext(
            provider_oid=provider_oid,
            dataowner_oid=dataowner_oid,
            context_values={
                "provider_oid": provider_oid,
                "dataowner_oid": dataowner_oid,
                "refresh_job_id": job_id,
            },
        )

        change_object_provider_factory = TwwChangeObjectProviderFactory(
            connection_factory=connection_factory,
        )

        refresh_service = TwwDiffJobRefreshService(
            connection_factory=connection_factory,
            diff_schema_service=diff_schema_service,
            rights_evaluator=rights_evaluator,
            object_provider_factory=(change_object_provider_factory),
            live_relation_lookup=live_relation_lookup,
            logger=context.logger,
        )

        result = refresh_service.refresh_pending_job(
            job_id=job_id,
            rights_base_context=rights_base_context,
            dry_run=dry_run,
            force=force,
        )

        context.logger.info(
            "Refreshed pending diff job %r: "
            "affected=%s, live_updates=%s, "
            "quarantine_updates=%s, live_deletions=%s, "
            "findings_changed=%s, decisions_invalidated=%s, "
            "dry_run=%s.",
            result.job_id,
            result.affected_change_count,
            result.live_update_count,
            result.quarantine_update_count,
            result.live_deletion_count,
            result.findings_changed_count,
            result.decisions_invalidated_count,
            dry_run,
        )

    def _required_string(
        self,
        *,
        parameters: Mapping[
            str,
            Any,
        ],
        key: str,
    ) -> str:
        value = parameters.get(
            key,
        )

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise ValueError(f"Parameter {key!r} must be a non-empty string.")

        return value.strip()

    def _optional_string(
        self,
        *,
        parameters: Mapping[
            str,
            Any,
        ],
        key: str,
        default: str,
    ) -> str:
        value = parameters.get(
            key,
            default,
        )

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise ValueError(f"Parameter {key!r} must be a non-empty string.")

        return value.strip()

    def _optional_boolean(
        self,
        *,
        parameters: Mapping[
            str,
            Any,
        ],
        key: str,
        default: bool,
    ) -> bool:
        value = parameters.get(
            key,
            default,
        )

        if not isinstance(
            value,
            bool,
        ):
            raise TypeError(f"Parameter {key!r} must be a boolean.")

        return value

    def _required_path(
        self,
        *,
        parameters: Mapping[
            str,
            Any,
        ],
        key: str,
    ) -> Path:
        value = self._required_string(
            parameters=parameters,
            key=key,
        )

        path = (
            Path(
                value,
            )
            .expanduser()
            .resolve()
        )

        if not path.is_dir():
            raise ValueError(f"Configured directory does not exist: {path}")

        return path

    def _metadata_string(
        self,
        *,
        job: Mapping[
            str,
            Any,
        ],
        key: str,
    ) -> str:
        metadata = job.get(
            "metadata",
            {},
        )

        value = metadata.get(
            key,
        )

        if (
            not isinstance(
                value,
                str,
            )
            or not value.strip()
        ):
            raise ValueError(
                f"Pending job {job.get('job_id')!r} does not " f"contain valid metadata {key!r}."
            )

        return value.strip()

    def _model_config_dir(
        self,
    ) -> Path:
        path = (
            Path(
                __file__,
            )
            .resolve()
            .parent
            / "config"
            / "model"
        )

        if not path.is_dir():
            raise RuntimeError("Model configuration directory does not exist: " f"{path}")

        return path

    def _eval_rights_profile(
        self,
        *,
        config_dir: Path,
        rights_profile: str,
    ) -> tuple[
        Path,
        Path,
    ]:
        profiles_path = config_dir / "rights_profiles.yaml"

        if not profiles_path.is_file():
            raise RightsEvaluationError.from_message(
                "Rights-profile configuration does not exist: " f"{profiles_path}"
            )

        with profiles_path.open(
            encoding="utf-8",
        ) as file:
            raw_profiles: Any = yaml.safe_load(
                file,
            )

        if not isinstance(
            raw_profiles,
            Mapping,
        ):
            raise RightsEvaluationError.from_message(
                "Rights-profile configuration must contain a "
                "mapping of profile identifiers: "
                f"{profiles_path}"
            )

        raw_profile = raw_profiles.get(
            rights_profile,
        )

        if not isinstance(
            raw_profile,
            Mapping,
        ):
            raise RightsEvaluationError.from_message(
                f"Unknown or invalid rights profile " f"{rights_profile!r}."
            )

        provider_rights_path = self._profile_path(
            config_dir=config_dir,
            profile_name=rights_profile,
            profile=raw_profile,
            key="provider_rights",
        )

        rights_definition_path = self._profile_path(
            config_dir=config_dir,
            profile_name=rights_profile,
            profile=raw_profile,
            key="rights_definition",
        )

        return (
            provider_rights_path,
            rights_definition_path,
        )

    def _profile_path(
        self,
        *,
        config_dir: Path,
        profile_name: str,
        profile: Mapping[
            str,
            Any,
        ],
        key: str,
    ) -> Path:
        raw_path = profile.get(
            key,
        )

        if (
            not isinstance(
                raw_path,
                str,
            )
            or not raw_path.strip()
        ):
            raise RightsEvaluationError.from_message(
                f"Rights profile {profile_name!r} must define " f"a non-empty {key!r} path."
            )

        path = Path(
            raw_path,
        ).expanduser()

        if not path.is_absolute():
            path = config_dir / path

        path = path.resolve()

        if not path.is_file():
            raise RightsEvaluationError.from_message(f"Rights-profile file does not exist: {path}")

        return path
