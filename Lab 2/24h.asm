cpu "8085.tbl"
hof "int8"

org 9000h
GTHEX: EQU 030EH
HXDSP: EQU 034FH
OUTPUT:EQU 0389H
CLEAR: EQU 02BEH
RDKBD: EQU 03BAH

CURDT: EQU 8FF1H
UPDDT: EQU 044cH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H

MVI A,00H
MVI B,00H

; HOURS
LXI H,8840H
MVI M,00H

LXI H,8841H
MVI M,00H

; MINUTES
LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,00H

LXI H,8840H
CALL OUTPUT

MVI A,00H
MVI B,00H
CALL GTHEX
MOV H,D
MOV L,E

FIRST:
	MOV A,H
	CPI 24H
	JC SECOND
	; if Accumulator(Hour) < 24 ==> Valid and jump to SECOND
START:
	MVI H,00H
	JC LOOP
SECOND:
	MOV A,L
	CPI 60H
	JC LOOP
	; if Accumulator(mINUTE) < 60 ==> Valid and jump to loop
THIRD:
	MVI L,00H 	
	

LOOP:

HR_MIN:
	SHLD CURAD ; VALUE OF HL IS STORED IN CURAD
	MVI A,00H
NXT_SEC:
	STA CURDT
	CALL UPDAD
	CALL UPDDT
	CALL DELAY
	LDA CURDT
	ADI 01H ;ADD ONE TO SECONDS 
	DAA ; BINARY TO BCD VALUE
	CPI 60H
	JNZ NXT_SEC
	LHLD CURAD
	MOV A,L
	ADI 01H
	DAA
	MOV L,A
	CPI 60H
	JNZ HR_MIN
	MVI L,00H
	MOV A,H
	ADI 01H
	DAA
	MOV H,A
	CPI 24H
	JNZ HR_MIN
	LXI H,0000H
	JMP LOOP
DELAY:
	MVI C,03H
OUTLOOP:
	LXI D,9F00H
INLOOP:
	DCX D ; DECREMENT REG PAIR BY ONE
	MOV A,D
	ORA E ; LOGICAL OR OPERATION WITH FF(VALUE OF REG E)
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET
RST 5
