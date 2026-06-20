/*  rem_inst.x
 *
 *  M J Wooldridge
 *  July 1990
 *
 *  An rpcgen(1) program -- the protocol definition for use with
 *  remote installation of agents. See :
 *      - the `rpcgen(1)' Programming Guide (in Sun's `Network Programming')
 *      - the MASC program.
 */

program REM_INST
{
    	version REM_INST_VERS
    	{
       		int INSTALL(string) = 1;
    	} = 1;
} = 100;
