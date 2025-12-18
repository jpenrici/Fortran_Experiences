cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project(
  Analysis
  VERSION 1.0
  LANGUAGES Fortran)

# Fortran
message(STATUS "Fortran Compiler: ${CMAKE_Fortran_COMPILER}")
message(STATUS "Compiler ID: ${CMAKE_Fortran_COMPILER_ID}")

set(SOURCE_DIR "app")
file(GLOB SOURCES "${SOURCE_DIR}/*.f90" "${SOURCE_DIR}/*.F90"
     "${SOURCE_DIR}/*.f")

# Test
set(FORTRAN_TEST analysis)
add_executable(${FORTRAN_TEST} "${SOURCE_DIR}/analysis.f90")

set(EXECUTABLE_DIR "${PROJECT_SOURCE_DIR}/bin")
set_target_properties(${FORTRAN_TEST} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                                 ${EXECUTABLE_DIR})

if(CMAKE_Fortran_COMPILER_WORKS)
  target_compile_options(${FORTRAN_TEST} PRIVATE -O3)
  target_compile_options(${FORTRAN_TEST} PRIVATE -std=f2018)
endif()

# Python Enviroment Setup
include(./PythonEnvSetup.cmake)

if(EXISTS "${CMAKE_SOURCE_DIR}/.venv")
  execute_process(COMMAND "${CMAKE_SOURCE_DIR}/.venv/bin/python" -m pip install
                          numpy)
else()
  message(WARNING "Python Virtual Environment not found!")
  message(
    WARNING "Interoperability with the Fortran library cannot be guaranteed.")
endif()
