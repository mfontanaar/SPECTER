!=================================================================
! MODULES to normalize fields in DNS
!
! 2007 Jonathan Pietarila Graham and Pablo D. Mininni
!      National Center for Atmospheric Research.
!=================================================================

!=================================================================

MODULE dns

CONTAINS
  SUBROUTINE normalize(fx,fy,fz,f0,kin,comm)
    USE fprecision
    USE commtypes
    USE grid
    USE mpivars
    USE mpivars
!$  USE threads
    IMPLICIT NONE

    DOUBLE PRECISION    :: tmp
    COMPLEX(KIND=GP), INTENT(INOUT), DIMENSION(nz,ny,ista:iend) :: fx,fy,fz
    REAL(KIND=GP), INTENT(IN) :: f0
    INTEGER, INTENT(IN) :: kin
    INTEGER, INTENT(IN) :: comm
    INTEGER :: i,j,k

    CALL energy(fx,fy,fz,tmp,kin)
    CALL MPI_BCAST(tmp,1,MPI_DOUBLE_PRECISION,0,MPI_COMM_WORLD,ierr)
!$omp parallel do if (iend-ista.ge.nth) private (j,k)
    DO i = ista,iend
!$omp parallel do if (iend-ista.lt.nth) private (k)
       DO j = 1,ny
          DO k = 1,nz
             fx(k,j,i) = fx(k,j,i)*f0/sqrt(tmp)
             fy(k,j,i) = fy(k,j,i)*f0/sqrt(tmp)
             fz(k,j,i) = fz(k,j,i)*f0/sqrt(tmp)
          END DO
       END DO
    END DO
  END SUBROUTINE normalize

END MODULE dns
!=================================================================
