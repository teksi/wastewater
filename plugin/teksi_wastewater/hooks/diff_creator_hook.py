from __future__ import annotations

import os
from collections.abc import Mapping
from pathlib import Path
from typing import Any
from uuid import uuid4

import yaml
from teksi_hooks.capabilities.conditions import ConditionsCapability
from teksi_hooks.capabilities.connection import DatabaseConnectionFactory
from teksi_hooks.capabilities.mapping import (
    EffectiveModelMappingCapability,
    ModelMappingCapability,
)
from teksi_hooks.capabilities.privilege import ResolvedProviderCapability
from teksi_hooks.capabilities.rights import (
    DerivedRightsCapability,
    RightsCapability,
    SubclassRightsCapability,
)
from teksi_hooks.evaluators.rights import RightsEvaluationBaseContext, RightsEvaluator
from teksi_hooks.exceptions import RightsEvaluationError
from teksi_hooks.hook import (
    HookBase,
    HookContext,
    HookMetadata,
)
from teksi_hooks.models.oid import Oid, Standardoid
from teksi_hooks.models.privilege import ALL_PRIVILEGES
from teksi_hooks.models.provider import ResolvedProvider
from teksi_hooks.parser.model_mapping_parser import ModelMappingParser
from teksi_hooks.parser.provider_rights_parser import ProviderRightsParser
from teksi_hooks.parser.rights_parser import RightsParser
from teksi_hooks.parser.validation_parser import ValidationParser
from teksi_hooks.resolver.provider_resolver import ProviderResolver
from teksi_hooks.resolver.rights_resolver import RightsResolver
from teksi_wastewater.hooks.adapters.tww_canonical_model_adapter import (
    TwwCanonicalModelAdapter,
)
from teksi_wastewater.hooks.adapters.tww_database_connection_factory import (
    TwwDatabaseConnectionFactory,
)
from teksi_wastewater.hooks.adapters.tww_implicit_model_mapping_adapter import (
    TwwImplicitModelMappingAdapter,
)
from teksi_wastewater.hooks.adapters.tww_interlis_persistence_adapter import (
    TwwInterlisPersistenceAdapter,
)
from teksi_wastewater.hooks.adapters.tww_interlis_service_adapter import (
    TwwInterlisContext,
    TwwInterlisServiceAdapter,
)
from teksi_wastewater.hooks.adapters.tww_quarantine_effect_projector import (
    TwwQuarantineEffectProjector,
)
from teksi_wastewater.hooks.adapters.tww_quarantine_runner import (
    TwwQuarantineRunner,
)
from teksi_wastewater.hooks.adapters.tww_relation_context_provider import (
    TwwRelationContextProvider,
)
from teksi_wastewater.hooks.adapters.tww_relation_lookup_adapter import (
    TwwRelationLookupAdapter,
)
from teksi_wastewater.hooks.services.tww_change_creation_service import (
    ChangeObjectProviderFactory,
    TwwChangeCreationService,
)
from teksi_wastewater.hooks.services.tww_database_backup_service import (
    TwwDatabaseBackupService,
)
from teksi_wastewater.hooks.services.tww_diff_review_service import (
    TwwDiffReviewService,
)
from teksi_wastewater.hooks.services.tww_diff_schema_service import (
    DiffJobMode,
    TwwDiffSchemaService,
)
from teksi_wastewater.hooks.services.tww_quarantine_persistence_preparer import (
    TwwQuarantinePersistencePreparer,
)
from teksi_wastewater.hooks.services.tww_review_persistence_service import (
    TwwReviewPersistenceService,
)
from teksi_wastewater.interlis import (
    config,
)


class Hook(
    HookBase,
):
    """
    Create a tww_diff review job from an XTF import.
    """

    required_capabilities = frozenset(
        {
            ChangeObjectProviderFactory,
        }
    )

    @property
    def metadata(
        self,
    ) -> HookMetadata:
        return HookMetadata(
            name="Create TWW Diff Review Job",
            description=(
                "Imports an XTF into quarantine, projects it to canonical "
                "changes, classifies validation and permission findings, and "
                "writes a pending review job into tww_diff."
            ),
        )

    def run_hook(
        self,
        context: HookContext,
    ) -> None:
        parameters = context.parameters
        context.logger.info("Starting diff creator hook")
        self.connection_factory = context.capability(
            DatabaseConnectionFactory,
        )

        if not isinstance(
            self.connection_factory,
            TwwDatabaseConnectionFactory,
        ):
            raise TypeError("The TWW diff hook requires TwwDatabaseConnectionFactory.")

        self.interlis_service = TwwInterlisServiceAdapter(
            connection_factory=self.connection_factory,
        )

        self.job_id = parameters.get("job_id", str(uuid4()))
        self.job_mode = DiffJobMode(
            parameters.get(
                "job_mode",
                DiffJobMode.CREATE,
            )
        )
        xtf_file = self._optional_path(
            parameters["xtf_input"],
        )
        import_schema = parameters.get(
            "import_schema",
            config.IMPORT_SCHEMA,
        )
        self.live_schema = parameters.get(
            "live_schema",
            config.TWW_OD_SCHEMA,
        )
        self.orgs_path = self._optional_path(
            parameters.get(
                "orgs_path",
            )
        )
        incremental_xtf = self._optional_path(
            parameters.get(
                "incremental_xtf",
            )
        )
        skip_rights_evaluation = parameters.get(
            "skip_rights_evaluation",
        )
        incremental_import_schema = parameters.get(
            "incremental_import_schema", config.IMPORT_SCHEMA_INCR
        )
        hook_config_dir = self._optional_path(
            parameters.get(
                "hook_config_dir",
            )
        ) or (
            Path(
                os.environ["TWW_DIFF_CONF_DIR"],
            )
            if "TWW_DIFF_CONF_DIR" in os.environ
            else None
        )

        auto_apply = parameters.get("auto_apply", False)

        self.provider_oid = Standardoid(parameters["provider_oid"])
        self.dataowner_oid = Standardoid(parameters["dataowner_oid"])

        self.model_config_dir = self._model_config_dir()

        self.validation_definition = ValidationParser().parse_file(
            self.model_config_dir / "validations.yaml",
        )

        provider_rights_path, rights_definition_path = self._eval_rights_profile(
            hook_config_dir,
            parameters.get(
                "rights_profile",
                "default",
            ),
        )
        self.rights_definition = RightsParser().parse_file(rights_definition_path)
        raw_provider_rights = ProviderRightsParser(oid_type=Standardoid).parse_file(
            provider_rights_path
        )
        resolved_providers = ProviderResolver().resolve_all(providers=raw_provider_rights)
        if skip_rights_evaluation:
            resolved_providers = self._grant_all(resolved_providers)
        try:
            self.resolved_provider = resolved_providers[self.provider_oid]
        except KeyError as exception:
            raise RightsEvaluationError.from_message(
                "No provider-rights definition exists for " f"provider {self.provider_oid!s}."
            ) from exception

        self.rights_context = RightsEvaluationBaseContext(
            provider_oid=self.provider_oid,
            dataowner_oid=self.dataowner_oid,
            context_values={
                "provider_oid": self.provider_oid,
                "dataowner_oid": self.dataowner_oid,
            },
        )

        # create adapters and services
        quarantine_runner = TwwQuarantineRunner(
            logger=context.logger,
        )

        canonical_model = TwwCanonicalModelAdapter(
            connection_factory=self.connection_factory,
        )

        diff_schema_service = TwwDiffSchemaService(
            connection_factory=self.connection_factory,
        )
        relation_lookup = TwwRelationLookupAdapter(
            schema=self.live_schema,
            connection_factory=self.connection_factory,
        )

        canonical_metadata = canonical_model.canonical_model()

        resolved_rights = RightsResolver().resolve(
            definition=self.rights_definition,
            validation_definition=self.validation_definition,
        )

        rights_capability = RightsCapability(
            resolved_rights,
        )

        provider_capability = ResolvedProviderCapability(
            self.resolved_provider,
        )

        conditions_capability = ConditionsCapability()

        derived_rights_capability = DerivedRightsCapability(
            resolved_rights,
        )

        subclass_rights_capability = SubclassRightsCapability(
            resolved_rights,
        )

        rights_evaluator = RightsEvaluator(
            rights=rights_capability,
            provider=provider_capability,
            conditions=conditions_capability,
            derived_rights=derived_rights_capability,
            relation_lookup=relation_lookup,
            subclass_rights=subclass_rights_capability,
        )

        if incremental_xtf is None:
            result = self.run_sub_verification(
                xtf_file=xtf_file,
                schema=import_schema,
                quarantine_runner=quarantine_runner,
                canonical_metadata=canonical_metadata,
                diff_schema_service=diff_schema_service,
                rights_evaluator=rights_evaluator,
                context=context,
                is_incremental=False,
                final_diff_run=True,
            )
        else:
            if xtf_file is not None:
                _ = self.run_sub_verification(
                    xtf_file=xtf_file,
                    schema=import_schema,
                    quarantine_runner=quarantine_runner,
                    canonical_metadata=canonical_metadata,
                    diff_schema_service=diff_schema_service,
                    rights_evaluator=rights_evaluator,
                    context=context,
                    is_incremental=False,
                    final_diff_run=False,
                )

            result = self.run_sub_verification(
                xtf_file=incremental_xtf,
                schema=incremental_import_schema,
                quarantine_runner=quarantine_runner,
                canonical_model=canonical_model,
                diff_schema_service=diff_schema_service,
                rights_evaluator=rights_evaluator,
                context=context,
                is_incremental=True,
                final_diff_run=True,
            )

        if auto_apply:
            if result.diff_schema_result is None:
                raise RuntimeError(
                    "The reviewed import did not create a persisted " "tww_diff review job."
                )
            diff_review_service = TwwDiffReviewService(
                diff_schema_service=diff_schema_service,
            )

            quarantine_preparer = TwwQuarantinePersistencePreparer(
                connection_factory=(self.connection_factory),
                diff_schema_service=(diff_schema_service),
            )
            backup_service = TwwDatabaseBackupService(
                connection_factory=self.connection_factory,
            )
            persistence_adapter = TwwInterlisPersistenceAdapter(
                connection_factory=(self.connection_factory),
                interlis_service=(self.interlis_service),
                model_config_dir=(self.model_config_dir),
            )
            review_persistence_service = TwwReviewPersistenceService(
                diff_schema_service=(diff_schema_service),
                quarantine_preparer=(quarantine_preparer),
                backup_service=backup_service,
                persistence_adapter=(persistence_adapter),
            )
            diff_review_service.accept_job(
                job_id=result.job_id,
            )

            persistence_result = review_persistence_service.persist_job(
                job_id=result.job_id,
                live_schema=self.live_schema,
            )

            if persistence_result.job_status != "applied":
                raise RuntimeError(
                    "The reviewed import completed without reaching "
                    f"the 'applied' state. Job {result.job_id!r} has "
                    f"status {persistence_result.job_status!r}."
                )

            context.logger.info(
                "Applied reviewed tww_diff job '%s' with %s review "
                "features, of which %s were permission-restricted.",
                persistence_result.job_id,
                persistence_result.review_feature_count,
                persistence_result.restricted_feature_count,
            )

            return
        else:
            # store diffs in a sensible way
            # send out information mails if needed
            # etc.
            pass

    def run_sub_verification(
        self,
        xtf_file,
        schema,
        quarantine_runner,
        canonical_metadata,
        diff_schema_service,
        rights_evaluator,
        context,
        is_incremental: bool = False,
        final_diff_run: bool = True,
    ):

        model_selection = self.interlis_service.identify_model(xtf_file)
        if model_selection.group in {"ag64", "ag96"}:
            import_context = TwwInterlisContext(
                schema=schema,
                import_orgs=False,
                orgs_path=None,
            )
        else:
            import_context = TwwInterlisContext(
                schema=schema,
                import_orgs=self.orgs_path is not None,
                orgs_path=self.orgs_path,
            )

        context.logger.info(f"importing {xtf_file} to quarantine.")
        selection_models = quarantine_runner.import_xtf_to_quarantine(
            xtf_file=xtf_file,
            context=import_context,
            schema=schema,
        )

        context.logger.info(f"Import schema models: {selection_models.import_schema_models}")
        context.logger.info(f"Import model: {selection_models.import_model}")
        context.logger.info(f"Validation models: {selection_models.validation_models}")

        quarantine_runner.validate_quarantine_or_raise(
            model_names=selection_models.validation_models,
            log_path=xtf_file.with_name(f"{xtf_file.stem}_validate_import_quarantine.log"),
            schema=schema,
        )

        explicit_mapping = ModelMappingParser().parse_file(
            self.model_config_dir / "explicit_mapping.yaml",
            model_id=model_selection.mapping_model_id,
        )

        explicit_mapping_capability = ModelMappingCapability(
            mapping=explicit_mapping,
        )

        quarantine_classes = self._get_quarantine_classes(
            model_selection=model_selection, schema=schema
        )

        implicit_mapping_capability = TwwImplicitModelMappingAdapter(
            connection_factory=self.connection_factory,
            import_schema=schema,
            language=model_selection.language,
        )

        effective_mapping = EffectiveModelMappingCapability(
            explicit_mapping=explicit_mapping_capability,
            implicit_mapping=implicit_mapping_capability,
        )

        relation_context_provider = TwwRelationContextProvider(
            quarantine_classes=quarantine_classes,
            model_mapping=effective_mapping,
            import_schema=schema,
        )

        effect_projector = TwwQuarantineEffectProjector(
            connection_factory=self.connection_factory,
            relation_context_provider=relation_context_provider,
            model_mapping=effective_mapping,
        )

        service = TwwChangeCreationService(
            connection_factory=self.connection_factory,
            quarantine_runner=quarantine_runner,
            canonical_metadata=canonical_metadata,
            effect_projector=effect_projector,
            rights_evaluator=rights_evaluator,
            object_provider_factory=context.capability(
                ChangeObjectProviderFactory,
            ),
            diff_schema_service=diff_schema_service,
        )

        result = service.create_diff_job_from_xtf(
            job_id=self.job_id,
            job_mode=self.job_mode,
            xtf_file=xtf_file,
            orgs_path=self.orgs_path,
            rights_context=self.rights_context,
            import_schema=schema,
            live_schema=self.live_schema,
            metadata={
                "source_role": ("incremental" if is_incremental else "base"),
                "source_xtf": str(
                    xtf_file,
                ),
                "source_schema": schema,
                "model_group": (model_selection.group),
                "model_language": (model_selection.language),
                "mapping_model_id": (model_selection.mapping_model_id),
                "persist_job": final_diff_run,
            },
        )

        context.logger.info(
            "Prepared tww_diff review job '%s' for xtf file %s.",
            result.job_id,
            xtf_file,
        )
        if final_diff_run:
            context.logger.info(
                "Created tww_diff review job '%s' with %s rows.",
                result.job_id,
                (
                    result.diff_schema_result.row_count
                    if result.diff_schema_result is not None
                    else "unknown"
                ),
            )

            return result

    def _optional_path(
        self,
        value,
    ) -> Path | None:
        if value in (
            None,
            "",
        ):
            return None

        return Path(
            value,
        )

    def _eval_rights_profile(
        self,
        config_dir: Path | None,
        rights_profile: str,
    ) -> tuple[
        Path,
        Path,
    ]:
        """
        Resolve the provider-rights and provider-privileges templates configured
        for one rights profile.

        Paths in ``rights_profiles.yaml`` are resolved relative to the configured
        validation directory.
        """

        if config_dir is None:
            raise RightsEvaluationError.from_message("Config directory is not set.")

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
                "Rights-profile configuration must contain a mapping "
                f"of profile identifiers: {profiles_path}"
            )

        raw_profile = raw_profiles.get(
            rights_profile,
        )

        if raw_profile is None:
            available_profiles = ", ".join(
                sorted(
                    str(
                        profile_name,
                    )
                    for profile_name in raw_profiles
                )
            )

            raise RightsEvaluationError.from_message(
                f"Unknown rights profile {rights_profile!r}. "
                f"Available profiles: {available_profiles or 'none'}."
            )

        if not isinstance(
            raw_profile,
            Mapping,
        ):
            raise RightsEvaluationError.from_message(
                f"Rights profile {rights_profile!r} must be a mapping."
            )

        provider_rights_path = self._profile_template_path(
            config_dir=config_dir,
            profile_name=rights_profile,
            profile=raw_profile,
            key="provider_rights",
        )

        rights_definition_path = self._profile_template_path(
            config_dir=config_dir,
            profile_name=rights_profile,
            profile=raw_profile,
            key="rights_definition",
        )

        missing_paths = [
            path
            for path in (
                provider_rights_path,
                rights_definition_path,
            )
            if not path.is_file()
        ]

        if missing_paths:
            raise RightsEvaluationError.from_message(
                f"Rights profile {rights_profile!r} is incomplete. Missing: "
                + ", ".join(
                    str(
                        path,
                    )
                    for path in missing_paths
                )
            )

        return (
            provider_rights_path,
            rights_definition_path,
        )

    def _profile_template_path(
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
        """
        Resolve one template path from a rights-profile definition.

        Relative paths are resolved against ``config_dir``. Absolute paths remain
        supported for explicitly configured external templates.
        """
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
                f"Rights profile {profile_name!r} must define a non-empty " f"{key!r} path."
            )

        path = Path(
            raw_path,
        ).expanduser()

        if not path.is_absolute():
            path = config_dir / path

        return path.resolve()

    def _model_config_dir(
        self,
    ) -> Path:
        """
        Return the absolute path to immutable model configuration shipped with
        the hook.
        """

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

    def _grant_all(
        self,
        providers: Mapping[
            Oid,
            ResolvedProvider,
        ],
    ) -> dict[
        Oid,
        ResolvedProvider,
    ]:
        """
        Grant every resolved provider all privileges for its configured data owners.

        Provider identities and data-owner scopes remain unchanged. Only the
        privilege sets are replaced by the ``ALL_PRIVILEGES`` sentinel.

        This is intended exclusively for trusted baseline imports where rights
        evaluation must run normally but must not reject any configured provider
        operation.
        """

        return {
            provider_oid: ResolvedProvider(
                name=provider.name,
                organisation_oid=(provider.organisation_oid),
                permissions={
                    dataowner_oid: frozenset(
                        {
                            ALL_PRIVILEGES,
                        }
                    )
                    for dataowner_oid in provider.permissions
                },
            )
            for provider_oid, provider in providers.items()
        }

    def _get_quarantine_classes(self, model_selection, schema):

        quarantine_model = model_selection.primary_component.quarantine_model(
            schema=schema,
        )

        return quarantine_model.classes()
