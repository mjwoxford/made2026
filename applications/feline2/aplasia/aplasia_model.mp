;;;	aplasia_model.mp
;;;
;;;	M J Wooldridge
;;;	October 1990
;;;
;;;	Environment Model for the `aplasia' agent

model:	aplasia

	skills: (aplasia)

	acquaintances:

		initial
			skills: (duration temperature
				appetite weight drinking
				urination lethargy depression
				colour icterus respiration
				neutered sex)

		blood
			skills: (creatinine_high bu_high)

