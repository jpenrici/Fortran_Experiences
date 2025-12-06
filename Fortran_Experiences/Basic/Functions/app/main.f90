! app/main.f90
! References: https://fortran-lang.org/learn/quickstart/

program main

   use Point3D ! import module
   implicit none

   type(t_point3D) :: p1, p2
   real :: dist

   p1 = t_point3D(x=0, y=0, z=0, label='P1') ! origin
   p2 = t_point3D(x=10, y=0, z=0, label='P2')
   dist = p1%distance(p2)

   call p1%view()
   call p2%view()

   print '("Distance(", A, "<--->", A, "):", F6.2)' &
      , trim(p1%label), trim(p2%label), dist

end program main
