cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project(
  DataAnalyzer
  VERSION 1.0
  LANGUAGES Fortran)

set(PROGRAM_NAME data_analyzer)

add_executable(${PROGRAM_NAME} app/main.f90)

target_compile_options(
  ${PROGRAM_NAME}
  PRIVATE $<$<Fortran_COMPILER_ID:GNU>:
          -O3
          -march=native
          -ffree-line-length-none
          -std=f2018
          -Wall
          >)

set_target_properties(${PROGRAM_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                                 "${CMAKE_CURRENT_BINARY_DIR}")

message(STATUS "Project: ${PROJECT_NAME}")
message(STATUS "Target: ${PROGRAM_NAME}")
message(STATUS "Compiler: ${Fortran_COMPILER_ID}")
