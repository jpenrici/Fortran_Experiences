#!/bin/bash

# Configuration
EXECUTABLE="./bin/analysis"
DATA_FILE="./output/sample.csv"

echo "[Shell] Checking environment..."

# 1. Check Python
if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 is not installed."
    exit 1
fi

# 2. Check/Build Fortran Executable
if [ ! -f "$EXECUTABLE" ]; then
    echo "[Shell] Executable not found. Running CMake..."
    mkdir -p build
    cd build || exit
    cmake .. && make
    cd ..
fi

# 3. Run Python Generator
echo "[Shell] Running Python generator..."
python3 python/generator.py --output "$DATA_FILE"

# 4. Check if file was created
if [ -f "$DATA_FILE" ]; then
    echo "[Shell] Data file found. Executing Fortran analysis..."
    $EXECUTABLE
else
    echo "Error: $DATA_FILE was not generated."
    exit 1
fi

# 5. Gnuplot call  << TO DO >>
# gnuplot -e "set datafile separator ','; plot '$DATA_FILE' with histograms"
