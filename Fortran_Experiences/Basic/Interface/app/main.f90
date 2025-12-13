! app/main.f90
! Test

program main

   use Climate_Monitoring
   implicit none

   ! Temperature in Celsius (in)
   real :: temp_real_C = 25.5
   integer :: temp_int_C = 18

   ! Temperature in Fahrenheit (out)
   real :: temp_real_F

   ! Temperature records (inout)
   real :: temp_average = 0.0
   integer :: reading_count = 0

   ! Reading 1
   call Convert_Temp(temp_real_C, temp_real_F)
   call Register_Reading(temp_real_F, temp_average, reading_count)

   print '("Real Temperature: ", F5.2, " C -> ", F5.2, " F")', temp_real_C, temp_real_F
   print '("Reading ", I2, " ( ", F5.2, " C ): Average = ", F5.2)', reading_count, temp_real_F, temp_average

   ! Reading 2
   call Convert_Temp(temp_int_C, temp_real_F)
   call Register_Reading(temp_real_F, temp_average, reading_count)

   print '("Integer Temperature: ", I2, " C -> ", F5.2, " F")', temp_int_C, temp_real_F
   print '("Reading ", I2, " ( ", F5.2, " C ): Average = ", F5.2)', reading_count, temp_real_F, temp_average

end program main
