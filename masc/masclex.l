
%{
/*  masclex.l
 *
 *  M J Wooldridge
 *  February 1990
 */

	/* first the usual #includes */

#include    <stdio.h>

#include    "masc.h"
#include    "y.tab.h"
#include    "../include/cosmetic.h"

	/* now the external data decalartions */

extern int
	yylval,
	opt_trace,
	opt_use_mp,
	opt_wintool,
	opt_dkbs,
	opt_reader,
	opt_debugger,
	opt_sunview,
	num_of_sym, 
	masc_errors;

extern	char
	*pre_file,
	*stralloc(),
	*sym_tab[];

    /* main error handling function */

void    masc_error(num,type,extra)
int     num;
char    *type,
        *extra;
{
    switch(num)
    {
        case ERROR_YACC:
        {
            fprintf(stderr,"Error : %s at line %d.\n",type,yylineno);
            fprintf(stderr,"Last token read was %s\n\n",yytext);
            exit(1);
        }
        break;

        case ERROR_LEXICAL:
        {
            fprintf(stderr,"Error at line %d.\n",yylineno);
            fprintf(stderr,"I didn't understand the token %s\n",yytext);	
fprintf(stderr,"I will treate it as an identifier and try to recover.\n\n");
        }
        break;

        case ERROR_ILLEGAL:
        {
            fprintf(stderr,"Illegal %s at line %d.\n",type,yylineno);
            fprintf(stderr,"The token `%s' is not a legal %s\n\n",extra,type);
        }
        break;

        default:
            fatal("Illegal error in masc_error");
    }
	masc_errors++;
}
%}

letter          [a-zA-Z]
letter_or_digit [a-z_A-Z0-9]
whitespace      [ \t\n]

%%
{whitespace}+             ;
";;;"                   {
    int c;
    while((c = yyinput()) != '\n')
        ;
}
"system:"                   	return(SYSTEM); 
"host:"                     	return(HOST);
"groups:"                    	return(GROUP);
"agent:"                    	return(AGENT);
"language:"                 	return(LANGUAGE);
"superordinate:" 	|
"sups:"		           	return(SUPERORDINATE);
"subordinate:"		|
"subs:"				return(SUBORDINATE);
"options:"			return(OPTIONS);
"trace"				{	opt_trace = TRUE;
					return(OPT);
			}
"use_mp"			{	opt_use_mp = TRUE;
					return(OPT);
			}
"wintool"			{	opt_wintool = TRUE;
					return(OPT);
			}
"dkbs"				{	opt_dkbs = TRUE;
					return(OPT);
			}
"reader"			{	opt_reader = TRUE;
					return(OPT);
			}
"sunview"			{	opt_sunview = TRUE;
					return(OPT);
			}
"debugger"			{	opt_debugger = TRUE;
					return(OPT);
			}
{letter}{letter_or_digit}+  {
				char *cp;
				cp = stralloc(yytext);
				yylval = strinsert(sym_tab,&num_of_sym,cp);
				return(IDEN); 
			}
.                       {
    masc_error(ERROR_LEXICAL,"lexical error",null(char));
	return(IDEN);
}
