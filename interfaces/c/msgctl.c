/*	msgctl.c
 *
 *	M J Wooldridge
 *	June 1990
 */

	/* include files */

#include	<stdio.h>
#include	<sys/types.h>
#include	<sys/stat.h>
#include	<fcntl.h>
#include	<unistd.h>
#include	<errno.h>

#include	"../../include/cosmetic.h"
#include	"../../include/dg.h"

	/* external data/fn declarations */

extern	int	errno;

	/* #definitions */

#define		MADE_CREATE_FIFO_FLAGS		(010777)
#define		MADE_CREATE_LOCK_FLAGS		(O_CREAT | O_RDWR)
#define		MADE_OPEN_FOR_READING_FLAGS	(O_RDONLY /*| O_TRUNC */)
#define		MADE_OPEN_FOR_WRITING_FLAGS	(O_WRONLY)
#define		MADE_CREATE_LOCK_MODE		(0600)

	/* now the basic fifo handling functions */

void	create_fifo(fifo_name)
char	*fifo_name;
{
	if(mknod(fifo_name, MADE_CREATE_FIFO_FLAGS, 0) < 0)
		if(errno != EEXIST)
			fatal("couldn't create fifo");
}

int	open_fifo_for_reading(fifo_name)
char	*fifo_name;
{
	int	fid;
	if((fid = open(fifo_name, MADE_OPEN_FOR_READING_FLAGS)) < 0)
		fatal("couldn't open fifo to read");
	return(fid);
}

int	open_fifo_for_writing(fifo_name)
char	*fifo_name;
{
	int	fid;

	if((fid = open(fifo_name, MADE_OPEN_FOR_WRITING_FLAGS)) < 0)
		fatal("couldn't open fifo for writing");
	return(fid);
}

int	num_msgs(fid)
int	fid;
{
	struct	stat buf;
	int	len;

	if(fstat(fid, &buf) < 0)
		fatal("fstat failed");
	len = ((int)buf.st_size) / PROC_DGSIZE;
	return(len);
}

char	*read_raw_dg(fid)
int	fid;
{
	char	*raw_dg;
	int	nread;

	raw_dg = alloc_raw_dg();

	if((nread = read(fid, raw_dg, PROC_DGSIZE)) != PROC_DGSIZE)
		fatal("readdg failed");
	return(raw_dg);
}

DG	*readdg(fid)
int	fid;
{
	char	*raw_dg;
	DG	*dg;
		
	raw_dg 	= read_raw_dg(fid);
	dg 	= decodedg(raw_dg);
	free_raw_dg(raw_dg);
	
	return(dg);
}

void	write_raw_dg(fid,raw_dg)
int	fid;
char	*raw_dg;
{
	int	nwrite;
	
	if((nwrite = write(fid, raw_dg, PROC_DGSIZE)) < 1)
		fatal("couldn't write dg");
}

void	writedg(fid,dg)
int	fid;
DG	*dg;
{
	char	*raw_dg;
	
	raw_dg 	= encodedg(dg); 
	write_raw_dg(fid, raw_dg); 
	free_raw_dg(raw_dg);
}

/* next the lock handling functions */

	/* create and lock the path passed as arg */
		
int	create_and_lock(path)
char	*path;
{
	int fd;
	
	if((fd = open(path,MADE_CREATE_LOCK_FLAGS,MADE_CREATE_LOCK_MODE)) < 0) 
		return(fd);
		
	lseek(fd,0L,0);
	
	return(lockf(fd,F_TLOCK, 0L));
}

	/* test the path passed as arg for a lock*/
	
int	is_locked(path)
char	*path;
{
	int	fd;
	
	if((fd = open(path,MADE_CREATE_LOCK_FLAGS,MADE_CREATE_LOCK_MODE)) < 0) 
		return(fd);
	
	lseek(fd,0L,0);
	
	return(lockf(fd,F_TEST,0L));
}
		
	/* THE END */

