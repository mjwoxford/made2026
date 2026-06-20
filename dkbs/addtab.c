
/*
 * addtab.c
 * 
 * M J Wooldridge 
 * December 1989
 * 
 * Functions to manipuate address tables
 * 
 */

/* the usual #includes */

#include	"../include/cosmetic.h"
#include	"../include/addtab.h"

/* now the functions themselves */

void 
rmagent(agname, pat_list)
	char           *agname;
	AT            **pat_list;
{
	;
}

int 
islocal(agname, at_list)
	char           *agname;
	AT             *at_list;
{
	while (at_list != null(AT)) {
		if (strcmp(at_list->agent_name, agname) == 0)
			return ((at_list->location == MADE_AT_LOCAL) ? TRUE : FALSE);
		at_list = at_list->next;
	}
	return (FALSE);
}

int 
isremote(agname, at_list)
	char           *agname;
	AT             *at_list;
{
	while (at_list != null(AT)) {
		if (strcmp(at_list->agent_name, agname) == 0)
			return ((at_list->location == MADE_AT_REMOTE) ? TRUE : FALSE);
		at_list = at_list->next;
	}
	return (FALSE);
}

int 
is_registered(agname, at_list)
	char           *agname;
	AT             *at_list;
{
	while (at_list != null(AT)) {
		if (strcmp(at_list->agent_name, agname) == 0)
			return (TRUE);
		at_list = at_list->next;
	}
	return (FALSE);
}

void 
add_agent(agname, fdes, host, location, pat_list)
	char           *agname, *host;
	int             fdes, location;
	AT            **pat_list;	/* note double pointer */
{
	AT             *new_at, *at_list;

	new_at = galloc(AT);

	/* now sort out where the new one goes */

	if (*pat_list == null(AT))
		*pat_list = new_at;
	else {
		at_list = *pat_list;
		while (at_list->next != null(AT))
			at_list = at_list->next;
		at_list->next = new_at;
	}

	/* now slot the details into the list */

	new_at->agent_name 	= stralloc(agname);
	new_at->location 	= location;
	new_at -> next 		= null(AT);

	/* deal with union */
	
	if (location == MADE_AT_LOCAL)
		new_at -> address.fifodes = fdes;
	else
		new_at -> address.host = stralloc(host);

}

int 
get_fdes(agname, at_list)
	char           *agname;
	AT             *at_list;
{
	while (at_list != null(AT)) {
		if (strcmp(agname, at_list->agent_name) == 0) 
			return (at_list -> address.fifodes);
		at_list = at_list->next;
	}

	return (-1);		/* not found */
}

char	*
get_host(agname, at_list)
	char           *agname;
	AT             *at_list;
{
	while (at_list != null(AT)) {
		if (strcmp(agname, at_list->agent_name) == 0)						return (at_list -> address.host);
		at_list = at_list->next;
	}

	return ((char *)0);		/* not found */
}

