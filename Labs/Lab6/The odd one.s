	AREA	ArmLabels, CODE
	ENTRY		
		LDR r2, =TABLE1;points to current value being tested
NEWV	LDR r1, =TABLE1;r1 = Table 1, will circle through values
		LDR r5, [r2], #4; r5 = value in r2, +4 post index offset, circle through values
		MOV r3, #0; r3=0
LOOP	LDR r4, [r1], #4;r4 = value in r1, increments by 4 so changes each loop
		CMP r4, r5; compare r4 to r5
		ADDEQ r3, #1; if equal add 1
		CMP r4, #0; compare r4 to 0
		BNE LOOP; if not equal start loop again, i.e. the value held in r4 is not 0 so the list goes on
		ANDS r6, r3, #1; And r3 with #1, i.e. if odd will be 1, if even will be 0
		CMP r6, #1; compare with 1
		LDREQ r7, [r2,#-4]; if equal load in r7 the value of r2 that was being tested, pre-index addressing
		BNE	NEWV; if not equal, i.e. 0 in r6, go to next value
STOP	B	STOP

TABLE1	DCD 10, 5, 10, 95, 5, 95, 33, 95, 2, 10, 95, 33, 2, 10, 95, 2, 33
	END
		