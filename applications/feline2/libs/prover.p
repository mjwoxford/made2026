/*	prover.p
 *	
 *	M J Wooldridge
 *	November 1990
 *
 *	Procedures for the L0 theorem prover
 */
 
 	/* needed for matcher */

global vars	match_goal match_rem match_antecedents 
		match_consequents subst_2 satisfying_args proc prover;
		
	/* set up the section */
	
section	$prover => compile_ruleset dclose;

/* generate_default_bindings()
 *	Takes a list of default bindings definitions:
 *	[	[ name-1 proc-1]
 *		[ name-2 proc-2]
 *		.
 *		.
 *		.
 *	]
 *	where:
 *		-name-n is the name of the binding (e.g., _cycle)
 *		-proc-n is a procedure which returns the value for the binding.
 */
 
define	generate_default_bindings(default_bindings_defn) -> default_bindings;

	lvars default_bindings_defn default_bindings binding proc name val;
	
	[%	for binding in default_bindings_defn do
			binding(1)	-> name;
			binding(2)	-> proc;
			valof(proc)()	-> val;
			[^name ^val] ; 	/* leave on stack */
		endfor;
	%] -> default_bindings;
	
enddefine;

/* isconditional_match()
 *	Takes two arguments:
 *		- a variable name
 *		- a set of conditional match definitions
 */
 
define isconditional_match(varname, conditional_match_defn) -> boolean;

	lvars varname conditional_match_defn boolean;
	
	conditional_match_defn matches [== [^varname =] ==] -> boolean;
enddefine;

/* generate_possible_bindings()
 *	Takes two arguments, each lists of the form:
 *		[drunk [_x]]				
 *				(a functor)
 *		[ [drunk [dave]] [drunk [tim]] ]	
 *				(base set of facts)
 *	and returns:
 *		[ [drunk [_x]] [ [[_x dave]] [[_x tim]] ] ]
 *				(all possible bindings that satisfy functor)
 */
 
 define	generate_possible_bindings(base_set, functor, conditional_match_defn) -> possible_bindings;
 
 	lvars base_set functor possible_bindings conditional_match_defn
 		functor_head functor_args binding bindings_list soln flag;
 	
 	/* a local function to perform conditional matching */
 	
 	define	conditional_match(subst, conditional_match_defn) -> boolean;
 	
 		lvars subst conditional_match_defn boolean
 			variable const;
 			
 		subst(1) -> variable;
 		subst(2) -> const;
 		
 		unless conditional_match_defn matches [== [^variable ?proc]==] then
 			mishap('Bad conditional match', [^subst]);
 		endunless;
 		
 		valof(proc)(const) -> boolean;
 	enddefine;
 	
 	/* a local function to return the set of substitutions */
 	
 	define	generate_substitution_list(f_args, s_args, conditional_match_defn) -> subst_list -> flag;
 	
 		lvars f_args s_args conditional_match_defn subst
 			flag lst fa sa subst_list count ;
 		
 		/* takes:	[_x _y]
 		 * and		[dave tim]
 		 * returns:	[[_x dave] [_y tim]]
 		 */
 		
 		if length(f_args) /= length(s_args) then
 			mishap('Arity mismatch!', [^f_args ^s_args]);
 		endif;
 		
 		[%
 			for count from 1 to length(f_args) do
 				f_args(count) -> fa;
 				s_args(count) -> sa;
 				[^fa ^sa];	/* leave on stack */
 			endfor;
 		%] -> subst_list;
 		
 		/* now check any conditional matches */
 		
 		true -> flag; ;;; here!!

 		for subst in subst_list do
 			if isconditional_match(subst(1), conditional_match_defn) then
 				conditional_match(subst, conditional_match_defn) -> flag;
 			endif;
 			quitif(not(flag));
 		endfor;
  	enddefine;
 	
 	/* now the function proper */
 	
 	base_set -> database;
 	functor(1) -> functor_head;	/* eg "drunk" */
 	functor(2) -> functor_args;	/* eg [_x _y] */
 	
  	[%
 		foreach [ ^functor_head ?satisfying_args ] do
 				generate_substitution_list(
 					functor_args,
 					satisfying_args,
 					conditional_match_defn) 
 						-> soln -> flag;
 				if flag then
 					soln;
  				endif;	
 		endforeach;
 	%] -> bindings_list;
 	 	
 	[ ^functor ^bindings_list ] -> possible_bindings;
enddefine;

/* generate_satisfying_solutions()
 * 	takes a rule structure such as that produced by the above function,
 *	and generates sets of bindings which will satisfy the rule.
 * 	these will appear as the third item in the rule structure returned
 *	NB - [] returned if no solutions.
 *	The second argument is a defaults definition list (see above).
 */
 	
define	generate_satisfying_solutions(rule_structure, default_defn, conditional_match_defn) -> rule_structure;

	lvars rule_structure goal_list flag solution default_defn goal
		possible_solution satisfying_solutions 
		conditional_match_defn product;
		
	/* a utility procedure to take a list of lists and generate
 	 * the cartesian product of the inner lists
 	 */

	define	generate_product(goal_list, default_defn) -> product;
	
		lvars goal_list product goal each binding flag;
		
		/* the default bindings are the first goal */
		
		[% generate_default_bindings(default_defn) %] -> product;
		
		true -> flag;
		
		for goal in goal_list do
		
			if product = [] then
				 goal(2)  -> product; 
			else
			[%	for each in product do
					for binding in goal(2) do 
						if flag then
							[^each ^binding];
						else	
							[^^each ^binding];
						endif;
					endfor;
				endfor;	
				false -> flag;
			%] 	-> product;
			endif;
		endfor;
		
	enddefine;

	
	/* now another utility function */
	
	define generate_satisfying_bindings(possible_solution, conditional_match_defn) -> binding_set -> flag;
	
		lvars possible_solution conditional_match_defn
			binding_set current_bindings flag count;
		
		/* unify_bindings()
		 *	Takes two arguments, lists of the form:
		 *		[[ _x dave] [_y jim]]
		 *		[[_x dave]]
		 *	and attempts to unify them.
		 */
		 
		define	unify_bindings(bindings_1, bindings_2, conditional_match_defn) -> bindings_set -> can_unify_flag;

			lvars 
				bindings_1 bindings_2 
				conditional_match_defn var_1 var_2  binding
				subst_1  bindings_set can_unify_flag ;
			
			true -> can_unify_flag;
	
			[%
				bindings_2 -> database;
				
				for binding in bindings_1 do
				
					binding(1) -> var_1; 
					binding(2) -> subst_1; 
					
					/* if the match is conditional, then
					 * don't leave the conditional binding
					 * on the stack 
					 */
					 
					unless isconditional_match(var_1, conditional_match_defn) then
					
						if (database matches [== [^var_1 ?subst_2 ] ==]) then
							if (subst_1 = subst_2) then
								binding;  	/* leave on stack */
							else	
								false -> can_unify_flag;
							endif;
						else
							binding;		/* leave on stack */
						endif;
						
					endunless;
				endfor;
		
				if can_unify_flag then
					bindings_1 -> database;
					for binding in bindings_2 do
					
						binding(1) -> var_2;
						
						/* is the match is conditional,
						 * then don't leave the
						 * binding on the stack
						 */
						 
						unless isconditional_match(var_2, conditional_match_defn) then
						
							if not(database matches [== [^var_2 =] ==]) then
								binding;
							endif;
						endunless;
						
					endfor;
				endif;
			%] -> bindings_set;
	
			if not(can_unify_flag) then
				[] -> bindings_set;
			endif;
	
		enddefine;

		/* now the generate satisfying bindings function proper */
		
		true -> flag;
		[] -> binding_set;
		possible_solution(1) -> current_bindings;
		
		for count from 2 to length(possible_solution) do
		
			unify_bindings(current_bindings, possible_solution(count), conditional_match_defn) -> current_bindings -> flag;
			quitif(not(flag));
			
		endfor;

		if flag then
			current_bindings -> binding_set;
		endif;
	enddefine;
	
	/* now the generate satisfying solutions function */
	
	rule_structure(2) -> goal_list;
	
	/* before going any further, check that there is at
	 * least ONE set of bindings for every funcotr with arity <> 0
	 */
	 
	true -> flag;
	
	for goal in goal_list do
		if 	(length(hd(tl(hd(goal)))) /= 0) and
			(length(hd(tl(goal))) = 0)
		then
			[^^rule_structure []] -> rule_structure;
			return();
		endif;
	endfor;
	
	/* there is at least one solution for every functor with arity <> 0
	 * so we now have to exhaustively check 
	 * all possible combinations of goal solutions
	 */

	generate_product(goal_list, default_defn) -> product;
	
	/* now check each possible solution */
	
	[% 	for possible_solution in product do
			generate_satisfying_bindings(possible_solution, conditional_match_defn) -> solution -> flag;
			if flag then
				solution;
			endif;
		endfor;
	%] -> satisfying_solutions;
	
	[^^rule_structure ^satisfying_solutions ] -> rule_structure;
	
enddefine;

/* generate_consequences()
 *	Takes a rule structure such as that returned by the
 *	previous function, and attempts to generate the
 * 	set of facts which will correspond to the satisfying solutions.
 *	These will appear as the fourth item in the returned rule structure.
 *	NB - [] if no solutions.
 */
  
define	generate_consequences(rule_structure) -> new_rule_structure;

	lvars consequence_list solution_list consequence solution
		new_fact new_facts binding new_rule_structure ;
		
	/* some utility functions */
	
	/* replace_all() replaces all occurences of
	 * its first argument in its second argument by its third
	 * argument.
	 */
	
	define replace_all(varbl, const, term) -> new_term;
	
		lvars const varbl term new_term temp_1 temp_2;
		
		/* isin() is a strong member() */
		
		define isin(at, arg) -> boolean;
		
			lvars at arg boolean;
			
			if arg = [] then
				false -> boolean;
			elseif at = arg then
				true -> boolean;
			elseif islist(arg) then
				isin(at,hd(arg)) or isin(at,tl(arg)) -> boolean;
			else
				false -> boolean;
			endif;
		enddefine;
	
		/* now the replace all function proper */
		
		if term = [] then
			[] -> new_term;
		elseif varbl = term then
			const -> new_term;
		elseif isword(term) then
			term -> new_term;
		elseif isin(varbl,term) then
			replace_all(varbl, const, hd(term)) -> temp_1;
			if isin(varbl, tl(term)) then
				replace_all(varbl, const, tl(term)) -> temp_2;
			else
				tl(term) -> temp_2;
			endif;
			temp_1 :: temp_2 -> new_term;
		else
			term -> new_term;
		endif;
	
	enddefine;
	
	/* substitute() 
	 * takes:	[_x dave]	(a substitution)
	 * and:		[drunk [_x]]	(a term)
	 * and performs the substituion using replace_all() -- see above.
	 */
	 
	define substitute(substitution, term) -> new_term;
	
		lvars substitution term variable const new_term;
		
		substitution(1) -> variable;
		substitution(2) -> const;
		
		replace_all(variable, const, term) -> new_term;
	enddefine;
	
	/* now the generate consequences function */
	
	rule_structure(1) -> consequence_list;
	rule_structure(3) -> solution_list;
	
	[%	for consequence in consequence_list do
			for solution in solution_list do
				consequence -> new_fact;
				for binding in solution do
					substitute(binding, new_fact) -> new_fact;
				endfor;
				new_fact; /* leave on stack */
			endfor;
		endfor;
	%] -> new_facts;
	
	[^^rule_structure ^new_facts ] -> new_rule_structure;
enddefine;

/* can_fire()
 *	Takes three arguments arguments: 
 *	[	
 *		[[drunk [_x]]]		;;; consequent list
 *		[
 *			[drunk [_x]]
 *			[stoned [_x]]
 *		]			;;; antecedent sequence
 *	]				(goal list form rule)
 *
 *	[
 *		[drunk [dave]]
 *		[stoned [dave]]
 *	]				(base set of facts)
 *
 *	- and a defaults definition list (see above)
 *	and returns rule structure containing consequents.
 */
 
define	can_fire(base_set, goal_list_rule, defaults_defn, conditional_match_defn) -> rule_structure;

	lvars base_set goal_list_rule rule_structure primary_goal
		antecedents consequents sat_goals defaults_defn
		conditional_match_defn;
		
	goal_list_rule(1) -> consequents;
	
	/* generate all possible satisfactions for each primary goal */
	
	[% 	for primary_goal in goal_list_rule(2) do
			generate_possible_bindings(
				base_set, 
				primary_goal,
				conditional_match_defn);
		endfor;
	%] -> sat_goals;
		
	/* now make a rule structure */
	
	[ ^consequents ^sat_goals ] -> rule_structure;
	
	/* generate bindings that satisfy the whole rule */
	
	generate_satisfying_solutions(rule_structure, defaults_defn, conditional_match_defn) -> rule_structure;
;;;	rule_structure==>
	/* finally, generate the consequences */
	
	generate_consequences(rule_structure) -> rule_structure;
enddefine;

/* assert()
 *	Takes two arguments:
 *		- a base set of facts
 *		- a new set of facts
 *	and does a `join' operation on them.
 */
 
define	assert(base_set, new_facts) -> new_base_set;

	lvars base_set new_facts new_base_set fact;
	
	base_set -> database;
	
	for fact in new_facts do
		if not(present(fact)) then
			add(fact);
		endif;
	endfor;
	
	database -> new_base_set;
enddefine;

/* add_fact()
 *	Does the same as asert (see above) but with a single fact.
 */
 
define	add_fact(base_set, new_fact) -> new_base_set;

	lvars base_set new_fact new_base_set;
	
	assert(base_set, [^new_fact]) -> new_base_set;
enddefine;

/* dclose()
 *	A crucial one, this. Takes a base set of facts and a rule-set
 *	and generates the deductive closure of the two. Third argument is
 *	a defaults definition list.
 */
 
define	dclose(base_set, rule_set, defaults_defn, conditional_match_defn) -> new_fact_set;

	lvars base_set rule_set new_fact_set old_length new_length
		rule rule_structure defaults_defn conditional_match_defn;
		
	base_set -> new_fact_set;
	length(new_fact_set) -> old_length;
	-1 -> new_length; /* just to start things off */
	
	until (old_length = new_length) do
		length(new_fact_set) -> old_length;
		for rule in rule_set do
			can_fire(new_fact_set, rule, defaults_defn, conditional_match_defn) -> rule_structure;
			assert(new_fact_set, rule_structure(4)) -> new_fact_set;
		endfor;
		length(new_fact_set) -> new_length;
	enduntil;
enddefine;

/* compile_rule()
 *	Takes a rule in human readable format, which may be one of:
 *		[ P[a b c] and ... implies S[j k l] and ... ]
 *	or
 *		[ S[j k l] and ... if P[a b c] and ... ]
 *	or
 *		[ if P[a b c] ... then S[j k l] and ... ]
 *	or
 *		[ S[j k l] and ... :- P[a b c] and...]
 *	and compiles it into the goal-list form of rules manipulated
 *	by functions like can_fire() (see above).
 */
 
define	compile_rule(rule) -> goal_list_rule;

	lvars antecedent_list consequent_list;
	
	define compile_and_list(and_list) -> goal_list;
	
		lvars and_list goal_list ;
		
		[%	until null(and_list) do
				if and_list matches [??match_goal and ??match_rem] then
					match_goal; 	/* leave on stack */
				else
					and_list;	/* leave on stack */	
					[] -> match_rem;
				endif;
				match_rem -> and_list;
			enduntil;
		%] -> goal_list;
	enddefine;
	
	/* now the function proper */

	if rule matches [??match_antecedents implies ??match_consequents] or
	   rule matches [if ??match_antecedents then ??match_consequents] or
	   rule matches [??match_consequents if ??match_antecedents] or
	   rule matches [??match_consequents :- ??match_antecedents]
	then
		compile_and_list(match_antecedents) -> antecedent_list;
		compile_and_list(match_consequents) -> consequent_list;
	else
		mishap('badly formed rule' , [^rule]);
	endif;
	
	[^consequent_list ^antecedent_list] -> goal_list_rule;
enddefine;

/* compile_ruleset()
 *	Takes a set of (English) rules, and compiles each to produce a
 *	goal list rule-set acceptable to dclose() (see above).
 */

define	compile_ruleset(rule_set) -> goal_list_rule_set;

	lvars rule_set goal_list_rule_set;
	
	maplist(rule_set, compile_rule) -> goal_list_rule_set;
enddefine;

endsection;

/******************************************************************END OF FILE*/
