 MODULE LAPCK
 USE MPIINFO
 USE DECLARATION
 IMPLICIT NONE

  CONTAINS
 
  REAL FUNCTION LXNORM(XQR,PDIM)
  IMPLICIT NONE
   INTEGER, INTENT(IN) :: PDIM
   REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::XQR
   INTEGER I
 
    LXNORM = 0.0d0
    DO I=1,PDIM
     LXNORM = LXNORM + XQR(I)**2
    ENDDO
    LXNORM = SQRT(LXNORM)
  END FUNCTION
  
  
  ! CONSTRUCT A HOUSEHOLDER VECTOR V THAT 
  ! ANNIHILATES ALL BUT THE FIRST COMPONENT OF X
  SUBROUTINE HOUSE(XQR,VQR1,PDIM)
	IMPLICIT NONE
    INTEGER, INTENT(IN) :: PDIM
    REAL,ALLOCATABLE,DIMENSION(:),INTENT(INOUT)::XQR
    REAL,ALLOCATABLE,DIMENSION(:),INTENT(INOUT)::VQR1

    VQR1 = XQR
    VQR1(1) = XQR(1) + SIGN(1.0,XQR(1))*LXNORM(XQR,PDIM)
    
  END SUBROUTINE


  ! CONSTRUCT A HOUSEHOLDER REFLECTION MATRIX
  ! FROM A HOUSEHOLDER VECTOR V 
  SUBROUTINE COMPUTEHOUSEMATRIX(PQR,VQR,IDEG)
	IMPLICIT NONE
    INTEGER, INTENT(IN) :: IDEG
    REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT)::PQR
    REAL,ALLOCATABLE,DIMENSION(:),INTENT(INOUT)::VQR
    REAL ::VNORM
    INTEGER:: I,J

    PQR = 0.0d0
    DO I=1,IDEG
      PQR(I,I) = 1.0D0
    ENDDO
   
    VNORM = LXNORM(VQR,ideg)
    VQR = VQR/VNORM
    
    DO I=1,IDEG
    DO J=1,IDEG
      PQR(I,J) = PQR(I,J) - 2.0d0*VQR(I)*VQR(J)
    ENDDO
    ENDDO
    
  END SUBROUTINE

 !%%%%%%%%%%%%%%%%%%
  SUBROUTINE TRANSPOSEMATRIX(QFF,QTFF,IDEG)
	IMPLICIT NONE
    INTEGER, INTENT(IN) :: IDEG
    REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(IN) :: QFF
    REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT) :: QTFF
    INTEGER I,J
    DO I=1,IDEG
    DO J=1,IDEG
      QTFF (I,J) = QFF(J,I)
    ENDDO
    ENDDO
  END SUBROUTINE


  ! QR DECOMPOSITION
  SUBROUTINE  QRDECOMPOSITION(LSCQM,QFF,RFF,IDEG)
	IMPLICIT NONE
    INTEGER, INTENT(IN) :: IDEG
    REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(IN) :: LSCQM
    REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT) ::  QFF,RFF
    REAL::IDENTITY(IDEG,IDEG)
    REAL:: TEST(IDEG)
    INTEGER:: I,J,L
    REAL,ALLOCATABLE,DIMENSION(:)::XQR
    
    IDENTITY(1:IDEG,1:IDEG) = 0.0d0
    QFF(1:IDEG,1:IDEG)=0.0D0
    RFF(1:IDEG,1:IDEG)=0.0D0
    DO I=1,IDEG
      IDENTITY(I,I) = 1.0D0
    ENDDO

    
    QFF(1:IDEG,1:IDEG) = IDENTITY(1:IDEG,1:IDEG)
    RFF(1:IDEG,1:IDEG) = LSCQM(1:IDEG,1:IDEG)
    
    ALLOCATE(PQR(1:IDEG,1:IDEG),VQR(1:IDEG));PQR=0.0D0;VQR=0.0D0

    DO L=1,IDEG
     ! ALLOCATE VECTOR AND REFLECTION MATRIX
     PDIM = IDEG-L+1
     ALLOCATE(VQR1(1:PDIM),XQR(1:PDIM)) 
     XQR = RFF(L:IDEG,L)
     ! COMPUTE THE PARTIAL VECTOR    
     CALL HOUSE(XQR,VQR1,PDIM)
     VQR(1:IDEG) = 0.0d0
     VQR(L:IDEG) = VQR1
    
     
     
     ! COMPUTE THE REFLECTION MATRIX
     CALL COMPUTEHOUSEMATRIX(PQR,VQR,IDEG)
     ! CONSTRUCT THE Q(L) MATRIX
     
     RFF(1:IDEG,1:IDEG) = MATMUL(PQR(1:IDEG,1:IDEG),RFF(1:IDEG,1:IDEG))
     QFF(1:IDEG,1:IDEG) = MATMUL(QFF(1:IDEG,1:IDEG),PQR(1:IDEG,1:IDEG))
    
     DEALLOCATE(VQR1,XQR)
    ENDDO

    DEALLOCATE(PQR,VQR)



 
  END SUBROUTINE

 END MODULE
