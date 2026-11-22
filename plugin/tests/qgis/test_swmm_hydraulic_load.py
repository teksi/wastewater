import unittest
from unittest.mock import Mock

from teksi_wastewater.processing_provider.TwwSwmm import TwwSwmm


class TestSwmmHydraulicLoad(unittest.TestCase):
    def setUp(self):
        self.swmm = TwwSwmm(None, None, None, None, None, None, None, None)

    def test_convert_max_over_full_flow(self):
        values = [
            ("0.02", 2),
            ("0.20", 20),
            ("0.40", 40),
            ("0.60", 60),
            ("0.80", 80),
            ("0.99", 99),
            ("1.25", 125),
        ]

        for ratio, expected in values:
            with self.subTest(ratio=ratio):
                rows = [{"max_over_full_flow": ratio}]
                converted = self.swmm.convert_max_over_full_flow(rows)
                self.assertEqual(converted[0]["max_over_full_flow"], expected)

    def test_import_hydraulic_load_uses_reach_column(self):
        self.swmm.extract_link_flow_summary = Mock(
            return_value=[{"id": "reach1", "max_over_full_flow": "0.40"}]
        )
        self.swmm.populate_attribute = Mock()

        self.swmm.import_hydraulic_load()

        self.swmm.populate_attribute.assert_called_once_with(
            [{"id": "reach1", "max_over_full_flow": 40}],
            "reach",
            "hydraulic_load_current",
            "max_over_full_flow",
        )
