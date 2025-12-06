module Point3D

   implicit none

   type :: t_point3D
      integer :: x, y, z
      character(len=5) :: label
   contains
      procedure, pass(this) :: distance => distance_impl
      procedure, pass(this) :: view => view_impl
   end type

contains

   function distance_impl(this, other) result(dist)

      use, intrinsic :: iso_fortran_env, only: real64
      implicit none

      real(real64) :: dist
      class(t_point3D), intent(in) :: this
      type(t_point3D), intent(in) :: other
      integer :: dx, dy, dz

      ! Calculate the distance between this point and other point
      dx = this%x - other%x
      dy = this%y - other%y
      dz = this%z - other%z

      dist = SQRT(real(dx)**2 + real(dy)**2 + real(dz)**2)

   end function distance_impl

   subroutine view_impl(this)

      implicit none

      class(t_point3D), intent(in) :: this

      print '(A5,"( ", I4, ", ", I4, ", ", I4, ")")', this%label, this%x, this%y, this%z

   end subroutine view_impl

end module Point3D
