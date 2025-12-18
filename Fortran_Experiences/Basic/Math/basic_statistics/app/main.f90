! app/main.f90

program main

   use statistical_tools
   implicit none

   integer, parameter :: SAMPLE_SIZE = 1000000
   real, allocatable :: observations(:)
   real :: avg, sd

   allocate (observations(SAMPLE_SIZE))

   ! Initialize the random seed and generate uniform distribution [0, 1)
   call random_seed()
   call random_number(observations)

   ! Compute statistics
   call calculate_stats(observations, avg, sd)

   print '("Sample Size: " , I7)', SAMPLE_SIZE
   print '("Calculated Mean: ", F5.2)', avg
   print '("Standard Deviation: ", F5.2)', sd

   deallocate (observations)

end program main
