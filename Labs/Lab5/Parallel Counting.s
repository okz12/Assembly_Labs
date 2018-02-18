	AREA	Armexample, CODE
	ENTRY
		MOV r0, #0xAB000000
		MOV r1, #0xF000000F
		MOV r2, #0xFC000000
		EOR r3, r1, r0;Sum (XOR) of r0+r1
		AND r4, r1, r0;Carry (AND) of r0+r1
		EOR r5, r3, r2;Sum of r2 + Sum(r0+r1), lower half of final result
		AND r6, r3, r2;Carry of r2 + Sum(r0+r1)
		ORR r7, r6, r4;ORring both carries, upper half of final result
		AND r8, r7, r5;AND Sum and Carry so (11)b2 = 3, hence non-zero here means a warning should be issued
STOP	B	STOP
	END