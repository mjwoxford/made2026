#   Makefile for .../dkb-1.0/dkbs/...
#
#   M J Wooldridge
#   December 1989
#
#   Makes the `dkbs' program.
#

#	sdkbs - Sunview DKBS (with windows)
sdkbs	:  
	-cc *.c -lsuntool -lsunwindow -lpixrect ../interfaces/c/libdkb.a \
		rpcs/rem_dkb_clnt.o -o dkbs
	-rm *- *% *.o

#	udkbs - UNIX DKBS (no Wiindows)
udkbs	: 
	-cc dkbs.c fifoset.c processdg.c addtab.c ../interfaces/c/libdkb.a \
		 -o dkbs

dump	:
	-lpr *.c rpcs/*.x rpcs/rem_dkb_proc.c

cleanup :
	-rm *.o *- *%

	
