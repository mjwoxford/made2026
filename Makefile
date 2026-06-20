#	made1.0/Makefile
#
#

dump	:
	-lpr interfaces/c/*.c interfaces/pop11/*.p
	-lpr dkbs/*.c rpcs/*.x
	-lpr io/*.c
	-lpr masc/*.c masc*.y masc*.l masc/rpcs/*.x
	
clean	:
	-rm interfaces/c/libdkb.a dkbs/dkbs io/reader io/agentwintool io/readertool
	
