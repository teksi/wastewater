from __future__ import annotations

from collections.abc import Iterable

from .config import DEFAULT_INTERLIS_LANGUAGE
from .model_config import (
    INTERLIS_INHERITANCE_TREE,
    TwwInterlisModelComponent,
    TwwInterlisModelSelection,
    interlis_models,
)

ALL_MODELS_BY_GROUP: dict[
    str,
    frozenset[str],
] = {group: model.names for group, model in interlis_models.items()}


ALL_SUPPORTED_MODELS: frozenset[str] = frozenset(
    model_name for model_names in ALL_MODELS_BY_GROUP.values() for model_name in model_names
)


def model_names_for_language(
    lang: str,
    fallback_lang: str = DEFAULT_INTERLIS_LANGUAGE,
    groups: Iterable[str] | None = None,
) -> dict[str, str]:
    """
    Return one language-specific model name per model group.

    If a group does not provide the requested language, its model in
    ``fallback_lang`` is returned.
    """

    selected_groups = (
        tuple(
            interlis_models,
        )
        if groups is None
        else tuple(
            groups,
        )
    )

    unknown_groups = set(
        selected_groups,
    ) - set(
        interlis_models,
    )

    if unknown_groups:
        raise ValueError(
            "Unknown INTERLIS model groups: "
            f"{sorted(unknown_groups)}. "
            f"Available groups: "
            f"{sorted(interlis_models)}"
        )

    return {
        group: interlis_models[group].lang_name(
            lang=lang,
            fallback_lang=fallback_lang,
        )
        for group in selected_groups
    }


def model_selection_for_imported_models(
    imported_models: str | Iterable[str],
) -> TwwInterlisModelSelection:
    """
    Resolve the authoritative model selection for imported INTERLIS models.

    Imported model names may include both the primary model and inherited
    dependency models. The most specific matching group is selected as the
    primary group.

    Selection components are returned in dependency-first order, with the
    primary model component last.
    """

    if isinstance(
        imported_models,
        str,
    ):
        imported_model_names = {
            imported_models,
        }
    else:
        imported_model_names = set(
            imported_models,
        )

    if not imported_model_names:
        raise LookupError("No imported INTERLIS models were provided.")

    matches = tuple(
        (
            group,
            language_model,
        )
        for group, model in interlis_models.items()
        for language_model in model.models
        if (language_model.model in imported_model_names)
    )

    if not matches:
        raise LookupError(
            "No configured INTERLIS model matches imported "
            f"models {sorted(imported_model_names)!r}."
        )

    matched_groups = {group for group, _language_model in matches}

    inherited_matched_groups = {
        inherited_group
        for group in matched_groups
        for inherited_group in resolve_interlis_model_groups(
            group,
        )[:-1]
    }

    primary_groups = matched_groups - inherited_matched_groups

    if (
        len(
            primary_groups,
        )
        != 1
    ):
        raise LookupError(
            "Imported models do not resolve to exactly one "
            "primary semantic model group. "
            f"Matching groups: {sorted(matched_groups)!r}. "
            f"Primary candidates: {sorted(primary_groups)!r}."
        )

    primary_group = next(
        iter(
            primary_groups,
        )
    )

    primary_language_models = tuple(
        language_model for group, language_model in matches if group == primary_group
    )

    if (
        len(
            primary_language_models,
        )
        != 1
    ):
        matched_models = tuple(
            sorted(language_model.model for language_model in primary_language_models)
        )

        raise LookupError(
            "Imported models do not resolve to exactly one "
            "configured primary model and language. "
            f"Matching primary models: {matched_models!r}."
        )

    primary_language_model = primary_language_models[0]

    language = primary_language_model.lang

    resolved_groups = resolve_interlis_model_groups(
        primary_group,
    )

    components = tuple(
        TwwInterlisModelComponent(
            group=group,
            language=language,
            model_name=(
                interlis_models[group].lang_name(
                    lang=language,
                )
            ),
            configuration=(interlis_models[group]),
        )
        for group in resolved_groups
    )

    return TwwInterlisModelSelection(
        group=primary_group,
        language=language,
        imported_models=tuple(
            sorted(
                imported_model_names,
            )
        ),
        components=components,
    )


def groups_for_models(
    imported_models: str | Iterable[str],
) -> set:
    """
    Return semantic model groups matching imported model names.
    """

    if isinstance(
        imported_models,
        str,
    ):
        imported_model_names = {
            imported_models,
        }
    else:
        imported_model_names = set(
            imported_models,
        )

    return {
        group for group, models in ALL_MODELS_BY_GROUP.items() if imported_model_names & models
    }


def resolve_interlis_model_groups(
    model_group: str,
) -> tuple[str, ...]:
    """
    Return inherited model groups in dependency-first order.

    The requested model group is included as the final item.
    """

    resolved: list[str] = []
    visited: set[str] = set()
    visiting: list[str] = []

    def visit(
        group: str,
    ) -> None:
        if group in visited:
            return

        if group in visiting:
            cycle_start = visiting.index(
                group,
            )

            cycle = visiting[cycle_start:] + [
                group,
            ]

            raise ValueError(
                "Circular INTERLIS model inheritance: "
                + " -> ".join(
                    cycle,
                )
            )

        if group not in INTERLIS_INHERITANCE_TREE:
            raise KeyError(f"Unknown INTERLIS model group: " f"{group!r}.")

        visiting.append(
            group,
        )

        for inherited_group in INTERLIS_INHERITANCE_TREE[group]:
            visit(
                inherited_group,
            )

        visiting.pop()

        visited.add(
            group,
        )

        resolved.append(
            group,
        )

    visit(
        model_group,
    )

    return tuple(
        resolved,
    )


def resolved_model_names(
    model_group: str,
    lang: str,
    fallback_lang: str = DEFAULT_INTERLIS_LANGUAGE,
) -> tuple[str, ...]:
    """
    Resolve one model group and its inheritance to concrete model names.

    Names are returned in dependency-first order.
    """

    resolved_groups = resolve_interlis_model_groups(
        model_group,
    )

    names_by_group = model_names_for_language(
        lang=lang,
        fallback_lang=fallback_lang,
        groups=resolved_groups,
    )

    return tuple(names_by_group[group] for group in resolved_groups)
