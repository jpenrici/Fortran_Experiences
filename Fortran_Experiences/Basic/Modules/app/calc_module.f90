! app/calc_module.f90
! Simple Calculate

module calc

   implicit none

   public :: public_var, print_matrix, sum_matrix

   real, parameter :: public_var = 2.0
   integer, private :: private_var = 0

contains

   subroutine print_matrix(matrix2D)

      real, intent(in) :: matrix2D(:, :)
      integer :: i

      do i = 1, size(matrix2D, 1)
         print *, matrix2D(i, :)
      end do

   end subroutine print_matrix

   function sum_matrix(matrix2D) result(total)

      real, intent(in) :: matrix2D(:, :)
      real :: total

      total = sum(matrix2D)

   end function sum_matrix

end module calc
