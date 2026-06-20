;;; carnivores.mp
;;;
;;; M J Wooldridge
;;; January 1990
;;;
;;; A knowledge base that knows about carnivores
;;;

model: carnivores

    skills: (is_carnivore)

    acquaintances:

	dummy
		skills: (nothing)

program:

;;; load the various libraries

load basic_comms.p
load shell.p

;;; load the startup function

load startup.p

;;; rules

rule(
[is_carnivore
    [or
        eats_meat
        [and
            pointed_teeth
            claws
            forward_eyes
        ]
    ]
]);

;;;	Now the questions

question(
[eats_meat 'Does the animal eat meat']);

question(
[pointed_teeth 'Does the animal have pointed teeth']);

question(
[claws 'Does the animal have claws']);

question(
[forward_eyes 'Does the animal have forward pointing eyes']);

;;;	Now start the process up

startup("carnivores");
