#	Makefile for .../dkb-1.0/models/masc/...
#	
#	M J Wooldridge
#	February 1990
#
YACC = yacc -d

all	: masc cleanup

masc	: masc.o mascgenc.o mascgenorg.o mascyacc.o masclex.o
	cc masc.o masclex.o mascyacc.o mascgenc.o mascgenorg.o\
		 -ll ../interfaces/c/libdkb.a -o masc

mascgenc.o mascgenorg.o	: masc.h

masc.o	: masc.c masc.h

masclex.o	: masclex.l masc.h

mascyacc.o	: mascyacc.y masc.h

cleanup : 
	-rm *- y.tab.h masclex.c *.o *%

dump	:
	-lpr *.h *.l *.y *.c 
