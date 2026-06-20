/*	dg.c
 *
 *	M J Wooldridge
 *	JUne 1990
 *
 *	General Datagram handling routines
 */

	/* first the usual #includes */

#include	<stdio.h>
#include	<memory.h>			/* for memcpy */

#include	"../../include/cosmetic.h"
#include	"../../include/dg.h"

	/* external data declarations */

extern	char	*malloc();

	/* global data decalarations */

char	*dg_type_str[] = {
	"Error",
	"Register",
	"Remote Register",
	"Die",
	"(Default: Request)",
	"(Default: Respond)",
	"(Default: Inform)",
	"(Default: None)"
};

	/* the next three handle raw datagrams */

char	*alloc_raw_dg()
{	char	*raw_dg;
	raw_dg = (char *) malloc(PROC_DGSIZE + 1);
	memset(raw_dg, ' ', PROC_DGSIZE);		/* set to spaces */
	return(raw_dg);
}

void	free_raw_dg(raw_dg)
char	*raw_dg;
{	
	free_if_not_null(raw_dg);
}

void	copy_raw_dg(dest,src)
char	*dest,
	*src;
{	
	memcpy(dest,src,PROC_DGSIZE);	
}

	/* the next two handle datagram structures */

DG	*alloc_dg()
{
	DG	*dg;
	
	dg = galloc(DG);

	dg->dg_type 		= 0;
	dg->agent_name		= get_null_string;
	dg->addressee		= get_null_string;
	dg->value		= get_null_string;

	return(dg);
}

void	free_dg(dg)
DG	*dg;
{
	free_if_not_null(dg->agent_name);
	free_if_not_null(dg->addressee);
	free_if_not_null(dg->value);
	free_if_not_null(dg); 
}


/* THE END */
