from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass, field

from .config import DEFAULT_INTERLIS_LANGUAGE
from .interlis_model_mapping.model_base import ModelBase
from .interlis_model_mapping.model_interlis_ag64 import ModelInterlisAG64
from .interlis_model_mapping.model_interlis_ag96 import ModelInterlisAG96
from .interlis_model_mapping.model_interlis_dss import ModelInterlisDss
from .interlis_model_mapping.model_interlis_sia405_abwasser import (
    ModelInterlisSia405Abwasser,
)
from .interlis_model_mapping.model_interlis_sia405_base_abwasser import (
    ModelInterlisSia405BaseAbwasser,
)
from .interlis_model_mapping.model_interlis_sia405_cable import (
    ModelInterlisSia405Fernwirkkabel,
)
from .interlis_model_mapping.model_interlis_sia405_protection_tube import (
    ModelInterlisSia405Schutzrohr,
)
from .interlis_model_mapping.model_interlis_vsa_kek import ModelInterlisVsaKek
from .interlis_model_mapping.model_tww_od import ModelTwwOd

ModelFactory = Callable[
    [],
    ModelBase,
]


@dataclass(
    frozen=True,
    slots=True,
)
class InterlisLangModel:
    """
    One language-specific INTERLIS model definition.
    """

    lang: str
    model: str

    topics: frozenset[str] = frozenset()


@dataclass(
    frozen=True,
    slots=True,
)
class InterlisModel:
    """
    Language-specific variants of one semantic model group.
    """

    models: frozenset[InterlisLangModel]

    orm_quarantine_factory: ModelFactory
    orm_live_factory: ModelFactory = field(
        default=ModelTwwOd,
    )

    def quarantine_model(
        self,
        schema: str,
    ) -> ModelBase:
        """
        Return a new ORM model for the quarantine schema.
        """

        return self.orm_quarantine_factory(schema=schema)

    def live_model(
        self,
        schema: str,
    ) -> ModelBase:
        """
        Return a new ORM model for the canonical live schema.
        """

        return self.orm_live_factory(schema=schema)

    @property
    def names(
        self,
    ) -> frozenset:
        """
        Return all language-specific model names.
        """

        return frozenset(model.model for model in self.models)

    @property
    def topics(
        self,
    ) -> frozenset:
        """
        Return all topics from all language variants.
        """

        return frozenset(topic for model in self.models for topic in model.topics)

    @property
    def languages(
        self,
    ) -> frozenset:
        """
        Return all configured language codes.
        """

        return frozenset(model.lang for model in self.models)

    def language_model(
        self,
        lang: str,
        fallback_lang: str = DEFAULT_INTERLIS_LANGUAGE,
    ) -> InterlisLangModel:
        """
        Return the configured model variant for a language.

        If the requested language is unavailable, return the model configured
        for ``fallback_lang``.
        """

        requested_model = next(
            (model for model in self.models if model.lang == lang),
            None,
        )

        if requested_model is not None:
            return requested_model

        fallback_model = next(
            (model for model in self.models if model.lang == fallback_lang),
            None,
        )

        if fallback_model is not None:
            return fallback_model

        raise ValueError(
            "No INTERLIS model is configured for "
            f"language {lang!r} or fallback language "
            f"{fallback_lang!r}. Available languages: "
            f"{sorted(self.languages)!r}."
        )

    def lang_name(
        self,
        lang: str,
        fallback_lang: str = DEFAULT_INTERLIS_LANGUAGE,
    ) -> str:
        """
        Return the model name for a language.

        If the requested language is unavailable, return the model configured
        for ``fallback_lang``.
        """

        return self.language_model(
            lang=lang,
            fallback_lang=fallback_lang,
        ).model

    def topics_by_lang(
        self,
        lang: str,
        fallback_lang: str = DEFAULT_INTERLIS_LANGUAGE,
    ) -> frozenset:
        """
        Return the configured topics for a language.

        If the requested language is unavailable, return the topics configured
        for ``fallback_lang``.
        """

        return self.language_model(
            lang=lang,
            fallback_lang=fallback_lang,
        ).topics


@dataclass(
    slots=True,
    frozen=True,
)
class TwwInterlisModelComponent:
    """
    One configured model participating in an INTERLIS import.
    """

    group: str
    language: str
    model_name: str
    configuration: InterlisModel

    def quarantine_model(
        self,
        schema: str,
    ) -> ModelBase:
        """
        Return a new quarantine ORM model for this component.
        """

        return self.configuration.quarantine_model(schema)

    def live_model(
        self,
        schema: str,
    ) -> ModelBase:
        """
        Return a new live ORM model for this component.
        """

        return self.configuration.live_model(schema)


@dataclass(
    slots=True,
    frozen=True,
)
class TwwInterlisModelSelection:
    """
    Describe the configured models selected for an XTF transfer.

    The primary group is detected from the XTF header. Components contain
    the primary group and its inherited model groups in dependency-first
    order.
    """

    group: str
    language: str
    imported_models: tuple[
        str,
        ...,
    ]
    components: tuple[
        TwwInterlisModelComponent,
        ...,
    ]

    @property
    def primary_component(
        self,
    ) -> TwwInterlisModelComponent:
        """
        Return the component representing the primary model group.
        """

        return self.components[-1]

    @property
    def import_model(
        self,
    ) -> str:
        """
        Return the primary model name used for the INTERLIS import.
        """

        return self.primary_component.model_name

    @property
    def groups(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return all selected semantic model groups.
        """

        return tuple(component.group for component in self.components)

    @property
    def mapping_model_id(
        self,
    ) -> str:
        """
        Return the model identifier used to load explicit mappings.
        """

        if self.group in {
            "ag64",
            "ag96",
        }:
            return "agxx"

        return self.group

    @property
    def import_schema_models(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return model names used to create an import quarantine schema.

        Every configured language variant of every highest selected
        inheritance level is included. Dependency models are resolved by
        ili2pg from the selected primary model definitions.
        """

        model_names: list[str,] = []

        highest_levels = set(
            self._highest_inheritance_levels,
        )

        for component in self.components:
            if component.group not in highest_levels:
                continue

            selected_model_name = component.model_name

            if selected_model_name not in model_names:
                model_names.append(
                    selected_model_name,
                )

            remaining_model_names = sorted(
                model_name
                for model_name in component.configuration.names
                if model_name != selected_model_name
            )

            for model_name in remaining_model_names:
                if model_name not in model_names:
                    model_names.append(
                        model_name,
                    )

        return tuple(
            model_names,
        )

    @property
    def export_schema_models(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return model names used to create an export quarantine schema.

        One language-specific model is selected for every component
        participating in the inheritance trees of the highest selected model
        levels.

        Components are returned in dependency-first order. Language fallback
        is handled by ``InterlisModel.lang_name``.
        """

        model_names: list[str,] = []

        for component in self._components_for_highest_levels:
            model_name = component.configuration.lang_name(
                self.language,
            )

            if model_name not in model_names:
                model_names.append(
                    model_name,
                )

        return tuple(
            model_names,
        )

    @property
    def created_models(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return models created for the current import workflow.

        This compatibility property represents import schema creation. New
        code should use ``import_schema_models`` explicitly.
        """

        return self.import_schema_models

    @property
    def validation_models(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return the model names actually declared by the imported transfer.

        Import schema creation may include additional language variants, but
        quarantine validation must be restricted to models for which baskets
        were imported.
        """

        if self.imported_models:
            return self.imported_models

        return (self.import_model,)

    @property
    def _highest_inheritance_levels(
        self,
    ) -> tuple[
        str,
        ...,
    ]:
        """
        Return the most-derived inheritance levels in the selection.

        A level is excluded when it is an ancestor of another selected level.
        Independent model families remain in the result.
        """

        available_levels = {
            component.group
            for component in self.components
            if (component.group in INTERLIS_INHERITANCE_TREE)
        }

        inherited_levels: set[str,] = set()

        for level in available_levels:
            inherited_levels.update(
                self._all_parent_levels.get(
                    level,
                    frozenset(),
                )
            )

        return tuple(
            level
            for level in INTERLIS_INHERITANCE_TREE
            if (level in available_levels and level not in inherited_levels)
        )

    @property
    def _all_parent_levels(
        self,
    ) -> dict[
        str,
        frozenset[str,],
    ]:
        """
        Return all direct and indirect parents keyed by model level.
        """

        parents_by_level: dict[
            str,
            frozenset[str,],
        ] = {}

        for level in INTERLIS_INHERITANCE_TREE:
            parent_levels: set[str,] = set()

            pending_levels = list(
                INTERLIS_INHERITANCE_TREE.get(
                    level,
                    (),
                )
            )

            while pending_levels:
                parent_level = pending_levels.pop()

                if parent_level in parent_levels:
                    continue

                parent_levels.add(
                    parent_level,
                )

                pending_levels.extend(
                    INTERLIS_INHERITANCE_TREE.get(
                        parent_level,
                        (),
                    )
                )

            parents_by_level[level] = frozenset(
                parent_levels,
            )

        return parents_by_level

    @property
    def _components_for_highest_levels(
        self,
    ) -> tuple[
        TwwInterlisModelComponent,
        ...,
    ]:
        """
        Return components participating in the highest inheritance trees.

        The result includes every highest selected level and all its direct
        and indirect dependencies. Existing component order is preserved.
        """

        selected_levels: set[str,] = set()

        for level in self._highest_inheritance_levels:
            selected_levels.add(
                level,
            )

            selected_levels.update(
                self._all_parent_levels.get(
                    level,
                    frozenset(),
                )
            )

        return tuple(
            component for component in self.components if component.group in selected_levels
        )


interlis_models: dict[
    str,
    InterlisModel,
] = {
    "dss": InterlisModel(
        models=frozenset(
            {
                InterlisLangModel(
                    lang="de",
                    model="DSS_2020_1_LV95",
                    topics=frozenset(
                        {
                            "Siedlungsentwaesserung",
                        }
                    ),
                ),
                InterlisLangModel(
                    lang="fr",
                    model="SDEE_2020_1_LV95",
                    topics=frozenset(
                        {
                            ("evacuation_des_eaux_" "des_agglomerations"),
                        }
                    ),
                ),
            }
        ),
        orm_quarantine_factory=ModelInterlisDss,
    ),
    "vsa_kek": InterlisModel(
        models=frozenset(
            {
                InterlisLangModel(
                    lang="de",
                    model="VSA_KEK_2020_1_LV95",
                    topics=frozenset(
                        {
                            "KEK",
                        }
                    ),
                ),
                InterlisLangModel(
                    lang="fr",
                    model="VSA_IVI_2020_1_LV95",
                    topics=frozenset(
                        {
                            "IVI",
                        }
                    ),
                ),
            }
        ),
        orm_quarantine_factory=ModelInterlisVsaKek,
    ),
    "sia405_abwasser": InterlisModel(
        models=frozenset(
            {
                InterlisLangModel(
                    lang="de",
                    model="SIA405_ABWASSER_2020_1_LV95",
                    topics=frozenset(
                        {
                            "SIA405_Abwasser",
                        }
                    ),
                ),
                InterlisLangModel(
                    lang="fr",
                    model="SIA405_EAUX_USEES_2020_1_LV95",
                    topics=frozenset(
                        {
                            "SIA405_Eaux_usees",
                        }
                    ),
                ),
            }
        ),
        orm_quarantine_factory=ModelInterlisSia405Abwasser,
    ),
    "sia405_base_abwasser": InterlisModel(
        models=frozenset(
            {
                InterlisLangModel(
                    lang="de",
                    model="SIA405_Base_Abwasser_1_LV95",
                    topics=frozenset(
                        {
                            "Administration",
                        }
                    ),
                ),
                InterlisLangModel(
                    lang="fr",
                    model="SIA405_Base_Eaux_usees_1_LV95",
                    topics=frozenset(
                        {
                            "Administration",
                        }
                    ),
                ),
            }
        ),
        orm_quarantine_factory=ModelInterlisSia405BaseAbwasser,
    ),
    "sia405_cable": InterlisModel(
        models=frozenset(
            {
                InterlisLangModel(
                    lang="de",
                    model="SIA405_FERNWIRKKABEL_2015_LV95",
                    topics=frozenset(
                        {
                            "SIA405_Fernwirkkabel",
                        }
                    ),
                ),
                InterlisLangModel(
                    lang="fr",
                    model=("SIA405_CABLE_DE_CONTROLE_" "A_DISTANCE_2015"),
                    topics=frozenset(
                        {
                            ("SIA405_Cable_de_controle_" "a_distance"),
                        }
                    ),
                ),
            }
        ),
        orm_quarantine_factory=ModelInterlisSia405Fernwirkkabel,
    ),
    "sia405_protection_tube": InterlisModel(
        models=frozenset(
            {
                InterlisLangModel(
                    lang="de",
                    model="SIA405_Schutzrohr_2015_LV95",
                    topics=frozenset(
                        {
                            "SIA405_Schutzrohr",
                        }
                    ),
                ),
                InterlisLangModel(
                    lang="fr",
                    model="SIA405_TUBE_DE_PROTECTION_2015",
                    topics=frozenset(
                        {
                            "SIA405_tube_de_protection",
                        }
                    ),
                ),
            }
        ),
        orm_quarantine_factory=ModelInterlisSia405Schutzrohr,
    ),
    "ag96": InterlisModel(
        models=frozenset(
            {
                InterlisLangModel(
                    lang="de",
                    model="Genereller_Entwaesserungsplan_AG",
                    topics=frozenset(
                        {
                            "GEP_AGIS",
                        }
                    ),
                ),
            }
        ),
        orm_quarantine_factory=ModelInterlisAG96,
    ),
    "ag64": InterlisModel(
        models=frozenset(
            {
                InterlisLangModel(
                    lang="de",
                    model="Abwasserkataster_AG_V2_LV95",
                    topics=frozenset(
                        {
                            "Abwasserkataster_AG",
                        }
                    ),
                ),
            }
        ),
        orm_quarantine_factory=ModelInterlisAG64,
    ),
}


INTERLIS_INHERITANCE_TREE: dict[
    str,
    tuple[str, ...],
] = {
    "dss": ("sia405_abwasser",),
    "vsa_kek": ("sia405_abwasser",),
    "sia405_abwasser": ("sia405_base_abwasser",),
    "sia405_base_abwasser": (),
    "sia405_cable": (),
    "sia405_protection_tube": (),
    "ag96": (),
    "ag64": (),
}
