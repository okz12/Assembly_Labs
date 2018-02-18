	AREA	ArmLabels, CODE
	ENTRY
		LDR r1, =TABLE1;r1 holds DCD 5, 0x10 (16), 3
		MOV r2, #5;r2=3, number of loops to run
		MOV r3, #0;r3=0
LOOP	LDR r4, [r1];r4 = the value at address r1, Goes through each value of r1
		SUBS r5, r6, r4; r5 = r6 - r4, set flags
		MOVMI r6, r4; If negative i.e. r4>r6, set r6=r4
		ADD r3, r3, r4;r3=r3+r4
		ADD r1, r1, #4;r1+r1+4
		SUBS r2, r2, #1;r2 decrement
		BNE LOOP
STOP	B	STOP

TABLE1	DCD 5, 0x10, 3, 4, 1;Adds these numbers
	END
		