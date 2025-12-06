! app/main.f90
! References: https://fortran-lang.org/learn/quickstart/

program main

  use calc
  implicit none

  real, dimension(2,3) :: mat
  real :: total

  mat(1,:) = (/ 1.0, 2.0, 3.0 /)
  mat(2,:) = (/ 4.0, 5.0, 6.0 /)

  total = sum_matrix(mat)

  call print_matrix(mat)
  print '("Total:", F6.2)', total

end program main
