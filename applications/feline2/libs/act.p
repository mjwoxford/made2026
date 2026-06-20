
/* 	act.p
 *
 *	M J Wooldridge
 * 	September 1990
 *
 * 	The action function & definitions for feline agents.
 */
	
	/* default bindings for the theorem prover */
	
vars	cycle;

define	val_cycle();
	cycle;
enddefine;

vars	feline_default_bindings feline_conditional_matchs
	feline_script_rules feline_strategy_rules feline_base_beliefs;
	
[
	[_cycle val_cycle]
] -> feline_default_bindings;

	/* conditional match definitions */
	
[] -> feline_conditional_matchs;
	
	/* define the script rules */
	
[ 
	[ request [_agent _hyp]
		implies wants [_cycle _agent _hyp]
	]
	[ inform [_hyp _value] 
		implies has_asserted [_cycle _agent _hyp _value]
	]
	[ requested_startup []
		implies request_to_startup[_cycle]
	]
] -> feline_script_rules;

	/* strategy rules -- define behaviour */
	
[
	[ wants [_cycle _agent _hyp]
		implies evaluate_for [_cycle _agent _hyp]
	]
	[ has_asserted [_cycle _agent _hyp _value]
		implies assert [_cycle _hyp _value]
	]
	[ request_to_startup [_cycle]
		implies startup [_cycle]
	]
] -> feline_strategy_rules;
	
		/* base beliefs TO DO - incorporate model */
		
[
	[initialise [1]]	;;; to start things going
] -> feline_base_beliefs;

vars	AGENT HYP VALUE	;	/* keep matcher quiet */

define	act(base_set, n);

	lvars base_set n value;
	
	/* only 4 types of actions are recognised:
 	 *	- initialise []
 	 *		(the initial does this straight away)
 	 *	- startup
 	 *		call startup function
 	 *	- evaluate_for [hyp agent]
 	 *		 causes evaluation of a fact & response sent
 	 *	- asserted [hyp val]
 	 *		causes fact to be asserted & forward chaining to begin
 	 */
 	 

 	 if base_set matches [== [evaluate_for [^n ?AGENT ?HYP]] == ] then
 	 	evaluate(HYP) -> value;
 	 	pop11_send(AGENT, MADE_DG_USER, [response [^HYP ^value]]);
 	 elseif base_set matches [ == [assert [^n ?HYP ?VALUE]] == ] then
 	 	assert(HYP,VALUE);
 	 	meta_chain();
 	 elseif base_set matches [ == [ startup [^n]] == ] then
 	 	startup();
 	 elseif base_set matches [ == [initialise [^n]] == ]
 	 	and not(isundef(initialise)) then
 	 	initialise();
 	 endif;
 enddefine;
 	 
