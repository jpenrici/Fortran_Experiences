// app/calc_wrapper.h
#ifndef CALC_WRAPPER_H
#define CALC_WRAPPER_H

#ifdef __cplusplus
extern "C" {
#endif

// Declaration of the function implemented in Fortran.
double dot_product_fortran(int n, const void *vector1_ptr,
                           const void *vector2_ptr);

#ifdef __cplusplus
}
#endif

#endif // CALC_WRAPPER_H
