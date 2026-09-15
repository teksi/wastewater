# teksi_wastewater/hooks/exceptions.py

from __future__ import annotations

from teksi_hooks.exceptions import (
    Finding,
    Severity,
    TeksiHookError,
    ValidationError,
)
from teksi_hooks.models.validation import (
    ValidationFinding,
)


class QuarantineValidationError(
    ValidationError,
):
    """
    Raised when quarantine schema validation fails.
    """

    def __init__(
        self,
        findings: tuple[
            ValidationFinding,
            ...,
        ],
        log_path: str | None = None,
    ) -> None:
        self.log_path = log_path

        super().__init__(
            findings,
        )


class TwwDiffSchemaError(
    TeksiHookError,
):
    """
    Base class for TEKSI Wastewater diff-schema failures.
    """


class DiffJobNotFoundError(
    TwwDiffSchemaError,
):
    """
    Raised when a requested diff review job does not exist.
    """

    def __init__(
        self,
        *,
        job_id: str,
    ) -> None:
        self.job_id = job_id

        super().__init__(
            findings=(
                Finding(
                    severity=Severity.ERROR,
                    message=(
                        f"Diff review job {job_id!r} does not exist."
                    ),
                ),
            ),
        )


class DiffJobStateError(
    TwwDiffSchemaError,
):
    """
    Raised when a diff job is not in the required lifecycle state.
    """

    def __init__(
        self,
        *,
        job_id: str,
        expected_status: str,
        actual_status: str,
    ) -> None:
        self.job_id = job_id
        self.expected_status = expected_status
        self.actual_status = actual_status

        super().__init__(
            findings=(
                Finding(
                    severity=Severity.ERROR,
                    message=(
                        f"Diff review job {job_id!r} has status "
                        f"{actual_status!r}; expected "
                        f"{expected_status!r}."
                    ),
                ),
            ),
        )


class DiffJobTransitionError(
    TwwDiffSchemaError,
):
    """
    Raised when a diff-job lifecycle transition cannot be completed.
    """

    def __init__(
        self,
        *,
        job_id: str,
        expected_status: str,
        new_status: str,
        actual_status: str,
    ) -> None:
        self.job_id = job_id
        self.expected_status = expected_status
        self.new_status = new_status
        self.actual_status = actual_status

        super().__init__(
            findings=(
                Finding(
                    severity=Severity.ERROR,
                    message=(
                        f"Diff review job {job_id!r} cannot transition "
                        f"from {expected_status!r} to {new_status!r}. "
                        f"Its current status is {actual_status!r}."
                    ),
                ),
            ),
        )


class DiffJobEligibilityError(
    TwwDiffSchemaError,
):
    """
    Raised when a pending review job is not eligible for acceptance.
    """

    def __init__(
        self,
        *,
        job_id: str,
        reason: str,
    ) -> None:
        self.job_id = job_id
        self.reason = reason

        super().__init__(
            findings=(
                Finding(
                    severity=Severity.ERROR,
                    message=(
                        f"Diff review job {job_id!r} is not eligible "
                        f"for acceptance: {reason}"
                    ),
                ),
            ),
        )


class DiffSchemaContractError(
    TwwDiffSchemaError,
):
    """
    Raised when the persisted tww_diff schema violates its contract.
    """

    def __init__(
        self,
        *,
        message: str,
        table_name: str | None = None,
        column_name: str | None = None,
    ) -> None:
        self.table_name = table_name
        self.column_name = column_name

        context = []

        if table_name is not None:
            context.append(
                f"table={table_name!r}"
            )

        if column_name is not None:
            context.append(
                f"column={column_name!r}"
            )

        context_message = (
            f" ({', '.join(context)})"
            if context
            else ""
        )

        super().__init__(
            findings=(
                Finding(
                    severity=Severity.ERROR,
                    message=(
                        f"{message}{context_message}"
                    ),
                ),
            ),
        )


class DiffJobPersistenceError(
    TwwDiffSchemaError,
):
    """
    Raised when an accepted diff job cannot be persisted.
    """

    def __init__(
        self,
        *,
        job_id: str,
        phase: str,
        message: str,
    ) -> None:
        self.job_id = job_id
        self.phase = phase

        super().__init__(
            findings=(
                Finding(
                    severity=Severity.ERROR,
                    message=(
                        f"Persistence of diff review job {job_id!r} "
                        f"failed during phase {phase!r}: {message}"
                    ),
                ),
            ),
        )