
task_100Hz:
.(

    ; kernelCentiSecond  =  (kernelCentiSecond + 1) % 100
	inc _kernel_cs
 
	lda _kernel_cs
	cmp #100
	bne not_1Hz

	lda #0
	sta _kernel_cs

    jsr task_1Hz

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
