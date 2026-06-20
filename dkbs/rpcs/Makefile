#	Makefile for .../dkb-1.0/dkbs/rpcs/...
#
#	M J Wooldridge
#	January 1990
#
#	Uses rpcgen(1) to create remote procedure calls

all	: cleanup rem_dkb_svc rem_dkb_clnt.o cleanup

rem_dkb_svc : rem_dkb.h rem_dkb_svc.o rem_dkb_proc.o
	-cc rem_dkb_svc.o rem_dkb_proc.o ../../interfaces/c/libdkb.a -o rem_dkb_svc

rem_dkb.h rem_dkb_svc.o rem_dkb_clnt.o :	
	rpcgen rem_dkb.x
	cc rem_dkb_svc.c rem_dkb_clnt.c -c

cleanup	:
	-rm rem_dkb_svc.* rem_dkb_proc.o *-


