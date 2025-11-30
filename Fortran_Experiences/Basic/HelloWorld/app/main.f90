! app/main.f90
! Basic Example

program main

  implicit none

  character(len=25) :: greeting_message
  greeting_message = "Hello World!"

  print *, "Fortran by CMake!"

  write(*,*) trim(greeting_message)

end program main
