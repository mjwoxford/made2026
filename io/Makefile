
#   Makefile for .../io
#
#   M J Wooldridge
#   June 1990

all	: readertool  reader agentwintool cleanup

readertool	: 
	cc readertool.c  -o readertool -lsuntool -lsunwindow -lpixrect

reader	:
	cc reader.c ../interfaces/c/libdkb.a -o reader

agentwintool	:
	cc agentwintool.c ../interfaces/c/libdkb.a -o agentwintool \
		-lsuntool -lsunwindow -lpixrect

cleanup	: 
	-rm *- *% *.o

dump	:
	-lpr *.c

