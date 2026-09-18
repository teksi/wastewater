from __future__ import annotations

from dataclasses import dataclass, field
from enum import StrEnum

from psycopg import sql
from teksi_hooks.capabilities.connection import (
    DatabaseConnectionFactory,
)
from teksi_hooks.capabilities.mapping import (
    ImplicitModelMappingCapability,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    ModelMapping,
    ValueMapping,
)

SOURCE_ATTRIBUTE_OVERRIDES = {
    "Status": "astatus",
    "status": "astatus",
}


TARGET_ATTRIBUTE_OVERRIDES = {
    "OBJ_ID": "obj_id",
    "oid": "obj_id",
    "dataowner": "fk_dataowner",
    "provider": "fk_provider",
}


class TwwLanguage(
    StrEnum,
):
    """
    Languages supported by implicit TEKSI Wastewater model mappings.
    """

    DE = "de"
    FR = "fr"
    EN = "en"


@dataclass(
    slots=True,
    frozen=True,
)
class _SourceRelation:
    """
    One relation available in the current quarantine schema.
    """

    table_name: str
    columns: frozenset[str]


@dataclass(
    slots=True,
)
class TwwImplicitModelMappingAdapter(
    ImplicitModelMappingCapability,
):
    """
    Database-backed provider for schema-scoped implicit canonical mappings.

    Dictionary metadata is read from ``tww_sys``. Only source classes and
    attributes physically available in the configured quarantine schema are
    included.

    A separate adapter instance must be created for each base or incremental
    quarantine schema.
    """

    connection_factory: DatabaseConnectionFactory
    import_schema: str

    language: TwwLanguage = TwwLanguage.DE

    dictionary_schema: str = "tww_sys"
    table_dictionary: str = "dictionary_od_table"
    attribute_dictionary: str = "dictionary_od_field"
    value_dictionary: str = "dictionary_od_values"

    _model_mapping: ModelMapping | None = field(
        init=False,
        default=None,
        repr=False,
    )

    def __post_init__(
        self,
    ) -> None:
        """
        Validate configuration and load the schema-scoped mapping.
        """

        try:
            self.language = TwwLanguage(
                self.language,
            )
        except ValueError as exception:
            raise ValueError(f"Unsupported language: {self.language!r}.") from exception

        if not self.import_schema.strip():
            raise ValueError("The import schema must not be empty.")

        self._model_mapping = self._load_model_mapping()

    def model_mapping(
        self,
    ) -> ModelMapping:
        """
        Return the complete schema-scoped implicit model mapping.
        """

        if self._model_mapping is None:
            raise RuntimeError("Implicit model mapping has not been loaded.")

        return self._model_mapping

    def class_mapping(
        self,
        ili_class_name: str,
    ) -> ClassMapping | None:
        """
        Return the implicit mapping for one source class.
        """

        return self.try_class_definition(
            ili_class_name,
        )

    def class_definition(
        self,
        class_id: str,
    ) -> ClassMapping:
        """
        Return the mapping for one source class identifier.
        """

        class_mapping = self.try_class_definition(
            class_id,
        )

        if class_mapping is None:
            raise KeyError(
                f"Unknown source class {class_id!r} " f"in schema {self.import_schema!r}."
            )

        return class_mapping

    def try_class_definition(
        self,
        class_id: str,
    ) -> ClassMapping | None:
        """
        Return a class mapping if it exists.
        """

        return self.model_mapping().classes.get(
            class_id,
        )

    def attribute_definition(
        self,
        class_id: str,
        attribute_name: str,
    ) -> AttributeMapping:
        """
        Return the mapping for one source attribute.
        """

        attribute_mapping = self.try_attribute_definition(
            class_id,
            attribute_name,
        )

        if attribute_mapping is None:
            raise KeyError(
                f"Unknown source attribute {attribute_name!r} "
                f"for class {class_id!r} in schema "
                f"{self.import_schema!r}."
            )

        return attribute_mapping

    def try_attribute_definition(
        self,
        class_id: str,
        attribute_name: str,
    ) -> AttributeMapping | None:
        """
        Return an attribute mapping if it exists.
        """

        class_mapping = self.try_class_definition(
            class_id,
        )

        if class_mapping is None:
            return None

        return class_mapping.attributes.get(
            attribute_name,
        )

    def value_mapping(
        self,
        class_id: str,
        attribute_name: str,
        value: str,
    ) -> ValueMapping:
        """
        Return the mapping for one source value.
        """

        value_mapping = self.try_value_mapping(
            class_id,
            attribute_name,
            value,
        )

        if value_mapping is None:
            raise KeyError(
                f"Unknown source value {value!r} for " f"{class_id!r}.{attribute_name!r}."
            )

        return value_mapping

    def try_value_mapping(
        self,
        class_id: str,
        attribute_name: str,
        value: str,
    ) -> ValueMapping | None:
        """
        Return a value mapping if it exists.
        """

        attribute_mapping = self.try_attribute_definition(
            class_id,
            attribute_name,
        )

        if attribute_mapping is None:
            return None

        return attribute_mapping.values.get(
            value,
        )

    def _load_model_mapping(
        self,
    ) -> ModelMapping:
        """
        Load mappings for relations present in the current import schema.
        """

        source_relations = self._load_source_relations()
        dictionary_classes = self._load_dictionary_classes()
        dictionary_attributes = self._load_attribute_mappings()
        dictionary_values = self._load_value_mappings()

        classes: dict[
            str,
            ClassMapping,
        ] = {}

        for source_relation in source_relations.values():
            class_definition = dictionary_classes.get(
                source_relation.table_name,
            )

            if class_definition is None:
                continue

            ili_class_name, canonical_class_id = class_definition

            attributes: dict[
                str,
                AttributeMapping,
            ] = {}

            for (
                ili_attribute_name,
                attribute_mapping,
            ) in dictionary_attributes.get(
                ili_class_name,
                {},
            ).items():
                source_attribute_name = self._source_attribute_name(
                    ili_attribute_name,
                )

                if source_attribute_name not in source_relation.columns:
                    continue

                values = dictionary_values.get(
                    (
                        ili_class_name,
                        ili_attribute_name,
                    ),
                    {},
                )

                attributes[source_attribute_name] = AttributeMapping(
                    canonical_class_id=(attribute_mapping.canonical_class_id),
                    canonical_attr_id=(attribute_mapping.canonical_attr_id),
                    foreign_key=(attribute_mapping.foreign_key),
                    values=dict(
                        values,
                    ),
                )

            classes[source_relation.table_name] = ClassMapping(
                canonical_class_id=canonical_class_id,
                attributes=attributes,
            )

        return ModelMapping(
            classes=classes,
            is_ssot=False,
        )

    def _load_source_relations(
        self,
    ) -> dict[
        str,
        _SourceRelation,
    ]:
        """
        Return physical relations and columns in the import schema.
        """

        query = sql.SQL("""
            SELECT
                table_name,
                column_name
            FROM
                information_schema.columns
            WHERE
                table_schema = %s
            ORDER BY
                table_name,
                ordinal_position;
            """)

        columns_by_table: dict[
            str,
            set[str],
        ] = {}

        for table_name, column_name in self._fetchall(
            query,
            (self.import_schema,),
        ):
            columns_by_table.setdefault(
                str(
                    table_name,
                ),
                set(),
            ).add(
                str(
                    column_name,
                )
            )

        if not columns_by_table:
            raise RuntimeError(
                "The import schema contains no readable relations: " f"{self.import_schema!r}."
            )

        return {
            table_name: _SourceRelation(
                table_name=table_name,
                columns=frozenset(
                    columns,
                ),
            )
            for table_name, columns in columns_by_table.items()
        }

    def _load_dictionary_classes(
        self,
    ) -> dict[
        str,
        tuple[
            str,
            str,
        ],
    ]:
        """
        Load dictionary classes keyed by physical source table name.
        """

        ili_name_column = self._ili_name_column()

        query = sql.SQL("""
            SELECT
                tablename,
                {ili_name_column} AS ili_class_name
            FROM
                {schema}.{table_dictionary}
            ORDER BY
                tablename;
            """).format(
            ili_name_column=sql.Identifier(
                ili_name_column,
            ),
            schema=sql.Identifier(
                self.dictionary_schema,
            ),
            table_dictionary=sql.Identifier(
                self.table_dictionary,
            ),
        )

        classes: dict[
            str,
            tuple[
                str,
                str,
            ],
        ] = {}

        for canonical_class_id, ili_class_name in self._fetchall(
            query,
        ):
            if not ili_class_name:
                continue

            source_table_name = self._source_class_name(
                str(
                    ili_class_name,
                )
            )

            classes[source_table_name] = (
                str(
                    ili_class_name,
                ),
                str(
                    canonical_class_id,
                ),
            )

        return classes

    def _load_attribute_mappings(
        self,
    ) -> dict[
        str,
        dict[
            str,
            AttributeMapping,
        ],
    ]:
        """
        Load dictionary mappings for canonical attributes.
        """

        ili_name_column = self._ili_name_column()

        query = sql.SQL("""
            SELECT
                t.tablename AS canonical_class_id,
                a.field_name AS canonical_attr_id,
                t.{ili_name_column} AS ili_class_name,
                a.{ili_name_column} AS ili_attribute_name
            FROM
                {schema}.{attribute_dictionary} AS a
            JOIN
                {schema}.{table_dictionary} AS t
                    ON t.id = a.class_id
            ORDER BY
                t.tablename,
                a.field_name;
            """).format(
            ili_name_column=sql.Identifier(
                ili_name_column,
            ),
            schema=sql.Identifier(
                self.dictionary_schema,
            ),
            attribute_dictionary=sql.Identifier(
                self.attribute_dictionary,
            ),
            table_dictionary=sql.Identifier(
                self.table_dictionary,
            ),
        )

        classes: dict[
            str,
            dict[
                str,
                AttributeMapping,
            ],
        ] = {}

        for (
            canonical_class_id,
            canonical_attr_id,
            ili_class_name,
            ili_attribute_name,
        ) in self._fetchall(
            query,
        ):
            if not ili_class_name or not ili_attribute_name:
                continue

            source_attribute_name = str(
                ili_attribute_name,
            )

            classes.setdefault(
                str(
                    ili_class_name,
                ),
                {},
            )[source_attribute_name] = AttributeMapping(
                canonical_class_id=str(
                    canonical_class_id,
                ),
                canonical_attr_id=(
                    self._target_attribute_name(
                        str(
                            canonical_attr_id,
                        )
                    )
                ),
            )

        return classes

    def _load_value_mappings(
        self,
    ) -> dict[
        tuple[
            str,
            str,
        ],
        dict[
            str,
            ValueMapping,
        ],
    ]:
        """
        Load dictionary mappings for canonical value-list values.
        """

        ili_name_column = self._ili_name_column()

        query = sql.SQL("""
            SELECT
                t.{ili_name_column} AS ili_class_name,
                f.{ili_name_column} AS ili_attribute_name,
                v.{ili_name_column} AS ili_value_name,
                v.value_id AS canonical_value_id,
                v.value_name AS canonical_value_name
            FROM
                {schema}.{value_dictionary} AS v
            JOIN
                {schema}.{table_dictionary} AS t
                    ON t.id = v.class_id
            JOIN
                {schema}.{attribute_dictionary} AS f
                    ON f.class_id = v.class_id
                   AND f.attribute_id = v.attribute_id
            ORDER BY
                ili_class_name,
                ili_attribute_name,
                ili_value_name;
            """).format(
            ili_name_column=sql.Identifier(
                ili_name_column,
            ),
            schema=sql.Identifier(
                self.dictionary_schema,
            ),
            value_dictionary=sql.Identifier(
                self.value_dictionary,
            ),
            table_dictionary=sql.Identifier(
                self.table_dictionary,
            ),
            attribute_dictionary=sql.Identifier(
                self.attribute_dictionary,
            ),
        )

        mappings: dict[
            tuple[
                str,
                str,
            ],
            dict[
                str,
                ValueMapping,
            ],
        ] = {}

        for (
            ili_class_name,
            ili_attribute_name,
            ili_value_name,
            canonical_value_id,
            canonical_value_name,
        ) in self._fetchall(
            query,
        ):
            if not ili_class_name or not ili_attribute_name or not ili_value_name:
                continue

            mappings.setdefault(
                (
                    str(
                        ili_class_name,
                    ),
                    str(
                        ili_attribute_name,
                    ),
                ),
                {},
            )[str(ili_value_name)] = ValueMapping(
                canonical_value_id=canonical_value_id,
                value=canonical_value_name,
            )

        return mappings

    def _source_class_name(
        self,
        ili_class_name: str,
    ) -> str:
        """
        Return the physical quarantine relation for an INTERLIS class.
        """

        return ili_class_name.rsplit(
            ".",
            maxsplit=1,
        )[-1].lower()

    def _source_attribute_name(
        self,
        ili_attribute_name: str,
    ) -> str:
        """
        Return the physical quarantine column for an INTERLIS attribute.
        """

        overridden_name = SOURCE_ATTRIBUTE_OVERRIDES.get(
            ili_attribute_name,
            ili_attribute_name,
        )

        return overridden_name.lower()

    def _target_attribute_name(
        self,
        canonical_attribute_name: str,
    ) -> str:
        """
        Return the canonical target attribute identifier.
        """

        return TARGET_ATTRIBUTE_OVERRIDES.get(
            canonical_attribute_name,
            canonical_attribute_name,
        )

    def _fetchall(
        self,
        query: sql.Composed | sql.SQL,
        parameters: tuple = (),
    ) -> list[tuple,]:
        """
        Execute a read-only query and return all rows.

        If execution fails, append the fully rendered SQL query and its parameters
        to the raised exception.
        """

        with self.connection_factory.connection(
            autocommit=True,
        ) as connection:
            rendered_query = query.as_string(
                connection,
            )

            try:
                with connection.cursor() as cursor:
                    cursor.execute(
                        query,
                        parameters,
                    )

                    return list(cursor.fetchall())

            except Exception as exception:
                raise RuntimeError(
                    "Implicit model-mapping query failed.\n"
                    f"Import schema: {self.import_schema!r}\n"
                    f"Dictionary schema: {self.dictionary_schema!r}\n"
                    f"Language: {self.language.value!r}\n"
                    f"Parameters: {parameters!r}\n"
                    "SQL query:\n"
                    f"{rendered_query}"
                ) from exception

    def _ili_name_column(
        self,
    ) -> str:
        """
        Return the localized INTERLIS-name dictionary column.
        """

        return f"ili_name_{self.language.value}"
