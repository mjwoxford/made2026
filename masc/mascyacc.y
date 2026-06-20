%{

/*  mascyacc.y
 *
 *  M J Wooldridge
 *  February 1990
 */

#include    <stdio.h>
#include    "masc.h"
#include    "../include/cosmetic.h"

	/* external function declarations */

extern  char
	*stralloc(),
    *yytext;

extern  int
    yylineno,
    yylex();

	/* external data declarations */

extern	char    *language_tab[];
extern	int     num_language_tab;

extern	char	*sym_tab[];
extern	int	num_of_sym;
extern	AG	*agent_list;
extern	SLIST	*host_list;

extern	int	vflag;

	/* local data declarations */

AG	*gen_agent 	= null(AG);
SLIST	*gen_slist	= null(SLIST),
	*gen_groups	= null(SLIST),
	*gen_sub	= null(SLIST),
	*gen_sup	= null(SLIST);

int	gen_host	= -1;
int	gen_language	= -1;

	/* Error handling */

    	/* Number of errors that occur */

int masc_errors = 0;

	/* get yacc to pass errors to my error handler */

#define yyerror(S)	masc_error(ERROR_YACC,(S),null(char));

 	/* now two table handling functions only required by the parser */

void	insert_ag(ag)
AG	*ag;
{
	if(agent_list == null(AG))
		agent_list = ag;
	else
	{
		AG	*current;
	
		current = agent_list;
		while((current -> next) != null(AG))
			current = (current -> next);
		(current->next) = ag;
	}
}

void	insert_slist(slist)
SLIST	*slist;
{
	if(gen_slist == null(SLIST))
		gen_slist = slist;
	else
	{
		SLIST	*current;
	
		for(	current = gen_slist; 
			(current -> next) != null(SLIST); 
			current = (current -> next))
			
			if(slist->name == current->name)
				return; /* no duplicates */
		(current->next) = slist;
	}
}

	/* Pretty Printing */

int	line_length = 8;

void	prname(n)
int	n;		/* pointer into sym_tab[] */
{
	if((line_length == 8) OR
		((line_length = (line_length + 1 + strlen(sym_tab[n]))) > 75))
	{
		line_length = 8 + strlen(sym_tab[n]);
		fprintf(stderr,"\n\t");
	}
	fprintf(stderr,"%s ",sym_tab[n]);
}

%}

%token	OPTIONS
%token	OPT
%token  SYSTEM
%token  GROUP
%token  AGENT
%token  HOST
%token  SUPERORDINATE
%token	SUBORDINATE
%token  LANGUAGE
%token  IDEN

%start  sdl_program

%%

sdl_program         :
        declarations    agent_sequence
    ;

declarations        :
        op_options	system_decs 
    ;

op_options		:
		options_dec
	|
	;

options_dec		:
		OPTIONS	options_sequence
	;

options_sequence	:
		options_sequence	OPT
	|	OPT
	;

system_decs         :
        SYSTEM  IDEN
    ;

agent_sequence      :
        agent_sequence  agent
    |   agent
    ;

agent               :
        AGENT   IDEN    main		{
	AG	*ag;
	
	/* first get space */
		
	if((ag = galloc(AG)) == null(AG))
		fatal("no more memory");

	
	/* if verbose flag set, print out the name */

	if(vflag)
		prname($2);

	/* now allocate the values to the new agent structure */

	(ag -> name) 		= $2;
	(ag -> host) 		= gen_host;
	(ag -> language) 	= gen_language;
	(ag -> groups)		= gen_groups;
	(ag -> sups)		= gen_sup;
	(ag -> subs)		= gen_sub;
	(ag -> next) 		= null(AG);

	/* now set the general variables back to defaults */

	gen_sup			= null(SLIST);
	gen_sub			= null(SLIST);
	gen_groups		= null(SLIST);
	gen_host		= -1;
	gen_language		= -1;

	/* finally, insert the new structure into the agent list */

	insert_ag(ag);
}
    ;

main                :
        slot_sequence
    ;

slot_sequence       :
        slot_sequence   slot
    |   slot
    ;

slot                :
        host
    |   language
    |   superordinate
    |	subordinate
    |	group
    ;

host                :
        HOST    IDEN			{ gen_host = $2; }
    ;

superordinate       :
        SUPERORDINATE iden_sequence	{
		gen_sup 	= gen_slist;
		gen_slist 	= null(SLIST);
}
    ;

subordinate       :
        SUBORDINATE iden_sequence	{
		gen_sub 	= gen_slist;
		gen_slist 	= null(SLIST);
}
    ;

group		:
	GROUP	iden_sequence		{
		gen_groups 	= gen_slist;
		gen_slist 	= null(SLIST);
}

	;

language            :
        LANGUAGE    IDEN		{
	if(!strisin(language_tab,num_language_tab,sym_tab[$2]))
		masc_error(ERROR_ILLEGAL,"language",sym_tab[$2]);

	gen_language = strwhere(language_tab, num_language_tab, sym_tab[$2]);
}
    ;

iden_sequence       :
        iden_sequence   IDEN		{
		SLIST	*slist;

		/* first get space */
		
		slist = galloc(SLIST);

		/* now allocate things */
		
		(slist->name) = $2;
		(slist->next) = null(SLIST);

		/* now insert */

		insert_slist(slist);
}
    |   IDEN				{
		SLIST	*slist;

		/* first get space */
		
		slist = galloc(SLIST);

		/* now allocate things */
		
		(slist->name) = $1;
		(slist->next) = null(SLIST);

		/* now insert */

		insert_slist(slist);
}
    ;
