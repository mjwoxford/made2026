
/*  cosmetic.h
 *
 *  M J Wooldridge
 *  December 1989
 *
 *  Cosmetic #defines - improves visibility dramatically!
 *
 */

	/* memory handling macros */
	
#define null(A)         	((A *)0)
#define galloc(A)       	((A *)malloc(sizeof(A)))
#define free_if_not_null(A)	if((A) != 0) free(A)
#define	get_null_string		(char *)stralloc("")

	/* signal handling macros */
	
#define sendsig(A,B)    	kill((A),(B))
#define handlesig(A,B)  	signal((A),(B))

	/* improve visibility in conditions */
	
#define AND             	&&
#define OR             		||
#define NOT             	!

#define TRUE            	1
#define FALSE           	0

	/* extern declarations for library functions */
	
extern	char	*stralloc();

extern	void	fatal();
extern	void	warning();
extern	void	debug();
extern	void	beep();
extern	void	get_current_host();
extern	char	*current_host;

