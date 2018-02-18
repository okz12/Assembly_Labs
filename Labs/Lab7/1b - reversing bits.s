	AREA	ArmLabels, CODE
	ENTRY
	
		LDR r4, =TABLE1
		LDR r0, [r4]	;r0 = number
	
REVERSE	MOV r1, #0;Final result
		MOV r2, #31; Bit shifting number, now starts from 31
		MOV r3, #1;LSB = 1 for bit shifting
		MOV r4, #0x80000000;MSB = 1 for bit shifting
		
		;works by right shift check, left shift bit set		
LOOP	TST r0, r4, lsr r2; r0 & r4 (>>r2), set flags
		ORRNE	r1, r1, r3, lsl r2; if not equal, r1 = r1 || r3 (<<r2)
		SUBS r2, r2, #1; r2 decrement
		BPL LOOP; if r2 positive or zero, loop
STOP	B	STOP

TABLE1	DCD 0x11111111
	END