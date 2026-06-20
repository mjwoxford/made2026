/*  dkbs/rpcs/rem_dkb_proc.c
 *
 *  M J Wooldridge
 *  January 1990
 *
 *  Implementation of the procedure `forward()' which will be used by
 *  the server process.
 */

	/* the usual #includes */

#include    	<rpc/rpc.h>     /* standard defs for rpcgen(1) generated code */
#include    	"rem_dkb.h"     /* generated from `rem_dkb.x' by rpcgen(1) */

#include	"../../include/cosmetic.h"
#include	"../../include/dg.h"

	/* external data defs */
	
extern	char	*get_host_lock_name();
extern	char	*get_host_fifo_name();

extern	int	is_locked();
extern	int	open_fifo_for_writing();

 	/* now the procedure itself */

int     *forward_1(praw_dg)
char    **praw_dg;
{	
	int 	result, count;
	char	*raw_dg,
		*server_lock_name;
		
	raw_dg = alloc_raw_dg();
	copy_raw_dg(raw_dg,*praw_dg);
	
	/* first remove wiggles */
	
	for(count = 0; count < PROC_DGSIZE; count++)
		if(raw_dg[count] == '~')
			raw_dg[count] = '\0';

	server_lock_name = get_host_lock_name();
	
	if(is_locked(server_lock_name)) { /* then server is present */
	
		int 	server_address;
		char	*server_msg_name;
	
		server_msg_name = get_host_fifo_name();
		server_address = open_fifo_for_writing(server_msg_name);
		write_raw_dg(server_address, raw_dg);
		close(server_address);
		
		result = 1;
	} else 	
		result = -1;
		
	/* free space */
	
	free_raw_dg(raw_dg);
	
	return(&result);
}
