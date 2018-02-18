	AREA	ArmLabels, CODE
	ENTRY		
		LDR r1, =TABLE1
		MOV r2, #3
		MOV r3, #0
		MOV r6, #0
		MOV r5, #0
LOOP	LDR r4, [r1,r5]
		ADD r5, r5, #4
		ADD r3, r3, r4
		CMP r6, r4
		MOVMI r6, r4
		SUBS r2, r2, #1
		BNE LOOP
STOP	B	STOP

TABLE1	DCD 5, 0x10, 3
	END
		