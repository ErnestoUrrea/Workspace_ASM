;
; ASM_AVR_BLINK.asm
;
; Author : Ernesto Urrea
;


; Replace with your application code
ldi r16, 0xFF
ldi r19, 0xFF
out DDRD, r16

start:
	ldi r16, 0b01010101
	out PORTD, r16
	ldi r17, 0x00
	ldi r18, 0x00
	jmp l1
    rjmp start

p2:
	ldi r16, 0b10101010
	out PORTD, r16
	ldi r17, 0x00
	ldi r18, 0x00
	jmp l2
    rjmp start

l1:
	inc r17       ; 1 cycle
	cp r17, r19   ; 1 cycle
	breq p2    ; 1 if false, 2 if true
	jmp l1        ; 3 cycles

l2:
	inc r17       ; 1 cycle
	cp r17, r19   ; 1 cycle
	breq start    ; 1 if false, 2 if true
	jmp l2        ; 3 cycles

;l2:
;	inc r18       ; 1 cycle
;	cp r18, r19   ; 1 cycle
;	breq start    ; 1 if false, 2 if true
;	jmp l1        ; 3 cycles