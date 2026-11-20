from __future__ import annotations

from dataclasses import dataclass, field
from enum import StrEnum
from typing import Any

from psycopg import sql
from sqlalchemy.orm import Session
from teksi_hooks.capabilities.mapping import (
    ImplicitModelMappingCapability,
    ModelMappingCapability,
)
from teksi_hooks.models.mapping import (
    AttributeMapping,
    ClassMapping,
    ModelMapping,
    ValueMapping,
)

SOURCE_CLASS_OVERRIDES = {
    "Zone": "azone",
    "zone": "azone",
}


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
    Describe one relation available in the current quarantine schema.
    """

    table_name: str

    columns: frozenset[str,]


@dataclass(
    slots=True,
)
class TwwImplicitModelMappingAdapter(
    ImplicitModelMappingCapability,
):
    """
    Provide schema-scoped implicit canonical mappings.

    Physical source relations are discovered through the borrowed quarantine
    session. Canonical dictionary metadata is read through the borrowed live
    session.

    The adapter does not:

    - create database sessions;
    - open independent database connections;
    - commit or roll back transactions;
    - close either borrowed session;
    - modify source or canonical data.

    A separate adapter instance must be created for each quarantine schema.
    """

    import_schema: str

    quarantine_session: Session = field(
        repr=False,
    )

    live_session: Session = field(
        repr=False,
    )

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

        if (
            not isinstance(
                self.import_schema,
                str,
            )
            or not self.import_schema.strip()
        ):
            raise ValueError("The import schema must not be empty.")

        if self.quarantine_session is None:
            raise RuntimeError(
                "Implicit model-mapping discovery requires a " "quarantine session."
            )

        if self.live_session is None:
            raise RuntimeError("Implicit model-mapping discovery requires a " "live session.")

        self._model_mapping = self._load_model_mapping()

    def materialize(
        self,
    ) -> ModelMappingCapability:
        """
        Return the fully loaded implicit mapping as a detached capability.

        The implicit mapping is loaded during adapter initialization. The
        returned capability retains only the resolved ``ModelMapping`` and does
        not retain this adapter, either borrowed SQLAlchemy session, database
        connections, cursors or other operation-scoped resources.

        The returned capability may therefore safely outlive the session scope
        in which this adapter was created.
        """
        return ModelMappingCapability(
            mapping=self.model_mapping(),
        )

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
                f"Unknown source attribute "
                f"{attribute_name!r} for class "
                f"{class_id!r} in schema "
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

            (
                ili_class_name,
                canonical_class_id,
            ) = class_definition

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
                canonical_class_id=(canonical_class_id),
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

        The lookup uses the borrowed quarantine session.
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
            set[str,],
        ] = {}

        rows = self._fetchall(
            session=self.quarantine_session,
            query=query,
            parameters=(self.import_schema,),
            query_role="source relation discovery",
        )

        for (
            table_name,
            column_name,
        ) in rows:
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
                "The import schema contains no readable " f"relations: {self.import_schema!r}."
            )

        return {
            table_name: _SourceRelation(
                table_name=table_name,
                columns=frozenset(
                    columns,
                ),
            )
            for (
                table_name,
                columns,
            ) in columns_by_table.items()
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

        Dictionary metadata is read through the borrowed live session.
        """

        query = sql.SQL("""
            SELECT
                tablename,
                {cls_name_column} AS ili_class_name
            FROM
                {schema}.{table_dictionary}
            ORDER BY
                tablename;
            """).format(
            cls_name_column=sql.Identifier(
                self._ili_name_column(
                    "name",
                ),
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

        rows = self._fetchall(
            session=self.live_session,
            query=query,
            query_role="class dictionary discovery",
        )

        for (
            canonical_class_id,
            ili_class_name,
        ) in rows:
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

        Dictionary metadata is read through the borrowed live session.
        """

        query = sql.SQL("""
            SELECT
                t.tablename AS canonical_class_id,
                a.field_name AS canonical_attr_id,
                t.{cls_name_column} AS ili_class_name,
                a.{attr_name_column} AS ili_attribute_name
            FROM
                {schema}.{attribute_dictionary} AS a
            JOIN
                {schema}.{table_dictionary} AS t
                    ON t.id = a.class_id
            ORDER BY
                t.tablename,
                a.field_name;
            """).format(
            cls_name_column=sql.Identifier(
                self._ili_name_column(
                    "name",
                ),
            ),
            attr_name_column=sql.Identifier(
                self._ili_name_column(
                    "field_name",
                ),
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

        rows = self._fetchall(
            session=self.live_session,
            query=query,
            query_role="attribute dictionary discovery",
        )

        for (
            canonical_class_id,
            canonical_attr_id,
            ili_class_name,
            ili_attribute_name,
        ) in rows:
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

        Dictionary metadata is read through the borrowed live session.
        """

        query = sql.SQL("""
            SELECT
                t.{cls_name_column} AS ili_class_name,
                f.{attr_name_column} AS ili_attribute_name,
                v.{val_name_column} AS ili_value_name,
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
            cls_name_column=sql.Identifier(
                self._ili_name_column(
                    "name",
                ),
            ),
            attr_name_column=sql.Identifier(
                self._ili_name_column(
                    "field_name",
                ),
            ),
            val_name_column=sql.Identifier(
                self._ili_name_column(
                    "value_name",
                ),
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

        rows = self._fetchall(
            session=self.live_session,
            query=query,
            query_role="value dictionary discovery",
        )

        for (
            ili_class_name,
            ili_attribute_name,
            ili_value_name,
            canonical_value_id,
            canonical_value_name,
        ) in rows:
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
            )[
                str(
                    ili_value_name,
                )
            ] = ValueMapping(
                canonical_value_id=(canonical_value_id),
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

        unqualified_class_name = ili_class_name.rsplit(
            ".",
            maxsplit=1,
        )[-1]

        return SOURCE_CLASS_OVERRIDES.get(
            unqualified_class_name,
            unqualified_class_name.lower(),
        )

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
        *,
        session: Session,
        query: sql.Composed | sql.SQL,
        parameters: tuple[
            Any,
            ...,
        ] = (),
        query_role: str,
    ) -> list[tuple,]:
        """
        Execute one read-only query through a borrowed Psycopg 3 session.

        The DBAPI cursor is created and closed by this method. The supplied
        session and its connection remain owned by the enclosing workflow.
        """

        cursor = self._borrowed_cursor(
            session,
        )

        try:
            cursor.execute(
                query,
                parameters,
            )

            return list(
                cursor.fetchall(),
            )

        except Exception as exception:
            rendered_query = self._render_query(
                query=query,
                cursor=cursor,
            )

            raise RuntimeError(
                "Implicit model-mapping query failed.\n"
                f"Query role: {query_role!r}\n"
                f"Import schema: {self.import_schema!r}\n"
                f"Dictionary schema: "
                f"{self.dictionary_schema!r}\n"
                f"Language: {self.language.value!r}\n"
                f"Parameters: {parameters!r}\n"
                "SQL query:\n"
                f"{rendered_query}"
            ) from exception

        finally:
            cursor.close()

    def _borrowed_cursor(
        self,
        session: Session,
    ):
        """
        Create a Psycopg 3 cursor from a borrowed SQLAlchemy session.

        The caller owns closing the cursor. The adapter must not close the
        SQLAlchemy connection, DBAPI connection, or session.
        """

        sqlalchemy_connection = session.connection()

        connection_fairy = sqlalchemy_connection.connection

        driver_connection = getattr(
            connection_fairy,
            "driver_connection",
            None,
        )

        if driver_connection is None:
            driver_connection = getattr(
                connection_fairy,
                "connection",
                None,
            )

        if driver_connection is None:
            raise RuntimeError(
                "Could not access the DBAPI connection owned "
                "by the supplied SQLAlchemy session."
            )

        driver_module = type(
            driver_connection,
        ).__module__

        if not (driver_module == "psycopg" or driver_module.startswith("psycopg.")):
            raise RuntimeError(
                "The SQLAlchemy engine is not using Psycopg 3. "
                "Expected a DBAPI connection from module "
                f"'psycopg', received {driver_module!r}. "
                "Configure the engine with the "
                "'postgresql+psycopg' dialect."
            )

        return driver_connection.cursor()

    def _render_query(
        self,
        *,
        query: sql.Composed | sql.SQL,
        cursor,
    ) -> str:
        """
        Render one Psycopg 3 composable query for diagnostics.

        Rendering is best-effort and must not hide the original database error.
        """

        try:
            return query.as_string(
                cursor.connection,
            )

        except Exception:
            return str(
                query,
            )

    def _ili_name_column(
        self,
        prefix: str,
    ) -> str:
        """
        Return the localized INTERLIS-name dictionary column.
        """

        if prefix not in {
            "field_name",
            "value_name",
            "name",
        }:
            raise ValueError(f"Dictionary level {prefix!r} is not " "supported.")

        return f"{prefix}_" f"{self.language.value}"
