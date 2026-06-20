;;; birds.mp
;;;
;;; M J Wooldridge
;;; January 1990
;;;
;;; A knowledge base that knows how to identify a bird - for use in
;;; the distributed animals knowledge base.

model: birds

    skills: (is_bird)

    acquaintances:

		dummy
			skills: ( nothing )

program:

;;; load code libraries

load basic_comms.p
load shell.p
load startup.p

;;; Rules

rule(
[is_bird
    [or
        has_feathers
        [and
            flies
            lays_eggs
        ]
    ]
]);

;;;	Questions

question(
[flies 'Does the animal fly']);

question(
[lays_eggs 'Does the animal lay eggs']);

question(
[flies_well 'Does the animal fly well']);

question(
[has_feathers 'Does the animal have feathers']);

;;; Now the `startup' function

startup("birds");
