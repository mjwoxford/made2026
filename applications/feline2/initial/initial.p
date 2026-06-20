
/*  initial.p
 *
 *  Rebecca Elks & Michael Wooldridge
 *  June 1990
 *
 *  The control functions of the agent `initial'
 */

vars	feline_agent_name = "initial";

	/* first thing! close the base window */

pwm_close_window(pwmbasewindow);

	/* load the expert system shell */

compile('../libs/shell_defs.p');
compile('../libs/shell.p');

	/* load the rules */

compile('../initial/initial_rules.p');

	/* load the screen handling procedures */

compile('../initial/initial_screen.p');

	/* the following function sets up data screens etc */

define  initialise();
	
	/* fisrt the local function startup() */
	
	define	startup();
	
		/* compile standard comms functions */

		compile('$made/interfaces/pop11/std_comms.p') ;
	
		/* register with the server */

		pop11_register("initial");

		/* change mode to distributed */
	

		false -> fc_flag;
		DISTRIBUTED 	-> operation_mode;
		WINDOW		-> terminal_mode;
		true 		-> wintool_flag;

		/* reselect this if you want a trace */

		;;;true -> trace_flag;

		/* print a message to the effect that things are starting */

		pr1(
		[
			'\tWelcome to FELINE!\n\t-----------------\n\n'
			'I will now look at the clinical signs...\n'
		]);

		/* data now stored safely, so start the investigate process*/

		evaluate("not_likely_anaemia");
	enddefine;	
	
	/* now set the initial function proper */

	MIXED_MODE -> strategy;

	;;; clear working memory

	clear();
	
	/* display intro screens, etc */
	
	get_initial_data();
	
	/* now call startup */
	
	startup();
	
enddefine;

	/* now get things going */
	
compile('../libs/act.p');

compile('../libs/agent_shell.p');

	/* and start... */

main(	feline_script_rules,
	feline_strategy_rules,
	feline_base_beliefs,
	feline_default_bindings,
	feline_conditional_matchs
);
	
