
/*  	applications/feline/libs/shell_defs.p
 *
 *  	M J Wooldridge
 *  	January 1990
 *
 *	Definitions for the POP-11 Expert System Shell for DAI systems.
 */

    /* First the various global variables */

vars
        fired questions questionbase rulebase rules metarules metarulebase
	facts vals valbase;
 
    /* Now the flags options */

vars
	dist_trace_flag fc_flag trace_flag mrc_flag wintool_flag;

    /* Now the system configuration */

vars
	strategy terminal_mode operation_mode;

	/* The Variables for wintool */

vars
	current_status current_goal current_action old_status;

	'Active' -> current_status;
	'* None *' -> current_action;
	'* None *' -> current_goal;

    /* Now finally some vars to keep the compiler quiet */

vars
        startup isfact getfact assert fact pop11_register pop11_output_request
        pop11_input_request update_status
	pop11_send pop11_raw_receive val evaluate clear
	remote get_agent_who_knows meta_chain investigate serve 
	MADE_DG_USER;      

    	/*  Now declare the constants for the inference strategy */

constant    MIXED_MODE         = 1;
constant    FORWARD_ONLY       = 2;
constant    FORWARD_BACKWARD   = 3;
constant    BACKWARD_ONLY      = 4;

    	/* Now constants to define the operation - distributed or stand alone */

constant    STAND_ALONE     = 1;
constant    DISTRIBUTED     = 2;

    	/* Now constants which define the environment - sunview/line mode */

constant    TERMINAL        = 1;
constant    WINDOW          = 2;
	
	/* THE END */
