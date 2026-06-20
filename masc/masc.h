/* masc.h
 *  M J Wooldridge
 *
 *  February 1990
 */

	/* Error Codes */

#define ERROR_YACC      1
#define ERROR_LEXICAL   2
#define ERROR_ILLEGAL   3

	/* Table Definitions */

	/* symbol list */

typedef struct slist
{
    int name;           /* pointer into sym_tab[] */
    struct slist *next;
}   SLIST;

	/* agent list */

typedef	struct	ag
{
	int	name,		/* pointer into sym_tab[] */
		host,		/* pointer into sym_tab[] */
		language;	/* what language is the agent in */

#define	LANGUAGE_DEFAULT	(-1)
#define	LANGUAGE_POP11		0
#define	LANGUAGE_LISP		1
#define	LANGUAGE_PROLOG		2
#define	LANGUAGE_PWMPOP11	3
#define	LANGUAGE_C		4

	SLIST	*groups,	/* groups the agent belongs to */
		*sups,		/* superordinates of agent */
		*subs;		/* subordinates of agent */
	struct	ag	*next;
}	AG;

	/* symbol table size */

#define	SYMTABSIZE	512

	/* and a define to make things more readable */

#define	SYSTEM_NAME	(sym_tab[0])

	/* The prefix for view files (may be changed by -prefix) */

#define	VIEW_PREFIX		"view_"
