	AREA	ArmExample, CODE
	ENTRY
		MOV r1, #5
		MOV r2, #10
		CMP r1, r2
		BPL	SWAP
STOP	B	STOP

SWAP
		MOV r3, r2
		MOV r2, r1
		MOV r1, r3
		B	STOP
	END