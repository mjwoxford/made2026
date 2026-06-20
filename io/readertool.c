/*  readertool.c
 *
 *  M J Wooldridge
 *  June 1990
 *
 *  Sunview - based reader agent
 */

	/* first the usual #includes */
	
#include    	<stdio.h>
#include    	<suntool/sunview.h>
#include    	<suntool/tty.h>
#include	<suntool/icon.h>

#include	"../include/cosmetic.h"
#include	"../include/system_agents.h"
#include	"../include/paths.h"

	/*  now the global variables */
	
Frame   base;                   /* the base window */
Tty	user;                   /* user interaction window */
Icon	icon;			/* the icon for when closed */

	/*	now the string defintitions */

char	*args[] = {"/home/warner/staff/mikew/made1.0/io/reader" , "-s" , 0};

char	*windowmess =
"ER*USER*USER*USER*USER*USER*USER*USER*USER*USER*USER*USER*USER*USER*USER*USER";

	/* now the default x/y co-ordinates */

int	x_co_ord	=	502;
int	y_co_ord	= 	595;

	/* now the icon defintions */

static	short	icon_image[] = {
#include	"../icons/reader.icon"
};

mpr_static(icon_pixrect, 64, 64, 1, icon_image);

	/* now the fatal function */

void	fatal(s)
char	*s;
{	fprintf(stderr,"FATAL : readertool : %s\n");
	perror("FATAL");
	exit(1);
}

	/*  now the main */

main(argc, argv)
int     argc;
char    *argv[];
{
	int count;

	for(count=1; count<argc; count++)
	{
		if(strcmp(argv[count],"-Wp") == 0)
		{
			if((argc - count) < 2)
				fatal("%s : bad command line\n",argv[count]);
			else
				fprintf(stderr,"ok, ok - changing position\n");
		}
	}

	/* create the icon */

	icon = icon_create(ICON_IMAGE, &icon_pixrect, 0);
		
    /* create the base frame */

    base = window_create(NULL, FRAME,
                        FRAME_LABEL,    windowmess,
			FRAME_ICON,	icon,
                        WIN_ERROR_MSG,  "Can't create base window",
			WIN_WIDTH, ATTR_COL(80),
			WIN_HEIGHT, ATTR_COL(17),
			WIN_X, x_co_ord,
			WIN_Y, y_co_ord,
                        0);

    /*  now create the text sub-window */

 	user = window_create(base,
				TTY, 
				TTY_QUIT_ON_CHILD_DEATH, 1,
				TTY_ARGV,
				args,
				0);

	window_fit(user);

	window_main_loop(base);
}
