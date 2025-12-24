! ==============================================================================
! File: main.f90
! Description: Reads pixel data from CSV and computes intensity distribution.
! ==============================================================================

program data_analyzer

   implicit none

   character(len=255) :: input_path, output_path, header
   integer, dimension(0:255) :: histogram
   integer :: r, g, b, i, io_status, unit_in, unit_out, avg_intensity
   real(8) :: mean, variance, std_dev
   integer(8) :: total_pixels, sum_intensity, sum_sq_intensity
   logical :: file_exists

   ! Initialize histogram with zeros
   histogram = 0
   total_pixels = 0
   sum_intensity = 0
   sum_sq_intensity = 0

   ! 1. Argument Handling
   if (command_argument_count() < 2) then
      print *, "Usage: data_analyzer <input.csv> <output.dat>"
      stop
   end if

   call get_command_argument(1, input_path)
   call get_command_argument(2, output_path)

   inquire (file=trim(input_path), exist=file_exists)

   if (.not. file_exists) then
      print *, "File not found! Nothing to calculate."
   else
      ! 2. Open Input File (CSV)
      open (newunit=unit_in, file=trim(input_path), status='old', action='read')

      ! Read and skip the header (R,G,B)
      read (unit_in, *) header

      print '(A)', ">>> Analyzing pixel intensities (Fortran)..."

      ! 3. Process Data
      do
         ! Read R, G, B values separated by commas
         read (unit_in, *, iostat=io_status) r, g, b

         if (io_status /= 0) exit ! End of file

         ! Calculate simple average intensity
         avg_intensity = (r + g + b)/3

         ! Stats accumulators
         total_pixels = total_pixels + 1
         sum_intensity = sum_intensity + avg_intensity
         sum_sq_intensity = sum_sq_intensity + (avg_intensity**2)

         ! Increment the corresponding bin in the histogram
         if (avg_intensity >= 0 .and. avg_intensity <= 255) then
            histogram(avg_intensity) = histogram(avg_intensity) + 1
         end if
      end do

      close (unit_in)

      ! 4. Calculate Final Statistics
      if (total_pixels > 0) then
         mean = real(sum_intensity, 8)/total_pixels
         variance = (real(sum_sq_intensity, 8)/total_pixels) - (mean**2)
         std_dev = sqrt(max(0.0_8, variance))

         print '(A, F6.2)', " >>> Mean Intensity:     ", mean
         print '(A, F6.2)', " >>> Standard Deviation: ", std_dev
         print '(A, I12)', " >>> Total Pixels:       ", total_pixels
      end if

      ! 5. Save Results for Gnuplot
      open (newunit=unit_out, file=trim(output_path), status='replace', action='write')

      do i = 0, 255
         ! Output format: "Intensity_Value Frequency"
         write (unit_out, '(I3, 1X, I10)') i, histogram(i)
      end do

      close (unit_out)

      print '(A, A)', ">>> Statistics saved to: ", trim(output_path)

   end if

end program data_analyzer
