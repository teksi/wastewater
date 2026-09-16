from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from teksi_hooks.capabilities.relation_lookup import (
    RelationLookupCapability,
)
from teksi_hooks.evaluators.rights import (
    RightsEvaluator,
)
from teksi_hooks.parsers.rights import (
    RightsParser,
)
from teksi_hooks.resolvers.rights import (
    RightsResolver,
)


@dataclass(slots=True)
class TwwRightsEvaluatorFactory:
    """
    Create rights evaluators from wastewater rights configuration.

    Rights templates and profile selection remain plugin responsibilities.
    Rights evaluation remains framework-owned.
    """

    config_dir: Path | None = None

    rights_profile: str | None = None

    def rights_evaluator(
        self,
        *,
        relation_lookup: RelationLookupCapability,
    ) -> RightsEvaluator:
        """
        Load, resolve and return the configured wastewater rights evaluator.
        """

        rights_path = self._rights_path()

        rights = RightsParser().parse_file(
            rights_path,
        )

        resolved_rights = RightsResolver().resolve(
            rights,
        )

        return RightsEvaluator(
            resolved_rights=resolved_rights,
            relation_lookup=relation_lookup,
        )

    def _rights_path(
        self,
    ) -> Path:
        """
        Return the selected wastewater rights configuration path.
        """

        config_dir = (
            self.config_dir
            if self.config_dir is not None
            else Path(__file__).resolve().parents[1] / "config"
        )

        profile = (
            self.rights_profile
            if self.rights_profile is not None
            else "default"
        )

        path = config_dir / "profiles" / f"{profile}.yaml"

        if not path.is_file():
            raise FileNotFoundError(
                f"Rights profile does not exist: {path}"
            )

        return path