;;; user.mp
;;;
;;; M J Wooldridge
;;; January 1990
;;;
;;; The user agent for the animals demo

model: user

    skills: (ostrich penguin albatross zebra giraffe tiger cheetah )

    acquaintances:

        carnivores
            skills: (is_carnivore)

        birds
            skills: (is_bird flies)

program:

;;; load code libraries

load basic_comms.p
load shell.p

;;; Rules

rule(
[cheetah
    [and
        is_carnivore
        dark_spots
    ]
]);

rule(
[albatross
    [and
        is_bird
        flies_well
    ]
]);

rule(
[penguin
    [and
        is_bird
        swims
        [not flies]
    ]
]);

rule(
[ostrich
    [and
        is_bird
        [not flies]
        long
    ]
]);

rule(
[zebra
    [and
        ungulate
        black_stripes
    ]
]);

rule(
[giraffe
    [and
        ungulate
        long
    ]
]);

rule(
[tiger
    [and
        is_carnivore
        black_stripes
    ]
]);

rule(
[ungulate
    [and
        mammal
        chews_cud
    ]
]);

rule(
[mammal
    [or
        gives_milk
        has_hair
    ]
]);

;;; Meta-Rules

metarule(
[fostrich ostrich 
	[ 
		[ print
			['The animal is an Ostrich']
		]
		[ quit ]
	]
]
);

metarule(
[fpenguin penguin 
	[
		[ print 
			['The animal is a Penguin']
		]
		[quit]
	]
]
);

metarule(
[falbatross albatross 
	[
		[ print 
			['The animal was an Albatross']
		]
		[quit]
	]
]
);

metarule(
[fzebra zebra 
	[
		[print
			['The animal was a Zebra']
		]
		[quit]
	]
]
);

metarule(
[fgiraffe giraffe 
	[
		[print 
			['The animal was a Giraffe']
		]
		[quit]
	]
]
);

metarule(
[ftiger tiger 
	[
		[print
			['The animal was a Tiger']
		]
		[quit]
	]
]
);

metarule(
[fcheetah cheetah 
	[
		[print
			['The animal was a cheetah']
		]
		[quit]
	]
]
);

;;; Questions

question(
[has_hair  'Does the animal have hair']);

question(
[gives_milk 'Does the animal give milk']);

question(
[flies_well	'Does the animal fly well']);

question(
[hoofs 'Does the animal have hoofs']);

question(
[chews_cud 'Does the animal chew the cud']);

question(
[tawny 'Is the animal a tawny (light brown) colour']);

question(
[dark_spots 'Is the animal covered in dark spots']);

question(
[black_stripes 'Is the animal covered in black stripes']);

question(
[long 'Does the animal have long legs AND a long neck']);

question(
[swims 'Can the animal swim']);

question(
[another_go 'Do you want another go?']);

;;;	Now set up the various environement variables

MIXED_MODE	-> strategy;
DISTRIBUTED	-> operation_mode;
WINDOW		-> terminal_mode;

;;; Now the startup

define startup();

    my_pr('\n\t\t\t   The Animals Database');
    my_pr('\n\t\t\t   --------------------\n\n');
    my_pr('Please answer the following questions...\n');

    investigate(
    [
        tiger
        penguin
        albatross
        zebra
        ostrich
        giraffe
        cheetah
    ]);

    my_pr('\n\t** Sorry, I couldnt guess it.\n');

enddefine;

define  begin();

    vars flag each dummy;

    true -> flag;

    pop11_register("user");

    while flag do

        startup();
        if evaluate("another_go") then
            clear();
            for each in acquaintances do
                pop11_request(each,"restart") -> dummy;
            endfor;
        else
            false -> flag;
        endif;
    endwhile;

enddefine;

begin();
