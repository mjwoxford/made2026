
/* 	main.p
 *
 *	M J Wooldridge
 * 	September 1990
 *
 * 	The startup routine for servers in distributed knowledge bases.
 */

	/* Set up the environment variables */

MIXED_MODE 	-> strategy;
DISTRIBUTED	-> operation_mode;
WINDOW		-> terminal_mode;
true 		-> wintool_flag;

	/* some variable defs to keep compiler quiet */

vars	act initialise;

	/* Now load the various librarys */

	compile('$made/interfaces/pop11/std_comms.p');
	compile('../libs/act.p');
	compile('../libs/agent_shell.p');
	
	/* Now the generic startup() function m*/

define  initialise();

    	pop11_register(feline_agent_name);

	'Waiting for message' -> current_action;
	'Sleeping' -> current_status;
	'* None *' -> current_goal;
	
	update_status();
	
enddefine;

