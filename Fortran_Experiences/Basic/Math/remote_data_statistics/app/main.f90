! app/main.f90
! Training in statistics using remote data.

module data_processor

   implicit none

   private
   public :: calculate_stats

contains

   subroutine calculate_stats(values, mean, std_dev)
      ! Receives an array of reals and returns mean and standard deviation
      real, intent(in) :: values(:)
      real, intent(out) :: mean, std_dev
      integer :: n

      n = size(values)
      if (n == 0) return

      mean = sum(values)/n
      std_dev = sqrt(sum((values - mean)**2)/(n - 1))

   end subroutine calculate_stats

end module data_processor

program remote_analyzer

   use data_processor

   implicit none

   character(len=255) :: url, filename, command
   integer :: file_unit, i, ios, rows

   real, allocatable :: data_points(:)
   real :: avg, sdev
   integer :: stat
   logical :: file_exists

   ! 1. Configuration
   ! For example, using the DataProfessor repository belongs to Prof. Chanin Nantasenamat.
   url = "https://raw.githubusercontent.com/dataprofessor/data/master/iris.csv"
   filename = "data_input.csv"

   ! 2. Check if the data file already exists
   inquire (file=trim(filename), exist=file_exists)

   if (.not. file_exists) then
      ! Fetching remote data using System Call (curl)
      ! Shell command: curl -s <url> -o <filename>
      command = "curl -s "//trim(url)//" -o "//trim(filename)

      print *, "Fetching data from remote source..."
      call execute_command_line(command, wait=.true., exitstat=stat)

      if (stat /= 0) then
         print *, "Error: Could not download data."
         stop
      end if
   else
      print *, "File '"//trim(filename)//"' already exists. Skipping download."
   end if

   ! 3. Simple CSV Parsing (Skipping headers and reading a specific column)
   ! +--------------+-------------+--------------+-------------+---------+
   ! | Sepal.Length | Sepal.Width | Petal.Length | Petal.Width | Species |
   ! +--------------+-------------+--------------+-------------+---------+
   ! | 5.1          | 3.5         | 1.4          | 0.2         | setosa  |
   ! +--------------+-------------+--------------+-------------+---------+
   ! | ...          | ...         | ...          | ...         | ...     |
   ! +--------------+-------------+--------------+-------------+---------+
   rows = 150
   allocate (data_points(rows)) ! 150 flowers (rows), as described in the Dataset.

   ! Open Data File
   open (newunit=file_unit, file=trim(filename), status='old', action='read')

   ! Skip header line
   read (file_unit, *)

   do i = 1, rows
      ! Reading the first column (Sepal.Length)
      read (file_unit, *, iostat=ios) data_points(i)
      if (ios /= 0) exit
   end do

   ! Close Data File
   close (file_unit)

   ! 4. Analysis
   call calculate_stats(data_points, avg, sdev)

   ! 5. Output results
   print "(A, F8.3)", " Mean of Sepal Length: ", avg
   print "(A, F8.3)", " Std Deviation:        ", sdev

   deallocate (data_points)

end program remote_analyzer
