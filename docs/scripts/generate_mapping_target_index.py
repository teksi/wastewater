from collections import defaultdict


def build_target_index(
    mapping: dict,
) -> dict[str, list[str]]:
    result = defaultdict(list)

    for source_class, definition in mapping.items():
        attributes = definition.get(
            "attributes",
            {},
        )

        for source_attribute, attr_definition in attributes.items():
            for target in attr_definition.get(
                "targets",
                [],
            ):
                key = f"{target['class']}." f"{target['attribute']}"

                result[key].append(f"{source_class}.{source_attribute}")

    return dict(result)


def render_target_index(
    mapping: dict,
) -> str:
    targets = build_target_index(
        mapping,
    )

    lines = [
        "Canonical Target Index",
        "======================",
        "",
    ]

    for target, sources in sorted(
        targets.items(),
    ):
        lines.extend(
            [
                target,
                "-" * len(target),
                "",
            ]
        )

        for source in sorted(
            sources,
        ):
            lines.append(f"* {source}")

        lines.append("")

    return "\n".join(lines)
