/*  initial_screen.p
 *
 *  Rebecca Elks
 *  June 1990
 *
 *  Screen to get initial clinical data from user
 */

	/* first variables for screens & buttons */
vars	
	continue_button cont_button intro_screen initial_screen second_screen
	item_list item_list2;

/* now the variables for the items */

vars	age t2 				/* the items themselves ... */
	sex t3
	neutered t4
	appetite t5
	pica t6
	git t7
	haematemesis t8
	drinking t9
	urination t10
	haematuria t11
	lethargy t12
	weakness t13
	lameness t14
	cold_sensitivity t15
	weight t16
	colour t17
	icterus t18
	brown t19
	petechiation t20
	cyanosis t21;

/* now the variables for the items in second screen */

vars	respiration t22  /* the items themselves ...*/
	heart_rate t23
	murmur t24
	pulse_rate t25
	pulse_character t26
	temperature t27
	abdomen t28
	abdominal_pain t29
	abdominal_masses t30
	wounds t31
	fractures t32
	torn_claws t33
	lymph_nodes t34
	duration t35;  

uses poppwmlib;

define	setup_intro_screen();

	lvars	 x1 y1 x2 y2 each intro_screen_data;

	[
		[20 150 20 10]
		[20 10 100 10]
		[20 60 80 60]		;;; end of F
		[50 80 90 80]		;;; start of first e
		[90 80 100 90]
		[100 90 100 110]
		[100 110 90 120]
		[50 120 90 120]
		[40 90 40 140]
		[40 110 50 120]
		[40 140 50 150]
		[50 150 90 150]
		[90 150 100 140]
		[40 90 50 80]		;;; end of first e
		[110 10 110 150]	;;; start of L
		[110 150 180 150]	;;; end of L
		[150 50 170 50]		;;; start of I
		[160 50 160 120]
		[150 120 170 120]	;;; end of L
		[190 150 190 10]	;;; start of N
		[190 10 260 150]
		[260 150 260 80]	;;; end of N
		[270 10 310 10]		;;; start of second e
		[260 20 270 10]
		[310 10 320 20]
		[260 20 260 70]
		[320 20 320 40]
		[260 40 270 50]
		[270 50 310 50]
		[310 50 320 40]
		[260 70 270 80]
		[270 80 310 80]
		[310 80 320 70]		;;; end of second e
	] -> intro_screen_data;

	pwm_make_gfxwin('Hello ! Welcome to FELINE !', 680 , 360)
		-> intro_screen;

	{458 497} -> pwm_windowlocation(intro_screen);

	intro_screen -> pwmgfxsurface;

	for each in intro_screen_data do
		((each(1) * 2) - 2) -> x1;
		((each(2) * 2) - 2) -> y1;
		((each(3) * 2) - 2) -> x2;
		((each(4) * 2) - 2) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;
	for each in intro_screen_data do
		(each(1) * 2) -> x1;
		(each(2) * 2) -> y1;
		(each(3) * 2) -> x2;
		(each(4) * 2) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;
	for each in intro_screen_data do
		((each(1) * 2) + 2) -> x1;
		((each(2) * 2) + 2) -> y1;
		((each(3) * 2) + 2) -> x2;
		((each(4) * 2) + 2) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;
	for each in intro_screen_data do
		((each(1) * 2) - 4) -> x1;
		((each(2) * 2) - 4) -> y1;
		((each(3) * 2) - 4) -> x2;
		((each(4) * 2) - 4) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;
	for each in intro_screen_data do
		((each(1) * 2) + 4) -> x1;
		((each(2) * 2) + 4) -> y1;
		((each(3) * 2) + 4) -> x2;
		((each(4) * 2) + 4) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;
	for each in intro_screen_data do
		((each(1) * 2) - 6) -> x1;
		((each(2) * 2) - 6) -> y1;
		((each(3) * 2) - 6) -> x2;
		((each(4) * 2) - 6) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;
	for each in intro_screen_data do
		((each(1) * 2) + 6) -> x1;
		((each(2) * 2) + 6) -> y1;
		((each(3) * 2) + 6) -> x2;
		((each(4) * 2) + 6) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;
	for each in intro_screen_data do
		((each(1) * 2) - 8) -> x1;
		((each(2) * 2) - 8) -> y1;
		((each(3) * 2) - 8) -> x2;
		((each(4) * 2) - 8) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;
	for each in intro_screen_data do
		((each(1) * 2) + 8) -> x1;
		((each(2) * 2) + 8) -> y1;
		((each(3) * 2) + 8) -> x2;
		((each(4) * 2) + 8) -> y2;
		pwm_draw_line([ ^x1 ^y1 ^x2 ^y2]);
	endfor;

	/* now write the various headings */

	pwm_gfxtext(intro_screen, 10, 327, 
		'Knowledge Engineer: Rebecca Elks');	

	pwm_gfxtext(intro_screen, 10, 342, 
		'Additional Code: Michael Wooldridge');

	pwm_gfxtext(intro_screen, 550, 260,
		'UMIST AI Group');

	pwm_gfxtext(intro_screen, 550, 275,
		'(C) + (P) 1990');
		
	pwm_make_toggleitem(intro_screen, 360, 325, false, 
		'-->>> Press to Continue --->>> ',
		updater(valof(%"continue_button"%))) -> cont_button;

	while not(pwmitem_valof(cont_button) = true) do
		pwm_wait_inevent(intro_screen, true);
	endwhile;

	pwm_kill_item(cont_button);
	pwm_close_window(intro_screen);
enddefine;

	/* now the clinical data windows */

define  store_screen_items(screen_id,ilist);

	lvars screen_id ilist each dummy;

	for each in ilist do
		valof(each) -> dummy;
	assert(each, pwm_itemvalue(dummy));
	endfor;

	/* now kill all the items */

	for each in ilist do
		valof(each) -> dummy;
		pwm_kill_item(dummy);
	endfor;

	pwm_kill_item(continue_button);

	/* now get rid of the screen */

	pwm_close_window(screen_id);

enddefine;

/* now the setup_initial_window() function */

define  setup_initial_window();

	false -> initial_screen;

	[
		age sex neutered appetite pica git
		haematemesis drinking urination
		haematuria lethargy weakness lameness
		cold_sensitivity weight colour
		icterus brown petechiation cyanosis 
	] -> item_list;

	while initial_screen = false do
		pwm_make_gfxwin('Clinical Signs (First Screen)', 
			700, 500) -> initial_screen;
	endwhile;

	{430 370} -> pwm_windowlocation(initial_screen);

	(erase <> vedputmessage(% '' %))
	-> pwmitemhandler(initial_screen, false, false, false);

	/* now create the various items */

	pwm_make_radioitem(initial_screen, 10, 10, '< 6 months',
		['< 6 months'
		'< 3 years' '3 - 8 years'
		'over 8 years' ], '1.(a) AGE',
		updater(valof(%"t2"%))) -> age;

	pwm_make_radioitem(initial_screen, 160, 10, "female",
		[  male  female], ' 1.(b) SEX',
		updater(valof(%"t3"%))) -> sex;

	pwm_make_toggleitem(initial_screen, 270, 10, false, ' 1.(c) Neutered',
  		updater(valof(%"t4"%))) -> neutered;

	pwm_make_radioitem(initial_screen, 10, 115, "normal",
		[ normal polyphagia decreased],
		' 2.(a) APPETITE',
		updater(valof(%"t5"%))) -> appetite;

	pwm_make_toggleitem(initial_screen, 160, 115, false, ' 2.(b) Pica',
	  	updater(valof(%"t6"%))) -> pica;

	pwm_make_radioitem(initial_screen, 295, 115, "normal",
  		[ normal  bloody_faeces  melaena ],
  		' 2.(c) GIT',
 		 updater(valof(%"t7"%))) -> git;

	pwm_make_toggleitem(initial_screen, 445, 115, false, 
		' 2.(d) Haematemesis',
  		updater(valof(%"t8"%))) -> haematemesis;

	pwm_make_radioitem(initial_screen, 10, 205, "normal",
 		[ normal  polydipsia  decreased ],
 		' 3.(a) DRINKING',
 		updater(valof(%"t9"%))) -> drinking;

	pwm_make_radioitem(initial_screen, 160, 205, "normal", 
		[  normal  polyuria  ],
 		' 3.(b) URINATION',
 		updater(valof(%"t10"%))) -> urination;

	pwm_make_toggleitem(initial_screen, 320, 205, false, '3.(c) Haematuria',
  		updater(valof(%"t11"%))) -> haematuria;

	pwm_make_toggleitem(initial_screen, 10, 300, false, ' 4.(a) Lethargy',
  		updater(valof(%"t12"%))) -> lethargy;

	pwm_make_toggleitem(initial_screen, 160, 300, false, ' 4.(b) Weakness',
  		updater(valof(%"t13"%))) -> weakness;

	pwm_make_toggleitem(initial_screen, 320, 300, false, ' 4.(c) Lameness',
  		updater(valof(%"t14"%))) -> lameness;

	pwm_make_toggleitem(initial_screen, 480, 300, false, 
		' 4.(d) cold sensitivity',
  		updater(valof(%"t15"%))) -> cold_sensitivity;

	pwm_make_radioitem(initial_screen, 10, 340, "normal",
		[  normal  poor  obese ],
		' 5. BODY CONDITION',
		updater(valof(%"t16"%))) -> weight;

	pwm_make_radioitem(initial_screen, 10, 440, "normal", [  normal  pale ],
		' 6. MUCOUS MEMBRANES (a) Colour',
		updater(valof(%"t17"%))) -> colour;

	pwm_make_toggleitem(initial_screen, 280, 440, false, ' 6.(b) Icterus',
		updater(valof(%"t18"%))) -> icterus;

	pwm_make_toggleitem(initial_screen, 450, 440, false,
		'6.(c) Muddy-brown discolour',
		updater(valof(%"t19"%))) -> brown;

	pwm_make_toggleitem(initial_screen, 280, 470, false, 
		' 6.(d) Petechiation',
		updater(valof(%"t20"%))) -> petechiation;

	pwm_make_toggleitem(initial_screen, 480, 470, false, ' 6.(e) Cyanosis',
		updater(valof(%"t21"%))) -> cyanosis;

	pwm_make_toggleitem(initial_screen, 320, 375, false,
		'-->>> Press to Continue -->>>',
	updater(valof(%"cont_button"%))) -> continue_button;

	while not(pwm_itemvalue(continue_button) = true) do
		pwm_wait_inevent(initial_screen,true);
	endwhile;
enddefine;

 	/* now the second window */

define  setup_second_window();

	false -> second_screen;
	
	/* store details of second screen in a list in item_list */

	[
		respiration heart_rate murmur pulse_rate pulse_character
		temperature abdomen abdominal_pain abdominal_masses
		wounds fractures torn_claws lymph_nodes duration
	] -> item_list2;


	while second_screen = false do
		pwm_make_gfxwin('Clinical Signs (Second Screen)',
			 700, 340,) -> second_screen;
	endwhile;

	{430 530} -> pwm_windowlocation(second_screen);

	pwm_setwincursor(second_screen, pwmstdcursor);

	(erase <> vedputmessage(% '' %))
	  -> pwmitemhandler(second_screen, false, false, false );

	/* now create the various items */

	pwm_make_radioitem(second_screen, 10, 10, "normal",
		[ normal  dyspnoea  tachypnoea ],
		' 7. RESPIRATION',
		updater(valof(%"t22"%))) -> respiration;

	pwm_make_radioitem(second_screen, 170, 10, "normal",
		[ normal  tachycardia  bradycardia],
		' 8.(a) HEART RATE',
		updater(valof(%"t23"%))) -> heart_rate;

	pwm_make_toggleitem(second_screen, 170, 95, false,
 		' 8.(b) Murmur',
		 updater(valof(%"t24"%))) -> murmur;


	pwm_make_radioitem(second_screen, 330, 10, "normal",
		[  normal  rapid  slow ],
		' 9.(a) PULSE RATE',
		updater(valof(%"t25"%))) -> pulse_rate;


	pwm_make_radioitem(second_screen, 500, 10, "normal",
		[ normal  bounding  collapsing],
	' 9.(b) PULSE CHARACTER',
	updater(valof(%"t26"%))) -> pulse_character;


	pwm_make_radioitem(second_screen, 10, 135, "normal",
		[ normal  pyrexia hypothermia],
		' 10. TEMPERATURE',
		updater(valof(%"t27"%))) -> temperature;

	pwm_make_radioitem(second_screen, 160, 135, "nad",
 		[ nad  enlarged_liver_or_spleen ],
 		' 11.(a) ABDOMEN',
 		updater(valof(%"t28"%))) -> abdomen;


	pwm_make_toggleitem(second_screen, 400, 135, false,
		' 11.(b) Pain on palpation',
		updater(valof(%"t29"%))) -> abdominal_pain;


	pwm_make_toggleitem(second_screen, 400, 170, false,
		' 11.(c) Palpable masses  ',
 		updater(valof(%"t30"%))) -> abdominal_masses;


	pwm_make_toggleitem(second_screen, 10, 230, false,
		' 12. TRAUMA (a) Wounds',
		updater(valof(%"t31"%))) -> wounds;


	pwm_make_toggleitem(second_screen, 240, 230, false,
		' 12.(b) Fractures',
		updater(valof(%"t32"%))) -> fractures;


	pwm_make_toggleitem(second_screen, 440, 230, false,
		' 12.(c) Torn claws',
		updater(valof(%"t33"%))) -> torn_claws;


	pwm_make_radioitem(second_screen, 10, 280, "normal",
		[normal  enlarged ],
		' 13. SUPERFICIAL LYMPH NODES',
		updater(valof(%"t34"%))) -> lymph_nodes;


	pwm_make_radioitem(second_screen, 260, 280, "acute_onset",
		[ acute_onset  chronic_illness_/_insidious_onset],
		'14. DURATION OF CLINICAL SIGNS',
		updater(valof(%"t35"%))) -> duration;

	pwm_make_toggleitem(second_screen, 330, 95, false,
		'-->>> Press to Continue -->>>',
		updater(valof(%"cont_button"%))) -> continue_button;

	while not(pwm_itemvalue(continue_button) = true) do
		pwm_wait_inevent(second_screen,true);
	endwhile;

enddefine;

define	get_initial_data();

	/* now setup first screen */

 	setup_intro_screen();

 	/* first get the two screens set up and data from them */

	setup_initial_window();

	store_screen_items(initial_screen,item_list);

	setup_second_window(); 
	store_screen_items(second_screen,item_list2);
	
enddefine;

/* THE END */
