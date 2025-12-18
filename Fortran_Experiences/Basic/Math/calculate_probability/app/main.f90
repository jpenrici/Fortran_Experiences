! app/main.f90
! Basic template

program main

   use dice_simulation
   implicit none

   ! plays
   call launch(10)
   !call launch(100)
   !call launch(1000)
   !call launch(10000)
   call launch(100000)

end program main
