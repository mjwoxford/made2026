/*	interfaces/pop11/std_comms.p
 *	
 *	M J Wooldridge
 *	January 1991
 *
 *	Basic message handling functions 
 */
 
	/* load the raw I/O fns */

compile('$made/interfaces/pop11/pop11cint.p');

	/* now the variable/constant declarations */
	
vars		made_msg_queue 	= [];		/* the internal msg queue */

constant	made_max_num_msgs = 10;		/* max no of msgs */

constant	made_sa_user_io	= 'reader';	/* system agents */
constant	made_sa_awm	= 'wintool';	/* window manager */

	/* datagram types for system agents */

constant	MADE_DG_USER	= 4;		/* general user msg */	
constant	MADE_DG_INPUT	= 4;		/* input request */
constant	MADE_DG_OUTPUT	= 6;		/* output request */
constant	MADE_DG_STATUS	= 5;		/* update status window */


	/* updates the internal msg queue */

define	made_update_msg_queue();

	lvars	msg;
	
	if	(pop11_get_raw_num_msgs() > 0) and 
		(length(made_msg_queue) < made_max_num_msgs)
	then
		until	(pop11_get_raw_num_msgs() = 0) or
			(length(made_msg_queue) = made_max_num_msgs)
		do
			[% pop11_raw_receive(); %] -> msg;
			[ ^^made_msg_queue ^msg] -> made_msg_queue;
		enduntil;
	endif;
enddefine;

	/* the standard way of sending msgs */

define	pop11_send(ag,dgt,val);

	lvars ag dgt val;
	
	pop11_raw_send(ag,dgt,val);
	made_update_msg_queue();
enddefine;

	/* the standard way of receiving msgs */

define	pop11_receive() -> ag -> dgt  -> val;

	lvars	ag dgt val msg;
	
	/* TO DO:
		- change msgs to lists ??
	*/
	
	made_update_msg_queue();
	
	if (length(made_msg_queue) > 0) then
	
		hd(made_msg_queue) -> msg;
		tl(made_msg_queue) -> made_msg_queue;
		
		msg(1) -> ag;
		msg(2) -> dgt;
		msg(4) -> val;
		
	else	/* don't block */
		[] ->> ag ->> dgt ->> val;
	endif;
enddefine;

	/* return the numbver of msgs on internal queue */
	
define	pop11_get_num_msgs() -> num_msgs;

	lvars num_msgs;

	made_update_msg_queue();
	
	length(made_msg_queue) -> num_msgs;
enddefine;

	/* now move on to system agent handling functions */
	
define	pop11_output_request(text);

	lvars	text;
	
	pop11_send(made_sa_user_io, MADE_DG_OUTPUT, text);
	made_update_msg_queue();
enddefine;

define	pop11_input_request() -> val;

	lvars agt dgt val;
	
	pop11_send(made_sa_user_io, MADE_DG_INPUT, '');
	
	/* TO DO
		- this should not be raw I/O
	 */
	 
	 pop11_raw_receive() -> agt -> dgt  -> val;
enddefine;
	
vars	current_status 
	current_goal   
	current_action 
	old_status ;

	'' ->> current_status ->> current_goal ->> current_action;
	
define	update_status();

	lvars new_status;
	
	current_status >< '%' >< current_goal >< '%'
		>< current_action -> new_status;
		
	if new_status /= old_status then
		pop11_send(made_sa_awm, MADE_DG_STATUS, new_status);
		new_status -> old_status;
	endif;
	
enddefine;
