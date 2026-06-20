/*
 * encodedg.c
 * 
 * M J Wooldridge December 1989
 * 
 * Takes a datagram structure (type DG) and from it generates a `raw' datagram,
 * (i.e., a character string.)
 */

/* first the #includes */

#include	"../../include/cosmetic.h"
#include	"../../include/dg.h"
#include	"../../include/select.h"

/* external data definitions */

extern	char
	*stralloc(),
	*alloc_raw_dg();

extern	void
	fatal();

	/* now a macro to pick up on arguments too long */

#define	check_len(A,B)						\
	if(((A) != null(char)) AND (strlen(A) >= B))		\
		fatal("encodedg failed - argument too long");

/* now the encode function */

char           *
encodedg(dg)
	DG             *dg;
{
	char           *raw_dg;
	int             count;

	/* get a buffer for the dg */

	raw_dg = alloc_raw_dg();

	/* now the datagram type */

	raw_dg[PROC_POS_DG_TYPE] = i2c(dg->dg_type);

	/* now check & copy the sender agent name */

	check_len(dg->agent_name, PROC_SIZE_AGENT_NAME);
	strcpy(&raw_dg[PROC_POS_AGENT_NAME], dg->agent_name);

	/* now check & copy the addressee name */

	check_len(dg->addressee, PROC_SIZE_AGENT_NAME);
	strcpy(&raw_dg[PROC_POS_ADDRESSEE], dg->addressee);
		
	/* check & encode the value itself */

	check_len(dg->value, PROC_SIZE_VALUE);
	strcpy(&raw_dg[PROC_POS_VALUE], dg->value);

	/* now return it */

	return (raw_dg);
}
