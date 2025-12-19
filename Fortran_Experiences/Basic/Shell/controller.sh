#!/bin/bash

# Configuration
EXECUTABLE="./bin/analysis"
DATA_FILE="./output/sample.csv"
BUILD_DIRS=("build" "bin" "output")

# --- Helper Functions ---
display_usage() {
    echo "Usage: ./script.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --output <file_path>  Set the path for the data file."
    echo "  --clean               Remove build, bin, and output directories."
    echo "  --help                Display this help message."
}

# --- Main ---
# 1. Argument Parsing
while [[ $# -gt 0 ]]; do
    case "$1" in
        --output)
            # Ensure the next argument exists and isn't another flag
            if [[ -n "$2" && "$2" != -* ]]; then
                DATA_FILE="$2"
                shift 2
            else
                echo "Error: --output requires a valid file path."
                exit 1
            fi
            ;;
        --clean)
            echo "Cleaning up project artifacts..."
            for dir in "${BUILD_DIRS[@]}"; do
                if [[ -d "$dir" ]]; then
                    rm -rf "$dir"
                    echo "Removed: $dir/"
                fi
            done
            echo "Cleanup complete."
            exit 0
            ;;
        --help)
            display_usage
            exit 0
            ;;
        *)
            echo "Error: Unknown argument '$1'"
            display_usage
            exit 1
            ;;
    esac
done

echo "[Shell] Checking environment..."

# 2. Check Python
if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 is not installed."
    exit 1
fi

# 3. Check/Build Fortran Executable
if [[ ! -f "$EXECUTABLE" ]]; then
    echo "[Shell] Executable not found. Running CMake..."
    mkdir -p build
    cd build || exit
    cmake .. && make
    cd ..
fi

# 4. Run Python Generator
echo "[Shell] Running Python generator..."
python3 python/generator.py --output "$DATA_FILE"

# 5. Check if file was created
if [[ -f "$DATA_FILE" ]]; then
    echo "[Shell] Data file found. Executing Fortran analysis..."
    $EXECUTABLE "$DATA_FILE"
else
    echo "Error: $DATA_FILE was not generated."
    exit 1
fi

# 6. Gnuplot
echo "[Gnuplot] Preparing plot..."
if ! command -v gnuplot &> /dev/null; then
    echo "Error: Gnuplot was not found. It is not possible to plot the data from '$DATA_FILE'"
    exit 0
fi

BASE_NAME="${DATA_FILE%.*}"
OUTPUT_PNG="${BASE_NAME}_histogram.png"

gnuplot <<- EOF
    set terminal pngcairo size 800,600
    set output "$OUTPUT_PNG"

    set title "Histogram: $(basename "$DATA_FILE")"
    set style fill solid 0.5 border -1

    bin_width = 1.0
    bin(x, s) = s * floor(x / s)

    # Filter data: ignore non-numeric and headers
    plot "< awk '\$1 ~ /^[0-9.eE+-]+$/ {print \$1}' $DATA_FILE" \
             using (bin(\$1, bin_width)):(1.0) \
             smooth frequency with boxes title "Values"
EOF

echo "Process finished. Output saved to: $OUTPUT_PNG"

# 7. Exit
exit 0
