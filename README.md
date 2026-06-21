# MADE: The Multi-Agent Development Environment

This codebase represents my first work on multi-agent systems, at the start of my PhD. I sketched out the basic architecture for a cooperating expert system platform in early 1989, and started work in October 1989. Development continued until late 1990. 

The platform was implemented on Sun 3/60 workstations, using the SunView interface. It supported communication across networks using RPCs, which seemed easier to get up and running that fiddling directly with ports.

Agents are UNIX processes. Interprocess communication is done via FIFOs. I used the POP-11 platform for buuilding agents because it supported multiple AI language (LISP and PROLOG) as well as the POP-11 language. 

Agents are essentially expert systems; there is a POP-11 expert system shell in there as well. The applications directory contains a sample animals system and a much larger FELINE system which was implemented by MSc student Rebecca Elks (a vet) for her MSC project. 

The system came with 2 domain specific languages: the model parser (MP) program allowed users to define front ends to their agents in a common framework. The MASC (Multi-agent system compiler) language generates a C program to install a system (this was quite tedious to do manually as it involved launching multiple processes in sequence).

In the intervening period I somehow lost the MP program, and I suspect some files are corrupted because I stopped implementation leaving various threads dangling.

The work was described in: *M. Wooldridge, G. M. P. O’Hare, and R. Elks. FELINE — A Case Study in the Design and Implementation of a Co-operating Expert System. In Proceedings of the International Conference on Expert Systems and their Applications (Avignon-91), Avignon, France, May 1991.* 

CLAUDE said it was a "fascinating historial artifact", and since multi-agent systems are a thing again it seemed worth making public.

<img width="678" height="426" alt="image" src="https://github.com/user-attachments/assets/9e133a98-feba-4c00-b7ba-282d094fd632" />
