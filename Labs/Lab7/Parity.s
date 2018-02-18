	AREA	ArmLabels, CODE
	ENTRY

		MOV r1, #0
		MOV r2, #31
		MOV r3, #1
		LDR r9, =TABLE1
		LDR r4, [r9]
		
LOOP	MOVS r5, r4, lsl r2
		ADDMI r1, r1, #1
		SUBS r2, r2, #1
		BPL LOOP

STOP	B	STOP

TABLE1	DCD 0x11111111
	END