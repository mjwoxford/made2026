/*
 * hosts.h
 * 
 * M J Wooldridge January 1990
 * 
 * Definitions for muli-agent, multi-machine systems.
 * *---------------------------------------------------------------------*
 * *-------------* Do NOT Include unless you support RPCs ! *------------*
 * *---------------------------------------------------------------------*
 */

/*
 * First the host names -- edit these to your suit your own environment.
 */

char           *hosts[] = {
	"minsky",
	"schank",
	"winograd",
	"papert",
	"turing",
	"simon",
	"mccarthy",
	((char *) 0)
};

/*
 * Define what underlying protocol to use -- the default is `UDP', the user
 * datagram protocol. Has the advantage of being simple and efficient, but it
 * is connectionless: if you require a reliable transport service, use the
 * `TCP' protocol.
 */

#define PRO "udp"
