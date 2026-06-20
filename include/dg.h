
/*
 * dg.h
 * 
 * M J Wooldridge December 1989
 * 
 * Datagram definitions for PROC programs TO DO: - change PROC to MADE_DG -
 * simplify value_name/value to content - rename all contents sensibly(!) -
 * (long term) variable size datagrams
 */

/*
 * first the datagram type
 */

typedef struct dg_struct {
	int             dg_type;	/* Datagram type, e.g, request */
	char           *addressee,	/* Name of agent sent to */
	               *agent_name,	/* Sender of datagram */
	               *value;		/* The value itself */
}               DG;

/*
 * Reserved Values to assign to `dg_type'
 */

#define PROC_ERR	0	/* Error somewhere ! */
#define PROC_REGI	1	/* Register */
#define PROC_REM_REGI 	2	/* Remote Register */
#define PROC_DIED	3	/* Die */

/*
 * User defined values to assign to `dg_type'
 */
 
#define	MADE_DG_USER	5	/* User defined */

	/* the following are a bit old fashioned */
	
#define PROC_REQU	4	/* Request for data */
#define PROC_RESP	5	/* Response to request */
#define PROC_INFM	6	/* Inform */
#define PROC_USER	7	/* User defined */

/*
 * The following definitions will define the format of the raw datagram
 */
 
/* Raw Datagram Length */

#define PROC_DGSIZE 256

/* Position Definitions */

#define	PROC_POS_DG_TYPE	0
#define	PROC_POS_AGENT_NAME	1
#define	PROC_POS_ADDRESSEE	17
#define	PROC_POS_VALUE_NAME	33
#define	PROC_POS_VALUE		57

/* Size Defintions */

#define	PROC_SIZE_AGENT_NAME	16
#define	PROC_SIZE_VALUE_NAME	24
#define	PROC_SIZE_VALUE		199

/* Macros to convert integers <--> characters */

#define	i2c(A)			((A)+'0')
#define	c2i(A)			((A)-'0')

/* external data declarations for dg handling fns */

/*	from dg.c */

extern	char	*alloc_raw_dg();
extern	void	free_raw_dg();
extern	void	copy_raw_dg();

extern	DG	*alloc_dg();
extern	void	free_dg();

/*	from encodedg.c/decodedg.c */

extern	DG	*decodedg();
extern	char	*encodedg();

/* 	from msgctl.c */

extern	void	write_dg();
extern	void	write_raw_dg();

extern	char	*read_raw_dg();
extern	DG	*readdg();


