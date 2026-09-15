from __future__ import annotations

from dataclasses import dataclass
from typing import Any
import json
import re

from teksi_hooks.capabilities.mapping import (
    EffectiveModelMappingCapability,
)
from teksi_hooks.models.canonical_object import (
    CanonicalModelMetadata,
    CanonicalObjectIdentity,
)
from teksi_hooks.models.effects import (
    Effect,
    EffectDocument,
    EffectSource,
    EnforceExistsEffect,
    EnforceNotExistsEffect,
    UpdateAttributeEffect,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    FunctionMapping,
    RelationContext,
)

from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.services.relation_context_provider import (
    RelationContextProvider,
)

try:
    from psycopg import sql
except ImportError:
    from psycopg2 import sql
    


@dataclass(slots=True)
class TwwQuarantineEffectProjector:
    """
    Project quarantine rows into canonical effects.

    The projector reads imported ili2pg quarantine rows, applies the effective
    model mapping and emits canonical effects.

    It does not:

    - evaluate rights;
    - classify changes;
    - validate business rules;
    - write review artifacts;
    - write tww_diff rows.
    """

    model_mapping: EffectiveModelMappingCapability

    connection_factory: DatabaseConnectionFactory

    relation_context_provider: RelationContextProvider

    def effect_document_from_quarantine(
        self,
        *,
        schema: str,
        source_model: str,
        canonical_metadata: CanonicalModelMetadata,
    ) -> EffectDocument:
        """
        Project the current quarantine schema into a canonical effect document.
        """

        effects: list[
            Effect
        ] = []

        with self.connection_factory.connection(
            autocommit=False,
        ) as connection:
            with connection.cursor() as cursor:
                for relation_context in (
                    self.relation_context_provider
                    .relation_contexts()
                ):
                    effects.extend(
                        self._effects_for_relation_context(
                            cursor=cursor,
                            relation_context=(
                                relation_context
                            ),
                            schema=schema,
                            canonical_metadata=(
                                canonical_metadata
                            ),
                        )
                    )

        return EffectDocument(
            source=EffectSource(
                model=source_model,
                class_id="quarantine",
                object_id=schema,
            ),
            effects=tuple(
                effects,
            ),
        )



    def _effects_for_relation_context(
        self,
        *,
        cursor,
        relation_context: RelationContext,
        schema: str,
        canonical_metadata: CanonicalModelMetadata,
    ) -> tuple[Effect, ...]:
        class_mapping = relation_context.class_mapping

        if class_mapping.function is not None:
            return self._function_effects_for_relation_context(
                cursor=cursor,
                relation_context=relation_context,
                schema=schema,
            )

        if class_mapping.canonical_class_id is None:
            return ()

        self._assert_known_class(
            canonical_metadata=canonical_metadata,
            class_id=class_mapping.canonical_class_id,
        )

        effects: list[Effect] = []

        for row in self._rows(
            cursor=cursor,
            schema=schema,
            relation=relation_context.relation,
        ):

            effects.extend(
                self._attribute_effects(
                    row=row,
                    source_class_id=(
                        relation_context.relation.__name__
                    ),
                    class_mapping=class_mapping,
                    canonical_metadata=canonical_metadata,
                )
            )

        return tuple(
            effects,
        )

    def _function_effects_for_relation_context(
        self,
        *,
        cursor,
        relation_context: RelationContext,
        schema: str,
    ) -> tuple[Effect, ...]:
        function_mapping = (
            relation_context.class_mapping.function
        )

        if function_mapping is None:
            return ()

        effects: list[Effect] = []

        for row in self._rows(
            cursor=cursor,
            schema=schema,
            relation=relation_context.relation,
        ):
            payload = self._call_function_mapping(
                cursor=cursor,
                function_mapping=function_mapping,
                row=row,
            )

            effects.extend(
                self._effects_from_payload(
                    payload,
                )
            )

        return tuple(
            effects,
        )

    def _rows(
        self,
        *,
        cursor,
        schema: str,
        relation,
    ) -> tuple[dict[str, Any], ...]:
        """
        Return all quarantine rows for one imported relation.
        """

        table_name = self._table_name(
            relation,
        )

        cursor.execute(
            sql.SQL(
                """
                SELECT *
                FROM {}.{}
                """
            ).format(
                sql.Identifier(
                    schema,
                ),
                sql.Identifier(
                    table_name,
                ),
            )
        )

        rows = cursor.fetchall()

        if cursor.description is None:
            return ()

        column_names = tuple(
            column[0]
            for column in cursor.description
        )

        return tuple(
            dict(
                zip(
                    column_names,
                    row,
                )
            )
            for row in rows
        )
    def _table_name(
        self,
        relation,
    ) -> str:
        table = getattr(
            relation,
            "__table__",
            None,
        )

        if table is not None:
            return table.name

        return relation.__name__


    def _identity(
        self,
        *,
        row: dict[
            str,
            Any,
        ],
        class_mapping: ClassMapping,
        canonical_class_id: str | None = None,
    ) -> CanonicalObjectIdentity:
        """
        Build the identity for one canonical target class.
        """

        target_class_id = (
            canonical_class_id
            or class_mapping.canonical_class_id
        )

        if target_class_id is None:
            raise ValueError(
                "Cannot build an identity without a canonical "
                "target class."
            )

        identity_mapping = (
            class_mapping.identities.get(
                target_class_id,
            )
        )

        if identity_mapping is None:
            raise ValueError(
                "No identity mapping exists for canonical target "
                f"class {target_class_id!r}."
            )

        try:
            source_value = row[
                identity_mapping.source_attribute
            ]
        except KeyError as exception:
            raise ValueError(
                "Source identity attribute "
                f"{identity_mapping.source_attribute!r} is missing "
                f"for canonical target class {target_class_id!r}."
            ) from exception

        return CanonicalObjectIdentity(
            class_id=target_class_id,
            attributes={
                identity_mapping.canonical_attribute: (
                    source_value
                ),
            },
        )

    def _attribute_effects(
        self,
        *,
        row: dict[str, Any],
        source_class_id: str,
        class_mapping: ClassMapping,
        canonical_metadata: CanonicalModelMetadata,
    ) -> tuple[UpdateAttributeEffect, ...]:
        """
        Project mapped source attributes to canonical update effects.

        Each attribute mapping may target the class mapping's primary canonical
        class or another canonical class for which the class mapping defines an
        identity.
        """

        effects: list[
            UpdateAttributeEffect
        ] = []

        for (
            source_attribute,
            attribute_mapping,
        ) in class_mapping.attributes.items():
            canonical_attribute_id = (
                attribute_mapping.canonical_attr_id
            )

            if canonical_attribute_id is None:
                continue

            target_class_id = (
                attribute_mapping.canonical_class_id
                or class_mapping.canonical_class_id
            )

            if target_class_id is None:
                raise ValueError(
                    "No canonical target class is defined for "
                    f"{source_class_id}.{source_attribute}."
                )

            identity = self._identity(
                row=row,
                class_mapping=class_mapping,
                canonical_class_id=target_class_id,
            )

            self._assert_known_attribute(
                canonical_metadata=canonical_metadata,
                class_id=target_class_id,
                attribute_id=canonical_attribute_id,
            )

            value = row.get(
                source_attribute,
            )

            value = self._mapped_value(
                source_class_id=source_class_id,
                source_attribute=source_attribute,
                attribute_mapping=attribute_mapping,
                value=value,
            )

            effects.append(
                UpdateAttributeEffect(
                    identity=identity,
                    attribute_id=canonical_attribute_id,
                    value=value,
                )
            )

        return tuple(
            effects,
        )

    def _mapped_value(
        self,
        *,
        source_class_id: str,
        source_attribute: str,
        attribute_mapping: AttributeMapping,
        value: Any,
    ) -> Any:
        if value is None:
            return None

        value_mapping = self.model_mapping.try_value_mapping(
            source_class_id,
            source_attribute,
            str(
                value,
            ),
        )

        if value_mapping is None:
            value_mapping = attribute_mapping.values.get(
                str(
                    value,
                )
            )

        if value_mapping is None:
            return value

        return value_mapping.canonical_value_id

    def _call_function_mapping(
        self,
        *,
        cursor,
        function_mapping: FunctionMapping,
        row: dict[str, Any],
    ) -> dict[str, Any]:
        """
        Call one configured SQL projection function.

        Function and parameter names are treated as PostgreSQL identifiers.
        Parameter values remain safely adapted SQL values.
        """

        arguments = []

        for parameter_name, source_name in (
            function_mapping.parameters.items()
        ):
            self._assert_safe_identifier(
                parameter_name,
            )

            if source_name == "$row":
                value_expression = sql.SQL(
                    "{}::jsonb"
                ).format(
                    sql.Literal(
                        self._json_dumps(
                            row,
                        )
                    )
                )
            else:
                value_expression = sql.Literal(
                    row.get(
                        source_name,
                    )
                )

            arguments.append(
                sql.SQL(
                    "{} => {}"
                ).format(
                    sql.Identifier(
                        parameter_name,
                    ),
                    value_expression,
                )
            )

        query = sql.SQL(
            """
            SELECT {}.{}({}) AS effect_document
            """
        ).format(
            sql.Identifier(
                function_mapping.schema,
            ),
            sql.Identifier(
                function_mapping.name,
            ),
            sql.SQL(
                ", ",
            ).join(
                arguments,
            ),
        )

        cursor.execute(
            query,
        )

        row_result = cursor.fetchone()

        if row_result is None:
            return {}

        payload = row_result[0]

        if payload is None:
            return {}

        if isinstance(
            payload,
            dict,
        ):
            return payload

        if isinstance(
            payload,
            str,
        ):
            parsed_payload = json.loads(
                payload,
            )

            if not isinstance(
                parsed_payload,
                dict,
            ):
                raise ValueError(
                    "Function mapping returned JSON that is "
                    "not an object."
                )

            return parsed_payload

        try:
            return dict(
                payload,
            )
        except (
            TypeError,
            ValueError,
        ) as exception:
            raise TypeError(
                "Function mapping returned an unsupported "
                f"payload type: {type(payload)!r}."
            ) from exception

    def _effects_from_payload(
        self,
        payload: dict[str, Any],
    ) -> tuple[Effect, ...]:
        effects_payload = payload.get(
            "effects",
            [],
        )

        return tuple(
            self._effect_from_payload(
                effect_payload,
            )
            for effect_payload in effects_payload
        )

    def _effect_from_payload(
        self,
        payload: dict[str, Any],
    ) -> Effect:
        kind = payload["kind"]

        identity = self._identity_from_payload(
            payload["identity"],
        )

        if kind == "update_attribute":
            return UpdateAttributeEffect(
                identity=identity,
                attribute_id=payload.get(
                    "attribute_id",
                    payload.get(
                        "tww_attribute_id",
                    ),
                ),
                value=payload.get(
                    "value",
                ),
            )

        if kind == "enforce_exists":
            return EnforceExistsEffect(
                identity=identity,
            )

        if kind == "enforce_not_exists":
            return EnforceNotExistsEffect(
                identity=identity,
            )

        raise ValueError(
            f"Unsupported effect kind: {kind!r}"
        )

    def _identity_from_payload(
        self,
        payload: dict[str, Any],
    ) -> CanonicalObjectIdentity:
        return CanonicalObjectIdentity(
            class_id=payload["class_id"],
            attributes=dict(
                payload["attributes"],
            ),
        )

    def _assert_known_class(
        self,
        *,
        canonical_metadata: CanonicalModelMetadata,
        class_id: str,
    ) -> None:
        if class_id not in canonical_metadata.classes:
            raise KeyError(
                f"Unknown canonical class: {class_id!r}"
            )

    def _assert_known_attribute(
        self,
        *,
        canonical_metadata: CanonicalModelMetadata,
        class_id: str,
        attribute_id: str,
    ) -> None:
        if (
            class_id,
            attribute_id,
        ) not in canonical_metadata.attributes:
            raise KeyError(
                "Unknown canonical attribute: "
                f"{class_id!r}.{attribute_id!r}"
            )

    def _assert_safe_identifier(
        self,
        value: str,
    ) -> None:
        if not re.fullmatch(
            r"[A-Za-z_][A-Za-z0-9_]*",
            value,
        ):
            raise ValueError(
                f"Unsafe SQL identifier: {value!r}"
            )

    def _json_dumps(
        self,
        value: Any,
    ) -> str:
        return json.dumps(
            value,
            default=str,
            ensure_ascii=False,
            sort_keys=True,
        )