C File: test_module_12.f
C Purpose: This program shows how importing a module into a subprogram
C          (rather than the main program) limits visibility of the
C          imported variables to the subprogram and does not affect
C          variables in the main program. This program has the same
C          functionality as that of of test_module_10.f except that
C          it uses derived types
C
C Compile and run this program as follows:
C
C    gfortran -c test_module_12.f     # << this will create a file "mymod10.mod"
C    gfortran test_module_12.f        # << this will create a file "a.out"
C
C The output generated by this program is:
C
C  123   234   345  1110  1110  1110
C  987   876   765  1110  1110  1110

!-------------------------------------------------------------------------------
      module mymod10
      implicit none

      type mytype
      integer :: x
      integer :: y
      integer :: z
      end type mytype

      type (mytype) m;

      end module mymod10

!-------------------------------------------------------------------------------
      subroutine f(u, v, w, a, b, c)
      use mymod10      ! << importing into a subprogram
      implicit none
      integer u, v, w, a, b, c

      m%x = 123
      m%y = 234
      m%z = 345

      a = u+m%x
      b = v+m%y
      c = w+m%z

 10   format(6(I5,X))
      write (*,10) m%x,m%y,m%z,a,b,c
      end subroutine f

!-------------------------------------------------------------------------------
      program main
      implicit none

      type mytype
      integer :: x
      integer :: y
      integer :: z
      end type mytype

      type (mytype) m;

      integer :: p, q, r  ! << Note that the variables x, y, z
                !    are not affected by those in mymod10
      m%x = 987
      m%y = 876
      m%z = 765

      call f(m%x, m%y, m%z, p, q, r)

 10   format(6(I5,X))
      write (*,10) m%x,m%y,m%z,p,q,r

      stop
      end program main
!-------------------------------------------------------------------------------