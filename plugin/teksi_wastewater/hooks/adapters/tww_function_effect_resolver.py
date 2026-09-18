# teksi_wastewater/hooks/adapters/tww_function_effect_resolver.py

from __future__ import annotations

import json
import re
from collections.abc import Mapping
from dataclasses import dataclass, field
from typing import Any

from sqlalchemy import inspect, text
from sqlalchemy.orm import Session
from teksi_hooks.capabilities.incremental_import import (
    FunctionEffectResolver,
)
from teksi_hooks.models.effects import (
    EffectDocument,
)
from teksi_hooks.models.mapping import (
    ClassMapping,
)
from teksi_hooks.parsers.effects import (
    EffectParser,
)

_SAFE_IDENTIFIER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


@dataclass(
    slots=True,
)
class TwwFunctionEffectResolver(
    FunctionEffectResolver,
):
    """
    Resolve database-function mappings into effect documents.

    The configured mapping function is executed through the supplied
    SQLAlchemy session. The function must be read-only and return one JSONB
    effect document.
    """

    parser: EffectParser = field(
        default_factory=EffectParser,
    )

    def resolve_effects(
        self,
        *,
        source_class_id: str,
        source_row: Any,
        session: Session,
        class_mapping: ClassMapping,
    ) -> EffectDocument:
        """
        Execute one function-backed mapping and parse its effect document.
        """

        function = class_mapping.function

        if function is None:
            raise ValueError(f"Class {source_class_id!r} has no function mapping.")

        row_payload = self._source_row_payload(
            source_row,
        )

        parameters = self._function_parameters(
            configured_parameters=function.parameters,
            row_payload=row_payload,
        )

        result = self._execute_function(
            schema=function.schema,
            name=function.name,
            session=session,
            parameters=parameters,
        )

        return self.parser.parse_dict(
            result,
        )

    def _source_row_payload(
        self,
        source_row: Any,
    ) -> dict[
        str,
        Any,
    ]:
        """
        Serialize mapped column values from one quarantine ORM row.

        SQLAlchemy state and relationship attributes are excluded.
        """

        mapper = inspect(
            type(
                source_row,
            )
        )

        return {
            attribute.key: getattr(
                source_row,
                attribute.key,
            )
            for attribute in mapper.column_attrs
        }

    def _function_parameters(
        self,
        *,
        configured_parameters: Mapping[
            str,
            Any,
        ],
        row_payload: Mapping[
            str,
            Any,
        ],
    ) -> dict[
        str,
        Any,
    ]:
        """
        Resolve configured mapping-function parameter bindings.

        Version 1 supports ``$row`` as the complete prepared source-row
        payload. Literal configured values are passed through unchanged.
        """

        available_bindings = {
            "$row": dict(
                row_payload,
            ),
        }

        parameters: dict[
            str,
            Any,
        ] = {}

        for (
            parameter_name,
            configured_value,
        ) in configured_parameters.items():
            if isinstance(
                configured_value,
                str,
            ) and configured_value.startswith(
                "$",
            ):
                try:
                    resolved_value = available_bindings[configured_value]
                except KeyError as exception:
                    raise ValueError(
                        "Unsupported mapping-function parameter "
                        f"binding {configured_value!r} for parameter "
                        f"{parameter_name!r}."
                    ) from exception
            else:
                resolved_value = configured_value

            parameters[parameter_name] = resolved_value

        return parameters

    def _execute_function(
        self,
        *,
        schema: str,
        name: str,
        session: Session,
        parameters: Mapping[
            str,
            Any,
        ],
    ) -> dict[
        str,
        Any,
    ]:
        """
        Execute one trusted read-only mapping function.

        Function schema, name and parameter names originate from trusted
        mapping configuration and are validated as PostgreSQL identifiers.
        Parameter values remain bound SQL values.
        """

        self._assert_identifier(
            value=schema,
            label="function schema",
        )

        self._assert_identifier(
            value=name,
            label="function name",
        )

        for parameter_name in parameters:
            self._assert_identifier(
                value=parameter_name,
                label="function parameter",
            )

        argument_expressions = []

        bound_parameters: dict[
            str,
            Any,
        ] = {}

        for (
            parameter_name,
            parameter_value,
        ) in parameters.items():
            bind_name = f"parameter_{len(bound_parameters)}"

            if isinstance(
                parameter_value,
                (
                    dict,
                    list,
                ),
            ):
                argument_expression = (
                    f"{self._quote_identifier(parameter_name)} " f"=> CAST(:{bind_name} AS jsonb)"
                )

                bound_parameters[bind_name] = json.dumps(
                    parameter_value,
                    default=str,
                )
            else:
                argument_expression = (
                    f"{self._quote_identifier(parameter_name)} " f"=> :{bind_name}"
                )

                bound_parameters[bind_name] = parameter_value

            argument_expressions.append(
                argument_expression,
            )

        statement = text(
            "SELECT "
            f"{self._quote_identifier(schema)}."
            f"{self._quote_identifier(name)}"
            "("
            f"{', '.join(argument_expressions)}"
            ") AS effect_document;"
        )

        result = session.execute(
            statement,
            bound_parameters,
        ).scalar_one()

        if result is None:
            raise ValueError("Mapping function " f"{schema!r}.{name!r} returned NULL.")

        if isinstance(
            result,
            str,
        ):
            result = json.loads(
                result,
            )

        if not isinstance(
            result,
            dict,
        ):
            raise ValueError(
                "Mapping function "
                f"{schema!r}.{name!r} must return one JSON object; "
                f"received {type(result).__name__!r}."
            )

        return result

    def _assert_identifier(
        self,
        *,
        value: str,
        label: str,
    ) -> None:
        """
        Require one simple PostgreSQL identifier.
        """

        if not isinstance(
            value,
            str,
        ) or not _SAFE_IDENTIFIER.fullmatch(
            value,
        ):
            raise ValueError(f"Invalid {label}: {value!r}.")

    def _quote_identifier(
        self,
        value: str,
    ) -> str:
        """
        Quote one validated PostgreSQL identifier.
        """

        return (
            '"'
            + value.replace(
                '"',
                '""',
            )
            + '"'
        )
