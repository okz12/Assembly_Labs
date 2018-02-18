	AREA	ArmLabels, CODE
	ENTRY
	
		LDR r4, =TABLE1
		LDR r0, [r4]	;r0 = number
	
REVERSE	MOV r1, #0;Final result
		MOV r2, #31; Bit shifting number, now starts from 31
		MOV r3, #1;LSB = 1 for bit shifting
		;MSB = 1 not needed
		
		;left shift for checking and writing
		;this works by checking if MSB is set, number would be negative
LOOP	MOVS r5, r0, lsl r2; r5 = r0 (<<r2), set flags
		ORRMI r1, r1, r3, lsl r2; r1 = r1||r3(<<r2) if Negative (i.e. MSB set)
		SUBS r2, r2, #1;decrement r2, set flags
		BPL LOOP;loop if r2 positive or 0
STOP	B	STOP

TABLE1	DCD 0x11111111
	END