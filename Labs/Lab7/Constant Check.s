	AREA	ArmLabels, CODE
	ENTRY
		MOV r1, #0
		MOV r2, #32
		MOV r3, #1
		LDR r9, =TABLE1
		LDR r4, [r9]
		
		;this looks for the first bit as 1, shifts that bit to the right, then checks if it is smaller than 255 or not
		;if greater than 255 it will set r1 to 1 (error), otherwise r1 is at 0 (no error)
LOOP	SUB r2, r2, #1; decrement r2 to check next value
		MOVS r5, r4, lsl r2; Move left, if this bit is 0, go to next value, else test the 8 bits from here
		BEQ LOOP
		RSB r6, r2, #31;r6 = 31-r2
		TST r6, #1;check r6 even or odd
		MOV r11, #127;r6 even compare with 255 r11
		MOVEQ r11, #255;r6 odd compare with 127 r11
		MOV r7, r4, lsr r6;r7 = r4 shifted right r6 times
		RSBS r8, r7, r11;r8 = r11-r7, can also use CMP and different condition on the next instruction
		ADDMI r1, r1, #1;if negative i.e. r7>255, add 1 (error) to r1

STOP	B	STOP

TABLE1	DCD	0x000003FC
	END