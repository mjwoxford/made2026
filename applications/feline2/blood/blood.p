
/*  blood.p
 *
 *  Rebecca Elks
 *
 *  July 1990
 *
 *  Main program for the 'blood' agent
 */

vars	feline_agent_name = "blood";

	/* now load the rules */
	
compile('../libs/shell.p');
compile('../blood/blood_rules.p');

	/* now the startup function */

define  startup();

	;;; true -> trace_flag;
	false -> fc_flag;
	investigate(
	[
		hb_normal hb_low   pcv_normal pcv_low pcv_high
	]);

enddefine;

	/* load the main function */

compile('../libs/main.p');

	/* now go */

main(	
	feline_script_rules,
	feline_strategy_rules,
	feline_base_beliefs,
	feline_default_bindings,
	feline_conditional_matchs);
	
);

