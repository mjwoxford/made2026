/*	debug.h
 *
 *	M J Wooldridge
 *	October 1990
 *
 *	Definitions for run-time debug options - used by servers.
 */

	/* First the defines for the various traps that may be set */

#define	TRAP_OFF	1	/* set the trap to off */
#define	TRAP_SENDER	2	/* Trap by message sender  */
#define	TRAP_ADDRESSEE	3	/* Trap by intended recipient  */
#define	TRAP_TYPE	4	/* Trap by message type  */
#define	TRAP_SEQUENCE	5	/* Trap by sequence number */
#define	TRAP_ATTRIBUTE	6	/* Trap by attribute */
#define	TRAP_VALUE	7	/* Trap by value */

	/* Now a define to set a trap */

#define	set_trap(A)	trap_flag = (8 | (A))
	
	/* to set trap on */

#define	trap_on()	trap_flag = (trap_flag | 8)

	/* to set trap off */

#define	trap_off()	trap_flag = (trap_flag & 7)

	/* To see if a trap is set */

#define	trap_is_on	((trap_flag & 8) == 8)

	/* To check the type of a trap */

#define	trap_is(A)	((trap_flag & 7) == (A))

