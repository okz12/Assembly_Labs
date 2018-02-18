	AREA	ArmExample, CODE
	ENTRY
		MOV r1, #23
		MOV r2, #4
COMP	CMP r1, r2
		BMI	QUO
		SUB	r1, r1, r2
		ADD r3, r3, #1
		B	COMP
QUO		MOV r4, r1
STOP	B	STOP
	
	END