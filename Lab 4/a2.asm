
cpu "8085.tbl"
hof "int8"


org 9000h

MVI A,8BH
OUT 43H


MVI A,80H
OUT 03H


MVI A,88H 		;POSITION OF MOTOR'S ROTATOR , VARIES IN 88 44 22 11
STA 9300H
MVI A,00H     ;POSITION OF MOTOR'S ACTUAL IN HEX
STA 9301H
LOOP:

;CALL DISPLAY
CALL FUNC
CALL DELAY
JMP LOOP

FUNC:

LDA 9301H				; ACTUAL POSITION
MOV B,A
MVI D,02H			
CALL CONVERT 			; TO GO TO
CMP B

JC LESSFUNC						; TO GO TO IS LESS THAN ACTUAL POS

JZ ENDFUNC

MOREFUNC:						; TO GO TO IS MORE THAT ACTUAL POS
LDA 9301H
CPI 0FFH
JC MOREFUNCL1
JZ MOREFUNCL2
JMP MOREFUNCL2
MOREFUNCL1:
LDA 9300H
RRC
OUT 00H
STA 9300H
LDA 9301H
ADI 03H
MOREFUNCL2:STA 9301H
JMP ENDFUNC

LESSFUNC:
LDA 9301H
CPI 00H
JC LESSFUNCL2
JZ LESSFUNCL2
JMP LESSFUNCL1
LESSFUNCL1:
LDA 9300H
RLC
OUT 00H
STA 9300H
LDA 9301H
SBI 03H
LESSFUNCL2:STA 9301H
ENDFUNC:
RET



DELAY:
MVI C, 0AH
LOOP4a:   MVI D, 16H
LOOP1a:  MVI E, 0DEH
LOOP2a:  DCR E
	    JNZ LOOP2a
	    DCR D
	    JNZ LOOP1a
	    DCR C
	    JNZ LOOP4a

RET


CONVERT:
	MVI A,00H
	ORA D
	OUT 40H

	; START SIGNAL
	MVI A,20H
	ORA D
	OUT 40H
	
	NOP
	NOP
	
	; START PULSE OVER
	MVI A,00H
	ORA D
	OUT 40H

; EOC = PC0
; CHECK FOR EOC PULSE
WAIT1:
	IN 42H
	ANI 01H
	JNZ WAIT1
WAIT2:
	IN 42H
	ANI 01H
	JZ WAIT2

; READ SIGNAL
	MVI A,40H
	ORA D
	OUT 40H
	NOP

	; GET THE CONVERTED DATA FROM PORT B
	IN 41H

	; SAVE A SO THAT WE CAN DEASSERT THE SIGNAL
	PUSH PSW

	; DEASSERT READ SIGNAL 
	MVI A,00H
	ORA D
	OUT 40H
	POP PSW

RET

DISPLAY:
		call DELAY
		PUSH PSW

		MOV A,E
		STA 8FEFH
		XRA A
		STA 8FF0H
		POP PSW
		STA 8FF1H
		PUSH D
		MVI B,00H
		CALL 0440H
		MVI B,00H
		CALL 0440H
		MVI B,00
		CALL 044CH
		POP D
		RET
