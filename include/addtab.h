/*
 *	addtab.h
 * 
 *	M J Wooldridge 
 *	December 1989
 * 
 *	Header file for address tables
 */

/* First the address table type */

typedef struct at {
	char           *agent_name;
	int		location;
	union {
		int             fifodes;
		char           *host;
	} address;
	struct	at     *next;
}               AT;


/* defines for location */

#define	MADE_AT_LOCAL	0
#define	MADE_AT_REMOTE	1

/* external data defs for addtab.c */

extern	void	rmagent();
extern	void	add_agent();

extern	int	islocal();
extern	int	isremote();
extern	int	isregistered();
extern	int	get_fdes();
extern	char	*get_host();

/* now some pseudo-functions */

	/* add a local agent */
#define	addlocal(A,B,C)		add_agent((A), (B), null(char), MADE_AT_LOCAL, (C))

	/* add a remote agent */
#define	addremote(A,B,C) 	add_agent((A), 0, (B), MADE_AT_REMOTE, (C))
