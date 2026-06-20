
/*  server_comms.c
 *
 * M J Wooldridge
 * December 1989
 *
 * routines to create the FIFO for the DKB server
 *
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#include	"../include/cosmetic.h"

char	*servname;	/* the name of the server msg queue */
int	fifodes;	/* a descriptor for the fifo */

	/* external data declarations */

extern  void	create_fifo();
extern	int	open_fifo_for_reading();
extern	char	*get_host_fifo_name();
extern	char	*get_host_lock_name();
extern	int	is_locked();
extern	int	create_and_lock();

/*
 * now the functions proper
 */

void	start_server_lock()
{	int len;
	char	*lockname;

	lockname = get_host_lock_name();
	
	if(len = is_locked(lockname))
		fatal("server installed (lock was on)");

	if(create_and_lock(lockname) < 0)
		fatal("create_and_lock() failed");
}


void	start_server_fifo()
{

	/* now create the fifo */

	servname = get_host_fifo_name();
	
	create_fifo(servname);

	/* and open it */
	
	fifodes = open_fifo_for_reading(servname);

}
