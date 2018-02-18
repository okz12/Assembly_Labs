; Standard definitions of Mode bits and Interrupt (I & F) flags in PSRs

Mode_USR        EQU     0x10
Mode_FIQ        EQU     0x11
Mode_IRQ        EQU     0x12
Mode_SVC        EQU     0x13
Mode_ABT        EQU     0x17
Mode_UND        EQU     0x1B
Mode_SYS        EQU     0x1F

I_Bit           EQU     0x80            ; when I bit is set, IRQ is disabled
F_Bit           EQU     0x40            ; when F bit is set, FIQ is disabled


;// <h> Stack Configuration (Stack Sizes in Bytes)
;//   <o0> Undefined Mode      <0x0-0xFFFFFFFF:8>
;//   <o1> Supervisor Mode     <0x0-0xFFFFFFFF:8>
;//   <o2> Abort Mode          <0x0-0xFFFFFFFF:8>
;//   <o3> Fast Interrupt Mode <0x0-0xFFFFFFFF:8>
;//   <o4> Interrupt Mode      <0x0-0xFFFFFFFF:8>
;//   <o5> User/System Mode    <0x0-0xFFFFFFFF:8>
;// </h>

UND_Stack_Size  EQU     0x00000000
SVC_Stack_Size  EQU     0x00000080
ABT_Stack_Size  EQU     0x00000000
FIQ_Stack_Size  EQU     0x00000000
IRQ_Stack_Size  EQU     0x00000080
USR_Stack_Size  EQU     0x00000000

ISR_Stack_Size  EQU     (UND_Stack_Size + SVC_Stack_Size + ABT_Stack_Size + \
                         FIQ_Stack_Size + IRQ_Stack_Size)

        		AREA     RESET, CODE
				ENTRY
;  Dummy Handlers are implemented as infinite loops which can be modified.

Vectors         LDR     PC, Reset_Addr         
                LDR     PC, Undef_Addr
                LDR     PC, SWI_Addr
                LDR     PC, PAbt_Addr
                LDR     PC, DAbt_Addr
                NOP                            ; Reserved Vector 
                LDR     PC, IRQ_Addr
;               LDR     PC, [PC, #-0x0FF0]     ; Vector from VicVectAddr
                LDR     PC, FIQ_Addr

ACBASE			DCD		P0COUNT
SCONTR			DCD		SIMCONTROL

Reset_Addr      DCD     Reset_Handler
Undef_Addr      DCD     Undef_Handler
SWI_Addr        DCD     SWI_Handler
PAbt_Addr       DCD     PAbt_Handler
DAbt_Addr       DCD     DAbt_Handler
                DCD     0                      ; Reserved Address 
FIQ_Addr        DCD     FIQ_Handler

Undef_Handler   B       Undef_Handler
SWI_Handler     B       SWI_Handler
PAbt_Handler    B       PAbt_Handler
DAbt_Handler    B       DAbt_Handler
FIQ_Handler     B       FIQ_Handler


				AREA 	ARMuser, CODE,READONLY

IRQ_Addr        DCD     ISR_FUNC1
EINT2			EQU 	16
Addr_VicIntEn	DCD		0xFFFFF010	 	; set to (1<<EINT0)
Addr_EXTMODE	DCD 	0xE01FC148   	; set to 1
Addr_PINSEL0	DCD		0xE002C000		; set to 2_1100
Addr_EXTINT		DCD		0xE01FC140

;  addresses of two registers that allow faster input

Addr_IOPIN		DCD		0xE0028000


; Initialise the Interrupt System
;  ...
ISR_FUNC1		STMED	R13!, {R0,R1}
				MOV 	R0, #(1 << 2) 	   ; bit 2 of EXTINT
				LDR 	R1,	Addr_EXTINT	   
				STR		R0, [R1]		   ; EINT2 reset interrupt
				LDMED	R13!, {R0,R1}
				B 		ISR_FUNC

Reset_Handler
; PORT0.1 1->0 triggers EINT0 IRQ interrupt
				MOV R0, #(1 << EINT2)
				LDR R1, Addr_VicIntEn
				STR R0, [R1]
				MOV R0, #(1 << 30)
				LDR R1, Addr_PINSEL0
				STR R0, [R1]
				MOV R0, #(1 << 2)
				LDR R1, Addr_EXTMODE
				STR R0, [R1]

;  Setup Stack for each mode

                LDR     R0, =Stack_Top

;  Enter Undefined Instruction Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_UND:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #UND_Stack_Size

;  Enter Abort Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_ABT:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #ABT_Stack_Size

;  Enter FIQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_FIQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #FIQ_Stack_Size

;  Enter IRQ Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_IRQ:OR:I_Bit:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #IRQ_Stack_Size

;  Enter Supervisor Mode and set its Stack Pointer
                MSR     CPSR_c, #Mode_SVC:OR:F_Bit
                MOV     SP, R0
                SUB     R0, R0, #SVC_Stack_Size
				B 		START
;----------------------------DO NOT CHANGE ABOVE THIS COMMENT--------------------------------
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
;********************************************************************************************
;Student Name: Osman Khawer Zubair
;College ID: 00737172
;Purpose: Introduction to Computer Architecture Programming assignment
;Date: January 2014
;Code overview:
;This code reads in values from 4 input pins and counts the number of cycles
;The minimum period supported is 18 cycles
;********************************************************************************************
				
START				
				LDR R2, Addr_IOPIN
				LDR R3, =0x01010101
				
LOOP
;R4,R5 alternately read in waveform values
;R7 keeps a count of 0 to 1 transitions for the 4 inputs, R7[7:0]=P0COUNT, R7[15:8]=P1COUNT, R7[23:16]=P2COUNT, R7[31:24]=P3COUNT
;To prevent overflow R7 counts are regularly transferred to other registers and R7 bits cleared
;Transfers of PxCOUNTs and interrupt checks are sandwiched between readings for high frequency performance
;R8=P0COUNT, R9=P1COUNT, R10=P2COUNT, R11=P3COUNT, R12=Interrupt flag

				LDR R4, [R2]	
				AND R4, R4, R3	;Sets undefined bits to 0, leaving only input bits
				BIC R6, R4, R5	;Sets high input bits that transitioned from 0 to 1
				ADD R7, R7, R6

				CMP R12, #1	;Check for interrupt with conditional branch to end code, repeated regularly throughout loop
				BEQ ENDC
				
				LDR R5, [R2]
				AND R5, R5, R3
				BIC R6, R5, R4
				ADD R7, R7, R6

				AND R6, R7, #0x000000FF	;P0COUNT summing and bit clearing R7[7:0] to prevent overflow
				ADD R8, R8, R6
				BIC R7, R7, #0x000000FF
				
				LDR R4, [R2]
				AND R4, R4, R3
				BIC R6, R4, R5
				ADD R7, R7, R6

				CMP R12, #1
				BEQ ENDC
				
				LDR R5, [R2]
				AND R5, R5, R3
				BIC R6, R5, R4
				ADD R7, R7, R6

				AND R6, R7, #0x0000FF00	;P1COUNT summing and bit clearing R7[15:8]
				ADD R9, R9, R6, lsr #8
				BIC R7, R7, #0x0000FF00
				
				LDR R4, [R2]
				AND R4, R4, R3
				BIC R6, R4, R5
				ADD R7, R7, R6

				CMP R12, #1
				BEQ ENDC
				
				LDR R5, [R2]
				AND R5, R5, R3
				BIC R6, R5, R4
				ADD R7, R7, R6
				
				AND R6, R7, #0x00FF0000	;P2COUNT summing and bit clearing R7[23:16]
				ADD R10, R10, R6, lsr #16
				BIC R7, R7, #0x00FF0000
				
				LDR R4, [R2]
				AND R4, R4, R3
				BIC R6, R4, R5
				ADD R7, R7, R6

				CMP R12, #1
				BEQ ENDC
				
				LDR R5, [R2]
				AND R5, R5, R3
				BIC R6, R5, R4
				ADD R7, R7, R6
				
				ADD R11, R11, R7, lsr #24	;P3COUNT summing and bit clearing R7[31:24]
				BIC R7, R7, #0xFF000000
				
				LDR R4, [R2]
				AND R4, R4, R3
				BIC R6, R4, R5
				ADD R7, R7, R6

				CMP R12, #1
				BEQ ENDC
				
				LDR R5, [R2]
				AND R5, R5, R3
				BIC R6, R5, R4
				ADD R7, R7, R6

				B		LOOP
				
ENDC			
				AND R6, R7, #0x000000FF	;Sum remaining PxCOUNTs held in R7 to respective registers
				ADD R8, R8, R6
				AND R6, R7, #0x0000FF00
				ADD R9, R9, R6, lsr #8
				AND R6, R7, #0x00FF0000
				ADD R10, R10, R6, lsr #16
				ADD R11, R11, R7, lsr #24
				
				LDR R6, =P0COUNT	;Store PxCOUNTs to memory
				STR R8, [R6]
				LDR R6, =P1COUNT
				STR R9, [R6]
				LDR R6, =P2COUNT
				STR R10, [R6]
				LDR R6, =P3COUNT
				STR R11, [R6]
				B	LOOP_END



ISR_FUNC							;Sets interrupt flag and restores from interrupt
				MOV R12, #1
				SUBS	pc, R14, #4

;--------------------------------------------------------------------------------------------
; PARAMETERS TO CONTROL SIMULATION, VALUES MAY BE CHANGED TO IMPLEMENT DIFFERENT TESTS
;--------------------------------------------------------------------------------------------
SIMCONTROL
SIM_TIME 		DCD  	48000  ; length of simulation in cycles (100MHz clock)
P0_PERIOD		DCD 	20		  ; bit 0 input period in cycles
P1_PERIOD		DCD   	18		  ; bit 8 input period in cycles
P2_PERIOD		DCD  	16	  ; bit 16 input period	in cycles
P3_PERIOD		DCD		14		  ; bit 24 input period	in cycles
;---------------------DO NOT CHANGE AFTER THIS COMMENT---------------------------------------
;--------------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------------
LOOP_END		MOV R0, #0x7f00
				LDR R0, [R0] 	; read memory location 7f00 to stop simulation
STOP			B 	STOP
;-----------------------------------------------------------------------------
 				AREA	DATA, READWRITE

P0COUNT			DCD		0
P1COUNT			DCD		0
P2COUNT			DCD		0
P3COUNT			DCD		0
;------------------------------------------------------------------------------			
                AREA    STACK, NOINIT, READWRITE, ALIGN=3

Stack_Mem       SPACE   USR_Stack_Size
__initial_sp    SPACE   ISR_Stack_Size

Stack_Top


        		END                     ; Mark end of file

