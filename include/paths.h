/*	include/paths.h
 *
 *	M J Wooldridge
 *	July 1990
 *
 *	Define the various paths required for use in MADE
 */
 
 	/* first the MADE executable programs to be prefixed by $made */
 	
#define EXEC_DKBS   	"dkbs/dkbs"
#define	EXEC_SREADER	"io/readertool"
#define EXEC_READER 	"io/reader"
#define	EXEC_AWT	"io/agentwintool"
#define	EXEC_DEBUGGER	"debugger/debugger"

	/* now various executable paths */
	
#define EXEC_POP    	"/usr/pop_admin/pop/pop/pop11"
#define	EXEC_PWM	"/usr/pop_admin/pop/pop/pwmtool"
#define	EXEC_LISP	"/usr/pop_admin/pop/pop/clisp"
#define	EXEC_PROLOG	"/usr/pop_admin/pop/pop/prolog"

	/* now paths for some include files - to be prefixed by $made*/
	
#define	INC_REM_FORK	"masc/rpcs/rem_inst.h"
#define	INC_PATHS	"include/paths.h"	/* this file !! */

	/* finally the prefix file (for masc) */
	
#define	PRE_MASC	"masc/pre.c"
