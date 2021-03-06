	AREA	ArmSubrEx, CODE, READWRITE
	ENTRY
		LDR R13, =STACKL + 36
		LDR	R8, =VEC1
		LDR R9, =VEC2
		MOV R11, #4
		MOV R7, #0
		MOV	R6, #0
LOOP	LDR	R1, [R8], #4
		LDR R2, [R9], #4
		BL MULT
		ADD R5, R5, R0
		SUBS R11, R11, #1
		BNE	LOOP
STOP	B	STOP
		
MULT	STMED R13!, {R1, R14}
		MOV	R0, #0
		CMP	R1, #0
		BEQ	MULTEND
MULOOP	ADD R0, R0, R2
		SUBS	R1, R1, #1
		BNE MULOOP
MULTEND	LDMED	R13!, {R1, PC}

VEC1	DCD 1, 1, 1, 1
		FILL 4
VEC2	DCD 2, 2, 2, 2
STACKL	FILL 40
	END