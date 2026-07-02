
from dataclasses import dataclass
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
