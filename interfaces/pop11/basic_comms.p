/*	basic_comms.p
 *
 *	M J Wooldridge
 *	January 1991
 *
 *	Application specific I/O functions:
 *		- Request
 *		- Respond
 *		- Inform
 */
 
	/* load the std_comms definitions */

compile('$made/interfaces/pop11/std_comms.p');

	/* Now some application specific functions */

	/* the name of a requesting agent */

vars	requesting_agent;

/*
 *	pop11_arequest(...) takes two arguments, both words, the name of a
 * 	remote agent and a value name, and requests that value from the remote
 *	agent. The value returned by the remote agent is returned with
 *	conversion done.
 */

define  pop11_request(ag, nm) -> retval;

    	vars    ag nm  msg;

    	pop11_raw_send(ag, MADE_DG_USER, [request ^nm]);
	pop11_raw_receive() -> ag -> type -> msg;
	if hd(msg) /= "response" then
		mishap('Unexpected message received after request', [^msg]);
	endif;
	msg(2) -> retval;
enddefine;

/*
 *	pop11_respond(...) takes two arguments, the first should be a word,
 *	and sends the value (the second argument) back to the requesting
 *	agent.
 */

define  pop11_respond(valnam, val);

    vars     valnam val;

    pop11_raw_send(requesting_agent, MADE_DG_USER, [response ^val]);

enddefine;

/*
 *	pop11_serve() takes no arguments but listens for requests. The return
 *	value is the name of a value required.
 */

define  pop11_serve() -> retval;

    vars    retval  dg_type value ;

	pop11_raw_receive() -> requesting_agent -> dg_type -> value;

	if  hd(value) /= "request" then
		mishap('Unexpected datagram type received when serving',
			[ value ]);
	endif;
	value(2) -> retval;
enddefine;

/*	pop11_ainform(...) informs a single agent of a hypothesis
 */

define  pop11_ainform(ag,vn,val);

    vars ag vn val ;

    pop11_raw_send(ag, MADE_DG_USER, [inform ^vn ^val]);

enddefine;

