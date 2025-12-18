cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project(
  Fortran_Py_Basic
  VERSION 1.0
  LANGUAGES Fortran)

# Fortran
set(SOURCE_DIR "app")
file(GLOB SOURCES "${SOURCE_DIR}/*.f90" "${SOURCE_DIR}/*.F90"
     "${SOURCE_DIR}/*.f")

message(STATUS "Fortran Compiler: ${CMAKE_Fortran_COMPILER}")
message(STATUS "Compiler ID: ${CMAKE_Fortran_COMPILER_ID}")

# Fortran Shared Library
set(FORTRAN_LIB fortran_math)
set(LIBRARY_OUTPUT_PATH "${CMAKE_SOURCE_DIR}/app/lib")

add_library(${FORTRAN_LIB} SHARED "${SOURCE_DIR}/math_utils.f90")

set_target_properties(
  ${FORTRAN_LIB} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${LIBRARY_OUTPUT_PATH}"
                            PREFIX "") # remove the 'lib' prefix

# Test
set(FORTRAN_TEST test)
add_executable(${FORTRAN_TEST} "${SOURCE_DIR}/main.f90")
target_link_libraries(${FORTRAN_TEST} ${FORTRAN_LIB})

set_target_properties(${FORTRAN_TEST} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                                 ${CMAKE_CURRENT_BINARY_DIR})

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
