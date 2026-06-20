;;; startup.p
;;;
;;; M J Wooldridge
;;;
;;; Jan 1990
;;;
;;; The startup routine for servers in distributed knowledge bases.
;;;

;;;	Set up the environment variables

MIXED_MODE 	-> strategy;
DISTRIBUTED	-> operation_mode;
WINDOW		-> terminal_mode;

;;;	Now the generic startup() function

define  startup(anam);

    vars    anam val_nam value;

    pop11_register(anam);

	
    while true do

	/* is agent window is open then update status/goal */

	'Sleeping' -> current_status;
	'Waiting for request' -> current_action;
	' * None *' -> current_goal;

	update_status();

        pop11_serve() -> val_nam;

        if val_nam = "restart" then
            "ok" -> value;
            clear();
        else

	    	/* if agent window is open then update goal etc */

		'Evaluate '>< val_nam -> current_goal;
		'Active' -> current_status;
		update_status();

            	evaluate(val_nam) -> value;

        endif;
        pop11_respond(val_nam , value);

    endwhile;
enddefine;
