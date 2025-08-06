# ------------------Macro-Defs---------------------
F90=gfortran -Wall 
#F90=ifort -warn all
# -------------------End-macro-Defs---------------------------

# Here is the link step 
Politropa:nrtype.o nrutil.o nr.o rk4.o rkck.o rkdumb.o rkqs.o odeint.o
	 $(F90) -o Politropa.exe Politropa.f90  nrtype.o nrutil.o nr.o rk4.o rkck.o rkdumb.o rkqs.o odeint.o 

# Here are the compile steps
nrtype.o:./nrtype.f90 
	 $(F90) -c nrtype.f90

nrutil.o:./nrutil.f90 nrtype.o 
	 $(F90) -c nrutil.f90

nr.o:./nr.f90 nrtype.o 
	 $(F90) -c nr.f90

rk4.o:./rk4.f90 nrtype.o nrutil.o 
	 $(F90) -c rk4.f90

rkck.o:./rkck.f90 nrtype.o nrutil.o 
	 $(F90) -c rkck.f90

rkdumb.o:./rkdumb.f90 nrtype.o 
	 $(F90) -c rkdumb.f90

rkqs.o:./rkqs.f90 nrtype.o nrutil.o nr.o
	 $(F90) -c rkqs.f90

odeint.o:./odeint.f90  nrtype.o
	 $(F90) -c odeint.f90

# This entry allows you to type " make clean " to get rid of
# all object and module files 
clean:
	rm -f *.mod *.o