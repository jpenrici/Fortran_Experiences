! app/analysis.f90
! Reads a file containing a set of numbers.
! Returns an analysis of the number of rows, skipped data, and the average.

program analysis

   implicit none

   integer, parameter :: dp = kind(1.0d0)
   real(dp), allocatable :: data_array(:)
   real(dp) :: mean, sum_val
   integer :: numbers, others, i, ios

   character(len=255) :: path_exe
   character(len=255) :: file_path
   integer :: length, status
   logical :: is_ok

   ! Check current directory
   !call get_command_argument(0, path_exe, length, status)
   !if (status == 0) then
   !   print *, "Current Directory:", trim(path_exe)
   !end if

   ! Check input arguments
   if (command_argument_count() >= 1) then
      call get_command_argument(1, file_path)
   else
      file_path = "../output/sample.csv"
   end if

   ! Check if file path exists
   inquire (file=trim(file_path), exist=is_ok)
   if (.not. is_ok) then
      print *, "Path:", trim(file_path), " [Not Found]"
   else
      ! Open the CSV file
      open (unit=10, file=trim(file_path), status='old', action='read')

      ! Count lines
      numbers = 0
      do
         read (10, *, iostat=ios)
         if (ios /= 0) exit
         numbers = numbers + 1
      end do

      print *, "Path: ", trim(file_path), numbers, "lines"

      allocate (data_array(numbers))
      rewind (10)

      sum_val = 0.0_dp
      others = 0 ! Counting ignored data
      do i = 1, numbers
         read (10, *, iostat=ios) data_array(i)
         if (ios /= 0) then
            others = others + 1
         else
            sum_val = sum_val + data_array(i)
         end if
      end do

      if (others > 0) then
         print *, "Values ​​ignored or incorrect:", others
         numbers = numbers - others
      end if

      ! Close the CSV file
      close (10)

      if (numbers > 0) then
         mean = sum_val/numbers
         print *, "Fortran Mean Analysis: ", mean
      else
         print *, "File with invalid quantities of numeric values!"
      end if

   end if

end program analysis
