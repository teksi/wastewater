from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass
from typing import Any


def fake_connection_factory(
    results: Sequence[
        FakeQueryResult,
    ] = (),
) -> tuple[
    FakeConnectionFactory,
    FakeCursor,
]:
    """
    Create a fake connection factory and expose its cursor for assertions.
    """

    cursor = FakeCursor(
        results=results,
    )

    connection = FakeConnection(
        cursor=cursor,
    )

    factory = FakeConnectionFactory(
        connection=connection,
    )

    return (
        factory,
        cursor,
    )

@dataclass(
    frozen=True,
    slots=True,
)
class FakeColumn:
    name: str

    def __getitem__(
        self,
        index: int,
    ) -> str:
        if index != 0:
            raise IndexError(
                index,
            )

        return self.name


@dataclass(
    frozen=True,
    slots=True,
)
class FakeQueryResult:
    """
    Rows and column names returned by one executed query.
    """

    rows: tuple[
        tuple[
            Any,
            ...,
        ],
        ...,
    ] = ()

    column_names: tuple[
        str,
        ...,
    ] = ()


class FakeCursor:
    """
    Cursor returning queued query results.

    One FakeQueryResult is consumed for every call to execute().
    """

    def __init__(
        self,
        results: Sequence[
            FakeQueryResult,
        ] = (),
    ) -> None:
        self.results = list(
            results,
        )

        self.executed_queries: list[
            tuple[
                Any,
                tuple[
                    Any,
                    ...,
                ],
            ]
        ] = []

        self._current_result = (
            FakeQueryResult()
        )

        self.description = None

    def execute(
        self,
        query,
        parameters=(),
    ) -> None:
        self.executed_queries.append(
            (
                query,
                tuple(
                    parameters or (),
                ),
            )
        )

        if not self.results:
            raise AssertionError(
                "No fake query result remains for executed query: "
                f"{query!r}"
            )

        self._current_result = (
            self.results.pop(
                0,
            )
        )

        self.description = tuple(
            FakeColumn(
                name=column_name,
            )
            for column_name
            in self._current_result.column_names
        )

    def fetchall(
        self,
    ) -> list[
        tuple[
            Any,
            ...,
        ]
    ]:
        return list(
            self._current_result.rows,
        )

    def fetchone(
        self,
    ) -> tuple[
        Any,
        ...,
    ] | None:
        if not self._current_result.rows:
            return None

        return self._current_result.rows[
            0
        ]


class FakeCursorContext:
    def __init__(
        self,
        cursor,
    ) -> None:
        self.cursor_instance = cursor

    def __enter__(
        self,
    ):
        return self.cursor_instance

    def __exit__(
        self,
        exc_type,
        exc_value,
        traceback,
    ) -> None:
        return None


class FakeConnection:
    def __init__(
        self,
        cursor,
    ) -> None:
        self.cursor_instance = cursor

    def cursor(
        self,
    ):
        return FakeCursorContext(
            self.cursor_instance,
        )


class FakeConnectionContext:
    def __init__(
        self,
        connection,
    ) -> None:
        self.connection = connection

    def __enter__(
        self,
    ):
        return self.connection

    def __exit__(
        self,
        exc_type,
        exc_value,
        traceback,
    ) -> None:
        return None


class FakeConnectionFactory:
    def __init__(
        self,
        connection=None,
    ) -> None:
        self.connection_instance = connection
        self.autocommit_values = []
        self.apply_to_database_config_calls = 0

    def connection(
        self,
        *,
        autocommit: bool = False,
    ):
        self.autocommit_values.append(
            autocommit,
        )

        if self.connection_instance is None:
            raise AssertionError(
                "No fake connection was configured."
            )

        return FakeConnectionContext(
            self.connection_instance,
        )

    def apply_to_database_config(
        self,
    ) -> None:
        self.apply_to_database_config_calls += 1