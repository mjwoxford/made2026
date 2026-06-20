

/*  blood_rules.p
 *
 *
 *      Rebecca Elks
 *      July 1990
 *
 *      Rules for the `Blood' Agent
 */

;;;         VALUES

value([
pcv
'Enter the packed cell volume (PCV), or haematocrit (%)' ]);

value([
rbc
'Enter the red cell count (RBC x 10^12/l)']);

value([
wbc
'Enter the white cell count (WBC x 10^9/l)']);

value([
hb
'Enter the whole blood haemoglobin concentration ( g/dl)']);

value([
thrombocytes
'Enter the thrombocyte count ( x 10^9/l )']);

value([
albumin
'Enter the blood albumin concentration (g/l)']);

value([
total_protein
'Enter the total protein concentration (g/l)']);

value([
total_bilirubin
'Enter the total bilirubin concentration(micromol/l)']);

value([
bilirubin_conj
'Enter the direct bilirubin(conjugated) concentration (micromol/l)']);

value([
prothrombin_time
'Please enter the result for the one stage prothrombin time(seconds)']);

value([
clotting_time
'Please enter the result for the whole blood clotting time(minutes).']);

;;;     QUESTIONS

;;; Questions concerning RBC morphology

question([
polychromasia
'We now need to examine a blood smear to see if there are signs of a bone '
' marrow response.  '
'On examining the red cell morphology on a blood smear, is there polychromasia'
' present?']);

question([
anisocytosis
' Is there any anisocytosis ?']);

question([
nucleated_rbc
'Are there any nucleated red blood cells present on the blood smear?']);

question([
felv
'What is the cats FeLV status?'
' Please enter Y for positive and N for negative.']);

question([
felv_info
'Do you wish to have more information regarding aplastic or hypoplastic '
'anaemia associated with FeLV infection ?']);

question([
fiv
'What is the cats FIV status?'
'Please enter Y for positive and N for negative.']);


;;;;        RULES
;;;     Rules to determine if Hb within the normal range.
;;;	Units - g/dl

rule([
hb_normal
	[and
		[gt
			hb
			9.7
		]
		[lt
			hb
			12.8
		]
	]
]);

rule([
hb_low
	[lt
		hb
		9.7
	]
]);


;;;	 Rules to determine if the PCV within the normal range.  ( % )

rule([
pcv_normal
	[and
		[gt
			pcv
			34
		]
		[lt
			pcv
			46
		]
	]
]);

rule([
pcv_low
	[lt
		pcv
		34
	]
]);

rule([
pcv_high
	[gt
		pcv
		46
	]
]);

;;;	Rules to determine if the MCHC is normal or low.
;;;	Units - g/dl

rule([
normochromic
	[and
		[gt
			mchc
			29
		]
		[lt
			mchc
			34
		]
	]
]);

rule([
hypochromic
	[lt
		mchc
		29
	]
]);


;;; 	Rules to determine if MCV normal, low or high.
;;;	Units - fl
rule([
normocytic
	[and
		[gt
			mcv
			44
		]
		[lt 
			mcv
			56
		]
	]
]);

rule([
microcytic
	[lt
		mcv
		44
	]
]);

rule([
macrocytic
	[gt
		mcv
		56
	]
]);


;;; Rules to determine if the wbc is within the normal range.
;;; 	Units - x 10^9/l

rule([
wbc_normal
	[and
		[gt
			wbc
			5
		]
		[lt
			wbc
			14
		]
	]
]);

rule([
wbc_low
	[lt
		wbc
		5
	]
]);

rule([
wbc_high
	[gt
		wbc
		14
	]
]);


;;; Rules to determine if the thrombocyte count is within the normal range.

;;;	Units - x 10^9 /l
rule([
thrombocytes_normal
	[and
		[gt
			thrombocytes
			200
		]
		[lt
			thrombocytes
			500
		]
	]
]);

rule([
thromocytopenia
	[lt
		thrombocytes
		200
	]
]);

rule([
thrombocytosis
	[gt
		thrombocytes
		500
	]
]);

        
;;; Rule to determine if there are signs of regeneration.

rule([
regeneration
	[or
		polychromasia
		[or
			anisocytosis
			nucleated_rbc
		]
	]
]);

    
;;; Rules to determine if the bilirubin(unconjugated) is within the normal
;;; range.  Units - micromol/l

rule([
bilirubin_unconj_normal
	[lt
		bilirubin_unconj
		5
	]
]);

rule([
bilirubin_unconj_high
	[gt
		bilirubin_unconj
		5
    ]
]);
;;; Rule to determine if prehepatic jaundice.

rule([
prehepatic_jaundice
	[and
		bilirubin_unconj_high
		bilirubin_conj_normal
	]
]);


;;; Rules to determine if the direct or conjugated bilirubin is within the
;;; normal range.

rule([
bilirubin_conj_normal
	[lt
		bilirubin_conj
		5
	]
]);

rule([
bilirubin_conj_high
	[gt
		bilirubin_conj
		5
	]
]);


;;; Rules to determine if the total protein is within the normal range
;;; 	Units - g/l

rule([
total_protein_normal
	[and
		[gt
			total_protein
			60
		]
		[lt
			total_protein
			70
		]
	]
]);
rule([
total_protein_low
	[lt
		total_protein
		60
	]
]);

rule([
total_protein_high
	[gt
		total_protein
		70
	]
]);

;;; Rules to determine if the blood albumin is within the normal range.
;;;	 Units - g/l

rule([
albumin_normal
	[and
		[gt
			albumin
			25
		]
		[lt
			albumin
			35
		]
	]
]);

rule([
albumin_low
	[lt
		albumin
		25
	]
]);

;;;	Rules for the prothrombin time.

;;;	Units - minutes
rule([
prothrombin_time_normal
	[lt
		prothrombin_time
		8
	]
]);

rule([
prothrombin_time_increased
	[gt
		prothrombin_time
		60
	]
]);

rule([
prothrombin_time_marginal
	[gt
		prothrombin_time
		8
	]
	[lt
		prothrombin_time
		60
	]
]);

;;;	Rules for the clotting time.
;;;	Units - seconds

rule([
clotting_time_normal
	[lt
		clotting_time
		4
	]
]);

rule([
clotting_time_increased
	[gt
		clotting_time
		9
	]
]);

rule([
clotting_time_marginal
	[gt
		clotting_time
		4
	]
	[lt
		clotting_time
		9
	]
]);


rule([possible_haemorrhage
	[and
		regeneration
		total_protein_low
	]
]);

;;;     METARULES


;;; To determine if cat is anaemic check the pcv or the Hb.

metarule([
not_anaemia
	[or
		hb_normal
		pcv_normal
	]
	[
		[print
			[
'The cat is not anaemic, since the Hb and PCV are within the normal range.\n'
'Consider other conditions which may fit the clinical signs e.g. cardiac disease.'
			]
		]
	[quit]
	]
]);

metarule([
polycythaemia
	pcv_high
	[
		[print
			[
'The cat appears to have polycythaemia.\nThis may be a primary condition such as'
' polycythaemia vera, or  secondary due to chronic hypoxia e.g.associated with '
'cardio-pulmonary disease such as tetralogy of fallot.\nBoth conditions are rare.''\nHowever the diagnosis of these conditions is outside the scope of this system.'
			]
		]
	[quit]
	]
]);


;;;     Rule to determine if the cat is anaemic.
;;; The following metarule does some calculation with the variable mcv
;;; and mchc

vars mcv mchc;

metarule([
has_anaemia
	[or
		hb_low
		pcv_low
	]
	[
		[print
			[
'\nWe are making progress. The cat is anaemic!'
'\nI will now investigate the cause.'
			]
		]   
	[investigate [rbc hb pcv]]
		[pop
			[

    ;;; calculate the mcv from pcv and rbc

    (getfact("pcv") * 10) / getfact("rbc") -> mcv;
    assert("mcv",mcv);

    (getfact("hb") * 100/ getfact("pcv")) -> mchc;
    assert("mchc",mchc);
			]
		]       
	[investigate [ normocytic microcytic macrocytic 
			normochromic hypochromic 
			inconclusive_1 inconclusive_2
			inconclusive_3 inconclusive_4]]
	]
]);

;;; 	Metarule to pick up on microcytic, hypochromic anaemia.

metarule([
microcytic_hypochromic_anaemia
	[and
		hypochromic 
		microcytic 
	]
	[
		[print
			[
'The cat has a microcytic, hypochromic anaemia.\n'
'This occurs when the bone marrow has depleted its reserves of iron. \n '
'Causes include:\n (1) Severe iron deficiency,\n(2) Severe or prolonged '
'haemorrhage,\n(3) Prolonged haemolysis.\nThe most likely cause is chronic '
'haemorrhage, in which red cells are lost from the body, therefore leading to'
'marrow exhaustion.  It is therefore best to consider the causes of prolonged '
'haemorrhage initially e.g bleedingfom the gastro-intestinal tract, the  '
'genito-urinary tract and so on.'
			]
		]
	[quit]
	]
]);


;;;     Metarule to pick up on an increased MCV i.e. macrocytic anaemia.

metarule([
macrocytic_anaemia
	macrocytic
	[
		[print
			[
'The cat has a macrocytic anaemia.\n'
'I will now attempt to determine the cause.'
			]
		]
		[investigate [regeneration]]
	]
]);


;;; Metarule to pick up on a regenerative anaemia i.e.a bone marrow response
;;; This uses the variable bilirubin_unconj in a calculation to derive the
;;; indirect bilirubin from the total bilirubin and direct/conjugated 
;;; bilirubin.

vars bilirubin_unconj;

metarule([
regenerative_anaemia
    regeneration
	[
		[print
			[
'The anaemia appears to be regenerative i.e. it is accompanied by a bone \n'
'marrow response.  A macrocytic anaemia with regeneration is generally \n'
'caused by either haemorrhage or haemolysis.\n'
'I will now try to distinguish between these possible causes.'
			]
		]
		[investigate [total_protein total_bilirubin
			      bilirubin_conj]]
		[pop
			[
			getfact("total_bilirubin") - getfact("bilirubin_conj")
                     		-> bilirubin_unconj;
			assert("bilirubin_unconj",bilirubin_unconj);
			]
		]
	[investigate [prehepatic_jaundice possible_haemorrhage]] 
	]
]);


;;; Metarule to pick up on haemorrhagic anaemia.

metarule([
haemorrhagic_anaemia
	possible_haemorrhage
	[
		[print
			[
'The cat appears to have a haemorrhagic anaemia.\n'
'I will now try to determine the cause.'
			]
		]
	;;; send startup message to haemorrhagic agent
	[send haemorrhagic 6  [[requested_startup []]]]
	;;; enter serve state
	[quit]
	]
]);


;;; Metarule to pick up on haemolytic anaemia.
;;; There are two metarules for this condition , in order to deal with the 
;;; inability  of the system to deal with uncertainty.  If the animal has 
;;; prehepatic jaundice then a diagnosis of haemolytic anaemia would be more
;;; certain.  However this does not always occur.

metarule([
haemolytic_anaemia_with_jaundice
	[and
		pre_hepatic_jaundice
		[not total_protein_low]
	]
	[
		[print
			[
'The cat has a haemolytic anaemia, with prehepatic jaundice.\n'
'I will now try to determine the cause.'
			]
		]
		;;; send startup message to haemolytic agent

		[send haemolytic 6 [[requested_startup []]] ]

		;;; enter serve state
	[quit]
	]
]);

metarule([
haemolytic_anaemia_mixed_jaundice
	[and
		bilirubin_conj_high
		bilirubin_unconj_high
	]
	[
		[print
			[
'The cat appears to have a haemolytic anaemia, with a mixed type jaundice.\n'
'I will now try to determine the cause.'
			]
		]
		;;; send startup message to haemolytic agent
		
		[send haemolytic 6 [[requested_startup []]] ]
		
		;;; enter serve state
	[quit]
	]
]);

metarule([
haemolytic_anaemia    
	[not total_protein_low]	
	[
		[print
			[
'The cat appears to have a haemolytic anaemia.\n'
'I will now try to determine the cause.'
			]
        	]

		;;; send startup message to haemolytic

		[send haemolytic 6 [[requested_startup []]] ]

		;;; enter serve state

		[quit]
	]
]);
    
                                
;;;  Metarule to pick up on a normal MCV and a normal MCHC. 
;;;  Then investigate the cats FeLV status.

metarule([
normocytic_normochromic_anaemia
	[and
		normocytic
		normochromic
	]
	[investigate [felv]]
]);


;;; Metarule to pick up on normal MCV and decreased MCHC.

metarule([
normocytic_hypochromic_anaemia
	[and
		normocytic
		hypochromic
	]
	[
        	[print
			[
'\n** The cat has a normocytic, hypochromic anaemia. **\n'
'I will now attempt to determine the cause.\n'
			]
		]

		;;; inform the blood agent of what's happened
	
		[send initial 6 [[inform [normo_hypo true]]] ]

		;;; can't do anything else, so wait
	
		[quit]
	]
]);


;;; Metarule to pick up on an increased MCV but no other signs of a marrow
;;; response.

metarule([
myelophthisic_anaemia
	[not regeneration]
	[
		[print
			[
'There is evidence to suggest that the cat may have a myeloproliferative\n'
'or myelophthisic anaemia since it has a macrocytic anaemia but with no other\n'
'signs of a regenerative response.\n'
'A bone marrow biopsy should be performed to confirm the diagnosis.\n'
'The cats FeLV status should  also be determined as these cases are\n'
'generally positive.\n'
			]
		]
	[quit]
	]
]); 


;;; Metarule to pick up on a normochromic, normocytic anaemia and FeLV
;;; positive.

metarule([
normochromic_normocytic_felv_positive
	felv
	[
		[print
			[
'The cat has a normochromic, normocytic anaemia associated with FeLV infection.'
			]
		]
	[investigate [felv_info]]
	]
]);

;;;	Metarule to give information regarding FeLV and aplastic anaemia.

metarule([
felv_assoc_anaemia
	felv_info
	[
		[print
			[
'FeLv is the most important cause of anaemia in cats, being responsible for a '
'variety of types including the hypoplastic and aplastic anaemias.\n'
'The anaemia may be as a result of lymphoid or myeloid leukaemia with their \n'
'deleterious effect on haematopoiesis, or more likely as a primary effect \n'
'of the virus itself.\n'
'Of these the most commonly diagnosed is erythroid hypoplasia, where only \n'
'cells of the erythroid series are affected. This is analogous to pure red \n'
'cell aplasia in man.  Complete marrow aplasia or hypoplasia also occurs \n'
'which is usually fatal.\n'
'There may be evidence of neoplasia associated with FeLV.\n'
'Euthanasia is usually recommended since the long term prognosis is \n'
'poor, even if the animal survives a short time with minimal clinical signs.\n'				]
		]
	[quit]
	]
]);

;;; Metarule to check FIV status if FeLV negative

metarule([
possible_fiv
	[not felv]
	[
		[investigate [fiv]]
	]
]);

;;; Metarule to give cause, if FIV positive

metarule([
fiv_positive
	fiv
	[
		[print
			[
'The anaemia is most probably linked to the FIV infection, which is known to \n'
'cause anaemia in cats.  The prognosis is always guarded in these cases, but \n'
'it may be 1-3 years before serious clinical signs develop. \n'
'Many cats suffer chronic or recurrent bouts of illness e.g gingivitis, \n'
'diarrhoea and anaemia, for which symptomatic treatment should be attempted. \n''However euthanasia should be considered once treatment becomes ineffective \n'
'and the quality of life falls below an acceptible level. '
			]
		]
	[quit]
	]
]);

;;; Metarule to pick up on a normochromic, normocytic anaemia and FeLV
;;; negative.  Then investigate  wether it is a pure red cell aplasia or
;;; complete bone marrow aplasia/hypoplasia.

metarule([
normochromic_normocytic_felv_negative
	[and
		[not felv]
		[not fiv]
	]
	[
		[investigate[wbc_low]]
	]
]);


;;; Metarule to pick up on marrow aplasia or hypoplasia.

metarule([
marrow_aplasia
	wbc_low
	[
		[print
			[
'The cat appears to have an anaemia associated with bone marrow aplasia or \n'
'hypoplasia, since the wbc are also decreased.\n'
'A bone marrow biopsy should be performed to confirm the diagnosis.\n'
'I will now attempt to determine the cause of the aplasia.'
			]
		]
	;;; send startup message to aplasia agent

	[send aplasia 6 [[requested_startup []]] ]

	;;; enter serve state

	[serve]
	]
]);


;;; Metarule to pick up on pure red cell aplasia.

metarule([
red_cell_aplasia
	[not wbc_low]
	[
		[print
			[
'The cat appears to have an anaemia due to a pure red cell aplasia.\n'
'A bone marrow biopsy should be performed to confirm the diagnosis.\n'
'I will now attempt to determine the cause of the aplasia.'
			]
		]
		;;; send startup message to aplasia

		[send aplasia 6 [[requested_startup []]]]

		;;; enter serve state

		[quit]
	]
]);

;;;	Metarule to end the consultation.

metarule([
end
	[not felv_info]
	[
		[quit]
	]
]);


;;;	Metarule to pick up on inconclusive results.

metarule([
inconclusive
	[and
		inconclusive_1
		[and
			inconclusive_2
			[and
				inconclusive_3
				inconclusive_4
			]
		]
	]

	[
		[print
			[
'I am unable to make a diagnosis, since the findings of the tests have resulted'
' in an anaemia which cannot easily be classified.\n'
'It may be advisable to repeat the blood tests, being careful to take a good '
'quality blood sample.'
			]
		]
	[quit]
	]
]);


rule([
inconclusive_1
	[not macrocytic]
]);

rule([
inconclusive_2
	[not
		[and
			microcytic
			hypochromic
		]
	]
]);

rule([
inconclusive_3
	[not
		[and
			normocytic
			normochromic
		]
	]
]);

rule([
inconclusive_4
	[not
		[and
			normocytic
			 hypochromic
		]
	]
]);

