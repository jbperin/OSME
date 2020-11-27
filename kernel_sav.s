

#define via_portb    $0300
#define via_porta_hs $0301
#define via_ddrb     $0302
#define via_ddra     $0303
#define via_t1cl     $0304
#define via_t1ch     $0305
#define via_t1ll     $0306
#define via_t1lh     $0307
#define via_t2cl     $0308
#define via_t2ll     $0308
#define via_t2ch     $0309
#define via_sr       $030A
#define via_acr      $030B
#define via_pcr      $030C
#define via_ifr      $030D
#define via_ier      $030E
#define via_porta    $030F

#define timer3_low 	$0276
#define timer3_high $0277

#define DEFAULT_BPM		120
#define NB_INT_PER_MINUTE	6000 

_kernel_ms 				.dsb	2
_kernel_s 				.dsb	1

_kernel_tempo 			.byt	DEFAULT_BPM

_kernel_fraction 		.dsb	1
_kernel_beat 			.dsb	1

kernel_tempo_err 		.dsb	2

; Number of Beat Fraction Per Minute
; shall contains tempo_BPM * 12 
kernel_bfpm 			.dsb	2

it_handler .dsb 2

_kernelInit:
.(


	;Since we are starting from when the standard irq has already been 
	;setup, we need not worry about ensuring one irq event and/or right 
	;timer period, only redirecting irq vector to our own irq handler. 
	sei

	; Save the old handler value
	lda $245
	sta jmp_old_handler+1
	sta it_handler
	lda $246
	sta jmp_old_handler+2
	sta it_handler+1

	lda #0
	sta _kernel_ms
	sta _kernel_ms+1
	sta _kernel_s
	sta _kernel_fraction
	sta _kernel_beat


	; Setup DDRA, DDRB and ACR
	; lda #%11111111
	; sta via_ddra
	; lda #%11110111 ; PB0-2 outputs, PB3 input.
	; sta via_ddrb
	; lda #%1000000
	; sta via_acr

	; Since this is an slow process, we set the VIA timer to 
	; issue interrupts at 25Hz, instead of 100 Hz. This is 
	; not necessary -- it depends on your needs
	; lda #<40000
	; sta via_t1ll 
	; lda #>40000
	; sta via_t1lh
		

	; Install our own handler
	lda #<irq_handler
	sta $245
	lda #>irq_handler
	sta $246

	; Start Sound and Music System
	jsr osmeInit

	cli
    rts
.)


irq_handler:

	inc _kernel_ms
	bne skipHighMs
	inc _kernel_ms+1
skipHighMs:

; 	; Entertain Sound and Music System
;	jsr osmePulse

	; If ms == 1000 ($3E8) ms = 0; 
	; lda _kernel_ms
	; cmp #$E8
	; bne not_1Hz
	; lda _kernel_ms+1
	; cmp #$03
	; bne not_1Hz

	; lda #0
	; sta _kernel_ms
	; sta _kernel_ms+1

	; jsr task_25Hz
	; jsr task_1Hz
	; jmp irq_handler_done
not_1Hz:

; 	lda _kernel_ms
; 	and #$03
; 	bne not_25Hz

; 	jsr task_25Hz
jmp_old_handler
	jmp 0000

not_25Hz:

irq_handler_done:

	rti

; _enterSC:
; .(
;     pha
;     lda #64
;     sta $030E
;     pla
; .)
;     rts
    
; _leaveSC:
; .(
;     pha
;     lda #192
;     sta $030E
;     pla
; .)
;     rts


task_25Hz:
.(

task25hz_done:
.)
    rts    

task_1Hz:
.(
    inc _kernel_s
    lda _kernel_s
    cmp #60
    bne task1hz_done
    lda #0
    sta _kernel_s

task1hz_done:
.)
    rts  



_kernelEnd:
.(
	sei
	; Restore the old handler value
	lda it_handler
	sta $245
	lda it_handler+1
	sta $246
	cli
    rts
.)




task_fraction:
.(
	lda		_kernel_fraction
	clc
	adc		#1
	sta		_kernel_fraction
	cmp		#12
	bne		taskfraction_done
	lda		#0
	sta		_kernel_fraction
	jsr		task_beat
taskfraction_done:
.)
    rts    

task_beat:
.(
	inc		_kernel_beat
taskbeat_done:
.)
    rts    


osmeInit:
.(
	; E <- ITPM
	lda #<NB_INT_PER_MINUTE
	sta kernel_tempo_err
	lda #>NB_INT_PER_MINUTE
	sta kernel_tempo_err+1

	; kernel_bpfm <- tempo_bpm * 12
	lda 	#0
	sta		kernel_bfpm+1
	lda 	_kernel_tempo
	asl							; 
	rol		kernel_bfpm+1
	clc							; useless
	adc 	_kernel_tempo
	sta		kernel_bfpm
	bcc 	skipCarryPropagation
	lda		kernel_bfpm+1
	adc		#0
	sta 	kernel_bfpm+1
skipCarryPropagation:

	lda 	kernel_bfpm
	asl							; 
	rol		kernel_bfpm+1
	asl							; 
	rol		kernel_bfpm+1
	sta		kernel_bfpm


osmeInitDone:
.)
	rts

osmePulse:
.(
	; E <- E - BFPM
	sec 
	lda 	kernel_tempo_err
	sbc 	kernel_bfpm
	sta 	kernel_tempo_err
	lda		kernel_tempo_err+1
	sbc		kernel_bfpm+1
	sta		kernel_tempo_err+1

	bmi		pulseFraction
	; SI 2*E < BFPM ALORS
	asl
	sec
	sbc		kernel_bfpm+1
	bvc		LABEL_1
	eor		#$80
LABEL_1
	bmi		pulseFraction
	bvc		LABEL_2
	eor		#$80
LABEL_2
	bne		PulseNoFraction
	lda		kernel_tempo_err
	asl
	sbc 	kernel_bfpm
	bcc 	pulseFraction
PulseNoFraction:
	jmp osmePulseDone

pulseFraction:
	;	E <- E + ITPM
	clc
	lda 	kernel_tempo_err
	adc 	#<NB_INT_PER_MINUTE
	sta 	kernel_tempo_err
	lda 	kernel_tempo_err+1
	adc 	#>NB_INT_PER_MINUTE
	sta 	kernel_tempo_err+1

	jsr		task_fraction

osmePulseDone:
.)
	rts


