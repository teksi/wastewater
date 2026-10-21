from collections import defaultdict


def build_function_inventory(
    mapping: dict,
) -> dict[str, list[str]]:
    result = defaultdict(list)

    for class_name, definition in mapping.items():
        if "function" in definition:
            function = definition["function"]

            key = f"{function['schema']}." f"{function['name']}"

            result[key].append(
                class_name,
            )

        for attribute_name, attr_definition in definition.get(
            "attributes",
            {},
        ).items():
            function = attr_definition.get(
                "function",
            )

            if not function:
                continue

            key = f"{function['schema']}." f"{function['name']}"

            result[key].append(f"{class_name}.{attribute_name}")

    return dict(result)
