
/*
 * decodedg.c
 * 
 * M J Wooldridge 
 * December 1989
 * 
 * Takes a `raw' datagram (a character string), and from it generates a datagram
 * structure (type DG).
 *	
 */

/* #includes */

#include	"../../include/cosmetic.h"
#include	"../../include/dg.h"

/* now the decode function */

DG             *
decodedg(raw_dg)
	char           *raw_dg;
{
	int             count;
	DG             *dg;

	/* now get space for the decoded datagram */

	dg = alloc_dg();

	/* decode datagram type */

	dg->dg_type = c2i(raw_dg[PROC_POS_DG_TYPE]);

	/* now get sender agent name */

	(dg->agent_name) = stralloc(&raw_dg[PROC_POS_AGENT_NAME]);

	/* now get addressee name */

	(dg->addressee) = stralloc(&raw_dg[PROC_POS_ADDRESSEE]);

	/* decode value digits */

	dg->value = stralloc(&raw_dg[PROC_POS_VALUE]);

	/* now simply return the value */

	return (dg);
}

/* THE END */

