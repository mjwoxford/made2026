
/*  agents.c
 *
 *  M J Wooldridge
 *  December 1989
 *
 *  Contains functions to :
 *
 *  	- register an agent with the DKB server
 *	- send a datagram to another agent
 *	- receive a datagram
 *  	- `die gracefully'
 *  	- also holds global data definitions for other routines
 */

	/* first the usual #includes */

#include	"../../include/cosmetic.h"
#include 	"../../include/dg.h"

	/* external data/function declarations */

extern  void
	free_dg(),
	debug(),
	fatal(),
	writedg();

extern  int
	open_fifo_for_reading(),
	open_fifo_for_writing(),
	num_msgs();

extern  char
	*get_host_fifo_name(),
	*get_agent_fifo_name(),
	*stralloc(),
	*encodedg();

extern  DG
	*readdg(),
	*decodedg(),
	*alloc_dg();

	/*  Global variable declarations */

int 	agent_address,  		/* qid of my FIFO */
	server_address;  		/* qid of DKB server FIFO */

char	*agentname = null(char);	/* name of agent calling routines */

/*
 *  now the register function, which also sets global variables
 *  `server_address', and `agent_address', and `agentname' - note that the name
 *  has to be `aregister' because `register' is a C reserved word
 */

void	aregister(agent_name)
char	*agent_name;
{
	char	*rawdg,
		*myfifoname,
		*serverfifoname;
	DG	*dg;

	/* first set the global variable `agentname' */

	agentname = stralloc(agent_name);

	/* create my fifo */

	myfifoname = get_agent_fifo_name(agent_name);

	create_fifo(myfifoname);

	/* now open the server FIFO */

	get_current_host();
	
	serverfifoname = get_host_fifo_name();

	server_address = open_fifo_for_writing(serverfifoname);

	/* now set up the datagram */

	dg = alloc_dg();

	dg -> dg_type   	= PROC_REGI;
	dg -> agent_name	= stralloc(agentname);

	/* now we can send the registering datagram to the dkbs */

	writedg(server_address, dg);

	/* reclaim space */
	
	free_dg(dg);

	/* now open my fifo for reading */

	agent_address = open_fifo_for_reading(myfifoname);

	if(strcmp("reader",agentname) != 0)
		close(0);   /* close stdin */
}

	/* Send datagram to named agent */

void	send(agent, dgtype, value)
int 	dgtype;
char	*agent,
	*value;
{
	DG  *dg;
	
	dg = alloc_dg();

	(dg->agent_name)	= stralloc(agentname);
	(dg->addressee) 	= stralloc(agent);
	(dg->dg_type)   	= dgtype;
	(dg->value) 		= stralloc(value);

	writedg(server_address,dg);
   
	free_dg(dg);		/* reclaim space */ 
}

	/* the basic receive function */
	
int 	receive(agent, value)
char	*agent,
	*value;
{
	DG  	*dg; 			/* the received dg */
	int	dg_type;
	
	dg = readdg(agent_address);
	
	strcpy(agent, 		dg->agent_name);
	strcpy(value, 		dg->value);
	dg_type 		= dg -> dg_type;
	free_dg(dg);			/* reclaim space */
	
	return(dg_type);
}

	/* The die function */

void	die()
{
	DG	*dg;
	
	dg 		= alloc_dg();
	dg->dg_type 	= PROC_DIED;
	dg->agent_name  = agentname;
	dg->addressee   = " ";

   	writedg(server_address, dg);
}

	/* returns the number of messages on an agents message queue. */

int get_num_msgs()
{
	return(num_msgs(agent_address));
}

