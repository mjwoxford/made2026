
/*  procgen.c
 *
 *  M J Wooldridge
 *  December 1989
 *
 *  General function used by MADE programs
 *
 */

	/* defines */
	
#include    	<stdio.h>
#include	"../../include/cosmetic.h"

	/* externals */
	
extern	char	*agentname;

	/* global variables */
	
char	*current_host = null(char);

	/* the following two fnctions are low-level error handling */

void    fatal(s)
char    *s;
{
    fprintf(stderr,"FATAL : %s : %s \n", agentname, s);
	perror("FATAL ");
    exit(1);
}

void    warning(s, t)
char    *s,
	*t;
{
    fprintf(stderr,"WARNING : %s : %s : %s \n", agentname, s, t);
}

	/* the following function issues a CTRL-G via stdout */

void	beep()
{
	fputc(7,stdout);
	fflush(stdout);
}

	/* stralloc saves strings */

char    *stralloc(s)                        /* Due to B. W. Kernighan */
char    *s;
{
    char    *cp;

    cp = (char *)calloc(strlen(s)+1,1);
    if(cp)
    {
        strcpy(cp,s);
        return(cp);
    }
    else
        fatal("No more room for strings.");
}

void    debug(s)
char    *s;
{
    fprintf(stderr,"DEBUG : %s : %s\n",agentname,s);
    fflush(stderr);
}

void	get_current_host()
{
	int 	len;
	char	temp[100];
	
	if(current_host == null(char)) {
		if(gethostname(temp,len) < 0)
			fatal("gethostname failed");
		current_host = stralloc(temp);
	}
}
