
/*
 * processdg.c
 * 
 * M J Wooldridge December 1989
 * 
 * Process a `raw' datagram for the DKB server
 * 
 */

#include    	<stdio.h>

#include    	"../include/cosmetic.h"
#include    	"../include/dg.h"
#include    	"../include/addtab.h"
#include	"../include/debug.h"
#include    	"../include/select.h"
#include	"../include/system_agents.h"

/* Now select whether to support remote agents or not */

#ifdef  SUNOS
#include    	<rpc/rpc.h>
#include    	"rpcs/rem_dkb.h"
#include    	"../include/hosts.h"
#endif  SUNOS


/* First the obligatory external function/data declarations */

extern int
num_msgs(),
open_fifo_for_writing(),
#ifdef  SUNOS
sunview_flag,
pause_flag,
debug_flag,
trap_flag,
trap_int,
rem_flag,
#endif  SUNOS
trace_flag,
verbose_flag,
no_of_local_agents,
no_of_remote_agents,
total_no_of_agents,
bad_msgs,
num_msgs_switched,
fifodes;

extern char
*get_agent_fifo_name(),
*last_message_from;

#ifdef	SUNOS
char	
*dg_type_str[],
*trap_string;
#endif	SUNOS

extern          AT
*ad_table;

extern          DG
*decodedg();

#ifdef	SUNOS
void
process_remote_register(dg)
	DG             *dg;
{
	addremote(dg->agent_name, dg->addressee, &ad_table);
	total_no_of_agents++;
	no_of_remote_agents++;
}

/*	Arguably, the following function ought to be in msgctl.c, but
 *	since the only place we need to do it is here, it stays.
 *	Note the `wiggling' --- translating \0's to ~ characters. This is
 *	to be able to pass a datagram through an rpcgen(1) STRING type.
 *	Of course we have to de-wiggle at the other end.
 */
 
void	
raw_forward_to_remote_host(rem_host, passed_raw_dg)
	char	*rem_host;	
	char	*passed_raw_dg;
	/* TO DO
	 * 	-Pass a block of memory properly!!
	 */
	 
{		int		count;
		int            *res;		
		CLIENT         *cl;
		char		*raw_dg;

		/* create another raw dg 'cos we need to wiggle it */
			
		raw_dg = alloc_raw_dg();
		copy_raw_dg(raw_dg, passed_raw_dg);
		
		/* insert wiggles in order to pass to remote */
		
		for(count=0; count < PROC_DGSIZE; count++)
			if(raw_dg[count] == '\0')
				raw_dg[count] = '~';
				
		raw_dg[PROC_DGSIZE] = '\0';
				
		/* now create a client, etc */
		
		cl = clnt_create(rem_host, REM_DKB, REM_DKB_VERS, PRO);

		if (cl != null(CLIENT)) {
		
			res = forward_1(&raw_dg, cl);
			if (res == null(int))
				warning("host dead after connection",rem_host);
			else 
				if(*res == -1)
					warning("remote server not present",rem_host);
			clnt_destroy(cl);		
		}
	
		/* free space, since we are so tidy... */
			
		free_raw_dg(raw_dg);
}
#endif	SUNOS

void
process_register(dg)
	DG             *dg;
	/*	TO DO
	 * 		-Tidy this up using new fns in names.c 
	 */
	 
{
	char           *agent_fifo_name;
	int             agent_fifo_desc;

	/* update stats */

	no_of_local_agents++;
	total_no_of_agents++;

	agent_fifo_name = get_agent_fifo_name(dg->agent_name);

	/* now open the fifo for writing */

	agent_fifo_desc = open_fifo_for_writing(agent_fifo_name);

	/* now add the agent details to the address tables */

	addlocal(dg->agent_name, agent_fifo_desc, &ad_table);
	
#ifdef  SUNOS
	if(rem_flag) {
		DG             *rem_reg_dg;
		int             count;
		char           *raw_rem_reg_dg;
		
		/* now create and send the remote registration datagram */
		
		rem_reg_dg = alloc_dg();

		rem_reg_dg->dg_type 	= PROC_REM_REGI;
		rem_reg_dg->agent_name 	= stralloc(dg->agent_name);
		rem_reg_dg->addressee 	= stralloc(current_host);
		
		/* encode remote register */

		raw_rem_reg_dg = encodedg(rem_reg_dg);

		/* now try each host */

		for(count = 0; hosts[count] != null(char); count++)
			if (strcmp(hosts[count], current_host) != 0)
				raw_forward_to_remote_host(hosts[count],raw_rem_reg_dg);

		/* free space */
	
		free_raw_dg(raw_rem_reg_dg);
		free_dg(rem_reg_dg);
	}	
#endif	SUNOS
}

void
forward(dg,raw_dg)
	DG             *dg;
	char		*raw_dg;
{

	/* check the address exists */

	if(islocal(dg->addressee, ad_table)) {
		int             receiver_ad;
		if ((receiver_ad = get_fdes(dg->addressee, ad_table)) < 0)
			fatal("get_fdes() failed");
		write_raw_dg(receiver_ad, raw_dg);
	} 
	
	if(isremote(dg->addressee, ad_table)) {
		char		*rem_host;
		rem_host = get_host(dg->addressee, ad_table);
		raw_forward_to_remote_host(rem_host, raw_dg);

	} 

	if((!islocal(dg->addressee,ad_table)) AND (!isremote(dg->addressee,ad_table))) {
		warning("datagram receiver address did not exist", dg->addressee);
		bad_msgs++;
	}

}

void
process_died(dg)
	DG             *dg;
{
	if (islocal(dg->agent_name))
		rmagent(dg->agent_name, &ad_table);
}

/* the following function deals with traps */

#ifdef	SUNOS

void
check_trap(dg)
	DG             *dg;
{
	extern	void	pause_toggle();
	
	if (trap_is(TRAP_SENDER) AND(strcmp(trap_string, dg->agent_name) == 0))
		pause_toggle();

	if (trap_is(TRAP_ADDRESSEE) AND
	    (strcmp(trap_string, dg->addressee) == 0))
		pause_toggle();

	if (trap_is(TRAP_VALUE) AND
	    (strcmp(trap_string, dg->value) == 0))
		pause_toggle();

	if (trap_is(TRAP_TYPE) AND(trap_int == dg->dg_type))
		pause_toggle();

	if (trap_is(TRAP_SEQUENCE) AND(trap_int == num_msgs_switched))
		pause_toggle();
}

void
send_dg_to_debugger(raw_dg)
	char           *raw_dg;
{
	int             debugger_address;

	if (islocal(MADE_SYSTEM_AGENT_DEBUGGER, ad_table)) {
		if ((debugger_address = get_fdes(MADE_SYSTEM_AGENT_DEBUGGER, ad_table)) < 0)
			fatal("internal error -- send_dg_to_debugger failed");
		else
			writedg(debugger_address, raw_dg);
	} else if (NOT isremote(MADE_SYSTEM_AGENT_DEBUGGER, ad_table))
		warning("debug selected with no debugger present", "*");
}

#endif	SUNOS

/* deal with decoded message */

void
process_message(dg,raw_dg)
	DG             *dg;
	char		*raw_dg;
{

	/* first, check for a trap, and if one fires then pause */

#ifdef	SUNOS
	if (trap_is_on)
		check_trap(dg);

	while (pause_flag)
		(void) notify_dispatch();
#endif	SUNOS

	switch (dg->dg_type) {

	case PROC_REGI:
		process_register(dg);
		break;

#ifdef  SUNOS
	case PROC_REM_REGI:
		process_remote_register(dg);
		break;
#endif  SUNOS

	case PROC_USER:
	case PROC_REQU:
	case PROC_RESP:
	case PROC_INFM:
		forward(dg, raw_dg);
		break;

	case PROC_DIED:
		process_died(dg);
		break;

	default:
		warning("Illegal datagram type", "--");
		bad_msgs++;
		break;

	}
}

/* Now the principle function */

void
processdg()
{
	char		*raw_dg;
	DG             *dg;

	/* first read the datagram from stream */

	raw_dg = read_raw_dg(fifodes);

#ifdef	SUNOS

	/* do we need to send to debugger? */

	if (debug_flag)
		send_dg_to_debugger(raw_dg);
#endif	SUNOS

	/* now decode the datagram */

	dg = decodedg(raw_dg);
	
	/* update stats */

	last_message_from = stralloc(dg->agent_name);

	/* print trace message if necessary */

#ifdef	SUNOS
	if (trace_flag AND sunview_flag) {
		char            buf[512];
		extern	void	update_trace();
		
		sprintf(buf,
			"Sequence  : %d From : %s To : %s Type : %s\n",
			num_msgs_switched,
			dg->agent_name,
			dg->addressee,
			dg_type_str[dg->dg_type]);
		update_trace(buf);

		if (strlen(dg->value) > 0) {
			sprintf(buf, "Value     : %s\n", dg->value);
			update_trace(buf);
		}
		update_trace(
"-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n");

	} else
#endif	SUNOS
	if (trace_flag) {
		fprintf(stderr,
			"rcvd from: %s to: %s type: %\n",
			dg->agent_name,
			dg->addressee,
			dg_type_str[dg->dg_type]);
		fprintf(stderr, "\n-----=-=-=-----\n");
	}
	/* send the message to process_message() */

	process_message(dg, raw_dg);

	/* free space */

	free_dg(dg);
	free_raw_dg(raw_dg);
}
