	AREA	ArmLabels, CODE
	ENTRY
		MOV r0, #1
		MOV r1, #3
COMP	AND r2, r1, r0
		CMP r2, #0
		BNE MULT
		ASR	r1,	#1
		B	COMP
STOP	B	STOP
MULT
		MOV r3, r1
		ADD r3, r3, r1
		ADD r3, r3, r1
		ADD	r3,	r3,	#1
		MOV r1, r3
		B	COMP
	END