
/*  	masc.c
 *
 * 	M J Wooldridge
 *  	February 1990
 *
 *	Main fn for masc
 */

	/* first the usual #includes */

#include    <stdio.h>

#include    	"masc.h"
#include    	"../include/cosmetic.h"
#include	"../include/paths.h"

	/* External Data Declarations */

extern	void
	generate_org_desc_files(),
	generate_dot_c_file();

extern  char
	*getenv(),
    	*yytext;

extern  int
	masc_errors,
    	yylineno,
    	yylex(),
	yyparse(),
	yylval;

    	/* Agent Implementation Languages  -- see also masc.h for #defines */

char    *language_tab[] = {
    	"pop11",
    	"poplisp",
    	"popprolog",
	"pwmpop11",
	"c"
};

int     num_language_tab = 5;	/* number of languages in language_tab[] */

	/* Symbol Table */

char	*sym_tab[SYMTABSIZE];
int	num_of_sym = 0;

AG	*agent_list = null(AG);

	/* A routine to get the time */

char	time_string[100];

void	get_time()
{
	long	ltime;

	time(&ltime);
	strcpy(time_string, ctime(&ltime));
}

	/*Command line flags */

int	vflag = FALSE,			/* verbose mode flag */
	sflag =	FALSE,			/* sunview flag */
	cflag = FALSE;			/* compile generated code flag */

	/* other options */

int	opt_trace 	= FALSE,	/* call dkbs with -t option */
	opt_use_mp	= FALSE,	/* generate organisation desc files */
	opt_dkbs	= TRUE,		/* install server */
	opt_reader	= TRUE,		/* install reader */
	opt_sunview	= FALSE,	/* run under sunview */
	opt_debugger	= FALSE,	/* select debugger */
	opt_wintool	= FALSE;	/* install agentwintool */

	/* now some general global variables */

char	*pre_file 		= null(char),	/* preamble file pathname */
	*view_prefix		= VIEW_PREFIX,	/* prefix for view file names */
	*rpc_include_file	= null(char);	/* rpc defs */
char	*paths_file		= null(char);

	/* now the function to look at environment and set paths */

void	set_up_paths()
{
	char	*root,
		path[512];

	if((root = getenv("made")) == null(char))
	{
		fprintf(stderr,"masc : environment variable `made' not set\n");
		exit(1);
	}

	sprintf(path,"%s/%s",root,PRE_MASC);
	pre_file 		= stralloc(path);
	
	sprintf(path,"%s/%s",root,INC_REM_FORK);
	rpc_include_file 	= stralloc(path);
	
	sprintf(path,"%s/%s",root,INC_PATHS);
	paths_file		= stralloc(path);
}

	/* Now the MAIN */

int     main(argc,argv)
int     argc;
char    *argv[];
{
    	FILE 	*infile;
	int	count;

	/* first process command line arguments */

    	if((argc < 2) OR (argc > 5))
	{
	        fprintf(stderr,"masc :illegal number of args\n");
		fprintf(stderr,"Usage is masc <infile> [-vc]\n");
		exit(1);
	}
	
	for(count = 2; count<argc; count++)
	{
		if(strcmp(argv[count] , "-s") == 0)
			sflag = TRUE;
	
		if(strcmp(argv[count] , "-c") == 0)
			cflag = TRUE;

		if(strcmp(argv[count] , "-v") == 0)
			vflag = TRUE;
	}
	
    	if((infile = freopen(argv[1],"r",stdin)) == NULL)
        {
		fprintf(stderr,"%s : Couldn't open input file %s\n",
			argv[0], argv[1]);
		exit(1);
	}

	/* now set the various global variables */

	get_time();

	set_up_paths();

	/* ok - now we can beging processing */

	if(vflag)
	{
		fprintf(stderr,
		"masc\t-- Multi Agent System Description Language Compiler\n");
		fprintf(stderr, "\t-- run at %s\n",time_string);
		fprintf(stderr,"Phase One   : Parsing\n");
	}
	
    	yyparse();

	if(vflag)
		fprintf(stderr,"\n\n");

	if(masc_errors)
	{
		fprintf(stderr,"%d Errors Reported\n");
		exit(1);
	}
	
	/* now use the tables to generate code */

	if(vflag)
		fprintf(stderr,"Phase Two   : Code Generation\n");

	generate_dot_c_file();

	if(opt_use_mp)
		generate_org_desc_files();

	if(vflag)
		fprintf(stderr,"** Terminating\n");

}

	/* THE END */
