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
    imported_models: tuple[str, ...]
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
    def created_models(
        self,
    ) -> tuple[str, ...]:
        """
        Return all dependency and primary model names.

        Names are returned in dependency-first order.
        """

        return tuple(component.model_name for component in self.components)

    @property
    def groups(
        self,
    ) -> tuple[str, ...]:
        """
        Return all selected semantic model groups.
        """

        return tuple(component.group for component in self.components)

    @property
    def mapping_model_id(
        self,
    ) -> str:
        if self.group in {
            "ag64",
            "ag96",
        }:
            return "agxx"

        return self.group


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
