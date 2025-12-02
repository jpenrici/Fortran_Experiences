! app/main.f90
! Reference: https://fortran-lang.org/learn/

program main

  implicit none

  integer :: i, j, k

  ! Arrays - Static Mode
  integer, dimension(10) :: array1D
  integer, dimension(2, 2) :: array2D
  integer, dimension(2, 2, 2) :: array3D

  real :: array_index(-2:2) ! Custom lower and upper index bounds

  integer, parameter :: nx=2, ny=2
  logical :: status(nx, ny)

  ! Arrays - Dynamic Mode
  real, allocatable :: matrix(:,:,:) ! 3D
  allocate(matrix(2, 2, 2))

  ! Initialization
  array1D = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  array2D = reshape([1, 2, 3, 4], shape(array2D))
  array3d = reshape([1, 2, 3, 4, 5, 6, 7, 8], shape(array3D))

  array_index = [ 1, 2, 3, 4, 5 ] ! Index = -2, -1, 0, 1, 2

  status = reshape([ .false., .true., .true., .false. ], shape(status))

  matrix = 0.5 ! 0.5 for all values ​​in the matrix.
  matrix(2, 2, 2) = 2.0
  matrix(1, :, 1) = 3.0

  ! View
  print *, "Fortran by CMake!"
  print *
  print *, array1D
  print *, array2D
  print *, array3D

  do i = 1, nx
    do j = 1, ny
      print *, "Status(", i, ",", j, ") = ", status(j,i)
    end do
  end do

  print '( / )'

  ! Matrix
  k = 1
  do while (k <= 2)
    print *, "-------------"
    i = 1
    do while (i <= 2)
      print '("|", 2(F5.1, " |"))', matrix(i, 1, k), matrix(i, 2, k)
      i = i + 1
    end do
    k = k + 1
  end do
  print *, "-------------"

  deallocate(matrix)

end program main
