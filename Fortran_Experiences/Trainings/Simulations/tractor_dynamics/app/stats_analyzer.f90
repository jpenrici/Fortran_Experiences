! app/stats_analyzer.f90

module stats_analyzer
   use iso_fortran_env
   implicit none

contains

   subroutine analyze_fuel_consumption(filename)

      character(len=*), intent(in) :: filename
      integer :: u, ios
      real(real64) :: vel, draft, fuel, total_fuel, avg_fuel
      integer :: soil, count
      character(len=100) :: header
      logical :: file_exists

      total_fuel = 0.0_real64
      count = 0

      inquire (file=trim(filename), exist=file_exists)

      if (.not. file_exists) then
         print *, "File not found! Nothing to calculate."
      else
         open (newunit=u, file=filename, status='old', action='read')
         read (u, *) header ! Skip CSV header

         do
            ! Reading CSV line by line
            read (u, *, iostat=ios) vel, draft, fuel, soil
            if (ios /= 0) exit ! End of file

            total_fuel = total_fuel + fuel
            count = count + 1
         end do

         if (count > 0) then
            avg_fuel = total_fuel/count
            print *, "--- Statistical Analysis ---"
            print *, "Total Records Processed:", count
            print *, "Average Fuel Consumption (L/h):", real(avg_fuel, 4)
         end if

         close (u)

      end if

   end subroutine analyze_fuel_consumption

end module stats_analyzer
