
#define USE_OSME

#ifdef USE_OSME
#include "osme_s.s"
#endif ;; USE_OSME


.zero

_kernel_cs .dsb	1
_kernel_s .dsb	1

_50hzFlipFlop   .byt 0

.text

task_100Hz:
.(
    ; Save Context
    ; pha:txa:pha:tya:pha


#ifdef USE_OSME
    jsr osmePulse
#endif ;; USE_OSME

    ; kernelCentiSecond  =  (kernelCentiSecond + 1) % 100
	inc _kernel_cs
 
	lda _kernel_cs
	eor #100			;; TODO: Optim with an EOR #100 : BNE skip: STA _kernel_cs: skip:
	bne not_1Hz

	sta _kernel_cs

    jsr task_1Hz
	jsr task_50Hz
	jsr task_25Hz

	jmp task100hz_done


not_1Hz:

    lda _50hzFlipFlop
    eor #1
    sta _50hzFlipFlop
    beq not_50Hz

    jsr task_50Hz
	jsr task_25Hz

	jmp task100hz_done

not_50Hz:


	lda _kernel_cs
	and #$03
	bne not_25Hz

	jsr task_25Hz

not_25Hz:


task100hz_done:
    ; Restore Context
    ; pla:tay:pla:tax:pla


.)
    rts    

task_50Hz:
.(
	; jsr _ayUpdate
.)
    rts    



task_25Hz:
.(

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
