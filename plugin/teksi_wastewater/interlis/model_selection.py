from __future__ import annotations

from collections.abc import Iterable
from .config import DEFAULT_INTERLIS_LANGUAGE
from .model_config import (
    interlis_models,
    TwwInterlisModelSelection,
    INTERLIS_INHERITANCE_TREE,
)



ALL_MODELS_BY_GROUP: dict[
    str,
    frozenset[str],
] = {
    group: model.names
    for group, model in interlis_models.items()
}


ALL_SUPPORTED_MODELS: frozenset[str] = frozenset(
    model_name
    for model_names in ALL_MODELS_BY_GROUP.values()
    for model_name in model_names
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

    unknown_groups = (
        set(
            selected_groups,
        )
        - set(
            interlis_models,
        )
    )

    if unknown_groups:
        raise ValueError(
            "Unknown INTERLIS model groups: "
            f"{sorted(unknown_groups)}. "
            f"Available groups: "
            f"{sorted(interlis_models)}"
        )

    return {
        group: interlis_models[
            group
        ].lang_name(
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

    The imported models must resolve to exactly one configured semantic
    model group and exactly one language-specific import model.
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
        raise LookupError(
            "No imported INTERLIS models were provided."
        )

    matches = tuple(
        (
            group,
            language_model,
            model,
        )
        for group, model in interlis_models.items()
        for language_model in model.models
        if (
            language_model.model
            in imported_model_names
        )
    )

    if not matches:
        raise LookupError(
            "No configured INTERLIS model matches imported "
            f"models {sorted(imported_model_names)!r}."
        )

    matched_groups = {
        group
        for group, _language_model, _model
        in matches
    }

    if len(
        matched_groups,
    ) != 1:
        raise LookupError(
            "Imported models resolve to multiple semantic "
            f"model groups: {sorted(matched_groups)!r}."
        )

    if len(
        matches,
    ) != 1:
        matched_models = tuple(
            sorted(
                language_model.model
                for (
                    _group,
                    language_model,
                    _model,
                ) in matches
            )
        )

        raise LookupError(
            "Imported models do not resolve to exactly one "
            "configured model and language. Matching models: "
            f"{matched_models!r}."
        )

    (
        group,
        language_model,
        model,
    ) = matches[0]

    created_models = tuple(
        model.names or (),
    )

    if not created_models:
        raise LookupError(
            "No created model names are configured for "
            f"semantic model group {group!r}."
        )

    return TwwInterlisModelSelection(
        group=group,
        language=language_model.lang,
        imported_models=tuple(
            sorted(
                imported_model_names,
            )
        ),
        import_model=language_model.model,
        created_models=created_models,
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
        group
        for group, models
        in ALL_MODELS_BY_GROUP.items()
        if imported_model_names & models
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

            cycle = (
                visiting[
                    cycle_start:
                ]
                + [
                    group,
                ]
            )

            raise ValueError(
                "Circular INTERLIS model inheritance: "
                + " -> ".join(
                    cycle,
                )
            )

        if group not in INTERLIS_INHERITANCE_TREE:
            raise KeyError(
                f"Unknown INTERLIS model group: "
                f"{group!r}."
            )

        visiting.append(
            group,
        )

        for inherited_group in (
            INTERLIS_INHERITANCE_TREE[
                group
            ]
        ):
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

    return tuple(
        names_by_group[
            group
        ]
        for group in resolved_groups
    )

