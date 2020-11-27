
; #define via_portb    $0300
; #define via_porta_hs $0301
#define via_ddrb     $0302
#define via_ddra     $0303
; #define via_t1cl     $0304
; #define via_t1ch     $0305
#define via_t1ll     $0306
#define via_t1lh     $0307
; #define via_t2cl     $0308
; #define via_t2ll     $0308
; #define via_t2ch     $0309
; #define via_sr       $030A
#define via_acr      $030B
; #define via_pcr      $030C
; #define via_ifr      $030D
; #define via_ier      $030E
; #define via_porta    $030F


.zero

_kernel_ms .dsb	2
_kernel_s .dsb	1

.text

it_handler .dsb 2

irq_handler:

    pha
    txa
    pha
    tya
    pha

	jsr task_100Hz

	lda _kernel_ms
	and #$03
	bne skipNormalItHandler

    pla
    tay
    pla
    tax
    pla
	
jmp_old_handler
	jmp 0000

skipNormalItHandler:

irq_handler_done:

    pla
    tay
    pla
    tax
    pla

	rti

task_100Hz:
.(
	inc _kernel_ms
	bne skipHighMs
	inc _kernel_ms+1
skipHighMs:

	; If ms == 1000 ($3E8) ms = 0; 
	lda _kernel_ms
	cmp #$E8
	bne not_1Hz
	lda _kernel_ms+1
	cmp #$03
	bne not_1Hz

	lda #0
	sta _kernel_ms
	sta _kernel_ms+1

    inc _kernel_s
    lda _kernel_s
    cmp #60
    bne not_minute
    lda #0
    sta _kernel_s
not_minute:

	jsr task_25Hz

	jmp task100hz_done


not_1Hz:

	lda _kernel_ms
	and #$03
	bne not_25Hz

	jsr task_25Hz

not_25Hz:


task100hz_done:
.)
    rts    


task_25Hz:

task25hz_done:
    rts    


_kernelInit:
.(

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


	; Install our own handler
	lda #<irq_handler
	sta $245
	lda #>irq_handler
	sta $246

    cli 

    rts
.)


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




	; php
	; pha
	; txa
	; pha
	; tya
	; pha

	; ; This handler runs at 100hz 

	; jsr task_25Hz

	; pla
	; tay
	; pla
	; tax
	; pla
	; plp



; #define timer3_low 	$0276
; #define timer3_high $0277




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
