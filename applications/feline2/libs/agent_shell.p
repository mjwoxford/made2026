/* 	agent_shell.p (V1.0)
 *
 *	M J Wooldridge
 *	December 1990
 *
 *	The shell for Co-operating Deliberate Agents
 */

	/* Only one global variable in this file - the cycle number */
	
vars	cycle;

	/* Now load the predicate logic functions (if required) */
	
vars generate_satisfying_solutions;

if isundef(generate_satisfying_solutions) then
	compile('../libs/prover.p');
endif;

/* main()
 *	The main loop for the CDA model. Takes n arguments:
 *	- a set of script rules (English form)
 *	- a set of belief rules (English form)
 *	- a set of base beliefs
 *	- a set of default bindings definitions
 *	- a set of tag (conditional match) definitions
 *	...
 */

define	main(s_rules, b_rules, base_set, def_defns, tag_defns);

	lvars s_rules b_rules base_set def_defns tag_defns
		message_facts gl_b_rules gl_s_rules;

	define	script(srules, defaults_defn) -> message_facts;

		lvars srules defaults_defn message_facts message temp
			sender type attrib;
	
		define set_diff(a,b) -> diff;
	
			lvars a b diff each;
			
			[%
				for each in a do
					if not(member(each, b)) then
						each;
					endif;
				endfor;
			%] -> diff;
		enddefine;
	
		pop11_raw_receive() -> sender -> type  -> message;
		dclose(message, srules, defaults_defn, []) -> temp;
		set_diff(temp,message) -> message_facts;
	
	enddefine;	

	define	update_base_set(message_facts, bs, br, dd, td) -> bs;
	
		lvars message_facts bs br dd td each;
	
		define	set_union(a, b) -> union;
		
			lvars a b union;
			
			[% 	for each in a do
					if not(member(each,b)) then
						each;
					endif;
				endfor;
			%] -> union;
		
			[ ^^b  ^^union] -> union;
		enddefine;
	
		set_union(message_facts, bs) -> bs;
		dclose(bs, br, dd, td) -> bs;
	enddefine;
	
	/* now the main function proper */
	
	1 -> cycle;

	/* compile the rule sets */
	
	compile_ruleset(s_rules) -> gl_s_rules;
	compile_ruleset(b_rules) -> gl_b_rules;

	repeat forever
	
		/* get & interpret message (but not on 1st cycle) */
		
		if cycle > 1 then
			/* get & interpret message */
			
			script(gl_s_rules, def_defns) -> message_facts;
			
			/* generate deductive closure */
			
			update_base_set(message_facts, base_set, gl_b_rules, def_defns, tag_defns) -> base_set;
		endif;

		/* act */
		
		act(base_set, cycle);
		
		/* update cycle number */
		
		1 + cycle -> cycle; 	 	
	endrepeat;
enddefine;

	
	
