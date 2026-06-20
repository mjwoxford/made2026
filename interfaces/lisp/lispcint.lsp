;;; lispcint.lsp
;;;
;;; M J Wooldridge
;;; January 1990
;;;
;;; Common LISP / `C' Interface
;;;     -Requires the POP-11 / `C' Interface to be available
;;;     -Currently (14/1/90) only deals with true/false values

;;; First switch to POP-11 at the top level

(pop11)

;;; Now load the POP-11 to C interface

uses    c_dec;

external_load('agents',
    ['libdkb.a'],
    [
        [ _aregister AREGISTER ]
        [ _arequest AREQUEST ]
        [ _serve SERVE ]
        [ _respond RESPOND ]
        [ _die DIE ]
    ],
    128000);

;;;     Now the high level functions which hide what goes on underneath.

;;;     pop11_register(...) takes one argument, a word - the name of the
;;; agent - and registers it with the system.

define  pop11_register(nm);

    vars nm name;

    length(nm) -> len;
    explode(nm);
    0;
    len + 1 -> len;
    consstring(len) -> name;

    AREGISTER(name,1,false);

enddefine;


;;;     pop11_arequest(...) takes two arguments, both words, the name of a
;;; remote agent and a value name, and requests that value from the remote
;;; agent. The value returned by the remote agent is returned with
;;; conversion done.

vectorclass dkbstr:8;
constant    DKB_STR_LEN = 256;

define  pop11_arequest(ag, nm) -> retval;

    vars    retval len ext_str agent name strindex = 1 ;

    initdkbstr(DKB_STR_LEN) -> ext_str;

    length(nm) -> len;
    explode(nm);
    0;
    consstring(len + 1)->name;

    length(ag) -> len;
    explode(ag);
    0;
    consstring(len + 1) -> agent;

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

enddefine;

;;;     pop11_respond(...) takes two arguments, the first should be a word,
;;; and sends the value (the second argument) back to the requesting
;;; agent.

define  pop11_respond(valnam, val);

    vars     valnam val len valuename value ;

    length(valnam) -> len;
    explode(valnam);
    0;
    consstring(len + 1)->valuename;

    if val then
        '<true>' -> val;
    else
        '<false>' -> val;
    endif;

    length(val) -> len;
    explode(val);
    0;
    consstring(len + 1)-> value;

    RESPOND(valuename, value, 2, false);

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

enddefine;

;;;     pop11_die() takes no arguments, but registers the death of an agent
;;; with the system

define  pop11_die();

    DIE(0, false);

enddefine;

;;; Now switch back to Common LISP

lisp

;;; Now hide the messiness of it by high level LISP routines

;;;     (lisp_register ...) is the function that registers the agent with
;;; the system

(defun lisp_register (nm)
        (pop11:pop11_register (string nm))
)

;;;     (lisp_arequest ...) allows a LISP agent to make an addressed reqest
;;; to another agent. It takes two arguments, the first an agent nam and the
;;; second a value name. It returns the value returned by the remote agent.

(defun  lisp_arequest (ag nam)
         (pop11::lisp_true (pop11::pop11_arequest (string ag) (string nam)))
)

;;;     (lisp_respond ...) allows a LISP agent to respond to a data value --
;;; it takes two arguments -- the value name and the value itself.

(defun  lisp_respond (nam val)
         (pop11::pop11_respond (string nam) (pop11::pop_true val))
)

;;;     (lisp_die ...) informs the system of the calling agent's iminent death.

(defun  lisp_die  ()
    (pop11::pop11_die)
)

;;;     (lisp_serve ...) allows the calling agent to serve agent requests.
;;; It returns the name of the value required by the remote agent.

(defun  lisp_serve ()
    (pop11::pop11_serve)
)
