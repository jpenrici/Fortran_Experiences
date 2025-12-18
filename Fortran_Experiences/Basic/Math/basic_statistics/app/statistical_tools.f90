module statistical_tools

   implicit none

contains

   ! Calculates the mean and standard deviation of a 1D array
   subroutine calculate_stats(data_array, mean, std_dev)

      real, intent(in) :: data_array(:)
      real, intent(out) :: mean, std_dev
      integer :: n

      n = size(data_array)
      mean = sum(data_array)/n
      std_dev = sqrt(sum((data_array - mean)**2) / n)

   end subroutine calculate_stats

end module statistical_tools
