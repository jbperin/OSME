; Vortex Tracker II v1.0 PT3 player for 6502
; ORIC 1/ATMOS version
; AC - 2018
;
; MAIN
; v0.03
;
;	ORG $1000
;
; -------------------------------------
.zero

	*= $70
    TimeCounter .dsb 1
    saveINT     .dsb 2
    save_A      .dsb 1
    save_X      .dsb 1
    save_Y      .dsb 1
; -------------------------------------
; PPT3 Player addresses
; ZP
SETUP = $50
; routines
START = $8000
INIT  = START+00
PLAY  = START+10
MUTE  = START+13
; VIA
VIA_ORB     = $300
VIA_T1CL    = $304
VIA_T1CH    = $305
VIA_PCR     = $30C
VIA_ORA     = $30F

; -------------------------------------
.text

MAIN       
        LDA #%00000001      ; no loop
        STA SETUP

        JSR INIT            ; init Player PT3

Init_INT		            ; init interrupt (50Hz = 1/50s)

        SEI                 ; disable INT for setup

        ; UTILE pour ORIC?!
        ; préparation interruption - TIMER 1 6522 
		LDA #%01000000		; continuous interrupt / PB7 disabled
		STA $30B    		; Auxiliary Control Register

		LDA #%11000000		;
		STA $30D    		; interrupt flag register	(Time Out of Timer 1/Int)
		STA $30E    		; interrupt Enable register (Timer 1 + Set)
        ; ------
        
        ; TIMER : 50 Hz = 20 ms = 20 000 microsecond = 20 000 tick environ (1 Mhz d'holorge) = $4E20
		; $4E20-2 (VIA) = $4E1E

        LDA #$1E		    ; TIC-LOW
	    STA VIA_T1CL        
	    LDA #$4E		    ; TIC-HIGH
	    STA VIA_T1CH       

        LDA #02
        STA TimeCounter

		; set interrupt routine
        LDA $245
        STA saveINT
        LDA $246
        STA saveINT+1
        LDA #<INT_ROUT
		STA $245	
		LDA #>INT_ROUT
		STA $246

        CLI                 ; enable int

LOOP    JMP LOOP            ; main loop 

; -------------------------------------

INT_ROUT

        ; save
		PHP					; on sauve les flags
		STA save_A			; on sauve A
		STX save_X		    ; on sauve X 
		STY save_Y			; on sauve Y
        
        JSR PLAY            ; music! (one tick)

        DEC TimeCounter
        BNE finInterrupt

        ; test SPACE key pressed or not => NOT WORKING

        ; setup register 14
        LDA #$0E        ; REGISTRE 14
        STA VIA_ORA     ; VIA_ORA
        LDA #$FF        ; SET PSG REG#
        STA VIA_PCR     ; VIA_PCR
        LDY #$DD        ; inactive
        STY VIA_PCR     ; VIA_PCR

        ; Key Matrix ROW
        LDA VIA_ORB
        AND #%11111000
        ORA #%00000100  ; ligne 4
	    STA VIA_ORB

        ; Key Matrix COLUMN
        LDA #%11111110  ; colonne 0 (inverse)
        STA VIA_ORA     ; VIA_ORA 
        LDA #$FD        ; fct: WRITE DATA
        STA VIA_PCR     ; VIA_PCR
        STY VIA_PCR     ; fct: INACTIVE/VIA_PCR

        ; delay (8/10 cycles)
        LDA #02         ; reset counter
        STA TimeCounter
        NOP
        NOP

        LDA VIA_ORB
        AND #08
        BEQ finInterrupt    ; 1 if space, 0 if not

        // space pressed
        ; restore default Int => NOT WORKING
        JSR MUTE
        ; restore default int and frequency (100Mhz)
        LDA saveINT
        STA $245
        LDA saveINT+1
        STA $246
        
        LDA #$10		    ; 10000
	    STA VIA_T1CL            
	    LDA #$27		    
	    STA VIA_T1CH            
        LDA #$60            ; RTS
        STA LOOP

finInterrupt

    	BIT VIA_T1CL        ; Clears interrupt (T1CL) pour pouvoir être de nouveau réutilisé! 

		LDY save_Y          ; on récup Y
		LDX save_X          ; on récup X
		LDA save_A			; on récup A
		PLP					; et les flags

		RTI					; sortie INT



