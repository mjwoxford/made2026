
;;;     prologcint.pl
;;;
;;;     M J Wooldridge
;;;     February 1990
;;;
;;;     Predicates to form the PROLOG / `C' Interface
;;;

;;; First get the `languages' library

:- library(languages).

POP11

;;; Now go into POP-11 and define the POP-11 Interface functions

uses    c_dec;

external_load('agents',
    ['libdkb.a'],
    [
        [ _aregister AREGISTER ]
        [ _arequest AREQUEST ]
        [ _serve SERVE ]
        [ _respond RESPOND ]
        [ _die DIE ]
    ]);


;;;     Now the high level functions which hide what goes on underneath.

;;;     pop11_register(...) takes one argument, a word - the name of the
;;; agent - and registers it with the system.

define  pop11_register(nm) -> retval;       ;;; must return a value

    vars nm name;

    if isword(nm) then
        nm >< '\^@' -> name;
    else
        nm -> name;
    endif;

    AREGISTER(name,1,false);

    true -> retval;

enddefine;


;;;     pop11_arequest(...) takes two arguments, both words, the name of a
;;; remote agent and a value name, and requests that value from the remote
;;; agent. The value returned by the remote agent is returned with
;;; conversion done.

vectorclass dkbstr:8;
constant    DKB_STR_LEN = 256;

define  pop11_arequest(ag, nm) -> retval;

    vars    retval ext_str agent name strindex = 1 ;

    initdkbstr(DKB_STR_LEN) -> ext_str;

    if isword(nm) then
        nm >< '\^@' -> name;
    endif;

    if isword(ag) then
        ag >< '\^@' -> agent;
    endif;

    AREQUEST(agent, name, ext_str, 3, false);

    while (strindex <= DKB_STR_LEN) and (ext_str(strindex) /= 0) do
        ext_str(strindex);     ;;; put on stack
        strindex + 1 -> strindex;
    endwhile;

    consstring(strindex - 1) -> retval;

    if retval = '<true>' then
        true -> retval;
    endif;

    if retval = '<false>' then
        false -> retval;
    endif;

    if isstring(retval) then
        consword(retval) -> retval;
    endif;

enddefine;

;;;     pop11_respond(...) takes two arguments, the first should be a word,
;;; and sends the value (the second argument) back to the requesting
;;; agent.

define  pop11_respond(valnam, val) -> retval;

    vars     valnam val valuename value retval;

    if isword(valnam) then
        valnam >< '\^@' -> valuename;
    endif;

    val >< '\^@' -> value;

    RESPOND(valuename, value, 2, false);

    true -> retval;

enddefine;

;;;     pop11_serve() takes no arguments but listens for requests. The return
;;; value is the name of a value required.

define  pop11_serve() -> retval;

    vars    retval ext_str strindex = 1 ;

    initdkbstr(DKB_STR_LEN) -> ext_str;

    SERVE(ext_str, 1, false);

    while (strindex <= DKB_STR_LEN) and (ext_str(strindex) /= 0) do
        ext_str(strindex);     ;;; put on stack
        strindex + 1 -> strindex;
    endwhile;

    consstring(strindex - 1) -> retval;

    consword(retval) -> retval;

enddefine;

;;;     pop11_die() takes no arguments, but registers the death of an agent
;;; with the system

define  pop11_die() -> retval;

    vars retval;

    DIE(0, false);

    true- > retval;

enddefine;

PROLOG

;;;     prolog_register(...) is the register predicate

prolog_register(Name,Dummy) :-
    Dummy is pop11_register(Name),
    !.

;;;     prolog_arequest(...) is the addressed request predicate.

prolog_arequest(Agent,Name,Value) :-
    Value is pop11_arequest(Agent,Name),
    !.

;;;     prolog_respond(...) is the respond to request predicate

prolog_respond(Name,Value,Dummy) :-
    Dummy is pop11_respond(Agent,Name),
    !.

;;;     prolog_die(...) is the die gracefully predicate

prolog_die(Dummy) :-
    Dummy is pop11_die.

TOP

;;; End of file
