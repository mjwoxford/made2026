/*  rem_dkb.x
 *
 *  M J Wooldridge
 *  January 1990
 *
 *  An rpcgen(1) program -- the protocol definition for use with
 *  remote dkbs access. See :
 *      - the `rpcgen(1)' Programming Guide (in Sun's `Network Programming')
 *      - configuration details for dkbs.
 */

program REM_DKB
{
    version REM_DKB_VERS
    {
        int FORWARD(string) = 1;
    } = 1;
} = 99;
