# -*- coding: utf-8 -*-
# Testing a library developed in Fortran (math_utils)

import sys

try:
    from ctypes import cdll, c_int, c_double
except ModuleNotFoundError:
    print("Module 'cytpes' is not installed!")
    sys.exit(0)

try:
    import numpy as np
except ModuleNotFoundError:
    print("Module 'numpy' is not installed!")
    sys.exit(0)

try:
    lib_name = "fortran_math.so"
    lib_path = f'./lib/{lib_name}'
    fortran_lib = cdll.LoadLibrary(lib_path)
except OSError:
    print(f"File '{lib_name}' not found!")
    sys.exit(0)


def test():
    # 1. Testing a function (scalar return)
    fortran_lib.compute_norm.restype = c_double
    fortran_lib.compute_norm.argtypes = [c_double, c_double] # x,y
    
    result = fortran_lib.compute_norm(3.0, 4.0)
    print(f"Fortran Norm Result: {result}")
    
    # 2. Testing a subroutine (array manipulation)
    fortran_lib.scale_array.argtypes = [
        np.ctypeslib.ndpointer(dtype=np.float64),   # array (pointer)
        c_int,                                      # size (value)
        c_double]                                   # factor (value)
                               
    data = np.array([1.0, 2.0, 3.0, 4.0, 5.0], dtype=np.float64)
    
    fortran_lib.scale_array(data, len(data), 2.0)
    print(f"Fortran Scaled Array: {data}")
    

if __name__ == "__main__":
    test()