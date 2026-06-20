/*	pop11cint.p
 *
 *	M J Wooldridge
 *	January 1990
 *
 *	The Raw POP-11 / `C' Language interface for agents.
 */


uses    c_dec;

external_load('agents',
    	['$made/interfaces/c/libdkb.a'],
    	[
    		[ _aregister AREGISTER ]
    		[ _send SEND ]
    		[ _receive RECEIVE ]
    		[ _get_num_msgs GET_NUM_MSGS ]
    		[ _die DIE ]
	]
);

;;;     Constant declarations (cf "include/dg.h")

constant    MADE_DG_ERR        	= 0;
constant    MADE_DG_REGI       	= 1;
constant    MADE_DG_REM_REGI   	= 2;
constant    MADE_DG_DIED       	= 3;
constant    MADE_DG_USER	= 4;

;;;	This variable contains the name of the sender of the last message.

vars	last_message_sender;

/*	
 *	Now some utility funcitons to convert between strings and
 *	pop-11 objects.
 */

	;;;     The string types required to talk to C

vectorclass 	madestr:8;		/* 8 bit data items ... */
constant    	MADE_STR_LEN = 256;	/* length of string 256 chars */

/*
 *	Now the high level functions which hide what goes on underneath.
 */

vars net_str_index ;

define  netstr2object(idx,str) -> retval;

	lvars idx item str string_val posn;

	define str2item(instring) -> outitem;
		vars getter;
		incharitem(stringin(instring)) -> getter;
		getter() -> outitem;
	enddefine;


	if str(idx) = 91 then	 /* [ */

		/* object is a list */

		idx + 1 -> idx;

		[%
			while not(str(idx) = 93) do
				netstr2object(idx,str);
				net_str_index -> idx;
			endwhile;
		%] -> retval;

		1 + idx -> idx;
		while(idx <= MADE_STR_LEN) and (str(idx) = 32) do
			idx + 1 -> idx;
		endwhile;
		idx -> net_str_index;
	else

		/* first skip past spaces etc */

		while (idx <= MADE_STR_LEN) and (str(idx) = 32) do
			1 + idx -> idx;
		endwhile;

		/* now get the length of the item */

		if(str(idx) /= 91) and (str(idx) /= 93) then

			idx -> posn;

			while
				(idx <= MADE_STR_LEN) and 
				(str(idx) /= 32) and
				(str(idx) /= 91) and 
				(str(idx) /= 93) and (str(idx) /= 0)
			do
				str(idx);
				1 + idx -> idx;
			endwhile;

			if idx /= posn then
				consstring(idx - posn) -> string_val;
				str2item(string_val) -> retval;

				/* return the values true/false if reqd */

				if retval = "true" then
					true -> retval;
				elseif retval = "false" then
					false -> retval;
				endif;
			endif;

			/* now get to the next interesting character */

			while((idx <= MADE_STR_LEN) and (str(idx) = 32)) do
				1 + idx -> idx;
			endwhile;
		endif;

		/* now change the posn of the index */

		idx -> net_str_index;

	endif;
enddefine;

/*
 *	pop11_register(...) takes one argument, a word - the name of the
 *	agent - and registers it with the system.
 */

define  pop11_register(nm);

    vars nm name;

    nm >< '\^@' -> name;

    AREGISTER(name,1,false);

enddefine;


;;; pop11_raw_send(...) is now getting to the meat of the system!

define  pop11_raw_send(ag,dgt,val);

    	lvars agent dgtype value;

	/* translate true/false to network form */

	if val = true then
		"true" -> val;
	elseif val = false then
		"false" -> val;
	endif;

    	ag >< '\^@' -> agent;
	val >< '\^@' -> value;
	
    	SEND(agent,dgt,value,3,false);

enddefine;

;;; pop11_raw_receive() returns 2 values -- datagram type and value

define  pop11_raw_receive() -> agent -> dgtype -> value;

    lvars ext_str1 ext_str2 agent dgtype value;

    initmadestr(MADE_STR_LEN) -> ext_str1;
    initmadestr(MADE_STR_LEN) -> ext_str2;

    RECEIVE(ext_str1, ext_str2,  2, true) -> dgtype;

    netstr2object(1, ext_str1) -> agent;
    netstr2object(1, ext_str2) -> value;

	agent -> last_message_sender;

enddefine;

;;; pop11_get_num_msgs() returns the number of messages on the input
;;; queue

define  pop11_get_raw_num_msgs() -> retval;

    GET_NUM_MSGS(0,true) -> retval;

enddefine;

/*
 *	pop11_die() takes no arguments, but registers the death of an agent
 * 	with the system
 */

define  pop11_die();

    DIE(0, false);

enddefine;

/*	THE END */
