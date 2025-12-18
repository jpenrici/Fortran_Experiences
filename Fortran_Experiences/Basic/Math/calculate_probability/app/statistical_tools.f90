module dice_simulation

   implicit none

contains

   subroutine launch(n)

      implicit none

      integer, intent(in) :: n ! number of trials

      integer, dimension(6) :: freq = 0
      integer :: i, roll
      real :: prob ! probability of one move at a time
      real :: mean, variance

      call random_seed() ! initialize random generator
      do i = 1, n
         call random_number(prob) ! generate random number in [0,1)
         roll = int(prob*6) + 1 ! map to [1,6]
         freq(roll) = freq(roll) + 1 ! accumulate frequency
      end do

      mean = 0.0
      do i = 1, 6
         mean = mean + real(i)*freq(i)/real(n)
      end do

      variance = 0.0
      do i = 1, 6
         variance = variance + (real(i) - mean)**2*freq(i)/real(n)
      end do

      ! Print results
      print '("Dice simulation:", I6, " trials")', n
      print '("Frequencies:")'
      do i = 1, 6
         print '("Face ", I2, ": ", I6)', i, freq(i)
      end do
      print '("Mean    : ", F5.2)', mean
      print '("Variance: ", F5.2)', variance
      print '(/)'

   end subroutine launch

end module dice_simulation
