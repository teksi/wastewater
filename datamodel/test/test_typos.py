import glob
import os
import unittest


class TestTypos(unittest.TestCase):
    def test_typos(self):
        thisdir = os.path.dirname(os.path.realpath(__file__))
        for filename in glob.glob(os.path.join(thisdir, "..", "*.sql")):
            with open(os.path.join(os.getcwd(), "..", filename)) as f:
                for line in f:
                    self.assertNotIn("dammage", line)
                    self.assertNotIn("relativ_path", line)
                    self.assertNotIn(
                        "AddGeometryColumn",
                        line,
                        msg="""AddGeometryColumn should no longer be used. Use
                            ALTER TABLE syntax instead""",
                    )


if __name__ == "__main__":
    unittest.main()
