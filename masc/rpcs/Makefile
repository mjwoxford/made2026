#	Makefile for .../dkb-1.0/models/masc/rpcs/...
#
#	M J Wooldridge
#	January 1990
#
#	Uses rpcgen(1) to create remote installation procedures

all	: cleanup rem_inst_svc rem_inst_clnt.o cleanup

rem_inst_svc : rem_inst.h rem_inst_svc.o rem_inst_proc.o
	-cc rem_inst_svc.o rem_inst_proc.o \
		../../interfaces/c/libdkb.a -o rem_inst_svc

rem_inst.h rem_inst_svc.o rem_inst_clnt.o :	
	rpcgen rem_inst.x
	cc rem_inst_svc.c rem_inst_clnt.c -c

cleanup	:
	-rm rem_inst_svc.* rem_inst_proc.o *- *%


dump	:
	-lpr *.x rem_inst_proc.c 
