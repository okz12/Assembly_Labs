	AREA	ArmLabels, CODE
	ENTRY
	
		LDR r4, =TABLE1
		LDR r0, [r4]	;r0 = number
	
REVERSE	MOV r2, #0;Bit shifting number
		MOV r1, #0;Final result register
		MOV r3, #1;LSB = 1, for shifting left
		MOV r4, #0x80000000;MSB = 1, for shifting right
		
		;works by left shift check, right shift bit set
LOOP	ANDS r5, r0, r3, lsl r2; r5 = r0 & r3 (<<r2), this shifts LSB left and checks if its present in r0
		ORRNE r1, r1, r4, lsr r2; OR if not equal to 0 with r4 (>>r2), this shifts MSB right and puts it in r1
		ADD	r2, r2, #1; increment r2
		CMP	r2, #32; check to see if end is reached
		BNE LOOP
		
STOP	B	STOP

TABLE1	DCD 0x00000001
	END