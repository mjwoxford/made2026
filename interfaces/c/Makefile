#	Makefile for directory ../dkb-1.0
#
#	M J Wooldridge
#	December 1989
#
#	Makes the main `libdkb.a' library

all	:	libs

libs	:
	-cc *.c  -c
	-ar rcv libdkb.a *.o
	-ranlib libdkb.a
	-rm *.o *- *%

dump	:
	-lpr *.c 

scrub	:
	-rm *.o 
