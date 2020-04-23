MODULE FLOW_OPERATIONS
USE DECLARATION
USE MPIINFO
USE TRANSFORM


IMPLICIT NONE


 CONTAINS
 
 
SUBROUTINE CONS2PRIM(N)
!> @brief
!> This subroutine transforms one vector of conservative variables to primitive variables
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,DIMENSION(5)::TEMPS
REAL::OODENSITY

OODENSITY=1.0D0/LEFTV(1)

TEMPS(1)=LEFTV(1)
TEMPS(2)=LEFTV(2)*OODENSITY
TEMPS(3)=LEFTV(3)*OODENSITY
TEMPS(4)=LEFTV(4)*OODENSITY
TEMPS(5)=((GAMMA-1.0D0))*((LEFTV(5))-OO2*LEFTV(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)+((TEMPS(4))**2)))

LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)




END SUBROUTINE CONS2PRIM


SUBROUTINE CONS2PRIM2(N)
!> @brief
!> This subroutine transforms two vector of conservative variables to primitive variables
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,DIMENSION(5)::TEMPS
REAL::OODENSITY

OODENSITY=1.0D0/LEFTV(1)

TEMPS(1)=LEFTV(1)
TEMPS(2)=LEFTV(2)*OODENSITY
TEMPS(3)=LEFTV(3)*OODENSITY
TEMPS(4)=LEFTV(4)*OODENSITY
TEMPS(5)=((GAMMA-1.0D0))*((LEFTV(5))-OO2*LEFTV(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)+((TEMPS(4))**2)))

LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)



OODENSITY=1.0D0/rightv(1)

TEMPS(1)=rightv(1)
TEMPS(2)=rightv(2)*OODENSITY
TEMPS(3)=rightv(3)*OODENSITY
TEMPS(4)=rightv(4)*OODENSITY
TEMPS(5)=((GAMMA-1.0D0))*((rightv(5))-OO2*rightv(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)+((TEMPS(4))**2)))

rightv(1:nof_Variables)=TEMPS(1:nof_Variables)



END SUBROUTINE CONS2PRIM2


SUBROUTINE LMACHT(N)
!> @brief
!> This subroutine applies the low-Mach number correction to two vectors of conserved variables
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL::Q2L,Q2R,UUL,UUR,VVL,VVR,WWR,WWL,RHOL,RHOR,ETAL,ETAR,DUU,DVV,DWW
REAL::MACH2,MACH,CMA,DUS,DVS,DWS,DIFF,C1o2,SSL,SSR,ppl,ppr,eel,eer,TOLE,MLM

TOLE=ZERO

 EEL=LEFTV(5)
 EER=RIGHTV(5)

 CALL CONS2PRIM2(N)


      C1o2=0.50D0
      RHOL=LEFTV(1)
      UUL=LEFTV(2)
      VVL=LEFTV(3)
      WWL=LEFTV(4)
       PPL=LEFTV(5)
     RHOR=RIGHTV(1)
      UUR=RIGHTV(2)
      VVR=RIGHTV(3)
      WWR=RIGHTV(4)
       PPR=RIGHTV(5)
		
      Q2L=(UUL*uul)+(vvl*vvl)+(wwl*wwl)
      Q2R=(uur*uur)+(vvr*vvr)+(wwr*wwr)

!	SSL=((GAMMA*PPL)/(RHOL)); SSR=((GAMMA*PPR)/(RHOR))
                                  
!	MLM=((ABS(PPR-PPL))/(0.5*RRES*((GAMMA*PRES/RRES))))
     
      SSL=((GAMMA*PPL)/(RHOL))
      SSR=((GAMMA*PPR)/(RHOR))
      

      CMA=1.0D0

      DUU=UUR-UUL
      DVV=VVR-VVL
      DWW=WWR-WWL

!       IF(LMACH.EQ.1) THEN !Standard proportional to du^2
         MACH2=MAX(Q2L/SSL,Q2R/SSR)
         MACH=sqrt(MACH2)
         MACH=MIN(CMA*MACH,1.0D0)
!       END IF

      DUS=UUR+UUL
      DVS=VVR+VVL
      DWS=WWR+WWL

      DUU=MACH*DUU
      DVV=MACH*DVV
      DWW=MACH*DWW


      DIFF=C1O2*DUU

      UUL=(DUS*C1O2-DIFF)
      UUR=(DUS*C1O2+DIFF)

      if (lmach_style.eq.1)then
       DIFF=C1O2*DVV

      VVL=(DVS*C1O2-DIFF)
      VVR=(DVS*C1O2+DIFF)

      DIFF=C1O2*DWW

      WWL=(DWS*C1O2-DIFF)
      WWR=(DWS*C1O2+DIFF)
      end if
	
    	
       LEFTV(1)=RHOL
       LEFTV(2)=UUL*RHOL
       LEFTV(3)=VVL*RHOL
       LEFTV(4)=WWL*RHOL
       LEFTV(5)=EEL
	
      RIGHTV(1)=RHOR 	
       RIGHTV(2)=UUR*RHOR
       RIGHTV(3)=VVR*RHOR
       RIGHTV(4)=WWR*RHOR
       RIGHTV(5)=EER




END SUBROUTINE LMACHT



SUBROUTINE LMACHT2D(N)
!> @brief
!> This subroutine applies the low-Mach number correction to two vectors of conserved variables 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL::Q2L,Q2R,UUL,UUR,VVL,VVR,WWR,WWL,RHOL,RHOR,ETAL,ETAR,DUU,DVV,DWW
REAL::MACH2,MACH,CMA,DUS,DVS,DWS,DIFF,C1o2,SSL,SSR,ppl,ppr,eel,eer,TOLE,MLM

TOLE=tolsmall



 EEL=LEFTV(4)
 EER=RIGHTV(4)


 
 CALL CONS2PRIM2d2(N)



      C1o2=0.5D0
      RHOL=LEFTV(1)
      UUL=LEFTV(2)
      VVL=LEFTV(3)
       PPL=LEFTV(4)
       
     RHOR=RIGHTV(1)
      UUR=RIGHTV(2)
      VVR=RIGHTV(3)
       PPR=RIGHTV(4)
		
       Q2L=(UUL*uul)+(vvl*vvl)
       Q2R=(uur*uur)+(vvr*vvr)
      
      
      


      SSL=((GAMMA*PPL)/(RHOL))
      SSR=((GAMMA*PPR)/(RHOR))
      

      CMA=1.0D0

      DUU=UUR-UUL
      DVV=VVR-VVL
      
      

!       IF(LMACH.EQ.1) THEN !Standard proportional to du^2
         MACH2=MAX(Q2L/SSL,Q2R/SSR)
         MACH=sqrt(MACH2)
         MACH=MIN(CMA*MACH,1.0D0)
!       END IF

      DUS=UUR+UUL
      DVS=VVR+VVL
     

       !UL+ZUL+UR-ZUR=(UL+UR)-Z(UR-UL))
      DUU=MACH*DUU
      DVV=MACH*DVV
      


      DIFF=C1O2*DUU
	!if (uul*uur.gt.tole)then
	
      UUL=(DUS*C1O2)-DIFF
      UUR=(DUS*C1O2)+DIFF
      
if (lmach_style.eq.1)then
      DIFF=C1O2*DVV
      VVL=(DVS*C1O2-DIFF)
      VVR=(DVS*C1O2+DIFF)
end if
	
       LEFTV(1)=RHOL
       LEFTV(2)=UUL*RHOL
       LEFTV(3)=VVL*RHOL
       LEFTV(4)=EEL
	
       RIGHTV(1)=RHOR 	
       RIGHTV(2)=UUR*RHOR
       RIGHTV(3)=VVR*RHOR
       RIGHTV(4)=EER




END SUBROUTINE LMACHT2D































SUBROUTINE PRIM2CONS(N)
!> @brief
! !> This subroutine transforms one vector of primitive variables to conservative variables
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,DIMENSION(5)::TEMPS
REAL::OODENSITY,skin1,ie1


skin1=(oo2)*((leftv(2)**2)+(leftv(3)**2)+(leftv(4)**2))
ie1=((leftv(5))/((GAMMA-1.0D0)*leftv(1)))

OODENSITY=1.0D0/LEFTV(1)

TEMPS(1)=LEFTV(1)
TEMPS(2)=LEFTV(2)*LEFTV(1)
TEMPS(3)=LEFTV(3)*LEFTV(1)
TEMPS(4)=LEFTV(4)*LEFTV(1)
TEMPS(5)=leftv(1)*(ie1+skin1)

LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)




END SUBROUTINE PRIM2CONS

SUBROUTINE PRIM2CONS2(N)
!> @brief
!> This subroutine transforms two vectors of primitive variables to conservative variables
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,DIMENSION(5)::TEMPS
REAL::OODENSITY,skin1,ie1


skin1=(oo2)*((leftv(2)**2)+(leftv(3)**2)+(leftv(4)**2))
ie1=((leftv(5))/((GAMMA-1.0D0)*leftv(1)))

OODENSITY=1.0D0/LEFTV(1)

TEMPS(1)=LEFTV(1)
TEMPS(2)=LEFTV(2)*LEFTV(1)
TEMPS(3)=LEFTV(3)*LEFTV(1)
TEMPS(4)=LEFTV(4)*LEFTV(1)
TEMPS(5)=leftv(1)*(ie1+skin1)

LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)


skin1=(oo2)*((rightv(2)**2)+(rightv(3)**2)+(rightv(4)**2))
ie1=((rightv(5))/((GAMMA-1.0D0)*rightv(1)))

OODENSITY=1.0D0/rightv(1)

TEMPS(1)=rightv(1)
TEMPS(2)=rightv(2)*rightv(1)
TEMPS(3)=rightv(3)*rightv(1)
TEMPS(4)=rightv(4)*rightv(1)
TEMPS(5)=rightv(1)*(ie1+skin1)

rightv(1:nof_Variables)=TEMPS(1:nof_Variables)


END SUBROUTINE PRIM2CONS2


SUBROUTINE CONS2PRIM2d2(N)
!> @brief
!> This subroutine transforms two vectors of conservative variables to primitive variables 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,DIMENSION(1:nof_Variables)::TEMPS
REAL::OODENSITY,MP_DENSITY

 IF (governingequations.EQ.-1) then
 
 MP_DENSITY=(LEFTV(5)+LEFTV(6)) !TOTAL DENSITY OF MIXTURE
 MP_AR(1)=LEFTV(7)/(GAMMA_IN(1)-1.0D0)  
 MP_AR(2)=(1.0D0-LEFTV(7))/(GAMMA_IN(2)-1.0D0)
 GAMMAL=(1.0D0/(MP_AR(1)+MP_AR(2)))+1.0D0    !MIXTURE GAMMA ISOBARIC ASSUMPTIO
 OODENSITY=1.0D0/MP_DENSITY
 
 
 TEMPS(1)=MP_DENSITY
TEMPS(2)=LEFTV(2)*OODENSITY
TEMPS(3)=LEFTV(3)*OODENSITY
TEMPS(4)=((GAMMAL-1.0D0))*((LEFTV(4))-OO2*TEMPS(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)))
TEMPS(5)=LEFTV(5)
TEMPS(6)=LEFTV(6)
TEMPS(7)=LEFTV(7)
 
 LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)
 
 
 
 MP_DENSITY=(RIGHTV(5)+RIGHTV(6)) !TOTAL DENSITY OF MIXTURE
 MP_AR(1)=RIGHTV(7)/(GAMMA_IN(1)-1.0D0)  
 MP_AR(2)=(1.0D0-RIGHTV(7))/(GAMMA_IN(2)-1.0D0)
 GAMMAR=(1.0D0/(MP_AR(1)+MP_AR(2)))+1.0D0    !MIXTURE GAMMA ISOBARIC ASSUMPTIO
 OODENSITY=1.0D0/MP_DENSITY
 
 
 TEMPS(1)=MP_DENSITY
TEMPS(2)=RIGHTV(2)*OODENSITY
TEMPS(3)=RIGHTV(3)*OODENSITY
TEMPS(4)=((GAMMAR-1.0D0))*((RIGHTV(4))-OO2*TEMPS(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)))
TEMPS(5)=RIGHTV(5)
TEMPS(6)=RIGHTV(6)
TEMPS(7)=RIGHTV(7)
 
 
 RIGHTV(1:nof_Variables)=TEMPS(1:nof_Variables)
 
else



OODENSITY=1.0D0/LEFTV(1)

TEMPS(1)=LEFTV(1)
TEMPS(2)=LEFTV(2)*OODENSITY
TEMPS(3)=LEFTV(3)*OODENSITY
TEMPS(4)=((GAMMA-1.0D0))*((LEFTV(4))-OO2*LEFTV(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)))

LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)


OODENSITY=1.0D0/rightv(1)

TEMPS(1)=rightv(1)
TEMPS(2)=rightv(2)*OODENSITY
TEMPS(3)=rightv(3)*OODENSITY
TEMPS(4)=((GAMMA-1.0D0))*((rightv(4))-OO2*rightv(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)))

rightv(1:nof_Variables)=TEMPS(1:nof_Variables)
end if

END SUBROUTINE CONS2PRIM2d2

SUBROUTINE CONS2PRIM2d(N)
!> @brief
!> This subroutine transforms one vectors of conservative variables to primitive variables 
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,DIMENSION(1:nof_Variables)::TEMPS
REAL::OODENSITY,MP_DENSITY

IF (governingequations.EQ.-1) then
 
 MP_DENSITY=(LEFTV(5)+LEFTV(6)) !TOTAL DENSITY OF MIXTURE
 MP_AR(1)=LEFTV(7)/(GAMMA_IN(1)-1.0D0)  
 MP_AR(2)=(1.0D0-LEFTV(7))/(GAMMA_IN(2)-1.0D0)
 GAMMAL=(1.0D0/(MP_AR(1)+MP_AR(2)))+1.0D0    !MIXTURE GAMMA ISOBARIC ASSUMPTIO
 OODENSITY=1.0D0/MP_DENSITY
 
 
 TEMPS(1)=MP_DENSITY
TEMPS(2)=LEFTV(2)*OODENSITY
TEMPS(3)=LEFTV(3)*OODENSITY
TEMPS(4)=((GAMMAL-1.0D0))*((LEFTV(4))-OO2*TEMPS(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)))
TEMPS(5)=LEFTV(5)
TEMPS(6)=LEFTV(6)
TEMPS(7)=LEFTV(7)
 
 LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)
 
ELSE

OODENSITY=1.0D0/LEFTV(1)

TEMPS(1)=LEFTV(1)
TEMPS(2)=LEFTV(2)*OODENSITY
TEMPS(3)=LEFTV(3)*OODENSITY
TEMPS(4)=((GAMMA-1.0D0))*((LEFTV(4))-OO2*LEFTV(1)*(((TEMPS(2))**2)+((TEMPS(3))**2)))

LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)

END IF
END SUBROUTINE CONS2PRIM2d


SUBROUTINE PRIM2CONS2d(N)
!> @brief
!> This subroutine transforms one vector of primitive variables to  conservative variables 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,DIMENSION(1:nof_Variables)::TEMPS
REAL::OODENSITY,skin1,ie1,MP_DENSITY

IF (governingequations.EQ.-1) then

 
 MP_DENSITY=(LEFTV(5)+LEFTV(6)) !TOTAL DENSITY OF MIXTURE
 MP_AR(1)=LEFTV(7)/(GAMMA_IN(1)-1.0D0)  
 MP_AR(2)=(1.0D0-LEFTV(7))/(GAMMA_IN(2)-1.0D0)
 GAMMAL=(1.0D0/(MP_AR(1)+MP_AR(2)))+1.0D0    !MIXTURE GAMMA ISOBARIC ASSUMPTIO
 
TEMPS(1)=MP_DENSITY
TEMPS(2)=LEFTV(2)*TEMPS(1)
TEMPS(3)=LEFTV(3)*TEMPS(1)
skin1=(oo2)*((leftv(2)**2)+(leftv(3)**2))
ie1=((leftv(4))/((GAMMAL-1.0D0)*TEMPS(1)))
TEMPS(4)=TEMPS(1)*(ie1+skin1)
TEMPS(5:7)=LEFTV(5:7)
 LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)
 
 else



skin1=(oo2)*((leftv(2)**2)+(leftv(3)**2))
ie1=((leftv(4))/((GAMMA-1.0D0)*leftv(1)))

OODENSITY=1.0D0/LEFTV(1)

TEMPS(1)=LEFTV(1)
TEMPS(2)=LEFTV(2)*LEFTV(1)
TEMPS(3)=LEFTV(3)*LEFTV(1)
TEMPS(4)=leftv(1)*(ie1+skin1)

LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)

end if

END SUBROUTINE PRIM2CONS2d

SUBROUTINE PRIM2CONS2d2(N)
!> @brief
!> This subroutine transforms one vector of primitive variables to  conservative variables 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,DIMENSION(1:nof_Variables)::TEMPS
REAL::OODENSITY,skin1,ie1,MP_DENSITY

IF (governingequations.EQ.-1) then

 
 MP_DENSITY=(LEFTV(5)+LEFTV(6)) !TOTAL DENSITY OF MIXTURE
 MP_AR(1)=LEFTV(7)/(GAMMA_IN(1)-1.0D0)  
 MP_AR(2)=(1.0D0-LEFTV(7))/(GAMMA_IN(2)-1.0D0)
 GAMMAL=(1.0D0/(MP_AR(1)+MP_AR(2)))+1.0D0    !MIXTURE GAMMA ISOBARIC ASSUMPTIO
 
TEMPS(1)=MP_DENSITY
TEMPS(2)=LEFTV(2)*TEMPS(1)
TEMPS(3)=LEFTV(3)*TEMPS(1)
skin1=(oo2)*((leftv(4)**2)+(leftv(5)**2))
ie1=((leftv(4))/((GAMMAL-1.0D0)*TEMPS(1)))
TEMPS(4)=TEMPS(1)*(ie1+skin1)
TEMPS(5:7)=LEFTV(5:7)
 LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)
 
 
 
 MP_DENSITY=(RIGHTV(5)+RIGHTV(6)) !TOTAL DENSITY OF MIXTURE
 MP_AR(1)=RIGHTV(7)/(GAMMA_IN(1)-1.0D0)  
 MP_AR(2)=(1.0D0-RIGHTV(7))/(GAMMA_IN(2)-1.0D0)
 GAMMAR=(1.0D0/(MP_AR(1)+MP_AR(2)))+1.0D0    !MIXTURE GAMMA ISOBARIC ASSUMPTIO
 
TEMPS(1)=MP_DENSITY
TEMPS(2)=RIGHTV(2)*TEMPS(1)
TEMPS(3)=RIGHTV(3)*TEMPS(1)
skin1=(oo2)*((RIGHTv(2)**2)+(RIGHTv(3)**2))
ie1=((RIGHTv(4))/((GAMMAR-1.0D0)*TEMPS(1)))
TEMPS(4)=TEMPS(1)*(ie1+skin1)
TEMPS(5:7)=RIGHTV(5:7)
 RIGHTV(1:nof_Variables)=TEMPS(1:nof_Variables)
 
 
 
 
 else


skin1=(oo2)*((leftv(2)**2)+(leftv(3)**2))
ie1=((leftv(4))/((GAMMA-1.0D0)*leftv(1)))

OODENSITY=1.0D0/LEFTV(1)

TEMPS(1)=LEFTV(1)
TEMPS(2)=LEFTV(2)*LEFTV(1)
TEMPS(3)=LEFTV(3)*LEFTV(1)
TEMPS(4)=leftv(1)*(ie1+skin1)

LEFTV(1:nof_Variables)=TEMPS(1:nof_Variables)

skin1=(oo2)*((rightv(2)**2)+(rightv(3)**2))
ie1=((rightv(4))/((GAMMA-1.0D0)*rightv(1)))

OODENSITY=1.0D0/rightv(1)

TEMPS(1)=rightv(1)
TEMPS(2)=rightv(2)*rightv(1)
TEMPS(3)=rightv(3)*rightv(1)
TEMPS(4)=rightv(1)*(ie1+skin1)

rightv(1:nof_Variables)=TEMPS(1:nof_Variables)

end if
END SUBROUTINE PRIM2CONS2d2



FUNCTION INFLOW(INITCOND,POX,POY,POZ)
!> @brief
!> This function applies a prescribed boundary condition to  the inflow in 3D
IMPLICIT NONE
REAL,DIMENSION(5)::INFLOW
INTEGER,INTENT(IN)::INITCOND
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::POX,POY,POZ
REAL::P,U,V,W,E,R,S,GM,SKIN,IEN,PI
REAL::XF,YF,ZF
REAL:: Theta_0,vtang, vradial


R=RRES
GM=GAMMA
P=PRES
U=uvel
V=vvel
W=wvel

!KINETIC ENERGY FIRST!
SKIN=(OO2)*((U**2)+(V**2)+(W**2))
!INTERNAL ENERGY 
IEN=((P)/((GM-1.0D0)*R))
!TOTAL ENERGY
E=R*(SKIN+IEN)
!VECTOR OF CONSERVED VARIABLES NOW
INFLOW(1)=R
INFLOW(2)=R*U
INFLOW(3)=R*V
INFLOW(4)=R*W
INFLOW(5)=E


IF (SWIRL.EQ.1)THEN

IF (POX(1).LT.-0.03)THEN
XF=POX(1)
YF=POY(1)
ZF=POZ(1)
Theta_0=atan2(ZF,YF)
Vtang=18.0375D0
Vradial=-12.63D0
U=0.0D0

V=-Vtang*sin(Theta_0)+Vradial*cos(Theta_0)
W=Vtang*cos(Theta_0)+Vradial*sin(Theta_0)



ELSE

 U=70.06D0
  V=0.0D0
  W=0.0D0


END IF

R=RRES
GM=GAMMA
P=PRES
S=SQRT((GM*P)/(R))
  
  
!KINETIC ENERGY FIRST!
SKIN=(OO2)*((U**2)+(V**2)+(W**2))
!INTERNAL ENERGY 
IEN=((P)/((GM-1.0D0)*R))
!TOTAL ENERGY
E=R*(SKIN+IEN)
!VECTOR OF CONSERVED VARIABLES NOW
INFLOW(1)=R
INFLOW(2)=R*U
INFLOW(3)=R*V
INFLOW(4)=R*W
INFLOW(5)=E  
  
  
END IF

END FUNCTION INFLOW













FUNCTION INFLOW2d(INITCOND,POX,POY)
!> @brief
!> This function applies a prescribed boundary condition to  the inflow in 2D
IMPLICIT NONE
REAL,DIMENSION(1:nof_Variables)::INFLOW2d
INTEGER,INTENT(IN)::INITCOND
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::POX,POY
REAL::P,U,V,W,E,R,S,GM,SKIN,IEN,PI
REAL::XF,YF,ZF
REAL:: Theta_0,vtang, vradial
REAL::MP_DENSITY


IF (governingequations.EQ.-1) then



P=PRES
U=uvel
V=vvel
MP_AR(1)=MP_A_IN(1)/(GAMMA_IN(1)-1.0D0)  
MP_AR(2)=MP_A_IN(2)/(GAMMA_IN(2)-1.0D0)
GAMMAR=(1.0D0/(MP_AR(1)+MP_AR(2)))+1.0D0    !MIXTURE GAMMA ISOBARIC ASSUMPTION

GM=GAMMAR

R=(MP_R_IN(1)*MP_A_IN(1))+(MP_R_IN(2)*MP_A_IN(2))
MP_IE(1)=((P)/((GAMMA_IN(1)-1.0D0)*MP_R_IN(1)))
MP_IE(2)=((P)/((GAMMA_IN(2)-1.0D0)*MP_R_IN(2)))
IEn=(MP_IE(1)*MP_A_IN(1))+(MP_IE(2)*MP_A_IN(2))
! !KINETIC ENERGY FIRST!
SKIN=(OO2)*((U**2)+(V**2))
! !TOTAL ENERGY
E=R*(SKIN+IEN)

!VECTOR OF CONSERVED VARIABLES NOW
INFLOW2d(1)=R
INFLOW2d(2)=R*U
INFLOW2d(3)=R*V
INFLOW2d(4)=E
INFLOW2d(5)=MP_R_IN(1)*MP_A_IN(1)
INFLOW2d(6)=MP_R_IN(2)*MP_A_IN(2)
INFLOW2d(7)=MP_A_IN(1)



ELSE


R=RRES
GM=GAMMA
P=PRES
U=uvel
V=vvel


!KINETIC ENERGY FIRST!
SKIN=(OO2)*((U**2)+(V**2))
!INTERNAL ENERGY 
IEN=((P)/((GM-1.0D0)*R))
!TOTAL ENERGY
E=R*(SKIN+IEN)
!VECTOR OF CONSERVED VARIABLES NOW
INFLOW2d(1)=R
INFLOW2d(2)=R*U
INFLOW2d(3)=R*V
INFLOW2d(4)=E


ENDIF

END FUNCTION INFLOW2d


FUNCTION OUTFLOW2d(INITCOND,POX,POY)
!> @brief
!> This function applies a prescribed boundary condition to  the outflow in 2D
IMPLICIT NONE
REAL,DIMENSION(1:nof_Variables)::OUTFLOW2d
INTEGER,INTENT(IN)::INITCOND
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::POX,POY
REAL::P,U,V,W,E,R,S,GM,SKIN,IEN,PI
REAL::XF,YF,ZF


IF (governingequations.EQ.-1) then



P=PRES
U=uvel
V=vvel
MP_AR(1)=MP_A_IN(1)/(GAMMA_IN(1)-1.0D0)  
MP_AR(2)=MP_A_IN(2)/(GAMMA_IN(2)-1.0D0)
GAMMAR=(1.0D0/(MP_AR(1)+MP_AR(2)))+1.0D0    !MIXTURE GAMMA ISOBARIC ASSUMPTION

GM=GAMMAR

R=(MP_R_IN(1)*MP_A_IN(1))+(MP_R_IN(2)*MP_A_IN(2))
MP_IE(1)=((P)/((GAMMA_IN(1)-1.0D0)*MP_R_IN(1)))
MP_IE(2)=((P)/((GAMMA_IN(2)-1.0D0)*MP_R_IN(2)))
IEn=(MP_IE(1)*MP_A_IN(1))+(MP_IE(2)*MP_A_IN(2))
! !KINETIC ENERGY FIRST!
SKIN=(OO2)*((U**2)+(V**2))
! !TOTAL ENERGY
E=R*(SKIN+IEn)

!VECTOR OF CONSERVED VARIABLES NOW
OUTFLOW2d(1)=R
OUTFLOW2d(2)=R*U
OUTFLOW2d(3)=R*V
OUTFLOW2d(4)=E
OUTFLOW2d(5)=MP_R_IN(1)*MP_A_IN(1)
OUTFLOW2d(6)=MP_R_IN(2)*MP_A_IN(2)
OUTFLOW2d(7)=MP_A_IN(1)

ELSE

R=RRES
GM=GAMMA
P=PRES
U=uvel
V=vvel


!KINETIC ENERGY FIRST!
SKIN=(OO2)*((U**2)+(V**2))
!INTERNAL ENERGY 
IEN=((P)/((GM-1.0D0)*R))
!TOTAL ENERGY
E=R*(SKIN+IEN)
!VECTOR OF CONSERVED VARIABLES NOW
OUTFLOW2d(1)=R
OUTFLOW2d(2)=R*U
OUTFLOW2d(3)=R*V
OUTFLOW2d(4)=E
END IF

END FUNCTION OUTFLOW2d

FUNCTION OUTFLOW(INITCOND,POX,POY,POZ)
!> @brief
!> This function applies a prescribed boundary condition to  the outflow in 3D
IMPLICIT NONE
REAL,DIMENSION(5)::OUTFLOW
INTEGER,INTENT(IN)::INITCOND
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::POX,POY,POZ
REAL::P,U,V,W,E,R,S,GM,SKIN,IEN,PI
REAL::XF,YF,ZF


R=RRES
GM=GAMMA
P=PRES
U=uvel
V=vvel
W=wvel

!KINETIC ENERGY FIRST!
SKIN=(OO2)*((U**2)+(V**2)+(W**2))
!INTERNAL ENERGY 
IEN=((P)/((GM-1.0D0)*R))
!TOTAL ENERGY
E=R*(SKIN+IEN)
!VECTOR OF CONSERVED VARIABLES NOW
OUTFLOW(1)=R
OUTFLOW(2)=R*U
OUTFLOW(3)=R*V
OUTFLOW(4)=R*W
OUTFLOW(5)=E

END FUNCTION OUTFLOW




FUNCTION PASS_INLET(INITCOND,POX,POY,POZ)
!> @brief
!> This function applies a prescribed boundary condition to  the inlet for a passive scalar
IMPLICIT NONE
REAL,DIMENSION(1:PASSIVESCALAR)::PASS_INLET
INTEGER,INTENT(IN)::INITCOND
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::POX,POY,POZ


PASS_INLET(1:PASSIVESCALAR)=1.0D0*RRES

END FUNCTION PASS_INLET


FUNCTION PASS_INLET2d(INITCOND,POX,POY)
!> @brief
!> This function applies a prescribed boundary condition to  the inlet for a passive scalar in 2d
IMPLICIT NONE
REAL,DIMENSION(1:PASSIVESCALAR)::PASS_INLET2d
INTEGER,INTENT(IN)::INITCOND
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::POX,POY



PASS_INLET2d(1:PASSIVESCALAR)=1.0D0

END FUNCTION PASS_INLET2d









SUBROUTINE SHEAR_X(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the shear stresses in x-axis
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED
REAL::UX,UY,UZ,VX,VY,VZ,WX,WY,WZ,TAUXX,TAUYY,TAUZZ,TAUYX,TAUZX,TAUZY
 REAL::SSX,SSY,SSZ,SSP

 

 
VORTET1(1:3,1:3) = ILOCAL_RECON3(ICONSI)%GRADS(1:3,1:3)


 ux = Vortet1(1,1);uy = Vortet1(1,2);uz = Vortet1(1,3)
 vx = Vortet1(2,1);vy = Vortet1(2,2);vz = Vortet1(2,3)
 wx = Vortet1(3,1);wy = Vortet1(3,2);wz = Vortet1(3,3)


 ANGLE1=IELEM(N,ICONSI)%FACEANGLEX(ICONSIDERED)
 ANGLE2=IELEM(N,ICONSI)%FACEANGLEY(ICONSIDERED)
 NX=(COS(ANGLE1)*SIN(ANGLE2))
 NY=(SIN(ANGLE1)*SIN(ANGLE2))
 NZ=(COS(ANGLE2))
 LEFTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 RIGHTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 CALL CONS2PRIM2(n)
 CALL SUTHERLAND(N,LEFTV,RIGHTV)

SSX=ZERO; SSP=ZERO; SSY=ZERO; SSZ=ZERO

TAUXX=(4.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY - (2.0D0/3.0D0)*WZ
TAUYY=(4.0D0/3.0D0)*VY - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*WZ
TAUZZ=(4.0D0/3.0D0)*WZ - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY
TAUYX=(UY + VX)
TAUZX=(WX + UZ)
TAUZY=(VZ + WY)
SSX=(VISCL(1)*((NX*TAUXX)+(NY*TAUYX)+(NZ*TAUZX)))
SSY=(VISCL(1)*((NX*TAUYX)+(NY*TAUYY)+(NZ*TAUZY)))
SSZ=(VISCL(1)*((NX*TAUZX)+(NY*TAUZY)+(NZ*TAUZZ)))





SHEAR_TEMP=-SSX/(0.5*rres*ufreestream*ufreestream)


END SUBROUTINE SHEAR_X



SUBROUTINE SHEAR_Y(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the shear stresses in y-axis
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED
REAL::UX,UY,UZ,VX,VY,VZ,WX,WY,WZ,TAUXX,TAUYY,TAUZZ,TAUYX,TAUZX,TAUZY
 REAL::SSX,SSY,SSZ,SSP
 
VORTET1(1:3,1:3) = ILOCAL_RECON3(ICONSI)%GRADS(1:3,1:3)


 ux = Vortet1(1,1);uy = Vortet1(1,2);uz = Vortet1(1,3)
 vx = Vortet1(2,1);vy = Vortet1(2,2);vz = Vortet1(2,3)
 wx = Vortet1(3,1);wy = Vortet1(3,2);wz = Vortet1(3,3)


 ANGLE1=IELEM(N,ICONSI)%FACEANGLEX(ICONSIDERED)
 ANGLE2=IELEM(N,ICONSI)%FACEANGLEY(ICONSIDERED)
 NX=(COS(ANGLE1)*SIN(ANGLE2))
 NY=(SIN(ANGLE1)*SIN(ANGLE2))
 NZ=(COS(ANGLE2))
 LEFTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 RIGHTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 CALL CONS2PRIM2(n)
 CALL SUTHERLAND(N,LEFTV,RIGHTV)

SSX=ZERO; SSP=ZERO; SSY=ZERO; SSZ=ZERO

TAUXX=(4.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY - (2.0D0/3.0D0)*WZ
TAUYY=(4.0D0/3.0D0)*VY - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*WZ
TAUZZ=(4.0D0/3.0D0)*WZ - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY
TAUYX=(UY + VX)
TAUZX=(WX + UZ)
TAUZY=(VZ + WY)
SSX=(VISCL(1)*((NX*TAUXX)+(NY*TAUYX)+(NZ*TAUZX)))
SSY=(VISCL(1)*((NX*TAUYX)+(NY*TAUYY)+(NZ*TAUZY)))
SSZ=(VISCL(1)*((NX*TAUZX)+(NY*TAUZY)+(NZ*TAUZZ)))


SHEAR_TEMP=-SSY/(0.5*rres*ufreestream*ufreestream)


END SUBROUTINE SHEAR_Y


SUBROUTINE SHEAR_Z(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the shear stresses in z-axis
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED
REAL::UX,UY,UZ,VX,VY,VZ,WX,WY,WZ,TAUXX,TAUYY,TAUZZ,TAUYX,TAUZX,TAUZY
REAL::SSX,SSY,SSZ,SSP 
 
VORTET1(1:3,1:3) = ILOCAL_RECON3(ICONSI)%GRADS(1:3,1:3)


 ux = Vortet1(1,1);uy = Vortet1(1,2);uz = Vortet1(1,3)
 vx = Vortet1(2,1);vy = Vortet1(2,2);vz = Vortet1(2,3)
 wx = Vortet1(3,1);wy = Vortet1(3,2);wz = Vortet1(3,3)


 ANGLE1=IELEM(N,ICONSI)%FACEANGLEX(ICONSIDERED)
 ANGLE2=IELEM(N,ICONSI)%FACEANGLEY(ICONSIDERED)
 NX=(COS(ANGLE1)*SIN(ANGLE2))
 NY=(SIN(ANGLE1)*SIN(ANGLE2))
 NZ=(COS(ANGLE2))
 LEFTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 RIGHTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 CALL CONS2PRIM2(n)
 CALL SUTHERLAND(N,LEFTV,RIGHTV)

SSX=ZERO; SSP=ZERO; SSY=ZERO; SSZ=ZERO

TAUXX=(4.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY - (2.0D0/3.0D0)*WZ
TAUYY=(4.0D0/3.0D0)*VY - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*WZ
TAUZZ=(4.0D0/3.0D0)*WZ - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY
TAUYX=(UY + VX)
TAUZX=(WX + UZ)
TAUZY=(VZ + WY)
SSX=(VISCL(1)*((NX*TAUXX)+(NY*TAUYX)+(NZ*TAUZX)))
SSY=(VISCL(1)*((NX*TAUYX)+(NY*TAUYY)+(NZ*TAUZY)))
SSZ=(VISCL(1)*((NX*TAUZX)+(NY*TAUZY)+(NZ*TAUZZ)))


SHEAR_TEMP=-SSZ/(0.5*rres*ufreestream*ufreestream)


END SUBROUTINE SHEAR_Z

SUBROUTINE SHEAR_X_av(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the average shear stresses in x-axis
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED
REAL::UX,UY,UZ,VX,VY,VZ,WX,WY,WZ,TAUXX,TAUYY,TAUZZ,TAUYX,TAUZX,TAUZY
 REAL::SSX,SSY,SSZ,SSP
 integer::ind1
 
 
 if (rungekutta.eq.4)then
	      ind1=7
	      else
	      ind1=5
	      end if

VORTET1(1:3,1:3) = ILOCAL_RECON3(ICONSI)%GRADSAV(1:3,1:3)


 ux = Vortet1(1,1);uy = Vortet1(1,2);uz = Vortet1(1,3)
 vx = Vortet1(2,1);vy = Vortet1(2,2);vz = Vortet1(2,3)
 wx = Vortet1(3,1);wy = Vortet1(3,2);wz = Vortet1(3,3)


 ANGLE1=IELEM(N,ICONSI)%FACEANGLEX(ICONSIDERED)
 ANGLE2=IELEM(N,ICONSI)%FACEANGLEY(ICONSIDERED)
 NX=(COS(ANGLE1)*SIN(ANGLE2))
 NY=(SIN(ANGLE1)*SIN(ANGLE2))
 NZ=(COS(ANGLE2))
 LEFTV(1:nof_Variables)=U_C(ICONSI)%VAL(IND1,1:nof_Variables)
 RIGHTV(1:nof_Variables)=U_C(ICONSI)%VAL(IND1,1:nof_Variables)
 CALL CONS2PRIM2(n)
 CALL SUTHERLAND(N,LEFTV,RIGHTV)

SSX=ZERO; SSP=ZERO; SSY=ZERO; SSZ=ZERO

TAUXX=(4.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY - (2.0D0/3.0D0)*WZ
TAUYY=(4.0D0/3.0D0)*VY - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*WZ
TAUZZ=(4.0D0/3.0D0)*WZ - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY
TAUYX=(UY + VX)
TAUZX=(WX + UZ)
TAUZY=(VZ + WY)
SSX=(VISCL(1)*((NX*TAUXX)+(NY*TAUYX)+(NZ*TAUZX)))
SSY=(VISCL(1)*((NX*TAUYX)+(NY*TAUYY)+(NZ*TAUZY)))
SSZ=(VISCL(1)*((NX*TAUZX)+(NY*TAUZY)+(NZ*TAUZZ)))


SHEAR_TEMP=-SSX/(0.5*rres*ufreestream*ufreestream)



END SUBROUTINE SHEAR_X_av



SUBROUTINE SHEAR_Y_av(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the average shear stresses in y-axis
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED
REAL::UX,UY,UZ,VX,VY,VZ,WX,WY,WZ,TAUXX,TAUYY,TAUZZ,TAUYX,TAUZX,TAUZY
 REAL::SSX,SSY,SSZ,SSP
  integer::ind1
 
 
 if (rungekutta.eq.4)then
	      ind1=7
	      else
	      ind1=5
	      end if
 
VORTET1(1:3,1:3) = ILOCAL_RECON3(ICONSI)%GRADSAV(1:3,1:3)


 ux = Vortet1(1,1);uy = Vortet1(1,2);uz = Vortet1(1,3)
 vx = Vortet1(2,1);vy = Vortet1(2,2);vz = Vortet1(2,3)
 wx = Vortet1(3,1);wy = Vortet1(3,2);wz = Vortet1(3,3)


 ANGLE1=IELEM(N,ICONSI)%FACEANGLEX(ICONSIDERED)
 ANGLE2=IELEM(N,ICONSI)%FACEANGLEY(ICONSIDERED)
 NX=(COS(ANGLE1)*SIN(ANGLE2))
 NY=(SIN(ANGLE1)*SIN(ANGLE2))
 NZ=(COS(ANGLE2))
 LEFTV(1:nof_Variables)=U_C(ICONSI)%VAL(IND1,1:nof_Variables)
 RIGHTV(1:nof_Variables)=U_C(ICONSI)%VAL(IND1,1:nof_Variables)
 CALL CONS2PRIM2(n)
 CALL SUTHERLAND(N,LEFTV,RIGHTV)

SSX=ZERO; SSP=ZERO; SSY=ZERO; SSZ=ZERO

TAUXX=(4.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY - (2.0D0/3.0D0)*WZ
TAUYY=(4.0D0/3.0D0)*VY - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*WZ
TAUZZ=(4.0D0/3.0D0)*WZ - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY
TAUYX=(UY + VX)
TAUZX=(WX + UZ)
TAUZY=(VZ + WY)
SSX=(VISCL(1)*((NX*TAUXX)+(NY*TAUYX)+(NZ*TAUZX)))
SSY=(VISCL(1)*((NX*TAUYX)+(NY*TAUYY)+(NZ*TAUZY)))
SSZ=(VISCL(1)*((NX*TAUZX)+(NY*TAUZY)+(NZ*TAUZZ)))


SHEAR_TEMP=-SSY/(0.5*rres*ufreestream*ufreestream)



END SUBROUTINE SHEAR_Y_av


SUBROUTINE SHEAR_Z_av(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the average shear stresses in z-axis
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED
REAL::UX,UY,UZ,VX,VY,VZ,WX,WY,WZ,TAUXX,TAUYY,TAUZZ,TAUYX,TAUZX,TAUZY
REAL::SSX,SSY,SSZ,SSP 
 integer::ind1
 
 
 if (rungekutta.eq.4)then
	      ind1=7
	      else
	      ind1=5
	      end if
 
VORTET1(1:3,1:3) = ILOCAL_RECON3(ICONSI)%GRADSAV(1:3,1:3)


 ux = Vortet1(1,1);uy = Vortet1(1,2);uz = Vortet1(1,3)
 vx = Vortet1(2,1);vy = Vortet1(2,2);vz = Vortet1(2,3)
 wx = Vortet1(3,1);wy = Vortet1(3,2);wz = Vortet1(3,3)


 ANGLE1=IELEM(N,ICONSI)%FACEANGLEX(ICONSIDERED)
 ANGLE2=IELEM(N,ICONSI)%FACEANGLEY(ICONSIDERED)
 NX=(COS(ANGLE1)*SIN(ANGLE2))
 NY=(SIN(ANGLE1)*SIN(ANGLE2))
 NZ=(COS(ANGLE2))
 LEFTV(1:nof_Variables)=U_C(ICONSI)%VAL(IND1,1:nof_Variables)
 RIGHTV(1:nof_Variables)=U_C(ICONSI)%VAL(IND1,1:nof_Variables)
 CALL CONS2PRIM2(n)
 CALL SUTHERLAND(N,LEFTV,RIGHTV)

SSX=ZERO; SSP=ZERO; SSY=ZERO; SSZ=ZERO

TAUXX=(4.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY - (2.0D0/3.0D0)*WZ
TAUYY=(4.0D0/3.0D0)*VY - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*WZ
TAUZZ=(4.0D0/3.0D0)*WZ - (2.0D0/3.0D0)*UX - (2.0D0/3.0D0)*VY
TAUYX=(UY + VX)
TAUZX=(WX + UZ)
TAUZY=(VZ + WY)
SSX=(VISCL(1)*((NX*TAUXX)+(NY*TAUYX)+(NZ*TAUZX)))
SSY=(VISCL(1)*((NX*TAUYX)+(NY*TAUYY)+(NZ*TAUZY)))
SSZ=(VISCL(1)*((NX*TAUZX)+(NY*TAUZY)+(NZ*TAUZZ)))


SHEAR_TEMP=-SSZ/(0.5*rres*ufreestream*ufreestream)


END SUBROUTINE SHEAR_Z_av

SUBROUTINE SHEAR_X2d(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the shear stresses in x-axis in 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED
REAL::UX,UY,UZ,VX,VY,VZ,WX,WY,WZ,TAUXX,TAUYY,TAUZZ,TAUYX,TAUZX,TAUZY
REAL::SSX,SSY,SSZ,SSP
integer::gqi_points,im
 SSX=zero; SSP=zero; SSY=zero; 
 
 gqi_points=qp_line_n
call  QUADRATURELINE(N,IGQRULES)
 
 do im=1,gqi_points
 if (ielem(n,iconsi)%ggs.eq.1)then
VORTET1(1:2,1:2) = ILOCAL_RECON3(ICONSI)%GRADS(1:2,1:2)
else
 vortet1(1,1:2)=ILOCAL_RECON3(iconsi)%ULEFTV(1:2,2,ICONSIDERED,IM)
vortet1(2,1:2)=ILOCAL_RECON3(iconsi)%ULEFTV(1:2,3,ICONSIDERED,IM)

end if

 ux = Vortet1(1,1);uy = Vortet1(1,2)
 vx = Vortet1(2,1);vy = Vortet1(2,2)
 


 ANGLE1=IELEM(N,ICONSI)%FACEANGLEX(ICONSIDERED)
 ANGLE2=IELEM(N,ICONSI)%FACEANGLEY(ICONSIDERED)
 NX=ANGLE1
 NY=ANGLE2
 
 LEFTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 RIGHTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 CALL CONS2PRIM2D2(n)
 CALL SUTHERLAND2D(N,LEFTV,RIGHTV)

SSX=ZERO; SSP=ZERO; SSY=ZERO; SSZ=ZERO

TAUXX=2.0D0*UX
TAUYY=2.0D0*VY

TAUYX=(UY + VX)

SSX=SSX+((VISCL(1)*((NY*TAUYX)))*WEQUA2D(im))
SSY=SSY+((VISCL(1)*((NX*TAUYX)))*WEQUA2D(im))
end do

SHEAR_TEMP=-SSX/(0.5*rres*ufreestream*ufreestream)




END SUBROUTINE SHEAR_X2d



SUBROUTINE SHEAR_Y2d(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the shear stresses in y-axis in 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED
REAL::UX,UY,UZ,VX,VY,VZ,WX,WY,WZ,TAUXX,TAUYY,TAUZZ,TAUYX,TAUZX,TAUZY
REAL::SSX,SSY,SSZ,SSP
integer::gqi_points,im
 SSX=zero; SSP=zero; SSY=zero; 
 
 gqi_points=qp_line_n
call  QUADRATURELINE(N,IGQRULES)
 
 do im=1,gqi_points
 if (ielem(n,iconsi)%ggs.eq.1)then
VORTET1(1:2,1:2) = ILOCAL_RECON3(ICONSI)%GRADS(1:2,1:2)
else
 vortet1(1,1:2)=ILOCAL_RECON3(iconsi)%ULEFTV(1:2,2,ICONSIDERED,IM)
vortet1(2,1:2)=ILOCAL_RECON3(iconsi)%ULEFTV(1:2,3,ICONSIDERED,IM)

end if

 ux = Vortet1(1,1);uy = Vortet1(1,2)
 vx = Vortet1(2,1);vy = Vortet1(2,2)
 


 ANGLE1=IELEM(N,ICONSI)%FACEANGLEX(ICONSIDERED)
 ANGLE2=IELEM(N,ICONSI)%FACEANGLEY(ICONSIDERED)
 NX=ANGLE1
 NY=ANGLE2
 
 LEFTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 RIGHTV(1:nof_Variables)=U_C(ICONSI)%VAL(1,1:nof_Variables)
 CALL CONS2PRIM2D2(n)
 CALL SUTHERLAND2D(N,LEFTV,RIGHTV)

SSX=ZERO; SSP=ZERO; SSY=ZERO; SSZ=ZERO

TAUXX=2.0D0*UX
TAUYY=2.0D0*VY

TAUYX=(UY + VX)

SSX=SSX+((VISCL(1)*((NY*TAUYX)))*WEQUA2D(im))
SSY=SSY+((VISCL(1)*((NX*TAUYX)))*WEQUA2D(im))
end do

SHEAR_TEMP=-SSX/(0.5*rres*ufreestream*ufreestream)


END SUBROUTINE SHEAR_Y2d




SUBROUTINE SHEAR_X2d_av(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the average shear stresses in x-axis in 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED

! 
! if (ielem(n,iconsi)%ggs.eq.1)then
! 
! VORTET1(1:3,1:3) = ILOCAL_RECON3(ICONSGVQ)%GRADS(1:3,1:3)
! 
! else
! 
! 
! 
! 
! 
! 
! else
! 
! ! vortet(1,1:3)=ILOCAL_RECON3(iconsi)%ULEFTV(1:3,2,J,IM)
! ! vortet(2,1:3)=ILOCAL_RECON3(iconsi)%ULEFTV(1:3,3,J,IM)
! ! vortet(3,1:3)=ILOCAL_RECON3(iconsi)%ULEFTV(1:3,4,J,IM)
! ! 
! ! 
! ! ux = Vortet1(1,1);uy = Vortet1(1,2);uz = Vortet1(1,3)
! ! vx = Vortet1(2,1);vy = Vortet1(2,2);vz = Vortet1(2,3)
! ! wx = Vortet1(3,1);wy = Vortet1(3,2);wz = Vortet1(3,3)
! 
! end if

! ANGLE1=IELEM(N,IBOUND_T(I))%FACEANGLEX(Jk,Kk)
! ANGLE2=IELEM(N,IBOUND_T(I))%FACEANGLEY(Jk,Kk)
! NX=(COS(ANGLE1)*SIN(ANGLE2))
! NY=(SIN(ANGLE1)*SIN(ANGLE2))
! NZ=(COS(ANGLE2))
! LEFTV(1:nof_Variables)=U_C(IBOUND_T(I))%VAL(1,1:nof_Variables)
! RIGHTV(1:nof_Variables)=U_C(IBOUND_T(I))%VAL(1,1:nof_Variables)
! CALL SUTHERLANDIi(N,LEFTV,RIGHTV,VISCL,LAML,PRES,RRES,GAMMA,VISC,BETAAS,SUTHER,PRANDTL)
! SSX=0.0; SSP=0.0; SSY=0.0; SSZ=0.0
! DO IM=1,NUMBEROFPOINTS2
! TAUXX=2.0*ILOCAL_RECON3(k)%ULEFTV(1,2,J,K,IM)
! TAUYY=2.0*ILOCAL_RECON3(k)%ULEFTV(2,3,J,K,IM)
! TAUZZ=2.0*ILOCAL_RECON3(k)%ULEFTV(3,4,J,K,IM)
! TAUYX=(ILOCAL_RECON3(IBOUND_T(I))%ULEFTV(2,2,Jk,Kk,IM))+(ILOCAL_RECON3(IBOUND_T(I))%ULEFTV(1,3,Jk,Kk,IM))	!(UY + VX)
! TAUZX=(ILOCAL_RECON3(IBOUND_T(I))%ULEFTV(1,4,Jk,Kk,IM))+(ILOCAL_RECON3(IBOUND_T(I))%ULEFTV(3,2,Jk,Kk,IM))	! (WX + UZ)
! TAUZY=(ILOCAL_RECON3(IBOUND_T(I))%ULEFTV(3,3,Jk,Kk,IM))+(ILOCAL_RECON3(IBOUND_T(I))%ULEFTV(2,4,Jk,Kk,IM))	!(VZ + WY)
! SSX=SSX-((VISCL(1)*((NY*TAUYX)+(NZ*TAUZX)))*ILOCAL_RECON3(IBOUND_T(I))%WGAUSS(Jk,Kk,IM))
! SSY=SSY-((VISCL(1)*((NX*TAUYX)+(NZ*TAUZY)))*ILOCAL_RECON3(IBOUND_T(I))%WGAUSS(Jk,Kk,IM))
! SSZ=SSZ-((VISCL(1)*((NX*TAUZX)+(NY*TAUZY)))*ILOCAL_RECON3(IBOUND_T(I))%WGAUSS(Jk,Kk,IM))








SHEAR_TEMP=0.0D0


END SUBROUTINE SHEAR_X2d_av



SUBROUTINE SHEAR_Y2d_av(ICONSI,ICONSIDERED)
!> @brief
!> This subroutine computes the average shear stresses in y-axis in 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::ICONSI,ICONSIDERED

SHEAR_TEMP=0.0D0


END SUBROUTINE SHEAR_Y2d_av



SUBROUTINE SUTHERLAND(N,leftv,rightv)
!> @brief
!> This subroutine computes the viscosity according to sutherland's law
	IMPLICIT NONE
        REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::LEFTV,RIGHTV
	INTEGER,INTENT(IN)::N
	REAL::KINETIC,U,V,W,T0L,T1L,T0R,T1R
		
		T1L=LEFTv(5)/LEFTv(1)
		T0L=PRES/RRES
		
		
		T1R=RIGHTv(5)/RIGHTv(1)
		T0R=PRES/RRES

	      	
              VISCL(1)=VISC*((T1L/T0L)**BETAAS)*((T0L+(SUTHER*T0L))/(T1L+(SUTHER*T0L)))
              VISCL(2)=VISC*((T1R/T0R)**BETAAS)*((T0R+(SUTHER*T0R))/(T1R+(SUTHER*T0R)))

	      
	      LAML(1)=VISCL(1)*GAMMA/(PRANDTL*(GAMMA-1.d0))
	      LAML(2)=VISCL(2)*GAMMA/(PRANDTL*(GAMMA-1.d0))
	  
	
	     
	   

      

  END SUBROUTINE SUTHERLAND
  
  SUBROUTINE SUTHERLAND2d(N,leftv,rightv)
  !> @brief
!> This subroutine computes the viscosity according to sutherland's law in 2D
	IMPLICIT NONE
        REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::LEFTV,RIGHTV
	INTEGER,INTENT(IN)::N
	REAL::KINETIC,U,V,W,T0L,T1L,T0R,T1R
		
		T1L=LEFTv(4)/LEFTv(1)
		T0L=PRES/RRES
		
		
		T1R=RIGHTv(4)/RIGHTv(1)
		T0R=PRES/RRES

	      	
              VISCL(1)=VISC*((T1L/T0L)**BETAAS)*((T0L+(SUTHER*T0L))/(T1L+(SUTHER*T0L)))
              VISCL(2)=VISC*((T1R/T0R)**BETAAS)*((T0R+(SUTHER*T0R))/(T1R+(SUTHER*T0R)))

	      
	      LAML(1)=VISCL(1)*GAMMA/(PRANDTL*(GAMMA-1.d0))
	      LAML(2)=VISCL(2)*GAMMA/(PRANDTL*(GAMMA-1.d0))
	  

	   

      

  END SUBROUTINE SUTHERLAND2d


  
SUBROUTINE VORTEXCALC(N)
!> @brief
!> This subroutine computes the q-criterion
  
IMPLICIT NONE
INTEGER,INTENT(IN)::N
INTEGER::KMAXE,I,IHGT,IHGJ
REAL::SNORM,ONORM
REAL,DIMENSION(3,3)::TVORT,SVORT,OVORT

 	 KMAXE=XMPIELRANK(N)
!$OMP DO SCHEDULE (STATIC) 
DO I=1,KMAXE     
	    
                VORTET1(1:3,1:3)=ILOCAL_RECON3(I)%GRADS(1:3,1:3)    
	    
	    DO IHGT=1,3; DO IHGJ=1,3
	    TVORT(IHGT,IHGJ)=VORTET1(IHGJ,IHGT)
	      END DO; END DO
	      SVORT=0.5D0*(VORTET1+TVORT)
	      OVORT=0.5D0*(VORTET1-TVORT)
	      SNORM=SQRT((SVORT(1,1)*SVORT(1,1))+(SVORT(1,2)*SVORT(1,2))+&
(SVORT(1,3)*SVORT(1,3))+(SVORT(2,1)*SVORT(2,1))+(SVORT(2,2)*SVORT(2,2))+(SVORT(2,3)*SVORT(2,3))&
+(SVORT(3,1)*SVORT(3,1))+(SVORT(3,2)*SVORT(3,2))+(SVORT(3,3)*SVORT(3,3)))
	      ONORM=SQRT((OVORT(1,1)*OVORT(1,1))+(OVORT(1,2)*OVORT(1,2))+(OVORT(1,3)*OVORT(1,3))+&
(OVORT(2,1)*OVORT(2,1))+(OVORT(2,2)*OVORT(2,2))+(OVORT(2,3)*OVORT(2,3))+(OVORT(3,1)*OVORT(3,1))+&
(OVORT(3,2)*OVORT(3,2))+(OVORT(3,3)*OVORT(3,3)))
	      
	      IELEM(N,I)%VORTEX(1)=(0.5D0*((ONORM**2)-(SNORM**2)))
		
END DO
!$OMP END DO



END SUBROUTINE VORTEXCALC

SUBROUTINE VORTEXCALC2D(N)
!> @brief
!> This subroutine computes the q criterion for 2D
  
IMPLICIT NONE
INTEGER,INTENT(IN)::N
INTEGER::KMAXE,I,IHGT,IHGJ
REAL::SNORM,ONORM
REAL,DIMENSION(2,2)::TVORT,SVORT,OVORT

 	 KMAXE=XMPIELRANK(N)
 	 
 	
!$OMP DO SCHEDULE (STATIC) 	 
DO I=1,KMAXE     
	    
                VORTET1(1:2,1:2)=ILOCAL_RECON3(I)%GRADS(1:2,1:2)    
	    
	    DO IHGT=1,2; DO IHGJ=1,2
	    TVORT(IHGT,IHGJ)=VORTET1(IHGJ,IHGT)
	      END DO; END DO
	      SVORT=0.5D0*(VORTET1+TVORT)
	      OVORT=0.5D0*(VORTET1-TVORT)
	      SNORM=SQRT((SVORT(1,1)*SVORT(1,1))+(SVORT(1,2)*SVORT(1,2))+&
+(SVORT(2,1)*SVORT(2,1))+(SVORT(2,2)*SVORT(2,2)))
	      ONORM=SQRT((OVORT(1,1)*OVORT(1,1))+(OVORT(1,2)*OVORT(1,2))+&
(OVORT(2,1)*OVORT(2,1))+(OVORT(2,2)*OVORT(2,2)))
	      
	      IELEM(N,I)%VORTEX(1)=(0.5D0*((ONORM**2)-(SNORM**2)))
		
END DO
!$OMP END DO



END SUBROUTINE VORTEXCALC2D





SUBROUTINE BOUNDARYS(N,B_CODE,ICONSIDERED)
!> @brief
!> This subroutine applies the boundary condition to each bounded cell
implicit none
integer,intent(in)::n,b_code,ICONSIDERED
REAL::SPS,SKINS,IKINS,VEL,vnb




SELECT CASE(B_CODE)

    
    CASE(1)!INFLOW SUBSONIC OR SUPERSONIC WILL BE CHOSEN BASED ON MACH NUMBER
    if (boundtype.eq.0)then	!SUPERSONIC
    
    RIGHTV(1:nof_Variables)=INFLOW(INITCOND,POX,POY,POZ)
    
    
    
        
    
    
    ELSE		!SUBSONIC
    RIGHTV(1:nof_Variables)=INFLOW(INITCOND,POX,POY,POZ)
    
    CALL cons2prim2(N)
    
    SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
    SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
    SPS=SQRT((GAMMA*SUBSON2(5))/(SUBSON2(1)))
    VEL=sqrt(SUBSON2(2)**2+SUBSON2(3)**2+SUBSON2(4)**2)
    CALL PRIM2CONS2(N)
    
      IF (VEL/(SPS+TOLSMALL).GT.1.0D0)THEN	!SUPERSONIC
      
      
      RIGHTV(1:nof_Variables)=INFLOW(INITCOND,POX,POY,POZ)
      
      
      
      ELSE		!SUBSONIC
      
      SUBSON3(5)=0.5*((SUBSON1(5))+(SUBSON2(5))-(SUBSON2(1)*SPS*((NX*(SUBSON1(2)-SUBSON2(2)))+(NY*(SUBSON1(3)-SUBSON2(3)))&
+(NZ*(SUBSON1(4)-SUBSON2(4))))))
      SUBSON3(1)=SUBSON1(1)+(SUBSON3(5)-SUBSON1(5))/(SPS**2)
      SUBSON3(2)=SUBSON1(2)-(NX*(SUBSON1(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
      SUBSON3(3)=SUBSON1(3)-(NY*(SUBSON1(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
      SUBSON3(4)=SUBSON1(4)-(NZ*(SUBSON1(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
      
     
      
       rightv(1)=SUBSON3(1)
    rightv(2)=SUBSON3(2)*SUBSON3(1)
    rightv(3)=SUBSON3(3)*SUBSON3(1)
    rightv(4)=SUBSON3(4)*SUBSON3(1)
    SKINS=oo2*((SUBSON3(2)**2)+(SUBSON3(3)**2)+(SUBSON3(4)**2))
    IKINS=SUBSON3(5)/((GAMMA-1.0d0)*(SUBSON3(1)))
    rightv(5)=(SUBSON3(1)*(IKINS))+(SUBSON3(1)*SKINS)
      
      
      
      END IF

      
      
      
      
      
      IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
	      
      
      
      
	      IF (TURBULENCEMODEL.EQ.1)THEN
		  CTURBR(1)=VISC*TURBINIT
	      END IF
	      IF (TURBULENCEMODEL.EQ.2)THEN	 
		CTURBR(1)=(1.5D0*I_turb_inlet*(ufreestream**2))*RIGHTV(1)!K INITIALIZATION
		CTURBR(2)=RIGHTV(1)*CTURBR(1)/(10.0e-5*visc)!OMEGA INITIALIZATION
	      END IF
 
	      IF (PASSIVESCALAR.GT.0)THEN
	      CTURBR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=PASS_INLET(INITCOND,POX,POY,POZ)*RIGHTV(1)
	      END IF
      END IF
      
      
      
      
      
      
      
      
    
    END IF
    
    
    CASE(2)!OUTFLOW SUBSONIC OR SUPERSONIC WILL BE CHOSEN BASED ON MACH NUMBER
     if (boundtype.eq.0)then
      rightv(1:nof_Variables)=leftv(1:nof_Variables)
      
     else
     
     rightv(1:nof_Variables)=OUTFLOW(INITCOND,pox,poy,poz)
     CALL cons2prim2(N)
    
    SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
    SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
     
     SPS=SQRT((GAMMA*SUBSON2(5))/(SUBSON2(1)))
    VEL=sqrt(SUBSON2(2)**2+SUBSON2(3)**2+SUBSON2(4)**2)
     
    SPS=SQRT((GAMMA*SUBSON2(5))/(SUBSON2(1)))
    
    CALL PRIM2CONS2(N)
    
    IF (VEL/(SPS+TOLSMALL).GT.1.0D0)THEN	!SUPERSONIC
    CALL PRIM2CONS2(N)
    rightv(1:nof_Variables)=leftv(1:nof_Variables)
    
    
      Else
    SUBSON3(5)=SUBSON1(5)
    SUBSON3(1)=SUBSON2(1)+(SUBSON3(5)-SUBSON2(5))/(SPS**2)
    SUBSON3(2)=SUBSON2(2)+(NX*(SUBSON2(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
    SUBSON3(3)=SUBSON2(3)+(NY*(SUBSON2(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
    SUBSON3(4)=SUBSON2(4)+(NZ*(SUBSON2(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
! 							
    rightv(1)=SUBSON3(1)
    rightv(2)=SUBSON3(2)*SUBSON3(1)
    rightv(3)=SUBSON3(3)*SUBSON3(1)
    rightv(4)=SUBSON3(4)*SUBSON3(1)
    SKINS=oo2*((SUBSON3(2)**2)+(SUBSON3(3)**2)+(SUBSON3(4)**2))
    IKINS=SUBSON3(5)/((GAMMA-1.0d0)*(SUBSON3(1)))
    rightv(5)=(SUBSON3(1)*(IKINS))+(SUBSON3(1)*SKINS)
     
     
    end if
    end if

    
    
      IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
	     
		  CTURBR(:)=CTURBL(:)
	
      END IF
    
    
    
    
    
    
    
    
    
    
    
    
    
    CASE(3)!SYMMETRY
    
			      CALL ROTATEF(N,TRI,Cleft_ROT,leftV,ANGLE1,ANGLE2)
			      
         		      CRIGHT_ROT(1)=CLEFT_ROT(1)
			      CRIGHT_ROT(2)=-CLEFT_ROT(2)
			      CRIGHT_ROT(3)=CLEFT_ROT(3)
			      CRIGHT_ROT(4)=CLEFT_ROT(4)
			      CRIGHT_ROT(5)=CLEFT_ROT(5)
					 
				     IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
					    CTURBR(:)=CTURBL(:)

					  if (passivescalar.gt.0)then
					  cturbR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=&
						    ctURBL(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)

					  end if
				      END IF
				
			      CALL ROTATEb(N,TRI,rightv,Cright_ROT,ANGLE1,ANGLE2)
    
    
    
    CASE(4)!WALL
    
    
			      IF (ITESTCASE.EQ.3)THEN
			      
			       CALL ROTATEF(N,TRI,Cleft_ROT,leftV,ANGLE1,ANGLE2)
			      
         		      CRIGHT_ROT(1)=CLEFT_ROT(1)
			      CRIGHT_ROT(2)=-CLEFT_ROT(2)
			      CRIGHT_ROT(3)=CLEFT_ROT(3)
			      CRIGHT_ROT(4)=CLEFT_ROT(4)
			      CRIGHT_ROT(5)=CLEFT_ROT(5)
					 
				     IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
					    CTURBR(:)=CTURBL(:)

					  if (passivescalar.gt.0)then
					  cturbR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=&
						    ctURBL(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)

					  end if
				      END IF
				
				
				
			      CALL ROTATEb(N,invTRI,rightv,Cright_ROT,ANGLE1,ANGLE2)
			      
			      
			      
			      ELSE
    
			      rightv(1)=leftv(1)
			      rightv(2)=-leftv(2)
			      rightv(3)=-leftv(3)
			      rightv(4)=-leftv(4)
			      rightv(5)=leftv(5)
    
    
    
    
				      IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
					IF (TURBULENCEMODEL.NE.2)THEN
					    CTURBR(:)=-CTURBL(:)

					  if (passivescalar.gt.0)then
					  cturbR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=&
						    -ctURBL(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)

					  end if
					ELSE
					     CTURBR(1)=-CTURBL(1)
					     CTURBR(2)=60.0D0*VISC/(BETA_I1*(IELEM(N,ICONSIDERED)%WallDist**2))

					  if (passivescalar.gt.0)then
					  cturbR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=&
						    -ctURBL(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)

					  end if
					  
					
					
					
					
					END IF
				      END IF
    
    
				END IF
    
    
    
    
    
    CASE(6)!FARFIELD INFLOW OR OUTFLOW, SUBSONIC OR SUPERSONIC WILL BE CHOSEN BASED ON MACH NUMBER
	    CALL ROTATEF(N,TRI,Cleft_ROT,leftV,ANGLE1,ANGLE2)
	    vnb=cleft_rot(2)
	  
	    CALL cons2prim2(N)
    
	    SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
	    SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
	    SPS=SQRT((GAMMA*SUBSON2(5))/(SUBSON2(1)))
	    VEL=sqrt(SUBSON2(2)**2+SUBSON2(3)**2+SUBSON2(4)**2)
	  
	    CALL PRIM2CONS2(N)

	  if (vnb.le.0.0d0)then		!inflow
			ibfc=-1
	
		  if ((abs(vnb)).ge.sps)then
				!supersonic
				rightv=INFLOW(INITCOND,POX,POY,POZ)
					
		  else
				!subsonic
			
			
			rightv=INFLOW(INITCOND,POX,POY,POZ)
	  	        
			  call cons2prim2(n)
			  
			
			SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
			SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
			SPS=SQRT((GAMMA*SUBSON2(5))/(SUBSON2(1)))
			VEL=sqrt(SUBSON2(2)**2+SUBSON2(3)**2+SUBSON2(4)**2)
	             CALL PRIM2CONS2(N)
				    
		    SUBSON3(5)=0.5*((SUBSON1(5))+(SUBSON2(5))-(SUBSON2(1)*SPS*((NX*(SUBSON1(2)-SUBSON2(2)))+(NY*(SUBSON1(3)-SUBSON2(3)))&
	      +(NZ*(SUBSON1(4)-SUBSON2(4))))))
		    SUBSON3(1)=SUBSON1(1)+(SUBSON3(5)-SUBSON1(5))/(SPS**2)
		    SUBSON3(2)=SUBSON1(2)-(NX*(SUBSON1(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
		    SUBSON3(3)=SUBSON1(3)-(NY*(SUBSON1(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
		    SUBSON3(4)=SUBSON1(4)-(NZ*(SUBSON1(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
		    
		    
		      rightv(1)=SUBSON3(1)
    rightv(2)=SUBSON3(2)*SUBSON3(1)
    rightv(3)=SUBSON3(3)*SUBSON3(1)
    rightv(4)=SUBSON3(4)*SUBSON3(1)
    SKINS=oo2*((SUBSON3(2)**2)+(SUBSON3(3)**2)+(SUBSON3(4)**2))
    IKINS=SUBSON3(5)/((GAMMA-1.0d0)*(SUBSON3(1)))
    rightv(5)=(SUBSON3(1)*(IKINS))+(SUBSON3(1)*SKINS)
		  
		  END IF
		  
		  
		  IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
	      
      
      
      
	       IF (TURBULENCEMODEL.EQ.1)THEN
		  CTURBR(1)=VISC*TURBINIT
	      END IF
	      IF (TURBULENCEMODEL.EQ.2)THEN	 
		CTURBR(1)=(1.5D0*I_turb_inlet*(ufreestream**2))*RIGHTV(1)!K INITIALIZATION
		CTURBR(2)=RIGHTV(1)*CTURBR(1)/(10.0e-5*visc)!OMEGA INITIALIZATION
	      END IF
 
	      IF (PASSIVESCALAR.GT.0)THEN
	      CTURBR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=PASS_INLET(INITCOND,POX,POY,POZ)*RIGHTV(1)
	      END IF
		    END IF
		  
		  
      
	else
      
	  !outflow
	
	    ibfc=-2
		if ((abs(vnb)).ge.sps)then
		      
		      rightv(1:nof_Variables)=leftv(1:nof_Variables)
		
		else
		
		
		
		rightv(1:nof_Variables)=OUTFLOW(INITCOND,pox,poy,poz)
		
		call cons2prim2(n)
		
    
    SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
    SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
     
     
     CALL PRIM2CONS2(N)
   
    
    
    SUBSON3(5)=SUBSON1(5)
    SUBSON3(1)=SUBSON2(1)+(SUBSON3(5)-SUBSON2(5))/(SPS**2)
    SUBSON3(2)=SUBSON2(2)+(NX*(SUBSON2(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
    SUBSON3(3)=SUBSON2(3)+(NY*(SUBSON2(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
    SUBSON3(4)=SUBSON2(4)+(NZ*(SUBSON2(5)-SUBSON3(5)))/(SPS*SUBSON2(1))
! 							
    rightv(1)=SUBSON3(1)
    rightv(2)=SUBSON3(2)*SUBSON3(1)
    rightv(3)=SUBSON3(3)*SUBSON3(1)
    rightv(4)=SUBSON3(4)*SUBSON3(1)
    SKINS=oo2*((SUBSON3(2)**2)+(SUBSON3(3)**2)+(SUBSON3(4)**2))
    IKINS=SUBSON3(5)/((GAMMA-1.0d0)*(SUBSON3(1)))
    rightv(5)=(SUBSON3(1)*(IKINS))+(SUBSON3(1)*SKINS)
	
	      
	      
	       IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
	     
		  CTURBR(:)=CTURBL(:)
	
		END IF
	      end if
	      

	END IF

	
! 	CALL ROTATEF(N,TRI,Cright_ROT,RIGHTV,ANGLE1,ANGLE2)
    
    

			      


END SELECT



END SUBROUTINE BOUNDARYS


SUBROUTINE BOUNDARYS2d(N,B_CODE,ICONSIDERED)
!> @brief
!> This subroutine applies the boundary condition to each bounded cell in 2D
implicit none
integer,intent(in)::n,b_code,ICONSIDERED
REAL::SPS,SKINS,IKINS,VEL,vnb
REAL::INTENERGY,R1,U1,V1,W1,ET1,S1,IE1,P1,SKIN1,E1,RS,US,VS,WS,KHX,VHX,AMP,DVEL,rgg,tt1



SELECT CASE(B_CODE)

    
    CASE(1)!INFLOW SUBSONIC OR SUPERSONIC WILL BE CHOSEN BASED ON MACH NUMBER
    if (boundtype.eq.0)then	!SUPERSONIC
    
    RIGHTV(1:nof_Variables)=INFLOW2d(INITCOND,POX,POY)
    
    
    
        
    
    
    ELSE		!SUBSONIC
    RIGHTV(1:nof_Variables)=INFLOW2d(INITCOND,POX,POY)

    CALL cons2prim2d2(N)
    
    SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
    SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
    SPS=SQRT((GAMMA*SUBSON2(4))/(SUBSON2(1)))
    VEL=sqrt(SUBSON2(2)**2+SUBSON2(3)**2)
    

    CALL PRIM2CONS2d2(N)
    

      IF (VEL/(SPS+TOLSMALL).GT.1.0D0)THEN	!SUPERSONIC
      
      
      RIGHTV(1:nof_Variables)=INFLOW2d(INITCOND,POX,POY)
      
      
      
      ELSE		!SUBSONIC
      
      
      SUBSON3(4)=0.5*((SUBSON1(4))+(SUBSON2(4))-(SUBSON2(1)*SPS*((NX*(SUBSON1(2)-SUBSON2(2)))+(NY*(SUBSON1(3)-SUBSON2(3)))&
)))
      SUBSON3(1)=SUBSON1(1)+(SUBSON3(4)-SUBSON1(4))/(SPS**2)
      SUBSON3(2)=SUBSON1(2)-(NX*(SUBSON1(4)-SUBSON3(4)))/(SPS*SUBSON2(1))
      SUBSON3(3)=SUBSON1(3)-(NY*(SUBSON1(4)-SUBSON3(4)))/(SPS*SUBSON2(1))
      
      
      		    
      
      
    rightv(1)=SUBSON3(1)
    rightv(2)=SUBSON3(2)*SUBSON3(1)
    rightv(3)=SUBSON3(3)*SUBSON3(1)
    
    SKINS=oo2*((SUBSON3(2)**2)+(SUBSON3(3)**2))
    IKINS=SUBSON3(4)/((GAMMA-1.0d0)*(SUBSON3(1)))
    rightv(4)=(SUBSON3(1)*(IKINS))+(SUBSON3(1)*SKINS)
      
      
       
      
      END IF

      
       END IF
      
      
      
      IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
	      
      
      
      
	      IF (TURBULENCEMODEL.EQ.1)THEN
		  CTURBR(1)=VISC*TURBINIT
	      END IF
	     IF (TURBULENCEMODEL.EQ.2)THEN	 
		CTURBR(1)=(1.5D0*I_turb_inlet*(ufreestream**2))*RIGHTV(1)!K INITIALIZATION
		CTURBR(2)=RIGHTV(1)*CTURBR(1)/(10.0e-5*visc)!OMEGA INITIALIZATION
		
		
	      END IF
 
	      IF (PASSIVESCALAR.GT.0)THEN
	      CTURBR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=PASS_INLET2d(INITCOND,POX,POY)*RIGHTV(1)
	      END IF
      END IF
      
      
      
      
      
      
      
      
    
   
    
    
    CASE(2)!OUTFLOW SUBSONIC OR SUPERSONIC WILL BE CHOSEN BASED ON MACH NUMBER
     if (boundtype.eq.0)then
      rightv(1:nof_Variables)=leftv(1:nof_Variables)
      
     else
     
     rightv(1:nof_Variables)=OUTFLOW2d(INITCOND,pox,poy)
     CALL cons2prim2d2(N)
    
    SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
    SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
     
     SPS=SQRT((GAMMA*SUBSON2(4))/(SUBSON2(1)))
    VEL=sqrt(SUBSON2(2)**2+SUBSON2(3)**2)
     
    SPS=SQRT((GAMMA*SUBSON2(4))/(SUBSON2(1)))
    
    CALL PRIM2CONS2d2(N)
    
    IF (VEL/(SPS+TOLSMALL).GT.1.0D0)THEN	!SUPERSONIC
    rightv(1:nof_Variables)=leftv(1:nof_Variables)
    
    
      Else
    SUBSON3(4)=SUBSON1(4)
    SUBSON3(1)=SUBSON2(1)+(SUBSON3(4)-SUBSON2(4))/(SPS**2)
    SUBSON3(2)=SUBSON2(2)+(NX*(SUBSON2(4)-SUBSON3(4)))/(SPS*SUBSON2(1))
    SUBSON3(3)=SUBSON2(3)+(NY*(SUBSON2(4)-SUBSON3(4)))/(SPS*SUBSON2(1))
    
! 							
    rightv(1)=SUBSON3(1)
    rightv(2)=SUBSON3(2)*SUBSON3(1)
    rightv(3)=SUBSON3(3)*SUBSON3(1)
    
    SKINS=oo2*((SUBSON3(2)**2)+(SUBSON3(3)**2))
    IKINS=SUBSON3(4)/((GAMMA-1.0d0)*(SUBSON3(1)))
    rightv(4)=(SUBSON3(1)*(IKINS))+(SUBSON3(1)*SKINS)
     
     
    end if
    end if

    
    
      IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
	     
		  CTURBR(:)=CTURBL(:)
	
      END IF
    
    
    
    
    
    
    
    
    
    
    
    
    
    CASE(3)!SYMMETRY
    
    
    
                            IF ((INITCOND.EQ.102).or.(INITCOND.EQ.30))THEN	!shock density interaction
                                   IF ((INITCOND.EQ.102))THEN	!shock density interaction
                            if (pox(1).lt.((1.0d0/6.0d0)+((1.0d0+20.0d0*T)/(sqrt(3.0d0)))))then
                            r1=8.0d0
                            u1=8.25*cos(pi/6.0d0)
                            v1=-8.25*sin(pi/6.0d0)
                            p1=116.5
                            else
                            r1=1.4d0
                            u1=zero
                            v1=zero
                            p1=1.0d0
                            end if
                            SKIN1=(OO2)*((U1**2)+(V1**2))
                            !INTERNAL ENERGY 
                            IE1=((P1)/((GAMMA-1.0D0)*R1))
                            !TOTAL ENERGY
                            E1=(P1/(GAMMA-1))+(R1*SKIN1)
                            !VECTOR OF CONSERVED VARIABLES NOW
                            rightv(1)=R1
                            rightv(2)=R1*U1
                            rightv(3)=R1*V1
                            rightv(4)=E1
                            else
    
                            
			     
			      
			      if (pox(1).le.zero)then
                            if (poy(1).le.zero)then
                            r1=0.138
                            u1=1.206
                            v1=1.206
                            p1=0.029
                            end if
                            if (poy(1).gt.zero)then
                            r1=0.5323
                            u1=1.206
                            v1=0.0
                            p1=0.3
                            end if
                            end if
                            if (pox(1).gt.zero)then
                            if (poy(1).le.zero)then
                            r1=0.5323
                            u1=0.0
                            v1=1.206
                            p1=0.3
                            end if
                            if (poy(1).gt.zero)then
                            r1=1.5
                            u1=0.0
                            v1=0.0
                            p1=1.5
                            end if
                            end if
			       SKIN1=(OO2)*((U1**2)+(V1**2))
                            !INTERNAL ENERGY 
                            IE1=((P1)/((GAMMA-1.0D0)*R1))
                            !TOTAL ENERGY
                            E1=(P1/(GAMMA-1))+(R1*SKIN1)
                            !VECTOR OF CONSERVED VARIABLES NOW
                           ! rightv(1)=leftv(1)
                            !rightv(2)=0.0
                            !rightv(3)=0.0
                            !rightv(4)=leftv(4)
                            
                             rightv(1)=R1
                            rightv(2)=R1*U1
                            rightv(3)=R1*V1
                            rightv(4)=E1
			      
			      end if
			      
			      
			      
			      
			      else
			      
			      
			       CALL ROTATEF2d(N,TRI,Cleft_ROT,leftV,ANGLE1,ANGLE2)
			      
                  CRIGHT_ROT(1)=CLEFT_ROT(1)
			      CRIGHT_ROT(2)=-CLEFT_ROT(2)
			      CRIGHT_ROT(3)=CLEFT_ROT(3)
			      CRIGHT_ROT(4)=CLEFT_ROT(4)
			     
					 
				     IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
					    CTURBR(:)=CTURBL(:)

					  if (passivescalar.gt.0)then
					  cturbR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=&
						    ctURBL(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)

					  end if
				      END IF
				
			    	
				
			      CALL ROTATEb2d(N,TRI,rightv,Cright_ROT,ANGLE1,ANGLE2)
                            end if
    
    
    CASE(4)!WALL
    
			     IF (ITESTCASE.EQ.3)THEN
			      
			       CALL ROTATEF2D(N,TRI,Cleft_ROT,leftV,ANGLE1,ANGLE2)
			      
			      
			      IF (governingequations.EQ.-1)then
			          CRIGHT_ROT(:)=CLEFT_ROT(:)
			      CRIGHT_ROT(4)=-CLEFT_ROT(4)
			      
			      
			      else
         		      CRIGHT_ROT(1)=CLEFT_ROT(1)
			      CRIGHT_ROT(2)=-CLEFT_ROT(2)
			      CRIGHT_ROT(3)=CLEFT_ROT(3)
			      CRIGHT_ROT(4)=CLEFT_ROT(4)
			      end if
			     
			      
					 
				     IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
					    CTURBR(:)=CTURBL(:)

					  if (passivescalar.gt.0)then
					  cturbR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=&
						    ctURBL(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)

					  end if
				      END IF
				
				
				
			      CALL ROTATEb2D(N,invTRI,rightv,Cright_ROT,ANGLE1,ANGLE2)
			      
			    
			      
			      ELSE
    
			      rightv(1)=leftv(1)
			      rightv(2)=-leftv(2)
			      rightv(3)=-leftv(3)
			      
			      rightv(4)=leftv(4)
    
    
    
    
				      IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
					IF (TURBULENCEMODEL.NE.2)THEN
					    CTURBR(:)=-CTURBL(:)

					  if (passivescalar.gt.0)then
					  cturbR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=&
						    -ctURBL(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)

					  end if
					ELSE
					     CTURBR(1)=-CTURBL(1)
					     CTURBR(2)=60.0D0*VISC/(BETA_I1*(IELEM(N,ICONSIDERED)%WallDist**2))

					  if (passivescalar.gt.0)then
					  cturbR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=&
						    -ctURBL(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)

					  end if
					  
					
					
					
					
					END IF
				      END IF
    
    
				END IF
    
    
    
    
    
    
    
    
    
    CASE(6)!FARFIELD INFLOW OR OUTFLOW, SUBSONIC OR SUPERSONIC WILL BE CHOSEN BASED ON MACH NUMBER
	 CALL ROTATEF2d(N,TRI,Cleft_ROT,leftV,ANGLE1,ANGLE2)
	    vnb=cleft_rot(2)/CLEFT_ROT(1)
	    
	    
	  
	    
	    CALL cons2prim2d2(N)
    
	    SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
	    SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
	    SPS=SQRT((GAMMA*SUBSON2(4))/(SUBSON2(1)))
	    VEL=sqrt(SUBSON2(2)**2+SUBSON2(3)**2)
	  
	  CALL PRIM2CONS2d2(N)

	  if (vnb.le.0.0d0)then		!inflow
			ibfc=-1
	
		  if ((abs(vnb)).ge.sps)then
				!supersonic
				rightv(1:nof_Variables)=INFLOW2d(INITCOND,POX,POY)
					
		  else
				!subsonic
				
			rightv(1:nof_Variables)=INFLOW2d(INITCOND,POX,POY)
	  	  
			  
			  CALL cons2prim2d2(N)
			
			SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
			SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
			SPS=SQRT((GAMMA*SUBSON2(4))/(SUBSON2(1)))
			VEL=sqrt(SUBSON2(2)**2+SUBSON2(3)**2)
			  CALL PRIM2CONS2d2(N)
				    
		    SUBSON3(4)=0.5d0*((SUBSON1(4))+(SUBSON2(4))-(SUBSON2(1)*SPS*((NX*(SUBSON1(2)-SUBSON2(2)))+(NY*(SUBSON1(3)-SUBSON2(3))))))
		    SUBSON3(1)=SUBSON1(1)+(SUBSON3(4)-SUBSON1(4))/(SPS**2)
		    SUBSON3(2)=SUBSON1(2)-(NX*(SUBSON1(4)-SUBSON3(4)))/(SPS*SUBSON2(1))
		    SUBSON3(3)=SUBSON1(3)-(NY*(SUBSON1(4)-SUBSON3(4)))/(SPS*SUBSON2(1))
		    
		    

		    rightv(1)=SUBSON3(1)
    rightv(2)=SUBSON3(2)*SUBSON3(1)
    rightv(3)=SUBSON3(3)*SUBSON3(1)
    
    SKINS=oo2*((SUBSON3(2)**2)+(SUBSON3(3)**2))
    IKINS=SUBSON3(4)/((GAMMA-1.0d0)*(SUBSON3(1)))
    rightv(4)=(SUBSON3(1)*(IKINS))+(SUBSON3(1)*SKINS)
		  
		  END IF
		  
		  
		  IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
	      
      
      
      
	        IF (TURBULENCEMODEL.EQ.1)THEN
		  CTURBR(1)=VISC*TURBINIT
	      END IF
	     IF (TURBULENCEMODEL.EQ.2)THEN	 
		CTURBR(1)=(1.5D0*I_turb_inlet*(ufreestream**2))*RIGHTV(1)!K INITIALIZATION
		CTURBR(2)=RIGHTV(1)*CTURBR(1)/(10.0e-5*visc)!OMEGA INITIALIZATION
	      END IF
 
	      IF (PASSIVESCALAR.GT.0)THEN
	      CTURBR(TURBULENCEEQUATIONS+1:TURBULENCEEQUATIONS+PASSIVESCALAR)=PASS_INLET2d(INITCOND,POX,POY)*RIGHTV(1)
	      END IF
		    END IF
		  
		  
      
	else
      
	  !outflow
	
	    ibfc=-2
		if ((abs(vnb)).ge.sps)then
		
		      rightv(1:nof_Variables)=leftv(1:nof_Variables)
		
		else
		
		
		rightv(1:nof_Variables)=OUTFLOW2d(INITCOND,pox,poy)
		 CALL cons2prim2d2(N)
    
    SUBSON1(1:nof_Variables)=RIGHTV(1:nof_Variables)
    SUBSON2(1:nof_Variables)=LEFTV(1:nof_Variables)
     
     CALL PRIM2CONS2d2(N)
     
   
    
    
    SUBSON3(4)=SUBSON1(4)
    SUBSON3(1)=SUBSON2(1)+(SUBSON3(4)-SUBSON2(4))/(SPS**2)
    SUBSON3(2)=SUBSON2(2)+(NX*(SUBSON2(4)-SUBSON3(4)))/(SPS*SUBSON2(1))
    SUBSON3(3)=SUBSON2(3)+(NY*(SUBSON2(4)-SUBSON3(4)))/(SPS*SUBSON2(1))
    
! 							
    rightv(1)=SUBSON3(1)
    rightv(2)=SUBSON3(2)*SUBSON3(1)
    rightv(3)=SUBSON3(3)*SUBSON3(1)
    
    SKINS=oo2*((SUBSON3(2)**2)+(SUBSON3(3)**2))
    IKINS=SUBSON3(4)/((GAMMA-1.0d0)*(SUBSON3(1)))
    rightv(4)=(SUBSON3(1)*(IKINS))+(SUBSON3(1)*SKINS)
	
	      
	      
	       IF ((TURBULENCE.EQ.1).OR.(PASSIVESCALAR.GT.0))THEN
	     
		  CTURBR(:)=CTURBL(:)
	
		END IF
	        end if
	      

	END IF

	

    
    

			      


END SELECT



END SUBROUTINE BOUNDARYS2d


SUBROUTINE COMPUTE_EIGENVECTORS(N,RVEIGL,RVEIGR,EIGVL,EIGVR,GAMMA)
!> @brief
!> This subroutine computes the left and right eigenvectors 
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::RVEIGL,RVEIGR
REAL,INTENT(IN)::GAMMA
REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT)::EIGVL,EIGVR
REAL::RS,US,VS,WS,ES,PS,VVS,AS,HS,GAMMAM1,vsd,OOR1,OOR2
INTEGER::IVGT

EIGVR=ZERO
GAMMAM1=GAMMA-1.0D0
OOR1=1.0D0/RVEIGL(1)
OOR2=1.0D0/RVEIGR(1)

RS=OO2*(RVEIGL(1)+RVEIGR(1))
US=OO2*((RVEIGL(2)*OOR1)+(RVEIGR(2)*OOR2))
VS=OO2*((RVEIGL(3)*OOR1)+(RVEIGR(3)*OOR2))
WS=OO2*((RVEIGL(4)*OOR1)+(RVEIGR(4)*OOR2))
ES=OO2*(RVEIGL(5)+RVEIGR(5))
 
VVS=(US**2)+(VS**2)+(WS**2)
VSD=OO2*VVS
PS=(GAMMA-1.0D0)*(ES - OO2*RS*VVS)
AS=SQRT(GAMMA*PS/RS)
HS=(OO2*VVS) + ((AS**2)/GAMMAM1)
EIGVR(1,1)=1.0D0		; EIGVR(1,2)=1.0D0	; EIGVR(1,3)=0.0D0	; EIGVR(1,4)=0.0D0	; EIGVR(1,5)=1.0D0
EIGVR(2,1)=US-AS	; EIGVR(2,2)=US		; EIGVR(2,3)=0.0D0	; EIGVR(2,4)=0.0D0	; EIGVR(2,5)=US+AS
EIGVR(3,1)=VS		; EIGVR(3,2)=VS		; EIGVR(3,3)=1.0D0	; EIGVR(3,4)=0.0D0	; EIGVR(3,5)=VS
EIGVR(4,1)=WS		; EIGVR(4,2)=WS		; EIGVR(4,3)=0.0D0	; EIGVR(4,4)=1.0D0	; EIGVR(4,5)=WS
EIGVR(5,1)=HS-(US*AS)	; EIGVR(5,2)=OO2*VVS	; EIGVR(5,3)=VS		; EIGVR(5,4)=WS		; EIGVR(5,5)=HS+(US*AS)

EIGVL(1,1)=(HS*us + as*us**2 + as*vs**2 - as*VSD - us*VSD + as*ws**2)/ (2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(1,2)=(-HS - as*us + VSD)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(1,3)= -((as*vs)/(2.0D0*as*HS - 2.0D0*as*VSD))
EIGVL(1,4)=  -((as*ws)/(2.0D0*as*HS - 2.0D0*as*VSD))
EIGVL(1,5)=as/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(2,1)=(2.0*as*HS - 2.0*as*us**2 - 2.0D0*as*vs**2 -2.0D0*as*ws**2)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(2,2)=(2.0D0*as*us)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(2,3)=(2.0D0*as*vs)/(2.0D0*as*HS - 2.0D0*as*VSD)
 EIGVL(2,4)=(2.0D0*as*ws)/(2.0D0*as*HS - 2.0D0*as*VSD) 
 EIGVL(2,5)=(-2.0D0*as)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(3,1)=(-2.0*as*HS*vs + 2.0*as*vs*VSD)/(2.0*as*HS - 2.0*as*VSD)
EIGVL(3,2)=0.0D0
EIGVL(3,3)=1.0D0
EIGVL(3,4)=0.0D0
 EIGVL(3,5)=0.0D0
EIGVL(4,1)=(-2.0D0*as*HS*ws + 2.0D0*as*VSD*ws)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(4,2)=0.0D0
 EIGVL(4,3)=0.0D0
EIGVL(4,4)=1.0D0
EIGVL(4,5)=0.0D0
EIGVL(5,1)=(-(HS*us) + as*us**2 + as*vs**2 - as*VSD + us*VSD + as*ws**2)/ (2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(5,2)=(HS - as*us - VSD)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(5,3)=-((as*vs)/(2.0D0*as*HS - 2.0D0*as*VSD))
 EIGVL(5,4)=-((as*ws)/(2.0D0*as*HS - 2.0D0*as*VSD))
EIGVL(5,5)= as/(2.0D0*as*HS - 2.0D0*as*VSD)
 
 

END SUBROUTINE COMPUTE_EIGENVECTORS




SUBROUTINE COMPUTE_EIGENVECTORS1(N,RVEIGL,EIGVR,GAMMA,eigvl)
!> @brief
!> This subroutine computes the left and right eigenvectors 
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::RVEIGL
REAL,INTENT(IN)::GAMMA
REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT)::EIGVR,eigvl
REAL::RS,US,VS,WS,ES,PS,VVS,AS,HS,GAMMAM1,vsd,OORS
INTEGER::IVGT

EIGVR=ZERO
GAMMAM1=GAMMA-1.0D0
OORS=1.0D0/RVEIGl(1)
RS=(RVEIGL(1))
US=((RVEIGl(2)*OORS))
VS=((RVEIGl(3)*OORS))
WS=((RVEIGl(4)*OORS))
ES=(RVEIGL(5))
 
VVS=(US**2)+(VS**2)+(WS**2)
VSD=OO2*VVS
PS=(GAMMA-1.0D0)*(ES - OO2*RS*VVS)
AS=SQRT(GAMMA*PS*OORS)
HS=(OO2*VVS) + ((AS**2)/GAMMAM1)
EIGVR(1,1)=1.0D0	; EIGVR(1,2)=1.0D0	; EIGVR(1,3)=0.0D0	; EIGVR(1,4)=0.0D0	; EIGVR(1,5)=1.0D0
EIGVR(2,1)=US-AS	; EIGVR(2,2)=US		; EIGVR(2,3)=0.0D0	; EIGVR(2,4)=0.0D0	; EIGVR(2,5)=US+AS
EIGVR(3,1)=VS		; EIGVR(3,2)=VS		; EIGVR(3,3)=1.0D0	; EIGVR(3,4)=0.0D0	; EIGVR(3,5)=VS
EIGVR(4,1)=WS		; EIGVR(4,2)=WS		; EIGVR(4,3)=0.0D0	; EIGVR(4,4)=1.0D0	; EIGVR(4,5)=WS
EIGVR(5,1)=HS-(US*AS)	; EIGVR(5,2)=OO2*VVS	; EIGVR(5,3)=VS		; EIGVR(5,4)=WS		; EIGVR(5,5)=HS+(US*AS)

EIGVL(1,1)=(HS*us + as*us**2 + as*vs**2 - as*VSD - us*VSD + as*ws**2)/ (2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(1,2)=(-HS - as*us + VSD)/(2.0*as*HS - 2.0*as*VSD)
EIGVL(1,3)= -((as*vs)/(2.0D0*as*HS - 2.0D0*as*VSD))
EIGVL(1,4)=  -((as*ws)/(2.0D0*as*HS - 2.0D0*as*VSD))
EIGVL(1,5)=as/(2.0D0*as*HS - 2.0*as*VSD)
EIGVL(2,1)=(2.0D0*as*HS - 2.0D0*as*us**2 - 2.0D0*as*vs**2 -2.0D0*as*ws**2)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(2,2)=(2.0D0*as*us)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(2,3)=(2.0D0*as*vs)/(2.0D0*as*HS - 2.0D0*as*VSD)
 EIGVL(2,4)=(2.0D0*as*ws)/(2.0D0*as*HS - 2.0D0*as*VSD) 
 EIGVL(2,5)=(-2.0D0*as)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(3,1)=(-2.0D0*as*HS*vs + 2.0D0*as*vs*VSD)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(3,2)=0.0D0
EIGVL(3,3)=1.0D0
EIGVL(3,4)=0.0D0
 EIGVL(3,5)=0.0D0
EIGVL(4,1)=(-2.0D0*as*HS*ws + 2.0D0*as*VSD*ws)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(4,2)=0.0D0
 EIGVL(4,3)=0.0D0
EIGVL(4,4)=1.0D0
EIGVL(4,5)=0.0D0
EIGVL(5,1)=(-(HS*us) + as*us**2 + as*vs**2 - as*VSD + us*VSD + as*ws**2)/ (2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(5,2)=(HS - as*us - VSD)/(2.0D0*as*HS - 2.0D0*as*VSD)
EIGVL(5,3)=-((as*vs)/(2.0D0*as*HS - 2.0D0*as*VSD))
 EIGVL(5,4)=-((as*ws)/(2.0D0*as*HS - 2.0D0*as*VSD))
EIGVL(5,5)= as/(2.0D0*as*HS - 2.0D0*as*VSD)
 
 

END SUBROUTINE COMPUTE_EIGENVECTORS1



SUBROUTINE COMPUTE_JACOBIANSE(N,EIGVL,RVEIGL,GAMMA,ANGLE1,ANGLE2)
!> @brief
!> This subroutine computes the Jacobians for the implicit time stepping
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,INTENT(IN)::ANGLE1,ANGLE2
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::RVEIGL
REAL,INTENT(IN)::GAMMA
REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT)::EIGVL
REAL::RS,US,VS,WS,ES,PS,VVS,AS,HS,GAMMAM1,vsd,PHI,A1,A2,A3,OORS
INTEGER::IVGT


A2=GAMMA-1.0D0
A3=GAMMA-2.0D0
OORS=1.0D0/RVEIGL(1)
RS=(RVEIGL(1))
US=(RVEIGL(2)*OORS)
VS=(RVEIGL(3)*OORS)
WS=(RVEIGL(4)*OORS)
ES=(RVEIGL(5)*OORS)
PHI=OO2*(A2)*((US*US)+(VS*VS)+(WS*WS))
 A1=GAMMA*ES-PHI

 
 
VVS=NX*US+NY*VS+NZ*WS


EIGVL(1,1)=0.0D0		; 		EIGVL(1,2)=NX	; 		EIGVL(1,3)=NY	; 		EIGVL(1,4)=NZ	; 		EIGVL(1,5)=0.0D0
EIGVL(2,1)=NX*PHI-US*VVS	; 	EIGVL(2,2)=VVS-A3*NX*US	; 	EIGVL(2,3)=NY*US-A2*NX*VS	; EIGVL(2,4)=NZ*US-A2*NX*WS	; EIGVL(2,5)=A2*NX
EIGVL(3,1)=NY*PHI-VS*VVS		; EIGVL(3,2)=NX*VS-A2*NY*US	; EIGVL(3,3)=VVS-A3*NY*VS	; EIGVL(3,4)=NZ*VS-A2*NY*WS	; EIGVL(3,5)=A2*NY
EIGVL(4,1)=NZ*PHI-WS*VVS		; EIGVL(4,2)=NX*WS-A2*NZ*US	; EIGVL(4,3)=NY*WS-A2*NZ*VS	; EIGVL(4,4)=VVS-A3*NZ*WS	; EIGVL(4,5)=A2*NZ
EIGVL(5,1)=VVS*(PHI-A1)	;		 EIGVL(5,2)=NX*A1-A2*US*VVS	; EIGVL(5,3)=NY*A1-A3*VS*VVS	; EIGVL(5,4)=NZ*A1-A2*WS*VVS	; EIGVL(5,5)=GAMMA*VVS


 
 

END SUBROUTINE COMPUTE_JACOBIANSE

SUBROUTINE COMPUTE_JACOBIANSn(N,EIGVL,RVEIGL,GAMMA,ANGLE1,ANGLE2,ICONSIDERED,viscots)
!> @brief
!> This subroutine computes the Jacobians for the implicit time stepping
IMPLICIT NONE
INTEGER,INTENT(IN)::N,iconSIDERED
REAL,INTENT(IN)::ANGLE1,ANGLE2,viscots
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::RVEIGL
REAL,INTENT(IN)::GAMMA
REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT)::EIGVL
REAL::RS,US,VS,WS,ES,PS,VVS,AS,HS,GAMMAM1,vsd,PHI,A1,A2,A3,ts
REAL::THI,THIX,THIY,THIZ,NNX,NNY,NNZ,PHIR,PHIP,PIX,PIY,PIZ,DXX,oors
INTEGER::IVGT
DXX=IELEM(N,ICONSIDERED)%MINEDGE

A2=GAMMA-1.0D0
A3=GAMMA-2.0D0
OORS=1.0D0/RVEIGL(1)
RS=(RVEIGL(1))
US=(RVEIGL(2)*OORS)
VS=(RVEIGL(3)*OORS)
WS=(RVEIGL(4)*OORS)
ES=(RVEIGL(5)*OORS)
ps=(((GAMMA-1))*((rs*Es)-(OO2*rs*((Us**2)+(Vs**2)+(Ws**2)))))

 
VVS=NX*US+NY*VS+NZ*WS


EIGVL(1,1)=0.0D0		; EIGVL(1,2)=0.0D0	; 		EIGVL(1,3)=0.0D0	; 			EIGVL(1,4)=0.0D0	; 			EIGVL(1,5)=0.0D0
EIGVL(2,1)=0.0D0	; 	EIGVL(2,2)=(1.0D0/3.0D0)*nx*nx+1.0D0	; 	EIGVL(2,3)=(1.0D0/3.0D0)*nx*ny	; 	EIGVL(2,4)=(1.0D0/3.0D0)*nx*nz	; EIGVL(2,5)=0.0D0
EIGVL(3,1)=0.0D0		; EIGVL(3,2)=(1.0D0/3.0D0)*nx*ny	; EIGVL(3,3)=(1.0D0/3.0D0)*ny*ny+1.0D0	; EIGVL(3,4)=(1.0D0/3.0D0)*ny*nz	; EIGVL(3,5)=0.0D0
EIGVL(4,1)=0.0D0		; EIGVL(4,2)=(1.0D0/3.0D0)*nx*nz	; 	EIGVL(4,3)=(1.0D0/3.0D0)*ny*nz	; 	EIGVL(4,4)=(1.0D0/3.0D0)*nz*nz+1.0D0; 	EIGVL(4,5)=0.0D0
EIGVL(5,1)=-ps/((rs**2)*(1.0D0-(1.0D0/gamma))*prandtl*(viscots)); EIGVL(5,2)=(1.0/3.0)*nx*vvs+us	; EIGVL(5,3)=(1.0D0/3.0D0)*ny*vvs+us	; EIGVL(5,4)=(1.0D0/3.0D0)*nz*vvs+ws; EIGVL(5,5)=1.0D0/((rs)*(1.0D0-(1.0D0/gamma))*prandtl*(viscots))

eigvl=(viscots/(abs(nx+ny+nz)*DXX))*eigvl
 
 

END SUBROUTINE COMPUTE_JACOBIANSn


SUBROUTINE COMPUTE_EIGENVECTORS2D(N,RVEIGL,RVEIGR,EIGVL,EIGVR,GAMMA)
!> @brief
!> This subroutine computes the left and right eigenvectors  in 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::RVEIGL,RVEIGR
REAL,INTENT(IN)::GAMMA
REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT)::EIGVL,EIGVR
REAL::RS,US,VS,WS,ES,PS,VVS,AS,HS,GAMMAM1,vsd,G8,s1,s2,vtots,OOR1,OOR2
INTEGER::IVGT,J,K

EIGVR=ZERO
GAMMAM1=GAMMA-1.0D0
OOR1=1.0D0/RVEIGL(1)
OOR2=1.0D0/RVEIGR(1)


EIGVR=0.0D0
GAMMAM1=GAMMA-1.0D0
RS=0.5*(RVEIGL(1)+RVEIGR(1))
US=0.5*((RVEIGL(2)*OOR1)+(RVEIGR(2)*OOR2))
VS=0.5*((RVEIGL(3)*OOR1)+(RVEIGR(3)*OOR2))
ES=0.5*(RVEIGL(4)+RVEIGR(4))
G8 = gamma - 1.0D0
 
VTOTS = US**2 + VS**2
   PS = (GAMMA-1)*(ES - OO2*RS*VTOTS)
   AS = SQRT(GAMMA*PS/RS)
   HS = OO2*VTOTS + (AS**2)/(G8)
  

   EIGVR(1,1) =1.D0;        EIGVR(1,2) = 1.D0;                EIGVR(1,3) =0.D0;  EIGVR(1,4) = 1.D0  
   EIGVR(2,1) =Us-As;     EIGVR(2,2) = Us;                EIGVR(2,3) =0.D0;  EIGVR(2,4) = Us+As 
   EIGVR(3,1) =Vs;        EIGVR(3,2) = Vs;                EIGVR(3,3) =1.D0;  EIGVR(3,4) = Vs   
   EIGVR(4,1) =Hs-Us*As;  EIGVR(4,2) = OO2*VTOTS; EIGVR(4,3) =Vs ; EIGVR(4,4) = Hs+Us*As 

   S1 = AS/(Gamma-1D0)
   S2 = AS**2/(Gamma-1D0)

   EIGVl(1,1) =   HS + S1*(US-AS);   EIGVl(1,2) = -(US+S1); EIGVl(1,3) = -VS;            EIGVl(1,4) = 1.D0
   EIGVl(2,1) =-2D0*HS+4D0*S2;           EIGVl(2,2) = 2D0*US;     EIGVl(2,3) = 2D0*VS;           EIGVl(2,4) = -2.D0
   EIGVl(3,1) =-2D0*VS*S2;             EIGVl(3,2) =   0.D0;     EIGVl(3,3) = 2D0*S2;           EIGVl(3,4) = 0.D0
   EIGVl(4,1) = HS- S1*(US+AS);      EIGVl(4,2) = -US+S1;   EIGVl(4,3) = - VS;           EIGVl(4,4) = 1.D0 

DO J=1,4
	DO K=1,4

   EIGVl(J,K) = EIGVl(J,K)/(2D0*S2)
	END DO
END DO
 
 

END SUBROUTINE COMPUTE_EIGENVECTORS2D


 subroutine COMPUTE_JACOBIANSE2D(N,EIGVL,rveigl,GAMMA,ANGLE1,ANGLE2)
 !> @brief
!> This subroutine computes the Jacobians for the implicit time stepping in 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::N
REAL,INTENT(IN)::ANGLE1,ANGLE2
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::RVEIGL
REAL,INTENT(IN)::GAMMA
REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT)::EIGVL
REAL::RS,US,VS,ES,PS,VVS,AS,HS,GAMMAM1,vsd,PHI,A1,A2,A3,OORS
INTEGER::IVGT


A2=GAMMA-1.0D0
A3=GAMMA-2.0D0
OORS=1.0D0/RVEIGL(1)
RS=(RVEIGL(1))
US=(RVEIGL(2)*OORS)
VS=(RVEIGL(3)*OORS)
ES=(RVEIGL(4)*OORS)
PHI=OO2*(A2)*((US*US)+(VS*VS))
 A1=GAMMA*ES-PHI

 
VVS=NX*US+NY*VS


EIGVL(1,1)=0.0D0		; 		EIGVL(1,2)=NX	; 		EIGVL(1,3)=NY	; 		EIGVL(1,4)=0.0D0
EIGVL(2,1)=NX*PHI-US*VVS	; 	EIGVL(2,2)=VVS-A3*NX*US	; 	EIGVL(2,3)=NY*US-A2*NX*VS	; EIGVL(2,4)=A2*NX
EIGVL(3,1)=NY*PHI-VS*VVS		; EIGVL(3,2)=NX*VS-A2*NY*US	; EIGVL(3,3)=VVS-A3*NY*VS	; EIGVL(3,4)=A2*NY

EIGVL(4,1)=VVS*(PHI-A1)	;		 EIGVL(4,2)=NX*A1-A2*US*VVS	; EIGVL(4,3)=NY*A1-A2*VS*VVS	; EIGVL(4,4)=GAMMA*VVS


 
 

END SUBROUTINE COMPUTE_JACOBIANSE2D




 subroutine COMPUTE_JACOBIANSn2D(N,EIGVL,rveigl,GAMMA,ANGLE1,ANGLE2,iconSIDERED,viscots)
 !> @brief
!> This subroutine computes the Jacobians for the implicit time stepping in 2D
IMPLICIT NONE
INTEGER,INTENT(IN)::N,iconSIDERED
REAL,INTENT(IN)::ANGLE1,ANGLE2,viscots
REAL,ALLOCATABLE,DIMENSION(:),INTENT(IN)::RVEIGL
REAL,INTENT(IN)::GAMMA
REAL,ALLOCATABLE,DIMENSION(:,:),INTENT(INOUT)::EIGVL
REAL::RS,US,VS,WS,ES,PS,VVS,AS,HS,GAMMAM1,vsd,PHI,A1,A2,A3,ts
REAL::THI,THIX,THIY,THIZ,NNX,NNY,NNZ,PHIR,PHIP,PIX,PIY,PIZ,DXX,OORS
INTEGER::IVGT


DXX=IELEM(N,iconSIDERED)%MINEDGE
NX=angle1
NY=angle2
A2=GAMMA-1.0
A3=GAMMA-2.0
OORS=1.0D0/RVEIGL(1)
RS=(RVEIGL(1))
US=(RVEIGL(2)*OORS)
VS=(RVEIGL(3)*OORS)
ES=(RVEIGL(4)*OORS)
ps=(((GAMMA-1))*((rs*Es)-(OO2*rs*((Us**2)+(Vs**2)))))

 
VVS=NX*US+NY*VS+NZ*WS


EIGVL(1,1)=0.0D0	; 							EIGVL(1,2)=0.0D0	; 	  		EIGVL(1,3)=0.0D0	; 		    EIGVL(1,4)=0.0D0	; 		
EIGVL(2,1)=0.0D0	; 							EIGVL(2,2)=(1.0D0/3.0D0)*nx*nx+1.0D0; 	EIGVL(2,3)=(1.0D0/3.0D0)*nx*ny	; 	     EIGVL(2,4)=0.0D0	;	 
EIGVL(3,1)=0.0D0	; 							EIGVL(3,2)=(1.0D0/3.0D0)*nx*ny	; 	EIGVL(3,3)=(1.0D0/3.0D0)*ny*ny+1.0D0	;    EIGVL(3,4)=0.0D0	; 	
EIGVL(4,1)=-(ps*(gamma/(gamma-1.0D0)))/((rs**2)*prandtl*(viscots)); 	EIGVL(4,2)=(1.0/3.0)*nx*vvs+us; 	EIGVL(4,3)=(1.0D0/3.0D0)*ny*vvs+vs; EIGVL(4,4)=(ps*(gamma/(gamma-1.0D0)))/((rs)*prandtl*(viscots))

eigvl=(viscots/(abs(nx+ny)*DXX))*eigvl


 
 

END SUBROUTINE COMPUTE_JACOBIANSn2D



SUBROUTINE EDDYVISCO(N,VISCL,LAML,TURBMV,ETVM,EDDYFL,EDDYFR)
!> @brief
!> This subroutine computes the tubulent eddy viscosity for turbulence models
	IMPLICIT NONE
    REAL,ALLOCATABLE,DIMENSION(:),INTENT(INOUT)::VISCL,LAML,TURBMV,ETVM,EDDYFL,EDDYFR
	INTEGER,INTENT(IN)::N
	REAL::ML,SMMM,MTT,chi,tolepsma,chipow3,fv1
	INTEGER:: IHGT, IHGJ
	REAL,DIMENSION(3,3)::VORTET,TVORT,SVORT
	REAL:: ux,uy,uz,vx,vy,vz,wx,wy,wz
	REAL:: wally, D_omplus, phi_2, phi_1, F_1, F_2, k_0, om_0,alpha_inf, alpha_star, Mu_turb
	REAL:: sigma_k_L, sigma_om_L, sigma_k_r, sigma_om_r
	REAL::SNORM,dervk_dervom,Re_t_SST,RHO_0,beta_i




	tolepsma = TOLSMALL
	
	IF (TURBULENCE.EQ.0)THEN
	VISCL(4)=ZERO;VISCL(3)=ZERO
	LAML(4)=ZERO;LAML(3)=ZERO
	ELSE
	
	
	
!Modified on 19/6/2013
  SELECT CASE(TURBULENCEMODEL)
  
   CASE(1)
	  TURBMV(1)=EDDYFL(2)
	  TURBMV(2)=EDDYFR(2)  
         chi     = abs ( max(TURBMV(1),tolepsma) / max(VISCL(1),tolepsma))
         chipow3 = chi * chi * chi
         fv1 = chipow3 / (chipow3 + (cv1*cv1*cv1))
	VISCL(3) = TURBMV(1)*fv1
	chi     = abs ( max(TURBMV(2),tolepsma) / max(VISCL(2),tolepsma))
         chipow3 = chi * chi * chi
         fv1 = chipow3 / (chipow3 + (cv1*cv1*cv1))
		VISCL(4) = TURBMV(2)*fv1


  CASE(2)

  
  !FOR LEFT CELL
  
 VORTET(1,1:3) = EDDYFL(4:6)
 VORTET(2,1:3) = EDDYFL(7:9) 
 VORTET(3,1:3) = EDDYFL(10:12)

  ux = Vortet(1,1);uy = Vortet(1,2);uz = Vortet(1,3)
  vx = Vortet(2,1);vy = Vortet(2,2);vz = Vortet(2,3)
  wx = Vortet(3,1);wy = Vortet(3,2);wz = Vortet(3,3)

  DO IHGT=1,3
  DO IHGJ=1,3
  TVORT(IHGT,IHGJ)=VORTET(IHGJ,IHGT)
  END DO
  END DO

sVORT=0.5*(VORTET+TVORT)
SNORM=SQRT(2.0*((SVORT(1,1)*SVORT(1,1))+(SVORT(1,2)*SVORT(1,2))+(SVORT(1,3)*SVORT(1,3))+&
	       (SVORT(2,1)*SVORT(2,1))+(SVORT(2,2)*SVORT(2,2))+(SVORT(2,3)*SVORT(2,3))+& 
	       (SVORT(3,1)*SVORT(3,1))+(SVORT(3,2)*SVORT(3,2))+(SVORT(3,3)*SVORT(3,3))))
		   
 wally=EDDYFL(1)
 rho_0=LEFTV(1)
 k_0=MAX(tolepsma,EDDYFL(2)/LEFTV(1))
 om_0=max(EDDYFL(3)/LEFTV(1),ufreestream/charlength/10.0)


 dervk_dervom=(EDDYFL(13)*EDDYFL(16))+(EDDYFL(14)*EDDYFL(17))+(EDDYFL(15)*EDDYFL(18))
		   
D_omplus=max(2*rho_0/sigma_om2/om_0*dervk_dervom, 1.0e-10)    
 phi_2=max(sqrt(k_0)/(0.09*om_0*wally),500.0*VISCL(1)/(rho_0*wally*wally*om_0))
 phi_1=min(phi_2, 4.0*rho_0*k_0/(sigma_om2*D_omplus*wally*wally)) 

F_1=tanh(phi_1**4)
F_2=tanh(phi_2**2)
RE_T_SST=RHO_0*K_0/(VISCL(1)*OM_0)
beta_i=F_1*beta_i1+(1.0-F_1)*beta_i2
alpha_star0=beta_i/3.0    
alpha_inf=F_1*alpha_inf1+(1.0-F_1)*alpha_inf2
alpha_star=alpha_starinf*(alpha_star0+Re_t_SST/R_k_SST)/(1.0+Re_t_SST/R_k_SST)


VISCL(3)=rho_0*k_0/om_0/max(1.0/alpha_star,SNORM*F_2/(aa_1*om_0))


!Added 20/6/2013
sigma_k_l=sigma_k1/F_1+sigma_k2/F_2
sigma_om_l=sigma_om1/F_1+sigma_om2/F_2



  IF (EDDYFR(1).GT.0.0)THEN
!FOR RIGHT
 VORTET(1,1:3) = EDDYFR(4:6)
 VORTET(2,1:3) = EDDYFR(7:9) 
 VORTET(3,1:3) = EDDYFR(10:12)

  ux = Vortet(1,1);uy = Vortet(1,2);uz = Vortet(1,3)
  vx = Vortet(2,1);vy = Vortet(2,2);vz = Vortet(2,3)
  wx = Vortet(3,1);wy = Vortet(3,2);wz = Vortet(3,3)

  DO IHGT=1,3
  DO IHGJ=1,3
  TVORT(IHGT,IHGJ)=VORTET(IHGJ,IHGT)
  END DO
  END DO

sVORT=0.5*(VORTET+TVORT)
SNORM=SQRT(2.0*((SVORT(1,1)*SVORT(1,1))+(SVORT(1,2)*SVORT(1,2))+(SVORT(1,3)*SVORT(1,3))+&
	       (SVORT(2,1)*SVORT(2,1))+(SVORT(2,2)*SVORT(2,2))+(SVORT(2,3)*SVORT(2,3))+& 
	       (SVORT(3,1)*SVORT(3,1))+(SVORT(3,2)*SVORT(3,2))+(SVORT(3,3)*SVORT(3,3))))
		   
 wally=EDDYFR(1)
 rho_0=RIGHTV(1)
 k_0=EDDYFR(2)/RIGHTV(1)
 om_0=max(EDDYFR(3)/RIGHTV(1),1.0e-6)

 ! EDDYFL(13:15)=ILOCAL_RECON3(K)%GRADS(4,1:3)
!EDDYFL(16:18)=ILOCAL_RECON3(K)%GRADS(5,1:3)

 dervk_dervom=(EDDYFR(13)*EDDYFR(16))+(EDDYFR(14)*EDDYFR(17))+(EDDYFR(15)*EDDYFR(18))
		   
D_omplus=max(2*rho_0/sigma_om2/om_0*dervk_dervom, 1.0e-10)    !I need derivative of k
 phi_2=max(sqrt(k_0)/(0.09*om_0*wally),500.0*VISCL(2)/(rho_0*wally*wally*om_0))
 phi_1=min(phi_2, 4.0*rho_0*k_0/(sigma_om2*D_omplus*wally*wally)) 

F_1=tanh(phi_1**4)
F_2=tanh(phi_2**2)
RE_T_SST=RHO_0*K_0/(VISCL(2)*OM_0)
beta_i=F_1*beta_i1+(1.0-F_1)*beta_i2
alpha_star0=beta_i/3.0    
alpha_inf=F_1*alpha_inf1+(1.0-F_1)*alpha_inf2
alpha_star=alpha_starinf*(alpha_star0+Re_t_SST/R_k_SST)/(1.0+Re_t_SST/R_k_SST)


VISCL(4)=rho_0*k_0/om_0/max(1.0/alpha_star,SNORM*F_2/(aa_1*om_0))

!Added 20/6/2013
sigma_k_r=sigma_k1/F_1+sigma_k2/F_2
sigma_om_r=sigma_om1/F_1+sigma_om2/F_2


ELSE
VISCL(4)=-VISCL(3)
SIGMA_K_R=SIGMA_K_L
SIGMA_OM_R=SIGMA_OM_L



END IF


END SELECT
		  
		  
    
		  Viscl(3) = MIN(10000000*visc,VISCL(3))  
		  Viscl(4) = MIN(10000000*visc,VISCL(4))		  
  

	 LAML(3)=( VISCL(3)*GAMMA/(PRTU*(GAMMA-1)) ) + ( VISCL(1)*GAMMA/(PRANDTL*(GAMMA-1)) )
	 LAML(4)=( VISCL(4)*GAMMA/(PRTU*(GAMMA-1)) ) + ( VISCL(2)*GAMMA/(PRANDTL*(GAMMA-1)) )
	 VISCL(3)=MAX(0.0D0,VISCL(3))
	 VISCL(4)=MAX(0.0D0,VISCL(4))
	 
	 IF ((TURBMV(1).LT.ZERO).OR.(TURBMV(2).LT.ZERO))THEN
	 VISCL(3)=0.0D0
	 VISCL(4)=0.0D0
	 END IF
	 
	 ETVM(1) = ( 0.5*(VISCL(1)+VISCL(2)) ) +  ( 0.5*(VISCL(3)+VISCL(4)) )




	  
!Added on 20/6/2013---------------------------------------------------------------
!After limiting these variables, we compute the diffusion for the turbulent variables
if (TURBULENCEMODEL .eq. 2) then
!--------EDDYFL/R(19)=GAMMA_k_L/R
!--------EDDYFL/R(20)=GAMMA_om_L/R  

EDDYFL(19)=VISCL(1)+VISCL(3)/sigma_k_l
EDDYFR(19)=VISCL(2)+VISCL(4)/sigma_k_r

EDDYFL(20)=VISCL(1)+VISCL(3)/sigma_om_l
EDDYFR(20)=VISCL(2)+VISCL(4)/sigma_om_r
end if
END IF




  END SUBROUTINE EDDYVISCO






SUBROUTINE EDDYVISCO2d(N,VISCL,LAML,TURBMV,ETVM,EDDYFL,EDDYFR)
!> @brief
!> This subroutine computes the tubulent eddy viscosity for turbulence models in 2d
	IMPLICIT NONE
    REAL,ALLOCATABLE,DIMENSION(:),INTENT(INOUT)::VISCL,LAML,TURBMV,ETVM,EDDYFL,EDDYFR
	INTEGER,INTENT(IN)::N
	REAL::ML,SMMM,MTT,chi,tolepsma,chipow3,fv1
	INTEGER:: IHGT, IHGJ
	REAL,DIMENSION(2,2)::VORTET,TVORT,SVORT
	REAL:: ux,uy,uz,vx,vy,vz,wx,wy,wz
	REAL:: wally, D_omplus, phi_2, phi_1, F_1, F_2, k_0, om_0,alpha_inf, alpha_star, Mu_turb
	REAL:: sigma_k_L, sigma_om_L, sigma_k_r, sigma_om_r
	REAL::SNORM,dervk_dervom,Re_t_SST,RHO_0,beta_i




	tolepsma = TOLSMALL
	
	IF (TURBULENCE.EQ.0)THEN
	VISCL(4)=ZERO;VISCL(3)=ZERO
	LAML(4)=ZERO;LAML(3)=ZERO
	ELSE
	
	
	
!Modified on 19/6/2013
  SELECT CASE(TURBULENCEMODEL)
  
   CASE(1)
            if (ispal.eq.2)then
	  TURBMV(1)=EDDYFL(2)
	  TURBMV(2)=EDDYFR(2)  
	  
	  chi     = abs ((TURBMV(1)) / (VISCL(1)))
         !chi     = abs ( max(TURBMV(1),tolepsma) / max(VISCL(1),tolepsma))
         chipow3 = chi * chi * chi
         fv1 = chipow3 / (chipow3 + (cv1*cv1*cv1))
	VISCL(3) = TURBMV(1)*fv1
	 chi     = abs ((TURBMV(2)) / (VISCL(2)))
! 	chi     = abs ( max(TURBMV(2),tolepsma) / max(VISCL(2),tolepsma))
         chipow3 = chi * chi * chi
         fv1 = chipow3 / (chipow3 + (cv1*cv1*cv1))
		VISCL(4) = TURBMV(2)*fv1
        else
        TURBMV(1)=EDDYFL(2)
	  TURBMV(2)=EDDYFR(2)  
	  
	 
         chi     = abs ( max(TURBMV(1),tolepsma) / max(VISCL(1),tolepsma))
         chipow3 = chi * chi * chi
         fv1 = chipow3 / (chipow3 + (cv1*cv1*cv1))
	VISCL(3) = TURBMV(1)*fv1
! 	 chi     = abs ((TURBMV(2)) / (VISCL(2)))
 	chi     = abs ( max(TURBMV(2),tolepsma) / max(VISCL(2),tolepsma))
         chipow3 = chi * chi * chi
         fv1 = chipow3 / (chipow3 + (cv1*cv1*cv1))
		VISCL(4) = TURBMV(2)*fv1
        
        
        end if

  CASE(2)

  
  !FOR LEFT CELL
  
 VORTET(1,1:2) = EDDYFL(4:5)
 VORTET(2,1:2) = EDDYFL(6:7) 
 

  ux = Vortet(1,1);uy = Vortet(1,2)
  vx = Vortet(2,1);vy = Vortet(2,2)
 

  DO IHGT=1,2
  DO IHGJ=1,2
  TVORT(IHGT,IHGJ)=VORTET(IHGJ,IHGT)
  END DO
  END DO

sVORT=0.5*(VORTET+TVORT)
SNORM=SQRT(2.0*((SVORT(1,1)*SVORT(1,1))+(SVORT(1,2)*SVORT(1,2))+&
	       (SVORT(2,1)*SVORT(2,1))+(SVORT(2,2)*SVORT(2,2))))
		   
 wally=EDDYFL(1)
 rho_0=LEFTV(1)
 k_0=MAX(tolepsma,EDDYFL(2)/LEFTV(1))
 om_0=max(EDDYFL(3)/LEFTV(1),ufreestream/charlength/10.0)


 dervk_dervom=(EDDYFL(8)*EDDYFL(10))+(EDDYFL(9)*EDDYFL(11))
		   
D_omplus=max(2*rho_0/sigma_om2/om_0*dervk_dervom, 1.0e-10)    
 phi_2=max(sqrt(k_0)/(0.09*om_0*wally),500.0*VISCL(1)/(rho_0*wally*wally*om_0))
 phi_1=min(phi_2, 4.0*rho_0*k_0/(sigma_om2*D_omplus*wally*wally)) 

F_1=tanh(phi_1**4)
F_2=tanh(phi_2**2)
RE_T_SST=RHO_0*K_0/(VISCL(1)*OM_0)
beta_i=F_1*beta_i1+(1.0-F_1)*beta_i2
alpha_star0=beta_i/3.0    
alpha_inf=F_1*alpha_inf1+(1.0-F_1)*alpha_inf2
alpha_star=alpha_starinf*(alpha_star0+Re_t_SST/R_k_SST)/(1.0+Re_t_SST/R_k_SST)


VISCL(3)=rho_0*k_0/om_0/max(1.0/alpha_star,SNORM*F_2/(aa_1*om_0))


!Added 20/6/2013
sigma_k_l=sigma_k1/F_1+sigma_k2/F_2
sigma_om_l=sigma_om1/F_1+sigma_om2/F_2



  IF (EDDYFR(1).GT.0.0)THEN
VORTET(1,1:2) = EDDYFL(4:5)
 VORTET(2,1:2) = EDDYFL(6:7) 
 

  ux = Vortet(1,1);uy = Vortet(1,2)
  vx = Vortet(2,1);vy = Vortet(2,2)
 

  DO IHGT=1,2
  DO IHGJ=1,2
  TVORT(IHGT,IHGJ)=VORTET(IHGJ,IHGT)
  END DO
  END DO

sVORT=0.5*(VORTET+TVORT)
SNORM=SQRT(2.0*((SVORT(1,1)*SVORT(1,1))+(SVORT(1,2)*SVORT(1,2))+&
	       (SVORT(2,1)*SVORT(2,1))+(SVORT(2,2)*SVORT(2,2))))
		   
 wally=EDDYFR(1)
 rho_0=RIGHTV(1)
 k_0=EDDYFR(2)/RIGHTV(1)
 om_0=max(EDDYFR(3)/RIGHTV(1),1.0e-6)

 ! EDDYFL(13:15)=ILOCAL_RECON3(K)%GRADS(4,1:3)
!EDDYFL(16:18)=ILOCAL_RECON3(K)%GRADS(5,1:3)

 dervk_dervom=(EDDYFL(8)*EDDYFL(10))+(EDDYFL(9)*EDDYFL(11))
		   
D_omplus=max(2*rho_0/sigma_om2/om_0*dervk_dervom, 1.0e-10)    !I need derivative of k
 phi_2=max(sqrt(k_0)/(0.09*om_0*wally),500.0*VISCL(2)/(rho_0*wally*wally*om_0))
 phi_1=min(phi_2, 4.0*rho_0*k_0/(sigma_om2*D_omplus*wally*wally)) 

F_1=tanh(phi_1**4)
F_2=tanh(phi_2**2)
RE_T_SST=RHO_0*K_0/(VISCL(2)*OM_0)
beta_i=F_1*beta_i1+(1.0-F_1)*beta_i2
alpha_star0=beta_i/3.0    
alpha_inf=F_1*alpha_inf1+(1.0-F_1)*alpha_inf2
alpha_star=alpha_starinf*(alpha_star0+Re_t_SST/R_k_SST)/(1.0+Re_t_SST/R_k_SST)


VISCL(4)=rho_0*k_0/om_0/max(1.0/alpha_star,SNORM*F_2/(aa_1*om_0))

!Added 20/6/2013
sigma_k_r=sigma_k1/F_1+sigma_k2/F_2
sigma_om_r=sigma_om1/F_1+sigma_om2/F_2


ELSE
VISCL(4)=-VISCL(3)
SIGMA_K_R=SIGMA_K_L
SIGMA_OM_R=SIGMA_OM_L



END IF


END SELECT
		  
		  
    
		  Viscl(3) = MIN(10000000*visc,VISCL(3))  
		  Viscl(4) = MIN(10000000*visc,VISCL(4))		  
  

	 LAML(3)=( VISCL(3)*GAMMA/(PRTU*(GAMMA-1)) ) + ( VISCL(1)*GAMMA/(PRANDTL*(GAMMA-1)) )
	 LAML(4)=( VISCL(4)*GAMMA/(PRTU*(GAMMA-1)) ) + ( VISCL(2)*GAMMA/(PRANDTL*(GAMMA-1)) )
	 VISCL(3)=MAX(0.0D0,VISCL(3))
	 VISCL(4)=MAX(0.0D0,VISCL(4))
	 
	 IF ((TURBMV(1).LT.ZERO).OR.(TURBMV(2).LT.ZERO))THEN
	 VISCL(3)=0.0D0
	 VISCL(4)=0.0D0
	 END IF
	 
	 ETVM(1) = ( 0.5*(VISCL(1)+VISCL(2)) ) +  ( 0.5*(VISCL(3)+VISCL(4)) )




	  
!Added on 20/6/2013---------------------------------------------------------------
!After limiting these variables, we compute the diffusion for the turbulent variables
if (TURBULENCEMODEL .eq. 2) then
!--------EDDYFL/R(19)=GAMMA_k_L/R
!--------EDDYFL/R(20)=GAMMA_om_L/R  

EDDYFL(12)=VISCL(1)+VISCL(3)/sigma_k_l
EDDYFR(13)=VISCL(2)+VISCL(4)/sigma_k_r

EDDYFL(12)=VISCL(1)+VISCL(3)/sigma_om_l
EDDYFR(13)=VISCL(2)+VISCL(4)/sigma_om_r
end if
END IF




  END SUBROUTINE EDDYVISCO2d


  

  
  
  






END MODULE FLOW_OPERATIONS
