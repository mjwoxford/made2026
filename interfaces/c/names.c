/*	names.c
 *
 *	M J Wooldridge
 *	June 1990
 *
 *	To implement naming conventions for message queues
 */

	/* first the #includes */

#include	<sys/types.h>
#include	<sys/stat.h>

#include	"../../include/cosmetic.h"

	/* now the #defines */

#define		MADE_NM_ROOT	"/tmp/"
#define		MADE_MSG_TAIL	".msg"
#define		MADE_LCK_TAIL	".lck"

	/* externals */
	
extern	char	*current_host;

/*	utility function */

char	*get_made_path_name(body,tail)
char	*body,
	*tail;
{
	char	tmp[512],
		*made_path;
		
	sprintf(tmp,"%s%s%s",MADE_NM_ROOT,body,tail);
	made_path = stralloc(tmp); 
	return(made_path);
}
	
	/* this function gets the msg queue name of the host */

char	*get_host_fifo_name()
{
	char	*path;

	get_current_host();
		
	path = get_made_path_name(current_host, MADE_MSG_TAIL);
	
	return(path);
}

	/* this function gets the lock name of the host server */

char	*get_host_lock_name()
{
	char	*path;

	get_current_host();
	
	path = get_made_path_name(current_host,MADE_LCK_TAIL);	
	
	return(path);
}

	/* get the msg queue name of the agent */
	
char	*get_agent_fifo_name(agent)
char	*agent;
{
	char	*path;
	
	path = get_made_path_name(agent,MADE_MSG_TAIL);

	return(path);
}

	/* get the lock name of the agent */
	
char	*get_agent_lock_name(agent)
char	*agent;
{
	char	*path;
	
	path = get_made_path_name(agent, MADE_LCK_TAIL);

	return(path);
}

