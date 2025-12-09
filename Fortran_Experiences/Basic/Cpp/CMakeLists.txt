cmake_minimum_required(VERSION 3.25 FATAL_ERROR)

project(
  Fortran_Cpp_Basic
  VERSION 1.0
  LANGUAGES Fortran CXX)

set(FORTRAN_LIB calc)
set(FORTRAN_TEST calc_test)
set(EXECUTABLE_CPP cpp_calc_test)

set(CMAKE_CXX_STANDARD 26)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Fortran
message(STATUS "Fortran Compiler: ${CMAKE_Fortran_COMPILER}")
message(STATUS "Compiler ID: ${CMAKE_Fortran_COMPILER_ID}")

add_library(${FORTRAN_LIB} STATIC app/calc.f90)

target_include_directories(${FORTRAN_LIB} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

add_executable(${FORTRAN_TEST} app/calc_test.f90)

target_link_libraries(${FORTRAN_TEST} ${FORTRAN_LIB})

# C++
add_executable(${EXECUTABLE_CPP} app/main.cpp app/calc_wrapper.h)

target_include_directories(${EXECUTABLE_CPP}
                           PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(${EXECUTABLE_CPP} PRIVATE ${FORTRAN_LIB} ${CMAKE_Fortran_LINK_OPTIONS})

set_target_properties(${EXECUTABLE_CPP} PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                                   "${CMAKE_BINARY_DIR}/bin")

if(CMAKE_Fortran_COMPILER_WORKS)
  target_compile_options(${FORTRAN_LIB} PRIVATE -O3)
  target_compile_options(${FORTRAN_LIB} PRIVATE -fno-stack-arrays)
  target_compile_options(${FORTRAN_LIB} PRIVATE -std=f2018)
endif()
