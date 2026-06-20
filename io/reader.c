/*  reader.c
 *
 *  M J Wooldridge
 *  June 1990 (adapted from Jan 1990)
 *
 *  The basic user interface program
 */

	/*  first get the inlcude files */

#include    	<stdio.h>
#include    	<fcntl.h>

#include    	"../include/dg.h"
#include	"../include/cosmetic.h"
#include	"../include/system_agents.h"

	/*  external data/function declarations */
	
extern  void
    debug(),
    send(),
    aregister(),
    fatal();

extern  char
    *stralloc();

int receive();

	/* global data declarations */

int	sunview_flag = FALSE;

	/*  now the main */

	main(argc,argv)
int	argc;
char	*argv[];
{
    FILE    *newin;
    int oldfd,
        newfd,
	count;

	/* process command line arguments */

	for(count = 1; count<argc; count++)
	{	
		if(strcmp(argv[count], "-s") == 0)
			sunview_flag = TRUE;
	}

    /* now check that the agent has access to stdin - the technique
     * is from `UNIX System Programming'
     */
    sleep(5);

	if(!sunview_flag)
	{
    		if((oldfd = fcntl(0, F_DUPFD, 0)) == -1)
        		fatal("fcntl failed");


    		if((newfd = open("/dev/tty", O_RDONLY)) == -1)
        		fatal("open failed");

    		close(0);

    		if(fcntl(newfd,F_DUPFD, 0) != 0)
        		fatal("fcntl(2) failed");
	}
	
    /*  now get on with the business of running things */

    aregister(MADE_SYSTEM_AGENT_USER_IO);
    
    while(TRUE)
    {
        int datagram_type;
        char    attribute[BUFSIZ],
                value[BUFSIZ],
                sender_agent[BUFSIZ];

    datagram_type = receive(sender_agent,value);

    switch(datagram_type)
        {
            case PROC_REQU:
            {	int	c;
                char    ret[BUFSIZ];
                
                printf("> ");
                for(count = 0; ((ret[count] = getchar()) != '\n'); count++)
                		;
                ret[count] = '\0';
                send(sender_agent, PROC_RESP, &ret[0]);
            }
            break;

            case PROC_INFM:
            {
                printf("%s",value);
            }
            break;

            default:
                printf("\n** Unknown datagram type : %d\n",datagram_type);
        }
    }
}
