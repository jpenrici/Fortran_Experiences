! app/main.f90
! Training...

program tractor_main

   use physics_telemetry
   use stats_analyzer
   implicit none

   character(len=30) :: csv_name = "tractor_data.csv"

   print *, "Step 1: Generating physics-based data..."
   call generate_tractor_csv(csv_name, 500)

   print *, "Step 2: Consuming and analyzing data..."
   call analyze_fuel_consumption(csv_name)

   print *, "Process complete."

end program tractor_main
