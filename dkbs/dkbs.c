
/*	dkbs.c
 *
 *	M. J. Wooldridge
 *	December 1989
 *
 *	The main() for the DKB server
 *
 */

	/* the usual #includes */

#include<stdio.h>

#include	"../include/cosmetic.h"
#include	"../include/dg.h"
#include	"../include/addtab.h"
#include	"../include/select.h"

/*
 * some external data declarations
 */

extern	int 	errno;
extern	int 	fifodes;
extern	char	*servname;
extern	char	*agentname;


/*
 * External functions
 */

extern	int	num_msgs(),
		fifodes;			/* my fifo descriptor */
		
extern	void 
#ifdef	SUNOS
		notify_dispatch(),
		startup_win(),
		update_monitor_window(),
#endif	SUNOS
		start_server_fifo(),	/* in server_comms.c */
		start_server_lock(),	/* in server_comms.c */
		processdg();

/* global data declarations */

	/* first the address tables */

AT 	*ad_table = null(AT);

	/* command line argument flags */

int 	trace_flag	= FALSE;
int	debug_flag	= FALSE;
int	verbose_flag	= FALSE;
int 	walk_flag 	= FALSE;
int 	sunview_flag	= FALSE;
int	pause_flag	= FALSE;
int	beep_flag	= TRUE;
int	slow_time	= 2;
int	trap_flag	= FALSE;
int	rem_flag	= FALSE;	/* TRUE if agents are remote */

	/* statistics */

int	no_of_local_agents 	= 0;
int	no_of_remote_agents 	= 0;
int	total_no_of_agents	= 0;
int	num_msgs_switched	= 0;
int	bad_msgs		= 0;
int	trap_int		= 0;

char	*trap_string		= "";
char	*last_message_from	= " ";

/*
 *Now the main()
 */

main(argc,argv)
	int 	argc;
	char	*argv[];
{
	int count;

	for(count=1; count<argc; count++) {
		if(strcmp("-t",argv[count]) == 0)
			trace_flag = TRUE;
		if(strcmp("-v",argv[count]) == 0)
			verbose_flag = TRUE;
		if(strcmp("-w",argv[count]) == 0)
			walk_flag = TRUE;
		if(strcmp("-s",argv[count]) == 0)
			sunview_flag = TRUE;
		if(strcmp("-r",argv[count]) == 0)
			rem_flag = TRUE;
	}

	/* close stdin (to leave the reader able to get at it */

	fclose(stdin);

	/* set the name of the agent */

	agentname = "*dkb server*";

	/* setup the lock (will exit if server already presemt */
	
	start_server_lock();
	
	/*now open communications */

	start_server_fifo();

#ifdef	SUNOS
	/* if sunview flag set then initialise the monitor window */

	if(sunview_flag)
		startup_win();
	(void) notify_dispatch();
#endif	SUNOS

	do
	{

#ifdef	SUNOS

		/* wait for a message to be received */
		if(sunview_flag)
			while(num_msgs(fifodes) == 0)
				(void)notify_dispatch();

		while(pause_flag)
			(void)notify_dispatch();

#endif	SUNOS

		/* get and process the next message */

processdg();

		/* increment the number of messages switched */

		if((num_msgs_switched++) == 9999)
			num_msgs_switched = 0;

#ifdef	SUNOS
		/* update the monitor window/dispatch events to event procs */

		if(sunview_flag)
			update_monitor_window();

#endif	SUNOS
		
		/* sleep for required time */

		if(walk_flag)
			sleep(slow_time);

	}
	while(TRUE);/* i.e., forever */
}
