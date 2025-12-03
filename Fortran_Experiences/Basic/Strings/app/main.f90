! app/main.f90
! References: https://fortran-lang.org/learn/quickstart/

program main

   implicit none

   integer :: size
   integer :: position
   integer :: number
   real    :: number_float
   logical :: test

   character(len=10) :: string_01
   character(10) :: string_02

   character(:), allocatable :: string_03
   character(:), allocatable :: string_04

   allocate (character(10) :: string_03)
   allocate (character(10) :: string_04)

   string_01 = '0123456789'
   string_02 = string_01(1:5)

   string_03 = string_01(5:) ! Characters after the index 5, including the 5th.
   string_03(:2) = '**' ! 456789 -> **6789
   string_03(:2) = '*'  ! **6789 -> * 6789

   size = len(string_01) ! 10
   print '(A, 1X, I2, A)', 'String 1: '//string_01//' (size =', size, ')'

   size = len(string_02) ! 10
   print '(A, 1X, I2, A)', 'String 2: '//string_02//' (size =', size, ')'

   size = len(string_03) ! 6
   print '(A, 1X, I2, A)', 'String 3: '//string_03//' (size =', size, ')'

   string_03 = string_01//','//string_01
   size = len(string_03) ! 21
   print '(A, 1X, I2, A)', 'String 3: '//string_03//' (size =', size, ')'

   string_03 = 'Fortran'
   string_04 = 'FORTRAN'

   test = string_03 == string_04  ! False
   print '(A, 1x, L)', string_03//' = '//string_04//':', test

   test = string_03 > string_04   ! True
   print '(A, 1x, L)', string_03//' > '//string_04//':', test

   print '(A, 1x, A)', 'String 3:', string_03

   ! INDEX function: Searches for a substring. Returns the starting position.
   position = index(string_03, 'tra') ! 4
   print '(A, 1x, I2)', "The substring 'tra' is located at position:", position
   position = index(string_03, 'TRA') ! 0, not found
   print '(A, 1x, I2)', "The substring 'TRA' is located at position:", position

   ! SCAN function: Checks if any character from a set exists in the string.
   position = scan(string_03, 'trn', BACK=.true.) ! 7
   print '(A, 1x, I2)', "The last character of 't r n' is in position:", position

   ! Converts a number to a string.
   number = 12345
   write (string_04, '(I5)') number
   string_04 = trim(string_04) ! "12345"

   print '(A, 1x, A)', 'String 4:', '"'//string_04//'"'

   ! Converts a number to a string.
   read (string_04, *) number_float ! 12345

   print '(A, 1x, F8.2)', 'number:', number_float ! 12345.00

   deallocate (string_03)
   deallocate (string_04)

end program main
