/*  initial_rules.p
 *
 *  Rebecca Elks
 *  July 1990
 *
 *  Rules for the initial agent
 */

;;; First to detect the lack of likelihood of anaemia.

rule([ not_likely_anaemia
   [and
      [eq appetite normal]
      [and
         [not pica]
         [and
            [not haematemesis]
            [and
               [eq colour normal]
               [and
                  [not icterus]
                  [and
                     [not brown]
                     [and
                        [not cyanosis]
                        [and
                           [eq weight normal]
                           [and
                              [eq lymph_nodes normal]
                              [and
                                 [eq respiration normal]
                                 [and
                                    [not murmur]
                                    [and
                                       [eq heart_rate normal]
                                       [and
                                          [eq pulse_rate normal]
                                          [and
                                             [eq temperature normal]
                                             [and
                                                [eq abdomen nad]
                                                [and
                                                   [not abdominal_masses]
                                                   [and
                                                      [not fractures]
                                                      [not torn_claws]
                                                   ]
                                                ]
                                             ]
                                          ]
                                       ]
                                    ]
                                 ]
                              ]
                           ]
                        ]
                     ]
                  ]
               ]
            ]
         ]
      ]
   ]
]);


;;; ok after that silly rule, some meta-rules to pick up on things.

;;; First pick up on not_likely anaemia.

metarule([
is_not_likely_anaemia
    not_likely_anaemia
    [
        [print
            [
'There are no clinical signs suggestive of anaemia.\n\n'
'** Try taking PCV if you are really concerned.'
            ]
        ]
        [quit]
    ]
]);

;;; if anaemia likely

metarule(
[possible_anaemia
        [not not_likely_anaemia]
        [
            [investigate [acute_trauma]]
        ]
]);

metarule([
no_acute_trauma
        [not acute_trauma]
        [
            [investigate [warfarin
                         paracetamol]]
        ]
]);

;;; Next a rule to look for signs of acute trauma

rule([
acute_trauma
        [and
            [eq colour pale]
            [and
                    [or
                        [eq heart_rate tachycardia]
                        [eq pulse_character collapsing]
                    ]
                    [and
                    	[eq duration acute_onset]
                            [or
                                wounds
                                [or
                                        torn_claws
                                        fractures
                                ]
                            ]
			]
		]
        ]
]);

metarule([
acute_trauma_cause
    acute_trauma
    [
        [print
            [
'\nThe history is suggestive of a road traffic accident or other acute trauma.\n'
'Treatment for shock is recomended, together with arresting any source of\n'
'haemorrhage, i.e. fluid therapy, large doses of corticosteroids\n'
'and/or analgesia as required.\n'
            ]
        ]
        [quit]
    ]
]);

metarule([
warfarin_cause
    warfarin
    [
        [print
            [
'\nThe history is suggestive of warfarin poisonning.\n'
'Vitamin K1 therapy is advised, together with blood transfusions if haemorrhage\n'
'is severe.\n\n'
'Fresh blood must be used since it is necessary to provide clotting factors.\n'
            ]
        ]
        [quit]
    ]
]);

;;; metarule to pick up on paracetamol poisonning

metarule([
paracetamol_cause
    paracetamol
    [
        [print
            [
'\nThe signs are suggestive of paracetamol poisonning or other oxidative poison.\n'
'Additional signs include facial oedema, excessive salivation, and dilated \n'
'pupils.  The prognosis is usually very poor.\n'
'Possible treatment includes use of the following:\n'
'(a) N-acetyl-L-cysteine(Parvolex), given intravenously at an initial dose \n'
'of 140 mg/kg, followed by six or seven further doses at 70 mg/kg at six \n'
'hourly intervals.\n'
'(b) Ascorbic acid at a dose rate of 30 mg/kg orally every six hours.\n'
'(c) Oxygen to alleviate the hypoxia.\n'
'(d) Fluid therapy, using lactated Ringer.\n'
	        ]
        ]
	[quit]
    ]
]);

metarule([
do_bloods
    [not paracetamol]
    [
        [print
            [
'Further information is required before a diagnosis can be made.\n'
'Some blood tests are required:\n'
	'\t* packed cell volume (pcv)\n'
	'\t* haemaglobin (Hb) \n'
	'\t* red blood cell counts (rbc)\n'
	'\t* white cell count (wbc)\n'
	'\t* thrombocyte count\n'
	'\t* examination of a blood smear for asssessment of cell morphology.\n'
'The cats FeLV status should also be determined.\n'
            ]
        ]		
		;;; pass startup message to blood agent
	[send blood 4 [[requested_startup []]]]
	[quit]
    ]
]);

;;; Metarule to investigate the age of the cat, if it has a normocytic,
;;; hypochromic anaemia( result from the blood agent).

metarule([
possible_iron_deficiency
    normo_hypo		;;; sent from the blood agent
    [investigate[kitten_dietary]]
]);


;;; Metarule to pick up on iron deficiency as the cause of the anaemia.

metarule([
iron_deficiency
    kitten_dietary
    [
        [print
            [
'\nDue to the low levels of iron in milk, the cat may have a mild anaemia due\n'
'to iron deficiency. In all kittens the PCV reaches its lowest level (20-25%)\n'
'between 4-6 weeks of age, and increases to adult levels by about 6 months.\n'
'This is usually not a clinical problem, but sometimes individuals fail to\n'
'thrive, due to even lower levels.  Treatment involves the use of iron\n'
'supplements e.g. iron dextran injection or ferrous sulphate tablets.\n'
            ]
        ]
    [investigate[continue]]
    ]
]);


;;; Metarule to end the consultation if the user wishes.

metarule([
finish
    [not continue]
    [
    [quit]
    ]
]);


;;; Metarule to continue the consultation after iron deficiency.

metarule([
possible_coccidia
    	[or
        	[not kitten_dietary]
        	continue
   	 ]
    
	[
		[investigate[coccidia]]
	]
]);

;;; Metarule to pick up on coccidia as the possible cause of the anaemia.

metarule([
coccidiosis
    coccidia
    [
        [print
            [
'\nThe kitten may have coccidiosis.  Check faecal samples for the prescence of \n'
'oocysts to conform the diagnosis.'
            ]
        ]
    [quit]
    ]
]);

/*
;;; Metarule to investigate possible chronic haemorrhage.

metarule([
	possible_chronic_haemorrhage
    [or
        [not
		[eq
            		age
            		'< 6 months'
            	]
        ]
        [and
        	[not kitten_dietary]
        	[not coccidia]
        ]
    ]
	[
		[print [ 'Investigate chronic haemorrhage.']]
		[quit]
	]
]); */


;;; QUESTIONS


;;; Question to determine if kitten has been weaned or recently weaned.

question([
kitten_unweaned
'Has the kitten been weaned recently or is it still with the mother?']);

;;; Question to determine if the user wants to continue the consultation.

question([
continue
'Do you wish to continue the consultation ?']);

;;; Question to determine if the cat has been kept under  unhygienic
;;; conditions.

question([
unhygienic_conditions
'Has the cat been kept under unhygienic conditions ?']);

;;; RULES


;;; Next a rule to determine if warfarin posioning is likely

rule(
[warfarin
      [and
	   petechiation
           [and
                 [eq duration acute_onset]
                 [or
                     [eq heart_rate tachycardia]
                     [or
                         [eq pulse_rate rapid]
                         [or
                             haematuria
                             [not
                                 [eq git normal]
                             ]
                         ]
                     ]
                 ]
             ]
	]
]);



;;; Rule to determine if paracetamol intoxication
rule(
[paracetamol
        [and
            brown
            [and
                   [eq duration acute_onset]
                   [eq respiration dyspnoea]
                ]
        ]
]);

;;; Rule to determine if microcytic/hypochromic anaemia in a kitten.

rule([
kitten_dietary
    [and
        [eq
            age
            '< 6 months'
        ]
        kitten_unweaned
    ]
]);

;;; Rule to determine if possible coccidiosis.

rule([
coccidia
    [and
        [eq
            age
            '< 6 months'
        ]
        [and
            [eq
                git
                bloody_faeces
            ]
            unhygienic_conditions
        ]
    ]
]);
