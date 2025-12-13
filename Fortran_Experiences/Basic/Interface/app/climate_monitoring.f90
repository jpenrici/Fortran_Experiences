! app/climate_monitoring.f90
! Temperature conversion (ºC -> ºF) and
! recording of the accumulated average temperature.

module Climate_Monitoring

   implicit none
   private

   ! Generic Interface
   interface Convert_Temp
      module procedure Convert_Temp_Real, Convert_Temp_Int
   end interface Convert_Temp

   public Convert_Temp, Register_Reading

contains

   subroutine Convert_Temp_Real(celsius, fahrenheit)

      real, intent(in) :: celsius
      real, intent(out) :: fahrenheit

      fahrenheit = celsius*9.0/5.0 + 32.0

   end subroutine Convert_Temp_Real

   subroutine Convert_Temp_Int(celsius, fahrenheit)

      integer, intent(in) :: celsius
      real, intent(out) :: fahrenheit

      fahrenheit = celsius*9.0/5.0 + 32.0

   end subroutine Convert_Temp_Int

   subroutine Register_Reading(new_reading, accumulated_avg, num_readings)

      real, intent(in) :: new_reading ! New temperature to be added
      real, intent(inout) :: accumulated_avg ! Average that will be updated
      integer, intent(inout) :: num_readings ! Counter that will be incremented

      accumulated_avg = (accumulated_avg*real(num_readings) + new_reading)/ &
                        (real(num_readings) + 1.0)
      num_readings = num_readings + 1

   end subroutine Register_Reading

end module Climate_Monitoring
