	/* this is where the standard code from pre.c starts */

	/* the following define the operation mode of the system */

#define	OP_INSTALL_LOCALLY	0	
/*	This one means that the system is to be installed locally, with
 *	all the agents and tools, etc, installed on the current host
 *	machine.
 */
#define	OP_INSTALL_REMOTELY	1
/*	This one means that the system is to be installed over remote
 *	machines as defined in the .masc file that the program was
 *	generated from.
 */
#define	OP_INSTALL_CALLED1	2
/*	This means that the program is being invoked from another machine,
 *	and should only instal;l the dkbs
 */
#define	OP_INSTALL_CALLED2	3
/*	This one means that the program has been called from a remote
 *	machine, and is only to install those agents that should be on this
 *	host machine. The machine which caused this invocation will set
 *	up the remainder of the tools.
 */

	/* the following variable defines the default operation mode */

int	operation_mode = OP_INSTALL_LOCALLY;

	/* external data declarations */

extern	char	
	*getenv(),
	*getwd();

extern	void	
	install_locally(),
	install_called2();

	/* the following variables are set by command line flags */

int 	dflag  = DEFAULT_DFLAG,      	/* if 1 then dkbs    selected */
	sflag  = DEFAULT_SUNVIEW,	/* if 1 then sunview selected */
    	rflag  = DEFAULT_READER,      	/* if 1 then reader  selected */
    	deflag = DEFAULT_DEBUGGER,	/* is 1 then debugger selected*/
	wflag  = DEFAULT_AWT;		/* if 1 then wintool selected */

	/* the following variables are used to keep track of the */
	/* various processes initiated by this program */

int 	pid[100],
        pcount = 0,
        count;

	/* occasionally we have to redirect stdin - we use infile for this */

FILE 	*infile;

	/* finally the system name and other global strings  */

char	system_name[512],	/* the name of the described system */
	hostname[512],		/* the name of the calling machine */
	prog_name[512],		/* the name of the program */
	current_dir[512],	/* current working directory */
	exec_dkbs[512],		/* pathname for dkbs */
	exec_awt[512],		/* pathname for agent window tool */
	exec_debugger[512],	/* pathname for default debugger */
	exec_sreader[512],	/* pathname for I/O agent (SunView)*/
	exec_reader[512];	/* pathname for I/O agent */
	
	/* now for some functions to set things up */

void	install_dkbs_locally()
{
	/* if dflag is set then install dkbs */

	if(dflag)
    	{
		fprintf(stderr,"%s : initiating dkbs.\n",system_name);
        	pid[pcount] = fork();
        	if(pid[pcount] == 0)
        	{	
			if(operation_mode != OP_INSTALL_LOCALLY) {
				if(sflag)
					execl(exec_dkbs,"dkbs","-r","-s",(char *)0);
				else	
					execl(exec_dkbs,"dkbs","-r",(char *)0);
			} else {
				if(sflag)
					execl(exec_dkbs,"dkbs","-s",(char *)0);
				else
					execl(exec_dkbs,"dkbs",(char *)0);
			}
			/* shouldn't ever get to here, but just in case ... */
			exit(1);
		}
		pcount++;
    	}
}

void	install_reader_locally()
{
	/* if rflag is set then install reader */

    	if(rflag)
    	{
		fprintf(stderr,"%s : initiating reader.\n", system_name);
        	pid[pcount] = fork();
        	if(pid[pcount] == 0)
		{
			if(sflag)
				execl(exec_sreader,"readertool",(char *)0);
			else
        			execl(exec_reader, "reader", (char *)0);
			exit(1);
		}
		else
			pcount++;
    	}
    	sleep(3);
}

void	install_wintool_locally()
{
	if(wflag && sflag)
	{
		fprintf(stderr,"%s : initiating agentwintool\n", system_name);
		pid[pcount] = fork();
		if(pid[pcount] == 0)
		{
			execl(exec_awt,"agentwintool", (char *)0);
			exit(1);
		}
		pcount++;
		sleep(3);
	}
}

void	install_debugger_locally()
{
	if(deflag && sflag)
	{
		fprintf(stderr,"%s : initiating debugger\n", system_name);
		pid[pcount] = fork();
		if(pid[pcount] == 0)
		{
			execl(exec_debugger,"debugger", (char *)0);
			exit(1);
		}
		pcount++;
		sleep(3);
	}
}

void	setup_names()
{
	char	*root;
	int	len;

	/* first try to get the environment variable `made' */

	if((root = getenv("made")) == (char *)0)
	{
		fprintf(stderr,"%s : environment variable made not set\n",
			system_name);
		exit(1);
	}

	/* now set up the various paths */

	sprintf(exec_dkbs,	"%s/%s", root, EXEC_DKBS);
	sprintf(exec_sreader,	"%s/%s", root, EXEC_SREADER);
	sprintf(exec_reader, 	"%s/%s", root, EXEC_READER);
	sprintf(exec_awt, 	"%s/%s", root, EXEC_AWT);
	sprintf(exec_debugger,	"%s/%s", root, EXEC_DEBUGGER);

	/* now get the hostname */

	gethostname(hostname,&len);

	/* and finally, get the name of this program */

	if((root = getwd(current_dir)) == (char *)0)
	{
		fprintf(stderr,"%s : couldn't get working directory\n",
			system_name);
		exit(1);
	}
	sprintf(prog_name, "%s/%s", root, system_name);
}

/* The wait_for_child_death function just waits for a child to die before 
 * killing the rest and dieing itself
 */

void	wait_for_child_death()
{
	wait((int *)0);
	fprintf(stderr,"%s -- stopping\n",system_name);

	for(count = 0; count<pcount; count++)
		kill(pid[count], SIGKILL);
}

/*	This function installs agents over the network
 */

void	rem_fork(rem_host,dir,path,prog,arg)
char	*rem_host,
	*dir,
	*path,
	*prog,
	*arg;
{	
	CLIENT *cl;
	char	*send_string;
	
	send_string = (char *)malloc(2048);
	
	sprintf(send_string,"%s %s %s %s",dir,path,prog,arg);
	
	cl = clnt_create(rem_host,REM_INST,REM_INST_VERS,"udp");

	if(cl != NULL) {	
		int	*result;

		fprintf(stderr,"%s : host `%s' is responding\n", system_name,
			rem_host);
			fprintf(stderr,"[0]\n");
		result = install_1(&send_string, cl);
		fprintf(stderr,"[1]\n");
		clnt_destroy(cl);
	}
	free(send_string);
	fprintf(stderr,"[2]\n");
}

void	install_dkbs_remotely()
{
	int	count = 0;

	fprintf(stderr,"%s : installing remote servers.\n", system_name);

	/* for each host in host_tab[], try to establish connection and */
	/* send the first call */
	
	for(count = 0; count < num_hosts; count++)
		if(strcmp(host_tab[count],hostname) != 0)
			rem_fork(host_tab[count],
				current_dir,
				prog_name,
				system_name,
				"-called1");
	
	/* now thats sorted out! */
	
	sleep(15);
}

void	install_agents_remotely()
{
	int	count;

	fprintf(stderr,"%s : installing remote agents.\n",system_name);

	/* send the second call */

	for(count = 0; count < num_hosts; count++)
		if(strcmp(host_tab[count],hostname) != 0)
			rem_fork(host_tab[count],
				current_dir,
				prog_name,
				system_name,
				"-called2");
}

void	install_remotely()
{
	/* first install the dkbs here */

	install_dkbs_locally();

	/* install servers on remote machines*/

	install_dkbs_remotely();
	
	/* now put system agents on this machine */

	install_reader_locally();
	install_wintool_locally();

	/* now put agents on remote machines */

	install_agents_remotely();

	/* now put the agents for this machine here */

	install_called2();
}

/* This function just installs the dkbs
 */

void	install_called1()
{	
	install_dkbs_locally();	
}

	/* now the main function */

main(argc,argv)
int argc;
char    *argv[];
{
	/* save the sysytem name */

	strcpy(system_name,argv[0]);

	/* save the command line arguments */

    	for(count = 1; count <argc; count++)
    	{
        	if(strcmp(argv[count], "-d") == 0)
            	{
			dflag = 1 - dflag;
			fprintf(stderr,"%s : dkbs %s\n",
				system_name,
				dflag ? "selected" : "deselected");
		}

        	if(strcmp(argv[count], "-r") == 0)
		{
            		rflag = 1 - rflag;
			fprintf(stderr,"%s : reader %s\n",
				system_name,
				rflag ? "selected" : "deselected");
		}

		if(strcmp(argv[count], "-s") == 0)
		{
			sflag = 1 - sflag;
			fprintf(stderr,"%s : SunView %s\n",
				system_name,
				sflag ? "selected" : "deselected");
		}

		if(strcmp(argv[count], "-remote") == 0)
		{
			fprintf(stderr,"%s : remote selected\n",system_name);
			operation_mode = OP_INSTALL_REMOTELY;
		}

		if(strcmp(argv[count], "-called1") == 0)
		{
			fprintf(stderr,"%s : called1\n",system_name);
			operation_mode = OP_INSTALL_CALLED1;
		}

		if(strcmp(argv[count], "-called2") == 0)
		{
			fprintf(stderr,"%s : called2\n",system_name);
			operation_mode = OP_INSTALL_CALLED2;
		}

    	}	

	/* setup pathnames, etc */

	setup_names();

	/* now depending on the operation mode, call the appropriate fn */

	switch(operation_mode)
	{
		case OP_INSTALL_LOCALLY:
			install_locally();
		break;

		case OP_INSTALL_REMOTELY:
			install_remotely();
		break;

		case OP_INSTALL_CALLED1:
			install_called1();
		break;
	
		case OP_INSTALL_CALLED2:
			install_called2();
		break;

		default:
		{
			fprintf(stderr,"%s - internal error - illegal mode\n",
				system_name);
			exit(1);
		}
	}

	/* now just wait for something to die */

	wait_for_child_death();

	/* if we ever get to here, quit */

	exit(0);
}

