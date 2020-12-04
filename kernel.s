

#include "tasks_s.s"


.text


irq_handler:
	
    ; Save Context
    php:pha

	; sei

	jsr task_100Hz

    ; If we're on a 25 Hz Spot (ie kernel centi second multiple of 4)
	lda _kernel_cs
	and #$03
	bne skipNormalItHandler

        ; Restore Context before we call the System IT Handler
        ; Because we won't come back from it
    
        pla:plp

jmp_old_handler
	    jmp 0000

skipNormalItHandler:


    ; Acknowledge Interruption
    bit $304

    ; Restore Context
    pla:plp

	; cli 

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

