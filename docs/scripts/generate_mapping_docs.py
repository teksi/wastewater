from pathlib import Path

import yaml

HEADER = """.. Generated file.
   Do not edit manually.

"""


def load_yaml(path: Path) -> dict:
    with open(path, encoding="utf-8") as file:
        return yaml.safe_load(file) or {}


def render_class(name: str, definition: dict) -> str:
    lines = [
        name,
        "-" * len(name),
        "",
    ]

    if "function" in definition:
        function = definition["function"]

        lines.extend(
            [
                "Function Mapping",
                "~~~~~~~~~~~~~~~~",
                "",
                f"Schema: ``{function['schema']}``",
                "",
                f"Function: ``{function['name']}``",
                "",
            ]
        )

        return "\n".join(lines)

    attributes = definition.get(
        "attributes",
        {},
    )

    lines.extend(
        [
            "Attribute Mappings",
            "~~~~~~~~~~~~~~~~~~",
            "",
        ]
    )

    for source_attribute, attribute_definition in sorted(
        attributes.items(),
    ):
        lines.extend(
            [
                f"``{source_attribute}``",
                "",
            ]
        )

        if "targets" in attribute_definition:
            for target in attribute_definition["targets"]:
                lines.append(f"* ``{target['class']}.{target['attribute']}``")

        if "function" in attribute_definition:
            function = attribute_definition["function"]

            lines.append(f"* Function: ``{function['schema']}.{function['name']}``")

        lines.append("")

    return "\n".join(lines)
