/*  rem_inst_proc.c
 *
 *  M J Wooldridge
 *  July 1990
 *
 *  Implementation of the procedure `install()' which will be used by
 *  MASC generated programs.
 */

#include	<stdio.h>

#include    	<rpc/rpc.h>     /* standard defs for rpcgen(1) generated code */
#include    	"rem_inst.h"   	/* generated from `rem_inst.x' by rpcgen(1) */

int     *install_1(s)
char    **s;
{
       	int  	result,
		pid;
	char	str[2048],
		prog_name[512],
		dir[512],
		path[512],
		arg[512];

	sprintf(str, "%s",  (*s));
	
	sscanf(str, "%s %s %s %s ", dir, path, prog_name, arg);
	 
	/* now change directory */

	if(chdir(dir) < 0)
		fprintf(stderr,"rem_inst_svc : chdir to `%s ' failed\n",dir);


	if((pid = fork()) == 0) /* ... then child */
	{
		execl(path,prog_name,arg,(char *)0);
				
		/* shouldn't ever get to here, but
		 * if it does, then quit
		 */

		exit(0);
	}

    	/* and return TRUE (for success) */

    	result = 1;
    	return(&result);
}
