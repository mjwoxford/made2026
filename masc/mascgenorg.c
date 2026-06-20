
/*  mascgenorg.c
 *
 *  M J Wooldridge
 *  February 1990
 */

	/* first the usual #includes */

#include    <stdio.h>

#include    "../include/cosmetic.h"
#include    "masc.h"

	/* External Data Declarations */

extern  AG
    	*agent_list;

extern  int
    	vflag;

extern  char
	*view_prefix,
    	*sym_tab[],
	*time_string;

extern  void
	write_headings(),
    	debug(),
    	masc_error(),
    	fatal();

	/* the following function looks for a name in a symbol list */

int	name_isin_slist(nm, sl)
int	nm;			/* pointer into sym_tab[] */
SLIST	*sl;			/* list of symbols to search */
{
	int	flag = FALSE;
	SLIST	*cur;

	cur = sl;
	while((!flag) AND (cur != null(SLIST)))
	{
		if(nm == (cur->name))
			flag = TRUE;
		cur = (cur->next);
	}

	return(flag);
}

	/* generate file for pop11 agents */

void	generate_pop11_org_file(ag)
AG	*ag;
{
	char	ofname[512];
	FILE	*of;
	SLIST	*current;

	sprintf(ofname,"%s%s.p", view_prefix, sym_tab[ag->name]);

	if((of = fopen(ofname,"w")) == null(FILE))
	{
		fprintf(stderr,"masc : couldn't open file %s.\n",ofname);
		exit(1);
	}
	
	write_headings(ofname,of);

	fprintf(of,"\n/* This is POP-11 source */\n\n");
	fprintf(of,"vars\n\tview_subordinates\n\tview_superordinates\n\t");
	fprintf(of,"view_groups\n\tview_other_members;\n\n");

	/* subordinates first */

	fprintf(of,"/* agent is superordinate to ... */\n\n\t[\n\t\t");
	current = (ag->subs);
	while(current != null(SLIST))
	{
		fprintf(of,"%s ",sym_tab[current->name]);
		current = (current->next);
	}
	fprintf(of,"\n\t] -> view_subordinates;\n\n");
	
	/* superordinates next */

	fprintf(of,"/* agent is subordinate to ... */\n\n\t[\n\t\t");
	current = (ag->sups);
	while(current != null(SLIST))
	{
		fprintf(of,"%s ",sym_tab[current->name]);
		current = (current->next);
	}
	fprintf(of,"\n\t] -> view_superordinates;\n\n");
	
	/* groups the agent is a member of next */

	fprintf(of,"/* groups the agent is a member of ... */\n\n\t[\n\t\t");
	current = (ag->groups);
	while(current != null(SLIST))
	{
		fprintf(of,"%s ",sym_tab[current->name]);
		current = (current->next);
	}
	fprintf(of,"\n\t] -> view_groups;\n\n");

	/* now tell who is in the same groups */

	fprintf(of,"/* other members of the same groups */\n\n\t[\n");

	current = (ag->groups);

		/* for each group the agent is a member of ... */

	while(current != null(SLIST))
	{	
		AG 	*agent;

		fprintf(of,"\t\t[ %s [",sym_tab[current->name]);
		agent = agent_list;

		/* ... see what other agents are members */

		while(agent != null(AG))
		{
			if(ag != agent)
				if(name_isin_slist(current->name, agent->groups))
					fprintf(of,"%s ",sym_tab[agent->name]);
			agent = (agent->next);
		}

		fprintf(of,"]]\n");
		current = (current->next);
	}
	fprintf(of,"\t] -> view_other_members;\n\n");

}
	/* generate file for pop11 agents */

void	generate_prolog_org_file(ag)
AG	*ag;
{
	char	ofname[512];
	FILE	*of;
	SLIST	*current;

	sprintf(ofname,"%s%s.pl", view_prefix, sym_tab[ag->name]);

	if((of = fopen(ofname,"w")) == null(FILE))
	{
		fprintf(stderr,"masc : couldn't open file %s.\n",ofname);
		exit(1);
	}
	
	write_headings(ofname,of);

	fprintf(of,"\t/* This is PROLOG source */\n\n");
	/* subordinates first */

	fprintf(of,"\t/* agent is superordinate to ... */\n\n");
	current = (ag->subs);
	while(current != null(SLIST))
	{
		fprintf(of,"view_subordinate(%s).\n",sym_tab[current->name]);
		current = (current->next);
	}
	
	/* superordinates next */

	fprintf(of,"\n\t/* agent is subordinate to ... */\n\n");
	current = (ag->sups);
	while(current != null(SLIST))
	{
		fprintf(of,"view_superordinate(%s).\n",sym_tab[current->name]);
		current = (current->next);
	}
	
	/* groups the agent is a member of next */

	fprintf(of,"\n\t/* groups the agent is a member of ... */\n\n");
	current = (ag->groups);
	while(current != null(SLIST))
	{
		fprintf(of,"view_member_of(%s).\n",sym_tab[current->name]);
		current = (current->next);
	}

	/* now tell who is in the same groups */

	fprintf(of,"\n\t/* other members of the same groups */\n\n");

	current = (ag->groups);

		/* for each group the agent is a member of ... */

	while(current != null(SLIST))
	{	
		AG 	*agent;

		fprintf(of,"view_other_members(%s , [",sym_tab[current->name]);
		agent = agent_list;

		/* ... see what other agents are members */

		while(agent != null(AG))
		{
			if(ag != agent)
				if(name_isin_slist(current->name, agent->groups))
					fprintf(of,"%s , ",
						sym_tab[agent->name]);
			agent = (agent->next);
		}

		fprintf(of,"%s]).\n", sym_tab[ag->name]);
		current = (current->next);
	}

}
	/* now the main function */

void	generate_org_desc_files()
{	
	AG	*ag;

	ag = agent_list;
	while(ag != null(AG))
	{
		switch(ag->language)
		{
			case LANGUAGE_DEFAULT:
			case LANGUAGE_POP11:
				generate_pop11_org_file(ag);
			break;

			case LANGUAGE_PROLOG:
				generate_prolog_org_file(ag);
			break;

			default:
				fprintf(stderr,
				"Can't generate org file for %s.\n",
				sym_tab[ag->name]);
		}

		ag = (ag->next);
	}
}

	/* THE END */
