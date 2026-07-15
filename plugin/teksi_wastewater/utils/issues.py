from dataclasses import dataclass, field
from enum import Enum


class IssueLevel(Enum):
    DEBUG = "debug"
    INFO = "info"
    WARNING = "warning"
    ERROR = "error"


@dataclass
class Issue:
    message: str
    level: IssueLevel = IssueLevel.WARNING


@dataclass
class CheckResult:
    issues: list[Issue] = field(default_factory=list)

    @property
    def failed(self) -> bool:
        return any(i.level == IssueLevel.ERROR for i in self.issues)

    @property
    def failed_checks(self) -> list:
        return [i for i in self.issues if i.level == IssueLevel.ERROR]

    @property
    def stats(self) -> dict[str, int]:
        failed = len(self.failed_checks)
        return {
            "failed": failed,
            "ok": len(self.issues) - failed,
        }

    def add(
        self,
        message: str,
        level: IssueLevel = IssueLevel.WARNING,
    ) -> None:
        self.issues.append(Issue(message, level))
