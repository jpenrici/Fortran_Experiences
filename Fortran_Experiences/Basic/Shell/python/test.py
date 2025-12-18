# -*- coding: utf-8 -*-

import sys

try:
    from generator import generate_data
except ModuleNotFoundError:
    print("The 'generator' module could not be found.")
    sys.exit(0)

if __name__ == '__main__':
    generate_data("../output/numbers.csv", 10)