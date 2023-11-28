import logging
import sys

from . import main

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG, format="%(levelname)s\t%(message)s")
    main(sys.argv[1:])
