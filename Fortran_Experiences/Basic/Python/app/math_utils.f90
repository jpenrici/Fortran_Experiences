! app/math_utils.f90
! Library for testing interoperability between Fortran and Python.

module math_utils

   use iso_c_binding
   implicit none

contains

   ! Calculate the square root of a sum (Euclidean norm)
   function compute_norm(a, b) bind(c, name="compute_norm")
      real(c_double), intent(in), value :: a, b
      real(c_double) :: compute_norm

      compute_norm = sqrt(a**2 + b**2)
   end function compute_norm

   ! Multiply an array by a scalar
   subroutine scale_array(array, size, factor) bind(c, name="scale_array")
      integer(c_int), intent(in), value :: size
      real(c_double), intent(inout) :: array(size)
      real(c_double), intent(in), value :: factor

      integer :: i
      do i = 1, size
         array(i) = array(i)*factor
      end do
   end subroutine scale_array

end module math_utils
