!#######################################################################################
PROGRAM POLITROPAS
  USE iso_fortran_env, ONLY: wp => REAL64
  USE nrtype
  USE nr
  USE ode_path
  IMPLICIT NONE
  INTERFACE
     SUBROUTINE fx_edo(x,y,dy_dx)
       USE nrtype                
       IMPLICIT NONE
       REAL(SP), INTENT(IN) :: x
       REAL(SP), DIMENSION(:), INTENT(IN) :: y
       REAL(SP), DIMENSION(:), INTENT(OUT) :: dy_dx
     END SUBROUTINE fx_edo
  END INTERFACE
  INTEGER :: cantidad,i,k
  REAL(SP) :: inicio,fin,error,hmin,x1,x2,h,n
  LOGICAL :: key
  CHARACTER(15) :: nombre
  CHARACTER(22) :: j
  REAL(SP), ALLOCATABLE :: y(:),inicial(:)
  COMMON /indice_do/ j
  COMMON /indice_politropico/ n
  !#######################################################################################
  ! Leemos el archivo de condiciones iniciales:
  OPEN(10,FILE='condicion_inicial.dat')
  READ(10,*) cantidad
  ! La variable 'cantidad' es el número de ecuaciones diferenciales a resolver.
  ALLOCATE (y(cantidad))
  ! y(cantidad) es el vector auxiliar que usaremos para trabajar con theta y phi en 
  ! la ecuación diferencial.
  ALLOCATE (inicial(cantidad))
  ! inicial(cantidad) es el vector que contiene las condiciones iniciales en theta y phi.
  READ(10,*) (inicial(i),i=1,cantidad)
  ! Donde inicial(1) será el valor de theta inicial e inicial(2) será el valor de phi
  ! inicial.
  !#######################################################################################
  DO k=0,5
     WRITE(j,'(A17,I1,A4)') 'indice_politropa_',k,'.dat'
     WRITE(nombre,'(A10,I1,A4)') 'Politropa_',k,'.dat'
     ! Abrimos el archivo donde guardaremos la salida del programa:
     OPEN(40,FILE='Salida/'//nombre)
     !#######################################################################################
     WRITE(40,'(A,1X,I2,1X,A)') '# Número de ecuaciones diferenciales a resolver:',cantidad
     WRITE(40,'(A,2(1X,G15.7,2X),1X,A)') '# Condiciones iniciales:',(inicial(i),i=1,cantidad)
     !#######################################################################################
     y(1)=inicial(1)
     ! Inicializamos la variable theta.
     y(2)=inicial(2)
     ! Inicializamos la variable phi.
     !#######################################################################################
     ! Leemos el intervalo de integración:
     OPEN(20,FILE='intervalo_integ.dat')
     READ(20,*) inicio
     ! La variable 'inicio' es el extremo inicial del intervalo de integración.
     WRITE(40,'(A,1X,F7.4,1X,A)') '# Extremo inicial del intervalo de integración:', inicio
     READ(20,*) fin
     ! La variable 'fin' es el extremo final del intervalo de integración.
     WRITE(40,'(A,1X,F7.4,1X,A)') '# Extremo final del intervalo de integración:', fin
     !#######################################################################################
     ! Definimos el paso de integración:
     h=0.01
     WRITE(40,'(A,1X,F7.4,1X,A)') '# Paso de integración:', h
     !#######################################################################################
     WRITE(40,'(A,A11,1X,A11,3X,A11)') '#','x_inicial','theta','phi'
     !#######################################################################################
     WRITE(40,'(1X,10(G14.7,2X))') inicio,(y(i),i=1,cantidad) 
     ! Escribimos el primer punto en el archivo de salida.
     !#######################################################################################
     x1=inicio
     error=1.*10.**(-6)
     hmin=1.*10.**(-6)
     key=.true.
     DO WHILE (key)
        x2=AMIN1(x1+h,fin)
        CALL odeint(y,x1,x2,error,h,hmin,fx_edo,rkqs)
 ! Escribimos el resultado:
        WRITE(40,'(1X,10(G14.7,2X))') x2, (y(i),i=1,cantidad)
        IF ((.not.(fin.gt.x2)).or.(abs(x2-fin).lt.(0.5d-5))) THEN
           key=.false.
        ENDIF
        x1=x2
     ENDDO
     WRITE(40,'(A,1X,F7.4,1X,A)') '# Índice politrópico:',n
     CLOSE(10)
     CLOSE(20)
     CLOSE(40)
  ENDDO
END PROGRAM POLITROPAS
!#######################################################################################



!#######################################################################################
SUBROUTINE fx_edo(x,y,dy_dx)
  USE nrtype
  IMPLICIT NONE
  REAL(SP), DIMENSION(:),INTENT(IN) :: y
  REAL(SP), DIMENSION(:),INTENT(OUT) :: dy_dx
  REAL(SP),INTENT(IN) :: x
  REAL(SP) :: epsilon
  REAL(SP) :: n
  COMPLEX*16 :: theta
  CHARACTER(22) :: j
  COMMON /indice_do/ j
  COMMON /indice_politropico/ n
  !#######################################################################################

  OPEN(50,FILE=j)
  READ(50,*) n
  ! La variable 'n' es el índice politrópico.
  CLOSE(50)
  !#######################################################################################
  theta=DCMPLX(y(1))
  ! Para evitar tener un valor muy cercano a cero:
  IF (x<1.0*10.**(-7)) THEN
     epsilon=1.*10.**(-6)
  ELSE 
     epsilon=x
  ENDIF
  !#######################################################################################
  dy_dx(1)=y(2)/(epsilon**2)     
  dy_dx(2)=-(REAL(DBLE(theta**n)))*(epsilon**2)
  RETURN
END SUBROUTINE fx_edo
!#######################################################################################
