/*	haemorrhagic_rules.p
 *
 *
 *	Rebecca Elks
 *
 *	August 1990
 *
 *	Rules for the agent 'Haemorrhagic'
 */


;;;	QUESTIONS


;;;	Questions for bleeding disorders.

question([
bleeding_tendency
'Does the cat have an abnormal tendency to bleed or bruise ?']);

question([
warfarin_info
'Do you wish to have more information regarding the treatment of warfarin '
'poisonning ?']);

question([
clotting_tests_info
'Do you wish to carry out tests for the whole blood clotting time and the one '
'stage prothrombin time, with interpretation of results ?']);

question([
superficial_bleeding
'Are there signs of superficial bleeding, such as purpura, oozing from the '
' mucous membranes or epistaxis ?']);

question([
deep_bleeding
'Are there signs of deep bleeding, such as haemarthrosis, intramuscular '
'haematoma, intracavity bleeds, or pulmonary haemorrhage ?']);

question([
trauma
'Was the cat initially presented with signs of trauma, but with no obvious '
'external wounds to explain the source of haemorrhage ?']);


question([
urine_dipstix
'Is there evidence of haematuria on a urine dipstix test ?']);

question([
occult_blood
'Is the test for occult blood positive or negative ? \n Enter Y for positive,'
'N for negative.']);





;;;	RULES


rule([
warfarin	
	[or
		superficial_bleeding
		deep_bleeding
	]
]);

;;;	These rules interpret the clotting tests.  May be better placed in the 
;;;	blood agent.

rule([
clotting_abnormalities
	[or
		[and
			prothrombin_time_increased
			clotting_time_increased
		]
		[or
			[and
				prothrombin_time_increased
				clotting_time_marginal
			]
			[or
				[and
					prothrombin_time_increased
					clotting_time_normal
				]
				[and
				prothrombin_time_marginal
				clotting_time_increased
				]
			]
		]
	]
]);
 

rule([
clotting_inconclusive
	[or
		[and
			prothrombin_time_marginal
			clotting_time_marginal
		]
		[or
			[and
				prothrombin_time_marginal
				clotting_time_normal
			]
			[and
				prothrombin_time_normal
				clotting_time_increased
			]
		]
	]
]);

rule([
clotting_normal
	[or
		[and
			prothrombin_time_normal
			clotting_time_normal
		]
		[and
			prothrombin_time_normal
			clotting_time_marginal
		]
	]
]);


;;;	METARULES

;;;	For the acute onset conditions.

metarule([
possible_acquired_coagulopathy
	[eq
		duration
		acute_onset
	]
	[
		[investigate[warfarin]]
	]
]);

;;;	If signs of bleeding then probably an acquired coagulopathy.

metarule([
acquired_coagulopathy
	warfarin
	[
		[print
			[
'The signs are suggestive of an acquired coagulopathy such as warfarin ,'
'poisonning or other coumarin type poison\n The cat should be tested for any '
'clotting abnormalities.  The whole blood clotting time and the one stage '
'prothrombin time should be measured.  However the one stage prothrombin time '
'is the best indicator.'
			]
		]
	[investigate[warfarin_info clotting_tests_info]]
	]
]);

;;;	To give more information about the treatment of warfarin poisonning.

metarule([
warfarin_treatment
	warfarin_info
	[
		[print
			[
'Warfarin and related compounds antagonise the action of vitamin K, thereby '
'preventing the synthesis of several clotting factors by the liver.\n'
'TREATMENT:  Vitamin K1(Konakion,Roche) should be given i/v at a dose of 1-2 mg/kg. '
' Two doses should be given i/v 6 hours apart.\n'
'Then the i/m route may be used once daily, followed by oral administration for'
' 3-5 days.  The one stage prothrombim time should be checked before stopping '
'treatment.  It takes up to 6 hours for any clinical response from the first '
'dose.\n'
'Supportive Measures: The patient should be protected from any impact or '
'pressure.  Sedation may be advisable.  If bleeding is severe a blood transfusion'
' may be necessary.  Fresh blood must be used to provide clotting factors , '
'at a dose of 10-20 ml/kg.  Chest drainage may be required if there are severe '
'respiratory problems from haemorrhage into the pleural cavity.\n'
'PROGNOSIS:  Good, provided the condition is recognised early on and therapy '
'is prompt and adequately maintained.'
			]
		]
	[investigate [clotting_tests_info]]
	]
]);

;;;	Metarule to ask the blood agent to look at the clotting time and the
;;;	prothrombin time.

metarule([
possible_clotting_abnormalities
	clotting_tests_info
	[investigate[   prothrombin_time_normal
			prothrombin_time_increased
			prothrombin_time_marginal
			clotting_time_normal
			clotting_time_increased
			clotting_time_marginal]]
]);

metarule([
finish
	[not clotting_tests_info]
	[
		[quit]
	]
]);

;;;	Metarules to pick up on the interpretation of the clotting tests.

metarule([
confirm_acquired_coagulopathy
		clotting_abnormalities
	[
		[print
			[
'The findings of the clotting tests confirm the diagnosis of an acquired '
'coagulopathy such as warfarin poisonning.'
			]
		]
	[quit]
	]
]);

metarule([
not_acquired_coagulopathy
	clotting_normal
	[
		[print
			[
'The clotting tests are normal.  Therfore the problem is not an acquired  '
'bleeding disorder.  Consider other causes of haemorrhage e.g trauma, chronic '
'haemorrhage from urinary tract, gastro intestinal tract and so on.'
			]
		]
	[quit]
	]
]);

metarule([
inconclusive_clotting_tests
	clotting_inconclusive
	[
		[print
			[
'Results of the clotting tests are inconclusive, with some increase from normal'
'values.  The tests may be repeated which may clarify the situation.  However '
'it is adviseable to start vitamin K therapy.  A response to vitamin K will '
'confirm a diagnosis of an acquired coagulopathy.'
			]
		]
	[quit]
	]
]);

;;;	Metarule to consider trauma if no signs of bleeding.

metarule([
possible_trauma
	[not warfarin]
	[investigate[trauma]]
]);

metarule([
possible_internal_haemorrhage
	trauma
	[
		[print
			[
'It is possible that the cat may have sustained injuries resulting in possible '
'internal haemorrhage, but that the symptoms at the time of the injury were '
'indistinguishable from those of hypovolaemic shock.\nProvided that the animal '
'has received treatment for shock(i.e. to restore circulating volume), it is '
'able to loose up to 2/3rds of its blood volume without requiring a blood '
'transfusion.\nThe haemorrhage is most likely to be intra-abdominal(e.g ruptured'
' spleen), since bleeding into the pleural or pericardial cavities would result in'
' signs of pulmonary collapse or cardiac tamponade, requiring emergency treatment.\n'
'Radiography and paracentesis may aid in the diagnosis of abdominal haemorrhage.'
			]
		]
	[quit]
	]
]);

metarule([
inconclusive
	[not trauma]
	[
		[print
			[
'The findings are inconclusive.\nConsider alternative causes such as possible '
'chronic haemorrhage or congenital/inherited coagulopathies that may have been '
'present for some time but been unnoticed by the owner.'
			]
		]
	[quit]
	]
]);



;;;	Metarules for the chronic conditions.

;;;	Metarule to consider possible bleeding tendency.

metarule([
possible_congenital_coagulopathy
	[eq
		duration
		chronic_illness_/_insidious_onset
	]	
	[investigate[bleeding_tendency]]
]);

metarule([
congenital_coagulopathy
	bleeding_tendency
	[
		[print
			[
'If the cat has a bleeding tendency which has is longstanding/congenital, it may be '
'an inherited condition. Other related cats may be affected, so it is advisable to '
'investigate other cats in the breeding line involved.\n'
'A brief description of possible conditions are given below, but the diagnosis of '
'these is outside the scope of this system.  All occur only rarely in the cat.\n\n'
'(1) Coagulation Abnormalities.\n(a) Haemophilia.  This is a congenital condition '
'and is inherited in a sex-linked fashion.  Levels of factor V111 are decreased.\n'
'(b) Hageman factor deficiency (factor X11).  Inherited in an autosomal recessive '
'manner.\n(c) Devon Rex coagulopathy.  Here the major deficiency is factor X.\n\n'
'(2) Platelet Abnormalities.\n(a) Chediak-Higashi Syndrome.  Inherited in an '
'autosomal recessive  fashion and has only been reported in the Persian blue-smoke'
' colour.'
			]
		]
	[quit]
	]
]);

;;;	Metarule to continue if not congenital coagolopathy.

metarule([
not_congenital_coagulopathy
	[not bleeding_tendency]
	[
		[investigate haematuria]
	]
]);


;;;	Metarule to pick up on urinary tract bleeding as the cause.
metarule([
urinary_tract_bleeding
	[or
		haematuria
		urine_dipstix
	]
	[
		[print
			[
'As the cat has haematuria, the cause of the anaemia may be urinary tract bleeding.  '
'Causes include:\n(1) Urinary tract infection(+/- Urolithiasis) and associated FUS.'
'e.g. severe chronic cystitis with ulceration.  This may be either bacterial or  '
'associated with Feline Urological Syndrome.  Signs may include increased frequency '
'of urination, dysuria, obstruction to urine flow or more rarely incontinence. Mild '
'infections may show no clinical signs.\n'
'(2) Neoplasia e.g. bladder neoplasia. Rare, but usually a transitional cell'
' carcinoma, which occurs in older animals.  Symptoms are unresponsive to treatment '
'with antibiotics.  Diagnosis may be made by contrast radiography and laparotomy.\n'
'(3) True calculi e.g. phosphate.  This is uncommon compared to FUS.  It is seen more'
' often in the female.'
			]
		]
	[quit]
	]
]);

;;;	Metarule to continue if no haematuria.

metarule([
no_haematuria
	[not haematuria]
	[
		[investigate[ git haematemesis ]]
	]
]);

;;;	Metarule to pick up on GIT bleeding as the cause.

metarule([
git_bleeding
	[or
		[not[eq
			git
			normal
		]]
		[or
			haematemesis
			occult_blood
		]
	]
	[
		[print
			[
'The clinical signs are suggestive of bleeding from the gastro-intestinal tract.\n'
'This may occur in a number of conditions:\n(1) Ulceration of the mucosa e.g. with '
'neoplasms,\n(2) Severe endo-parasite burden e.g. coccidia, but this usually only '
'occurs in kittens,\n(3) Severe liver failure.\n'
'Useful diagnostic aids to distingiush between these may include radiography '
'(+/- contrast media), endoscopy, biochemistry/enzymology, faecal examination, '
'and exploratory laparotomy.'
			]
		]
	[quit]
	]
]);

metarule([
possible_urinary_tract_bleeding
	[and
		[not haematuria]
		[and
			[eq
				git
				normal
			]
 			[not haematemesis]
		]
	]
	[
		[print
			[
'In order to determine if the haemorrhage is from the genito-urinary tract, it is '
'necessary to test the urine for the presecnce of blood.'
			]
		]
	[investigate[urine_dipstix]]
	]
]);

;;;	Metarule to consider git bleeding if urinary tract bleeding ruled out on dipstix
;;;	test.

metarule([
possible_git_bleeding
	[not urine_dipstix]
	[
		[print
			[
'In order to determine wether the source of haemorrhage is the gastro-intestinal tract '
'it is necessary to carry out a test for occult blood in the faeces. '
			]
		]
	[investigate[occult_blood]]
	]
]);



;;;	Metarule to consider the remaining causes.

metarule([
remaining_causes
	[not occult_blood]
	[
		[print
			[
'Final causes to consider as the cause of the haemorrhage:\n'
'(1) Occasionally animals with a severe ectoparasite burden e.g. fleas lice'
' may have anaemia.  However this is generally obvious on initial examinatuon of '
'the animal.\n(2) Internal lesions causing chronic bleeding e.g into the '
'peritoneal cavity from a tumour.  Here red cell constituents may be recycled, '
'so that hypochromasia does not develop.  Regeneration is often very active in'
' these cases.'
			]
		]
	[quit]
	]
]);
