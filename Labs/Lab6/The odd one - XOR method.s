	AREA	ArmLabels, CODE
	ENTRY		
		LDR r1, =TABLE1;points to current value being tested
		MOV r3, #0; r3=0
LOOP	LDR r2, [r1], #4; Load value, cycles through value
		CMP r2, #0; If loaded value is zero
		BEQ STOP; End program
		EOR r3, r3, r2; Else XOR with r3 value
		B LOOP; Next value
		
STOP	B STOP

TABLE1	DCD 10, 10, 5, 5, 2, 2, 4, 4, 7
		FILL 4
	END
		