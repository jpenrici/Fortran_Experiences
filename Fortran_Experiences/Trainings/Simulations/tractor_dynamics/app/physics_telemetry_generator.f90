! app/physics_telemetry_generator.f90

module physics_telemetry

   use iso_fortran_env
   implicit none

   ! Structure to hold tractor sensor data
   type :: TractorData
      real(real64) :: velocity      ! km/h
      real(real64) :: draft_force   ! kN (KiloNewtons)
      real(real64) :: fuel_rate     ! L/h
      integer      :: soil_type     ! 1: Sandy, 2: Loam, 3: Clay
   end type TractorData

contains

   subroutine generate_tractor_csv(filename, n_records)

      character(len=*), intent(in) :: filename
      integer, intent(in) :: n_records
      type(TractorData) :: record
      integer :: i, u
      real(real64) :: rv

      open (newunit=u, file=filename, status='replace')
      write (u, '(A)') "velocity,draft,fuel,soil"

      do i = 1, n_records
         call random_number(rv)
         record%velocity = 5.0_real64 + (rv*3.0_real64)
         call random_number(rv)
         record%draft_force = 15.0_real64 + (rv*10.0_real64)
         record%soil_type = mod(i, 3) + 1

         ! Physics-based fuel calculation
         record%fuel_rate = 2.0_real64 + (0.45_real64*(record%draft_force*record%velocity/3.6_real64))

         write (u, '(F8.2, ",", F8.2, ",", F8.2, ",", I1)') &
            record%velocity, record%draft_force, record%fuel_rate, record%soil_type
      end do

      close (u)

   end subroutine generate_tractor_csv

end module physics_telemetry
