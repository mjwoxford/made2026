 ;;;	haemorrhagic_model.mp
;;;
;;;	M J Wooldridge
;;;	October 1990
;;;
;;;	Environment model for the haemorrhagic agent
;;;

model:	haemorrhagic

	skills: ( nothing )

	acquaintances:

		blood
			skills: (clotting_time_marginal
				clotting_time_increased
				clotting_time_normal
				prothrombin_time_marginal
				prothrombin_time_normal
				prothrombin_time_increased)

		initial
			skills: (duration
				haematuria
				git
				haematemesis
				warfarin)
program:

;;;	well, nothing here actually
