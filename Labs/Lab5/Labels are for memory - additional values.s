	AREA	ArmLabels, CODE
	ENTRY
		LDR r1, =TABLE1;r1 holds DCD 5, 0x10 (16), 3, holds address value to =TABLE1
		MOV r2, #5;r2=3, number of loops to run
		MOV r3, #0;r3=0
LOOP	LDR r4, [r1];r4=r1? Goes through each value of r1
		ADD r3, r3, r4;r3=r3+r4, holds the final result of addition
		ADD r1, r1, #4;r1+r1+4, guess increases address by 4 to get to next number. DCD enters 3 bytes of padding, hence add 4.
						;ref: http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0041c/Babbfcga.html
		SUBS r2, r2, #1;r2 decrement
		BNE LOOP
STOP	B	STOP

TABLE1	DCD 5, 0x10, 3, 4, 1;Adds these numbers
	END
		