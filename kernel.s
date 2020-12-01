
#define USE_OSME


.zero

_kernel_cs .dsb	1
_kernel_s .dsb	1

.text

#include "tasks_s.s"

#ifdef USE_OSME
#include "osme_s.s"
#endif ;; USE_OSME

irq_handler:

    ; Save Context
    pha:txa:pha:tya:pha

	jsr task_100Hz

#ifdef USE_OSME
    jsr osmePulse
#endif ;; USE_OSME

    ; If we're on a 25 Hz Spot (ie kernel centi second multiple of 4)
	lda _kernel_cs
	and #$03
	bne skipNormalItHandler

        ; Call the System IT Handler
        ; We won't come back from it

        ; Restore Context
        pla:tay:pla:tax:pla

jmp_old_handler
	    jmp 0000

skipNormalItHandler:

    ; If we're on a 25 Hz Spot (ie kernel centi second multiple of 4)

    ; Restore Context
    pla:tay:pla:tax:pla

    ; Acknowledge Interruption
    bit $304

	rti

_kernelInit:
.(

	sei

	; Save the old handler value
	lda $245
	sta jmp_old_handler+1
	lda $246
	sta jmp_old_handler+2

	lda #0
	sta _kernel_cs
	sta _kernel_s


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


#ifdef USE_OSME
    jsr osmeInit
#endif ;; USE_OSME


    cli 

    rts
.)


_kernelEnd:
.(
	sei
	; Restore the old handler value
	lda jmp_old_handler+1
	sta $245
	lda jmp_old_handler+2
	sta $246
	cli
    rts
.)

