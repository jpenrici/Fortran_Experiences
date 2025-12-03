! app/main.f90
! References: https://fortran-lang.org/learn/quickstart/

program main

   use Point3D ! import module
   implicit none

   type(t_point3D) :: p1, p2
   real :: dist

   p1 = t_point3D(x=0, y=0, z=0) ! origin
   p2 = t_point3D(x=10, y=0, z=0)
   dist = p1%distance(p2)

  call p1%view()
  call p2%view()

  print *, "Distance (p1 <---> p2):", dist

end program main
