cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project(
  ImageGenerator
  VERSION 1.0
  LANGUAGES CXX)

set(PROGRAM_NAME image_gen)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(SOURCES src/main.cpp)

add_executable(${PROGRAM_NAME} ${SOURCES})

# Optimization flags for fractal generation
target_compile_options(
  ${PROGRAM_NAME}
  PRIVATE # Logic for MSVC (Windows)
          $<$<CXX_COMPILER_ID:MSVC>:/W4
          /O2>
          # Logic for GCC and Clang
          $<$<OR:$<CXX_COMPILER_ID:GNU>,$<CXX_COMPILER_ID:Clang>>:-Wall
          -Wextra
          -Wpedantic
          -O3
          -march=native>
          # Specific aggressive tweaks for GCC 15
          $<$<CXX_COMPILER_ID:GNU>:-ffast-math
          -fopt-info-vec-optimized>)

set_target_properties(${PROGRAM_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                                 "${CMAKE_CURRENT_BINARY_DIR}")

message(STATUS "Project: ${PROJECT_NAME}")
message(STATUS "Target: ${PROGRAM_NAME}")
message(STATUS "Compiler: ${CMAKE_CXX_COMPILER_ID}")
