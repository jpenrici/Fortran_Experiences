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
   print *

   ! Cylinder
   radius = 5.0
   height = 10.0

   area = pi*radius**2
   volume = area*height

   print *, 'Cylinder:'
   print *, 'radius = ', radius
   print *, 'height = ', height
   print *, 'area   = ', area
   print *, 'volume = ', volume
   print *

   ! Local scope
   block
      ! Floating-point precision
      use, intrinsic :: iso_fortran_env, only: sp => real32, dp => real64

      real :: number
      real(sp) :: float32 ! 32-bit
      real(dp) :: float64 ! 64-bit

      number = 1.0
      float32 = 1.0_sp ! explicit suffix for literal constants
      float64 = 1.0_dp

      print *, "Floating-point precision"
      print *, "number   = ", number
      print *, "float 32 = ", float32
      print *, "float 64 = ", float64

   end block

end program main
