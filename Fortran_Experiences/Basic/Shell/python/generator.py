# -*- coding: utf-8 -*-

import os
import sys
import argparse


try:
    import numpy as np
except ModuleNotFoundError:
    print("Module 'numpy' is not installed!")
    sys.exit(0)


def generate_data(filepath, count=1000):
    # Ensure the directory exists
    directory = os.path.dirname(filepath)
    if directory and not os.path.exists(directory):
        os.makedirs(directory)
        print(f"[Python] Created directory: {directory}")
        
    # Generate random numbers following a normal distribution
    data = np.random.normal(loc=50, scale=15, size=count)
    
    # Save data in the CSV file
    np.savetxt(filepath, data, delimiter=',', header='numbers', comments='')
    print(f"Successfully generated {count} samples in '{filepath}'.")
    

if __name__ == "__main__":
    # Setup argument parser
    parser = argparse.ArgumentParser(description="Generate random numbers for analysis.")
    parser.add_argument('--output', type=str, default="../output/sample.csv",
                        help='Path and filename for the output CSV (default: ../output/sample.csv)')
    args = parser.parse_args()
    generate_data(args.output)
