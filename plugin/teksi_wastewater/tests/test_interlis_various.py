import unittest

from teksi_wastewater.interlis.utils.various import logger


class TestVarious(unittest.TestCase):
    def test_logger(self):
        logger.info("Test info")

        logger.warning("Test with stacklevel=2", stacklevel=2)
