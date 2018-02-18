	AREA	ArmExample, CODE
	ENTRY
		MOV r1, #7
		CMP r1, #0
		BMI	MOD
		MOV	r2, r1
STOP	B	STOP

MOD
		SUB r2, r3, r1
		B	STOP	
	END