! app/main.f90
! Library test.

program test_math_utils

   use math_utils
   implicit none

   real(8) :: x, y, norm_result  ! compatibility with c_double and np.float64
   real(8), dimension(5) :: array
   integer :: i

   print '("--- Testing Fortran Math Library ---")'

   ! 1. Testing scalar function (Norm)
   x = 3.0_8
   y = 4.0_8
   norm_result = compute_norm(x, y)

   print '("Result of compute_norm(", F5.2, ",", F5.2, " ): ", F5.2)', x, y, norm_result

   ! 2. Testing subroutine (Array Scaling)
   array = [1.0_8, 2.0_8, 3.0_8, 4.0_8, 5.0_8]
   print '("Original array:", *(F8.3))', array

   call scale_array(array, size(array), 2.0_8)

   print '("Scaled array (factor 2.0):", *(F8.3))', array

   if (abs(norm_result - 5.0_8) < 1e-6) then
      print '("Status: SUCCESS")'
   else
      print '("Status: FAILED")'
   end if

end program test_math_utils
