from ...interlis import config
from .model_base import ModelBase


class ModelTwwVl(ModelBase):
    inheritance_key = None

    def __init__(self):
        super().__init__(config.TWW_VL_SCHEMA)


class ModelTwwSys(ModelBase):
    inheritance_key = None

    def __init__(self):
        super().__init__(config.TWW_SYS_SCHEMA)
