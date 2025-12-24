#!/bin/bash

# ==============================================================================
# File: controller.sh
# Description: Advanced CLI orchestrator for the image processing pipeline.
# ==============================================================================

# Terminal colors : Output formatting
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Paths and Project Structure
RESOURCES_DIR="./resources" # where the outputs will be stored
VENV_PATH="./.venv"
GEN_BUILD_DIR="./image_generator/build"
ANALYZER_BUILD_DIR="./data_analyzer/build"

# Artifacts
PPM_OUT="$RESOURCES_DIR/fractal.ppm"
CSV_OUT="$RESOURCES_DIR/data.csv"
STATS_OUT="$RESOURCES_DIR/stats.dat"
PLOT_OUT="$RESOURCES_DIR/histogram.png"

# Binaries and Scripts
GEN_BIN="$GEN_BUILD_DIR/image_gen"
ANALYZER_BIN="$ANALYZER_BUILD_DIR/data_analyzer"
PY_CONVERTER="./image_converter/ppm2csv.py"
GP_SCRIPT="./image_plot/histogram.gp"

# --- Functions ---

show_help() {
    echo -e "${CYAN}Usage: ./controller.sh [OPTIONS]${NC}"
    echo -e "Options:"
    echo -e "  --setup      Create .venv and install dependencies (Numpy)"
    echo -e "  --clean      Remove build directories and resource files"
    echo -e "  --build      Compile C++ and Fortran projects"
    echo -e "  --gen        Generate the Fractal image (C++)"
    echo -e "  --ppm2csv    Convert PPM to CSV (Python/Numpy)"
    echo -e "  --analyze    Process CSV data for statistics (Fortran)"
    echo -e "  --plot       Generate histogram (Gnuplot)"
    echo -e "  --all        Run full pipeline"
}

setup_env() {
    echo -e "${GREEN}>>> Setting up Python environment...${NC}"
    if [ ! -d "$VENV_PATH" ]; then
        python3 -m venv "$VENV_PATH"
    fi
    # shellcheck source=/dev/null
    source "$VENV_PATH/bin/activate"
    pip install --upgrade pip
    pip install numpy
    echo -e "${GREEN}>>> Environment ready.${NC}"
}

clean_all() {
    echo -e "${YELLOW}Cleaning environment...${NC}"
    rm -rf "$GEN_BUILD_DIR" "$ANALYZER_BUILD_DIR" "$RESOURCES_DIR"
    echo "Removed builds and resources."
}

check_env() {
    # Check for Gnuplot
    command -v gnuplot &> /dev/null || { echo -e "${RED}Error: Gnuplot not found.${NC}"; exit 1; }

    # Check Python Venv
    if [ ! -d "$VENV_PATH" ]; then
        echo -e "${RED}Error: Virtual environment (.venv) not found.${NC}"
        exit 1
    fi

    mkdir -p "$RESOURCES_DIR"
}

compile_projects() {
    echo -e "${GREEN}>>> Building C++ Image Generator...${NC}"
    mkdir -p "$GEN_BUILD_DIR" && cd "$GEN_BUILD_DIR" && cmake .. && make && cd - || exit

    echo -e "${GREEN}>>> Building Fortran Analyzer...${NC}"
    mkdir -p "$ANALYZER_BUILD_DIR" && cd "$ANALYZER_BUILD_DIR" && cmake .. && make && cd - || exit
}

# --- Command Logic ---

if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        --setup)
            setup_env
            shift
            ;;
        --clean)
            clean_all
            shift
            ;;
        --build)
            check_env || exit 1
            compile_projects
            shift
            ;;
        --gen)
            echo -e "${GREEN}>>> Executing C++ Generator...${NC}"
            [ ! -f "$GEN_BIN" ] && echo -e "${RED}Bin not found. Run --build first.${NC}" && exit 1
            "$GEN_BIN" "$PPM_OUT"
            shift
            ;;
        --ppm2csv)
            echo -e "${GREEN}>>> Executing Python/Numpy Converter...${NC}"
            # shellcheck source=/dev/null
            source "$VENV_PATH/bin/activate"
            python3 "$PY_CONVERTER" "$PPM_OUT" "$CSV_OUT"
            shift
            ;;
        --analyze)
            echo -e "${GREEN}>>> Executing Fortran Analyzer...${NC}"
            [ ! -f "$ANALYZER_BIN" ] && echo -e "${RED}Bin not found. Run --build first.${NC}" && exit 1
            "$ANALYZER_BIN" "$CSV_OUT" "$STATS_OUT"
            shift
            ;;
        --plot)
            # Check if the plot file exists
            if [ ! -f "$GP_SCRIPT" ]; then
               echo -e "${RED}Error: $GP_SCRIPT not found. Plotting will not be possible!${NC}"
               exit 1
            fi
            # Check if the data file was generated correctly
            if [ ! -f "$STATS_OUT" ]; then
               echo -e "${RED}Error: $STATS_OUT not found. Run --analyze first.${NC}"
               exit 1
            fi

            echo -e "${GREEN}>>> Rendering Histogram...${NC}"

            # Plot histogram
            gnuplot -e "infile='$STATS_OUT'; outfile='$PLOT_OUT'" "$GP_SCRIPT"

            echo -e "${GREEN}>>> Success! Check $PLOT_OUT${NC}"
            shift
            ;;
        --all)
            $0 --clean || exit 1
            $0 --setup || exit 1
            $0 --build || exit 1
            $0 --gen || exit 1
            $0 --ppm2csv || exit 1
            $0 --analyze || exit 1
            $0 --plot || exit 1
            exit 0
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done
