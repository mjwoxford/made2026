

/*   haemolytic_rules.p
 *
 *
 *  Rebecca Elks
 *
 *  August 1990
 *
 *
 *  Rules for the 'Haemolytic Anaemia' Agent.
 */


;;; QUESTIONS

question([
haemobartonella_positive
'Is the RBC parasite Haemobartonella felis present on a blood film?']);

question([
fia_info
'Do you require any further information about feline infectious anaemia?']);

question([
felv
'What is the cats FeLV status?  Enter y for positive, n for negative.']);

question([
heinz_bodies
'Are there an increased number of heinz-bodies(over 10%) present on the blood film?']);

question([
autoagglutination
'Is there any autoagglutination of rbcs ?']);

question([
poikilocytes
'Are there poikilocytes(irregular shaped RBC) present?']);

question([
schistocytes
'Are there any schistocytes(red cell fragments) present on a blood smear?']);

question([
alternative_causes
'Do you wish to continue the consultation and consider alternative causes'
' of the anaemia ?']);

question([
cyclic_course
'Has the cat shown any fluctuation in symptoms in a cyclical manner?']);

question([
immune_mediated_info
'Do you wish to have more information on immune mediated anaemia?']);

question([
microangiopathic_info
'Do you wish to have more information on microangiopathic anaemia?']);



;;; RULES

rule([
haemolytic_crisis
    [and
        lethargy
        [and
            weakness
            [and
                [eq
                    appetite
                    decreased
                ]
                [and
                    [eq
                        duration
                        acute_onset
                    ]
                    [eq
                        respiration
                        tachypnoea
                    ]
                ]
            ]
        ]
    ]
]);

rule([
fia
    [and
        [eq
            colour
            pale
        ]
        [and
            [eq
                pulse_character
                collapsing
            ]
            [and
                [eq
                    heart_rate
                    tachycardia
                ]
                [or
                    [eq
                        abdomen
                        enlarged_liver_or_spleen
                    ]
                    [or
                        [eq
                            respiration
                            tachypnoea
                        ]
                        haemic_murmur
                    ]
                ]
            ]
        ]
    ]
]);

rule([
fia_chronic
    [and
        lethargy
        [and
            [eq
                weight
                poor
            ]
            cyclic_course
        ]
    ]
]);



;;; METARULES

metarule([
fia
    haemobartonella_positive
    [
        [print
            [
'The cat has Feline Infectious Anaemia(FIA), associated with parasitism of the '
'RBC by the organism H.felis.  '
            ]
        ]
    [investigate[fia_info]]
    ]
]);

metarule([
finish
    [or
        [not fia_info]
        [or
        [not alternative_causes]
        [or
            [not immune_mediated_info]
            [not microangiopathic_info]
        ]
        ]
    ]
    [
    	[quit]
    ]
]);

metarule([
fia_treatment
    fia_info
    [
        [print
            [
'TREATMENT: Oxytetracycline is the drug of choice(20 mg/kg t.i.d) for at least'
' 14 days. This should be given i/v initially, followed by oral dosing. Blood '
'films should be re-examined for the absence of the parasite before treatment '
'is stopped.  Supportive treatment should include a blood transfusion if '
'required.  Vitamins and a high protein diet may also be useful.\n'
'PROGNOSIS: In severe cases, often fatal within hours or days.  Cats that '
'recover usually become carriers, with the possibility of relapse being likely '
'after a period of remission. The carrier state may persist for many months, so'
' that careful observation of apparently recovered cats is essential.  \n' 
'There is a correlation between FIA and FeLV infection.  Therefore the cat '
'should be tested for FeLV since it may go on to develop FeLV related disease.'
            ]
        ]
    [quit]
    ]
]);

;;; Metarule to investigate the possibility of FIA in spite of negative
;;; H.felis on initial blood film, since one negative is not conclusive.

metarule([
possible_fia
    [not haemobartonella_positive]
    [investigate[ haemolytic_crisis fia fia_chronic]]
]);

;;; Metarule to pick up on FIA if the signs are suggestive.

metarule([
fia_suggestive
    [or
        haemolytic_crisis
        [or
            fia
            fia_chronic
        ]
    ]
    [
        [print
            [
'The history and clinical signs are suggestive of FIA. \n This parasite can be '
'difficult to detect due to the transient parasitaemia and the cyclical nature '
'of the disease.  The peak of the parasitaemia occurs just prior to the '
'haemolytic episode, so that on presentation of the cat, very few parasites are'
'present in the blood for detection.  \nTherefore it is recommended that several '
'blood films are made over a period of 4-10 days before FIA can be ruled out.  '
'Films should be made as soon as possible after the blood sample has been taken'
            ]
        ]
    [investigate[fia_info]]
    ]
]);


;;; Metarule to continue if not FIA.

metarule([
possible_heinz_body_anaemia
    [and
        [not haemolytic_crisis]
        [and
            [not fia]
            [not fia_chronic]
        ]
    ]
    [investigate[heinz_bodies]]
]);

;;; Metarule to pick up on oxidant intoxicants as the possible cause.

metarule([
oxidant_intoxicants
    heinz_bodies
    [
        [print
            [
'The cat has a heinz body haemolytic anaemia, which is caused by oxidative '
'intoxicants. \nCat haemoglobin is very susceptible to oxidation, producing '
'methaemaglobin with heinz body formation and intravascular haemolysis. \n '
' Causes may include the following: \n(1) Paracetamol poisonning, often due to '
'misguided administratuon by the owner, and methylene blue(previously used in '
'urinary antiseptics) which is now less commonly seen.  Faecial oedema  is also'
' a common finding in these cases.\n'
'Prognosis: paracetamol, very poor with only a single tablet being sufficient '
'to cause death within hours. \n Treatment: supportive only. Blood transfusion'
' if PCV below 15%\n '
'(2) Gastrointestinal obstruction or stasis.  This may occur in Key-Gaskell '
'sydrome(feline dysautonomia) and appears to be due to the absorption of '
'intestinal products leading to autointoxication.\n'
'(3) Lead poisonning.  Here there are usually gastrointestinal or CNS signs '
'aswell. In addition there may be large numbers of circulating nucleated RBCs '
'and basophilic stippling of RBCs, though this is not a pathognomonic feature.\n'
'(4) A rare heinz body anaemia has been reported in Siamese kittens, which is '
'of unknown mechanism and appears to occur spontaneously. '
            ]
        ]
    [quit]
    ]
]);


;;; Metarule to check FeLV status if not FIA or heinz body anaemia.

metarule([
possible_felv
    [not heinz_bodies]
    [investigate[felv]]
]);

;;; Metarule to pick up on FeLV induced haemolytic anaemia as the cause.

metarule([
felv_induced_haemolytic_anaemia
    felv
    [
        [print
            [
'The cat may have a Feline Leukaemia virus induced haemolytic anaemia.\n'
'PROGNOSIS: Long term is very poor.\n Cats may have recurrent haemolytic '
'episodes, eventually leading to bone marrow failure.  However bouts may be '
'relatively mild and cats may remain free of clinical signs for some time.\n'
'TREATMENT: Corticosteroids may have some beneficial effect in some cases.  '
'This may be due to the suppression of immune mediated destruction of RBCs.'
            ]
        ]
    [investigate[alternative_causes]]
    ]
]);

;;; Metarule to investigate the possibility of immune mediated haemolytic
;;; anaemia, or microangoipathic anaemia.

metarule([
not_felv_induced_anaemia
    [or
        [not felv]
        alternative_causes
    ]
    [investigate[schistocytes poikilocytes autoagglutination]]
]);

;;; Metarule to pick up on immune mediated anaemia or microangiopathic
;;; anaemia.

metarule([
possible_immune_mediated_anaemia
    [or
        autoagglutination
        [or
            schistocytes
            poikilocytes
        ]
    ]
    [
        [print
            [
'These findings are suggestive of an immune mediated anaemia or possible '
'microangiopathic anaemia.'
            ]
        ]
    [investigate[immune_mediated_info]]
    ]
]);

;;; Metarule to give more information about immune mediated anaemia.


metarule([
immune_mediated_anaemia
    immune_mediated_info
    [
        [print
            [
'Confirmation of a diagnosis of immune mediated anaemia can be made by performing'
' a Coombs test.\n However this is a contraversial area due to several'
' factors:-\n'
'(1) Interpretation of the Coombs test is complicated by the positive results '
'obtained in many cats infected with FeLV or H.felis.  It is difficult to know '
'wether positive results truely have anti-erythrocyte autoantibodies or wether '
'these are false positives due to membrane abnormalities caused by H.felis or '
'FeLV.\n'
'(2) Some cases may actually be associated with H.felis infection but remain '
'undiagnosed due to the difficulty of detecting this parasite in the blood '
'because of the cyclical nature of the disease and the transient parasitaemia. '
'(3) Autoagglutination of the blood occurs spontaneously in many cases of '
'anaemia irrespective of the cause.\n'
'(4) Some cats may go on to develop a myeloproliferative disease in spite of an'
' immune mediated condition being suspected.\n'
'PROGNOSIS: Long term is poor. \n'
'TREATMENT: Corticosteroids may be of some benefit if an autoimmune condition '
'is suspected and other causes of haemolysis and haemorrhage have been ruled '
'out.  Prednisolone at a dose rate of 2 mg/kg daily in divided doses is '
'recommended.  The dose should gradually be reduced over a period of 8 weeks to'
' alternate day therapy of 0.125 mg/kg.  '
            ]
        ]
    [investigate[microangiopathic_info]]
    ]
]);


;;; Metarule to give more information about microangiopathic anaemia if the 
;;; user requests it.

metarule([
microangiopathic_anaemia
    microangiopathic_info
    [
        [print
            [
'Mechanically induced haemolysis may occur because of direct RBC damage in ' 
'cavernous tumours e.g. haemangiosarcomas, or as a result of shredding of RBCs '
'by fibrin networks in Disseminated Intravascular Coagulation(DIC).\n'
'In  DIC clinically there should be signs of haemorrhage and thrombo-embolic '
'organ failure.  If this is suspected further laboratory investigation is  '
'required to confirm the diagnosis.\nFindings should include: whole blood ' 
'clotting time, one stage prothrombin time, and kaolin cephalin clotting time '
'are all increased.  Clot retraction will also be poor and the platelet count '
'will be reduced. \nHowever the diagnosis of such conditions is outside the '
'scope of this system.'
            ]
        ]
    [quit]
    ]
]);

;;; Metarule to consider the remaining causes.

metarule([
remaining_causes
    [and
        [not schistocytes]
        [and
            [not poikilocytes]
            [not autoagglutination]
        ]
    ]
    [
        [print
            [
'(1) Lead poisonning may cause haemolytic anaemia, but this is usually '
'accompanied by GIT or CNS signs.  However this is not common in cat '
'compared to other species. Other diagnostic features include the presence of '
' increased circulating nucleated RBCs and possible basophilic stippling( on'
'fresh samples only with no anticoagulant), but this feature is not '
'pathognomonic and occurs with other strongly regenerative anaemias.\n'
'TREATMENT: Symptomatic e.g. diazepam to control convulsions and fluid therapy,'
' and CaEDTA which chelates lead and removes it from the body. (75-100 mg/kg '
'in 2-4 divided doses either by slow i/v or s/c injection for 5 days.'
'If severe convulsions, indicative of cerebral oedema.  Therefore use '
'dexamethasone and mannitol. \n'
'\n'
'(2) Congenital erythropoietic porphyria.  Very rare.  Appears to inherited '
'in an autosomal dominant fashion.  The condition is caused by a defect in the'
' synthesis of porphyrin precursors and leads to haemolytic anaemia.  The pigment'
' accumulates in the tissues, particularly bone and teeth giving a characteristic'
'pink-brown colour.\n'
'\n'
'(3) Bacterial haemolysis may occur rarely with severe infections and usually'
' causes a profound  haemolytic anaemia.\n'
'\n'
'(4) Idiopathic.  In these cases administration of prednisolone may be '
'indicated.  High initial doses are required(2-4 mg/kg daily in divided doses)'
'Gradually reduce the dose over a period of 8 weeks to alternate day therapy '
'with 0.125 mg/kg. \nHowever although a response may be shown inially, the long'
' term prognosis is poor.'
            ]
        ]
    [quit]
    ]
]);
