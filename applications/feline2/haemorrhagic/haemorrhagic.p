/*  haemorrhagic.p
 *
 *  Rebecca Elks
 *
 *  August 1990
 *
 *  Main program for the 'Haemorraghic Anaemia' agent
 */

vars	feline_agent_name = "haemorrhagic";

   	 /* first load the shell */

compile('../libs/shell.p');

	/* now load the environment model */

compile('../haemorrhagic/haemorrhagic_model.p');

    	/* now load the rules */

compile('../haemorrhagic/haemorrhagic_rules.p');

    /* now the startup function */

define  startup();

	;;; true -> trace_flag;
	false -> mrc_flag;	;;; disable meta rules
	false -> fc_flag; 	;;; disbale forward chaining

    	investigate([git haematuria haematemesis warfarin duration]);
	true -> mrc_flag;	;;; enable forward chaining
	
    	meta_chain();
enddefine;

	/* now load the main function */

compile('../libs/main.p');

main(	feline_script_rules,
	feline_strategy_rules,
	feline_base_beliefs,
	feline_default_bindings,
	feline_conditional_matchs
);
	

