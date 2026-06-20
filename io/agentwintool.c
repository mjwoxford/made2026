/*	agentwintool.c
 *
 *	M J Wooldridge
 *	July 1990
 *
 *	Agent Window Tool *** SunView Only! ***
 */

	/* first include the select file for this type */

#include	"../include/select.h"

	/* only compile if this lot is under SunOs */

#ifdef	SUNOS

#include	<suntool/sunview.h>
#include	<suntool/canvas.h>
#include	<suntool/icon.h>

#include	"../include/cosmetic.h"
#include	"../include/dg.h"
#include	"../include/system_agents.h"

	/* external data declarations */

extern	void
	aregister(),
	debug(),
	fatal();

extern	int
	get_num_msgs(),
	receive();

extern	char
	*stralloc();

	/* a #define for a blank string */

#define	BLNK_STRNG	"                                "

	/* global data declarations */

int	number_of_agents	= 0;

int	base_x			= 10;	/* x posn for base agent windows */
int	base_y			= 200;	/* y posn for base agent windows */

	/* now the tables to hold agent details */

char	*agent_names_array[100];
int	x_co_ord[100];
int	y_co_ord[100];
Frame	frame_array[100];
Canvas	canvas_array[100];

	/* now the create function */

void	create_agent_window(name)
char	*name;
{

	/* create the window */

	frame_array[number_of_agents] = window_create( NULL, FRAME,
		FRAME_LABEL, name,
		WIN_X, x_co_ord[number_of_agents],
		WIN_Y, y_co_ord[number_of_agents],
		0);

	canvas_array[number_of_agents] = window_create(
		frame_array[number_of_agents], CANVAS,
		WIN_WIDTH, ATTR_COLS(40),
		WIN_HEIGHT, ATTR_ROWS(3),
		0);

	window_fit(frame_array[number_of_agents]);
	window_set(frame_array[number_of_agents], WIN_SHOW, TRUE, 0);
	(void)notify_dispatch();

	/* now write the initial messages */

	pw_text(canvas_pixwin(canvas_array[number_of_agents]), 
		0, 15, PIX_SRC, 0, "Status : ----");

	pw_text(canvas_pixwin(canvas_array[number_of_agents]), 
		0, 30, PIX_SRC, 0, "Goal   : ----");

	pw_text(canvas_pixwin(canvas_array[number_of_agents]), 
		0, 45, PIX_SRC, 0, "Action : ----");

	/* now update the number of agents */

	agent_names_array[number_of_agents] = stralloc(name);
	number_of_agents++;
}

void	update_agent_window(ptr,val)
int	ptr;
char	*val;
{
	char	*status,
		*goal,
		*action;

	int	count;

	Canvas	canvas;

	/* first decode status/goal/action */

	count = 0;
	while(val[count] != '%')
		count++;

	val[count++] = '\0';  
	status = val; 

	goal 	= &val[count]; 
	while(val[count] != '%')
		count ++; 
	val[count++] = '\0';
	action = &val[count];

	/* now write it all */

	canvas = canvas_array[ptr];

	pw_text(canvas_pixwin(canvas), 68, 15, PIX_SRC, 0, BLNK_STRNG);

	pw_text(canvas_pixwin(canvas), 68, 15, PIX_SRC, 0, status);

	pw_text(canvas_pixwin(canvas), 68, 30, PIX_SRC, 0, BLNK_STRNG);

	pw_text(canvas_pixwin(canvas), 68, 30, PIX_SRC, 0, goal);

	pw_text(canvas_pixwin(canvas), 68, 45, PIX_SRC, 0, BLNK_STRNG);

	pw_text(canvas_pixwin(canvas), 68, 45, PIX_SRC, 0, action);

	(void)notify_dispatch();
}


	/* now the main */

main(argc,argv)
int	argc;
char	*argv[];
{
	int	new_flag,
		pointer,
		count;

	/* first set up window posns */

	for(count = 0; count<100; count++)
		if(count<4)
		{
			x_co_ord[count] = base_x;
			y_co_ord[count] = base_y + (count * 100);
		}
		else
		{
			x_co_ord[count] = base_x + 400;
			y_co_ord[count] = base_y + ((count - 4) * 100);
		}

	/* now register */

	aregister(MADE_SYSTEM_AGENT_WINDOW_MANAGER); /* system_agents.h */

	/* and enter the main server loop */

	while(TRUE)
	{
		int	datagram_type;
		char	value[512],
			sender[512];

		while(get_num_msgs() == 0)
			(void)notify_dispatch();

		datagram_type = receive(sender, value);

		new_flag = TRUE;

		for(count = 0; count< number_of_agents; count++)
			if(strcmp(sender,agent_names_array[count]) == 0)
			{
				new_flag = FALSE;	
				pointer = count;
			}

		if(new_flag)
		{

			pointer = count;
			create_agent_window(sender);

		}

		update_agent_window(pointer,value);
	}
}

#endif	SUNOS
	/* THE END */
