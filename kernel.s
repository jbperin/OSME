
#define via_t1ll     $0306
#define via_t1lh     $0307

.zero

_kernel_cs .dsb	1
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

	lda _kernel_cs
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
	inc _kernel_cs
 
	lda _kernel_cs
	cmp #100
	bne not_1Hz

	lda #0
	sta _kernel_cs


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

	lda _kernel_cs
	and #$03
	bne not_25Hz

	jsr task_25Hz

not_25Hz:


task100hz_done:
.)
    rts    


task_25Hz:

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
	sta _kernel_cs
	sta _kernel_cs+1
	sta _kernel_s


	; Since this is an slow process, we set the VIA timer to 
	; issue interrupts at 25Hz, instead of 100 Hz. This is 
	; not necessary -- it depends on your needs
	lda #<40000
	sta via_t1ll 
	lda #>40000
	sta via_t1lh


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

