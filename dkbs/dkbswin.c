
/*
 * dkbswin.c
 * 
 * M J Wooldridge June 1990
 * 
 * Window manager procedures for DKBS Server
 */


/* get the include file which defines the system environment */

#include	"../include/select.h"

/* only compile this lot if in Sun environment */

#ifdef	SUNOS

/* the usual #inludes */

/* for SunView */

#include	<suntool/sunview.h>
#include	<suntool/panel.h>
#include	<sunwindow/win_input.h>
#include	<suntool/walkmenu.h>
#include	<suntool/canvas.h>
#include	<suntool/textsw.h>
#include	<suntool/icon.h>
#include	<suntool/alert.h>

/* MADE specific */

#include	"../include/cosmetic.h"
#include	"../include/debug.h"
#include	"../include/addtab.h"

/* #defines */

/* first the length & breadth of all windows */

#define		DKBS_WIN_PANEL_WIDTH	13
#define		DKBS_WIN_PANEL_HEIGHT	17

#define		DKBS_WIN_CANV_WIDTH	25
#define		DKBS_WIN_CANV_HEIGHT	16

#define		DKBS_WIN_TRACE_WIDTH	80
#define		DKBS_WIN_TRACE_HEIGHT	9

/* default x/y co-ords for the frame */

#define		DKBS_WIN_X_CO_ORD  	795
#define		DKBS_WIN_Y_CO_ORD  	290

#define		DKBS_WIN_TRACE_X_CO_ORD	502
#define		DKBS_WIN_TRACE_Y_CO_ORD	4


/* now the file for saving trace information */

#define	DKBS_WIN_TRACE_FILE	"dkbs.trace"

/* labels for the three main windows */

#define		DKBS_WIN_MAIN_FRAME_LABEL 	\
"ITOR*MONITOR*MONITOR*MONITOR*MONITOR*MONITOR*MONITOR*MONITOR*MONITOR*MONITOR*"

#define		DKBS_WIN_TRACE_FRAME_LABEL	\
"CE*TRACE*TRACE*TRACE*TRACE*TRACE*TRACE*TRACE*TRACE*TRACE*TRACE*TRACE*TRACE*TR"

#define		DKBS_WIN_TRAP_FRAME_LABEL	\
"AP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP*TRAP"

/* now the external data declarations, etc */

extern int      no_of_local_agents;
extern int      no_of_remote_agents;
extern int      total_no_of_agents;
extern int      num_msgs_switched;
extern int      bad_msgs;

extern int      trace_flag;
extern int      pause_flag;
extern int      walk_flag;
extern int      debug_flag;
extern int      trap_flag;
extern int      beep_flag;
extern int      trap_int;

extern char    *trap_string;
extern char    *last_message_from;

extern char    *stralloc();

extern void
                debug(),
                beep(),		/* issues ctrl-g */
                update_monitor_window();

/* global data declarations  for windows */

static Frame    frame,		/* the base frame of the program */
                trace_frame,	/* the base frame of the trace facility */
                trap_frame;	/* frame for the trap facility */

static Menu     trap_menu,	/* the menu created for debug option */
                slow_menu;	/* select slow wait times */

static Panel    panel,		/* slow, trace, and quit buttons */
                trap_panel;	/* the trap facility */

static Canvas   canvas;		/* status information display area */

static Textsw   trace_window;	/* the trace window */

static Pixwin  *pixwin;		/* needed for conversion in canvas fns */

static Icon     icon;		/* the monitor icon */

static          Panel_item	/* the six button for th control panel */
                slow_button,	/* select/deselect slow option */
                trace_button,	/* select/deselsect trace option */
                pause_button,	/* select/deselect pause */
                trap_button,	/* get trap select menu up */
                extras_button,	/* get extras menu up */
                debug_button,	/* select/deselect debug option */
                pict_button,	/* select/deselect picture option */
                quit_button;	/* guess !! */

static          Panel_item	/* buttons for the trap facility */
                trap_confirm_button, trap_key;

/* initial format for the monitor window */

static char    *init_str[] = {	/* used to create monitor window */
	"                  ",	/* 1  */
	"                  ",	/* 2  */
	"Local Agents  : 00",	/* 4  */
	"Remote Agents : 00",	/* 5  */
	"                  ",	/* 6  */
	"                  ",	/* 7 */
	"                  ",	/* 8  */
	"Bad Messages  : 00",	/* 9  */
	"Msgs Switched : 00",	/* 10  */
	"                  ",	/* 11  */
	"                  ",	/* 12 */
	"                  ",	/* 13 */
	"Last Message From:",	/* 14 */
	"                   ",	/* 15 */
	"		    ",
(char *) 0};


/* setup_icon loads the icon from the icon file */

static short    icon_image[] = {
#include	"../icons/monitor.icon"
};

mpr_static(icon_pixrect, 64, 64, 1, icon_image);

void
setup_icon()
{				/* NB - PUT NO INSTRUCTIONS BFORE THE
				 * FOLLOWING LINE */
	icon = icon_create(ICON_IMAGE, &icon_pixrect, 0);
}

/* initialise_monitor_window() sets up the initial text display & graphics */

void
initialise_monitor_window()
{
	int             count;
	for (count = 0; init_str[count] != null(char); count++)
		pw_text(canvas_pixwin(canvas),
			20,
			(count * 15),
			PIX_SRC,
			0,
			init_str[count]);

	/* now draw some boxes around things */

	/* top box */

	pw_vector(canvas_pixwin(canvas), 5, 10, 190, 10, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 5, 10, 5, 55, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 5, 55, 190, 55, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 190, 55, 190, 10, PIX_SRC, 1);

	/* middle box */

	pw_vector(canvas_pixwin(canvas), 5, 85, 190, 85, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 5, 85, 5, 130, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 5, 130, 190, 130, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 190, 130, 190, 85, PIX_SRC, 1);

	/* bottom box */

	pw_vector(canvas_pixwin(canvas), 5, 160, 5, 220, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 5, 160, 190, 160, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 5, 220, 190, 220, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 190, 160, 190, 220, PIX_SRC, 1);
	pw_vector(canvas_pixwin(canvas), 5, 195, 190, 195, PIX_SRC, 1);

}

/* next 6 fns define what happens when buttons are pressed */

/* just toggle walk_flag between TRUE and FALSE */

void
set_toggle(item, value, event)
	Panel_item      item;
	int             value;
	Event          *event;
{
	walk_flag = value;
	(void) update_monitor_window();
}

/* the following 4 fns define possible trace actions */

void
open_trace_window()
{

	trace_frame = window_create(NULL, FRAME,
				    FRAME_LABEL, DKBS_WIN_TRACE_FRAME_LABEL,
				    FRAME_NO_CONFIRM, TRUE,
				    WIN_ERROR_MSG, "Can't create trace",
				  WIN_WIDTH, ATTR_COL(DKBS_WIN_TRACE_WIDTH),
				WIN_HEIGHT, ATTR_COL(DKBS_WIN_TRACE_HEIGHT),
				    WIN_X, DKBS_WIN_TRACE_X_CO_ORD,
				    WIN_Y, DKBS_WIN_TRACE_Y_CO_ORD,
				    TEXTSW_MEMORY_MAXIMUM, 200000,
				    0);

	trace_window = window_create(trace_frame, TEXTSW, 0);

	window_fit(trace_window);
	window_fit(trace_frame);
	window_set(trace_frame, WIN_SHOW, TRUE, 0);
	(void) notify_dispatch();
}

void
close_trace_window()
{
	if (textsw_store_file(trace_window, DKBS_WIN_TRACE_FILE, 0, 0) != 0)
		fatal("couldn't save trace file");

	window_destroy(trace_frame);

	(void) notify_dispatch();
}

void
update_trace(s)
	char           *s;
{
	Textsw_index    trace_posn;

	trace_posn = textsw_insert(trace_window, s, strlen(s));
}

void
set_trace(item, value, event)
	Panel_item      item;
	int             value;
	Event          *event;
{
	if (trace_flag)
		close_trace_window();
	else
		open_trace_window();
	trace_flag = value;

	update_monitor_window();
}

/* this next function just exits */

void
quit()
{
	int             result;

	result = alert_prompt(
			      (Frame) frame, (Event *) 0,
			      ALERT_MESSAGE_STRINGS,
			      " ",
			      "Are you sure you want to quit?",
			      0,
			      ALERT_BUTTON_YES, "CONFIRM",
			      ALERT_BUTTON_NO, "CANCEL",
			      0);
	if (result == ALERT_YES)
		exit(0);
}

/* select/deselect the debug option */

void
set_debug(item, value, event)
	Panel_item      item;
	int             value;
	Event          *event;
{
	debug_flag = value;
	(void) update_monitor_window();
}

/* set slow taime */

void
set_slow_time(menu, menu_item)
	Menu            menu;
	Menu_item       menu_item;
{
	extern int      slow_time;
	int             count, result;

	slow_time = 1;
	result = (int) menu_get(menu_item, MENU_VALUE);
	for (count = 1; count < result; count++)
		slow_time = 2 * slow_time;
}

/* display extras menu */

void
create_xtras_menu(item, event)
	Panel_item      item;
	Event          *event;
{
	int             result = 0, count;
	Menu            xtras_menu, local_agent_menu, remote_agent_menu;
	AT             *at;
	extern AT      *ad_table;
	char           *beep_string;

	/* search address tables for remote + local agent `menu' */

	remote_agent_menu = menu_create(0);

	local_agent_menu = menu_create(0);

	at = ad_table;
	while (at != null(AT)) {
		if (at->location == MADE_AT_LOCAL)
			menu_set(local_agent_menu,
				 MENU_STRING_ITEM,
				 at->agent_name, 0,
				 0);
		else
			menu_set(remote_agent_menu,
				 MENU_STRING_ITEM,
				 at->agent_name, 0,
				 0);
		at = at->next;
	}

	/* select message about beeps for xtras menu */

	if (beep_flag)
		beep_string = "Switch Beep OFF";
	else
		beep_string = "Switch Beep ON";

	/* create the xtras menu */

	xtras_menu = menu_create(
				 MENU_ITEM,
				 MENU_STRING, "List Local Agents",
				 MENU_PULLRIGHT, local_agent_menu, 0,
				 MENU_ITEM,
				 MENU_STRING, "List Remote Agents",
				 MENU_PULLRIGHT, remote_agent_menu, 0,
				 MENU_ITEM,
				 MENU_STRING, "Set `SLOW' Delay",
				 MENU_PULLRIGHT, slow_menu, 0,
				 MENU_ITEM,
				 MENU_STRING, beep_string,
				 MENU_VALUE, 100, 0,
				 0);

	if (event_action(event) == MS_RIGHT && event_is_down(event)) {
		result = (int) menu_show(xtras_menu, panel, event, 0);

		if (result == 100)	/* beep toggle */
			beep_flag = 1 - beep_flag;
	} else
		panel_default_handle_event(item, event);

	menu_destroy(local_agent_menu);
	menu_destroy(remote_agent_menu);
}

/* the following two functions handle pausing */

void
set_pause(item, value, event)
	Panel_item      item;
	int             value;
	Event          *event;
{
	if (pause_flag != value) {
		pause_flag = value;
		panel_set_value(pause_button, value);
		if (pause_flag AND beep_flag)
			beep();
	}
	(void) update_monitor_window();
}

void
pause_toggle()
{
	set_pause(pause_button, (1 - pause_flag), null(Event));
}

/* the next four functions handle traps */

/* confirm_trap is called when a user confirms a trap set */

void
confirm_trap()
{
	char           *key_string;
	int             temp;

	/* save the trap type */

	temp = trap_flag;

	/* first save the entered string */

	key_string = (char *) panel_get_value(trap_key);

	if ((trap_flag == TRAP_TYPE) OR(trap_flag == TRAP_SEQUENCE))
		sscanf(key_string, "%d", &trap_int);
	else
		trap_string = stralloc(key_string);

	/* and set the trap */

	set_trap(temp);

	/* and close the trap select window */

	window_set(trap_frame, FRAME_NO_CONFIRM, TRUE, 0);
	window_destroy(trap_frame);

	/* and update the monitor window */

	update_monitor_window();
}

/* create the trap select window */

void
create_trap_window(trap_type)
	int             trap_type;
{

	trap_flag = trap_type;

	trap_frame = window_create(NULL, FRAME,
				   FRAME_LABEL, DKBS_WIN_TRAP_FRAME_LABEL,
				   WIN_WIDTH, ATTR_COLS(30),
				   WIN_HEIGHT, ATTR_ROWS(5),
				   WIN_X, (DKBS_WIN_X_CO_ORD - 250),
				   WIN_Y, DKBS_WIN_Y_CO_ORD,
				   0);

	trap_panel = window_create(trap_frame, PANEL, 0);

	trap_key = panel_create_item(trap_panel,
				     PANEL_TEXT,
				     PANEL_LABEL_STRING, "Trap key: ",
				     PANEL_VALUE_DISPLAY_LENGTH, 16,
				     0);

	trap_confirm_button = panel_create_item(trap_panel,
						PANEL_BUTTON,
						PANEL_LABEL_IMAGE,
			    panel_button_image(trap_panel, "CONFIRM", 7, 0),
					    PANEL_NOTIFY_PROC, confirm_trap,
						0);

	window_fit(trap_panel);
	window_set(trap_frame, WIN_SHOW, TRUE, 0);
}

/* on pressing trap button, display menu etc */

void
create_trap_menu(item, event)
	Panel_item      item;
	Event          *event;
{
	int             result = 0;

	if (event_action(event) == MS_RIGHT AND event_is_down(event)) {
		result = (int) menu_show(trap_menu, panel, event, 0);
		if (result > 1)
			create_trap_window(result);
		else {
			trap_flag = 0;
			update_monitor_window();
		}
	} else
		panel_default_handle_event(item, event);

}

/* eventually, this will show a picture ... */

void
set_pict(item, value, event)
	Panel_item      item;
	int             value;
	Event          *event;
{
	/*
	 * TO DO - Draw picture of agent arrangement
	 */

	;
}

void
create_panel_items()
{
	slow_button = panel_create_item(panel, PANEL_CYCLE,
					PANEL_LABEL_STRING, "SLOW ",
					PANEL_CHOICE_STRINGS,
					"Off", "On", 0,
					PANEL_NOTIFY_PROC, set_toggle,
					PANEL_ITEM_X, ATTR_COL(0),
					PANEL_ITEM_Y, ATTR_ROW(0),
					0);

	pause_button = panel_create_item(panel, PANEL_CYCLE,
					 PANEL_LABEL_STRING, "PAUSE",
					 PANEL_CHOICE_STRINGS,
					 "Off", "On", 0,
					 PANEL_NOTIFY_PROC, set_pause,
					 PANEL_ITEM_X, ATTR_COL(0),
					 PANEL_ITEM_Y, ATTR_ROW(1),
					 0);

	trace_button = panel_create_item(panel, PANEL_CYCLE,
					 PANEL_LABEL_STRING, "TRACE",
					 PANEL_CHOICE_STRINGS,
					 "Off", "On", 0,
					 PANEL_NOTIFY_PROC, set_trace,
					 PANEL_ITEM_X, ATTR_COL(0),
					 PANEL_ITEM_Y, ATTR_ROW(2),
					 0);

	pict_button = panel_create_item(panel, PANEL_CYCLE,
					PANEL_LABEL_STRING, "PICT ",
					PANEL_CHOICE_STRINGS,
					"Off", "On", 0,
					PANEL_NOTIFY_PROC, set_pict,
					PANEL_ITEM_X, ATTR_COL(0),
					PANEL_ITEM_Y, ATTR_ROW(3),
					0);

	debug_button = panel_create_item(panel, PANEL_CYCLE,
					 PANEL_LABEL_STRING, "DEBUG",
					 PANEL_CHOICE_STRINGS,
					 "Off", "On", 0,
					 PANEL_NOTIFY_PROC, set_debug,
					 PANEL_ITEM_X, ATTR_COL(0),
					 PANEL_ITEM_Y, ATTR_ROW(4),
					 0);

	extras_button = panel_create_item(panel, PANEL_BUTTON,
					  PANEL_LABEL_IMAGE,
				   panel_button_image(panel, "XTRAS", 5, 0),
					PANEL_EVENT_PROC, create_xtras_menu,
					  PANEL_ITEM_X, ATTR_COL(3),
					  PANEL_ITEM_Y, ATTR_ROW(6),
					  0);

	trap_button = panel_create_item(panel, PANEL_BUTTON,
					PANEL_LABEL_IMAGE,
				    panel_button_image(panel, "TRAP", 5, 0),
					PANEL_EVENT_PROC, create_trap_menu,
					PANEL_ITEM_X, ATTR_COL(3),
					PANEL_ITEM_Y, ATTR_ROW(8),
					0);

	quit_button = panel_create_item(panel, PANEL_BUTTON,
					PANEL_LABEL_IMAGE,
				    panel_button_image(panel, "QUIT", 5, 0),
					PANEL_NOTIFY_PROC, quit,
					PANEL_ITEM_X, ATTR_COL(3),
					PANEL_ITEM_Y, ATTR_ROW(11),
					0);

	window_fit_height(panel);
}


void
startup_win()
{
	setup_icon();

	frame = window_create(NULL, FRAME,
			      FRAME_LABEL, DKBS_WIN_MAIN_FRAME_LABEL,
			      FRAME_ICON, icon,
			      WIN_X, DKBS_WIN_X_CO_ORD,
			      WIN_Y, DKBS_WIN_Y_CO_ORD,
			      0);

	panel = window_create(frame, PANEL,
			      WIN_WIDTH, ATTR_COLS(DKBS_WIN_PANEL_WIDTH),
			      WIN_HEIGHT, ATTR_ROWS(DKBS_WIN_PANEL_HEIGHT),
			      0);

	create_panel_items();

	canvas = window_create(frame,
			       CANVAS,
			       WIN_WIDTH, ATTR_COLS(DKBS_WIN_CANV_WIDTH),
			       WIN_HEIGHT, ATTR_ROWS(DKBS_WIN_CANV_HEIGHT),
			       WIN_RIGHT_OF, panel,
			       0);

	window_fit(frame);

	initialise_monitor_window();

	/* create & store the menu for trap options */

	trap_menu = menu_create(
				MENU_STRINGS,
				"Trap Off",
				"Trap by Sender",
				"Trap by Addressee",
				"Trap by Type",
				"Trap by Sequence",
				"Trap by Attribute",
				"Trap by Value",
				0,
				0);

	slow_menu = menu_create(MENU_STRINGS,
				" 1 sec ",
				" 2 secs",
				" 4 secs",
				" 8 secs",
				"16 secs",
				"32 secs",
				"64 secs", 0,
				MENU_NOTIFY_PROC, set_slow_time,
				0);

	window_set(frame, WIN_SHOW, TRUE, 0);
}

void
update_monitor_window()
{
	char            buf[100];
	int             temp = 0;

	/* first print out the new no of local agents */

	sprintf(buf, "%4d", no_of_local_agents);
	pw_text(canvas_pixwin(canvas), 148, 30, PIX_SRC, 0, buf);

	/* now print out the new no local */

	sprintf(buf, "%4d", no_of_remote_agents);
	pw_text(canvas_pixwin(canvas), 148, 45, PIX_SRC, 0, buf);

	/* now print out the no of bad msgs */

	sprintf(buf, "%4d", bad_msgs);
	pw_text(canvas_pixwin(canvas), 148, 105, PIX_SRC, 0, buf);

	/* now print out the new no msgs switched */

	sprintf(buf, "%4d", num_msgs_switched);
	pw_text(canvas_pixwin(canvas), 148, 120, PIX_SRC, 0, buf);

	/* now print out the new last message */

	sprintf(buf, "%s", last_message_from);
	pw_text(canvas_pixwin(canvas), 20, 210, PIX_SRC, 0, "               ");
	pw_text(canvas_pixwin(canvas), 20, 210, PIX_SRC, 0, buf);

	/* now invoke the dispatcher */

	(void) notify_dispatch();

	if (walk_flag) {
		/* to improve response when slowing call notify three times */

		(void) notify_dispatch();
		(void) notify_dispatch();
		(void) notify_dispatch();
	}
}


#endif	/* SUNOS */

/*
 * THE END
 */
