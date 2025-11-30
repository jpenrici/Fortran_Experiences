! References: https://fortran-lang.org/learn/quickstart/

program main

  implicit none

  integer :: amount
  real :: pi, radius, height, area, volume
  complex :: frequency
  character :: initial
  logical :: isOkay

  amount = 10
  pi = 3.1415927
  frequency = (1.0, -0.5)
  initial = 'A'
  isOkay = .false.

  print *, 'Values:'
  print *, 'amount (integer)    : ', amount
  print *, 'pi (real)           : ', pi
  print *, 'frequency (complex) : ', frequency
  print *, 'initial (character) : ', initial
  print *, 'isOkay (logical)    : ', isOkay

  ! Cylinder
  radius = 5.0
  height = 10.0

  area = pi * radius ** 2
  volume = area * height

  print *, 'Cylinder:'
  print *, 'radius = ', radius
  print *, 'height = ', height
  print *, 'area   = ', area
  print *, 'volume = ', volume

end program main
