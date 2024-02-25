;
; ASM_AVR_BLINK_TIMER.asm
;
; Author : Ernesto Urrea
;


; Initialization of LED pin
ldi r16, 0x01       ;
out DDRD, r16       ; Set D0 as output
ldi r16, 0x00       ;
out PORTD, r16      ; Set D0 to 0

; Initialization of TIMER 0
ldi r16, 0b00000000 ; OC0A/B disconnected, TOP=0xFF
sts TCCR1A, r16     ;
ldi r16, 0b00000000 ; TOP=0xFF, counter stopped (no clock source)
sts TCCR1B, r16     ;
ldi r16, 0b00000000 ; Do not force OC
sts TCCR1C, r16     ;

loop:
    call delay1s        ; Call delay
	ldi  r16, 0x01      ;
	out  PORTD, r16     ; Set D0 to 1
	call delay1s        ; Call delay
	ldi  r16, 0x00      ;
	out  PORTD, r16     ; Set D0 to 0
    rjmp loop

; Function for 1s delay (not exactly 1s, but close by some microseconds)
delay1s:
	ldi r16, 0xC2       ;
	ldi r17, 0xF7       ;
	sts TCNT1H, r16     ;
	sts TCNT1L, r17     ; Set Timer initial value to 49911 (0xC2F7)

	ldi r16, 0b00000011 ;
	lds r17, TCCR1B     ;
	or  r16, r17        ;
	sts TCCR1B, r16     ; Enable Timer 0, clk/64 (15.625 kHz)
	
	ldi r19, 0b00000001 ; For comparing OVF
	jmp wait            ; Start waiting for overflow

	wait:
		lds  r18, 0x36  ; Store OVF register
		and  r18, r19   ; Ignore all but OVF
		cp   r18, r19   ; Check if OVF = 1 (there's prbly a more efficient or elegant way to do this)
		breq return     ; If true, go to return
		jmp  wait       ; Else, start wait again

	return:	
		lds r18, 0x36   ; Store OVF register
		or  r18, r19    ; Set OVF to 1
		sts 0x36, r18   ; Write OVF register
		ret             ; End of function
		



