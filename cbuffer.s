

#define TEMPLATE 

// BEWARE : Only use Power of Two ::
#define NB_MAX_ELEM_TEMPLATE    16

.text

cbuffer_TEMPLATE        .dsb NB_MAX_ELEM_TEMPLATE

iR_TEMPLATE             .byt 0
iW_TEMPLATE             .byt 0
nbE_TEMPLATE            .byt 0

; Register A contains element to add in buffer
add_TEMPLATE:
.(
    ; Buff[iW ] = E
    ; SI iW == iR Alors
    ;   iR = (iR+1)%NBM
    ;   iW = iR
    ; Sinon
    ;   iW = (iW + 1)%NBM
    ;   nbE = nbE + 1
    ; Finsi

    ; Buff[iW ] = E
    ldy         iW_TEMPLATE
    sta         cbuffer_TEMPLATE, Y

    ; SI iW == iR Alors
    cpy         iR_TEMPLATE
    bne         noOverload
    ;   iR = (iR+1)%NBM
        inc         iR_TEMPLATE
        lda         iR_TEMPLATE
        and         #(NB_MAX_ELEM_TEMPLATE-1)
        sta         iR_TEMPLATE
    ;   iW = iR
        sta         iW_TEMPLATE
    jmp         endif
    ; Sinon
noOverload:
    ;   iW = (iW + 1)%NBM
        inc         iW_TEMPLATE
        lda         iW_TEMPLATE
        and         #(NB_MAX_ELEM_TEMPLATE-1)
        sta         iW_TEMPLATE
    ;   nbE = nbE + 1
        inc         nbE_TEMPLATE
    ; Finsi
endif:



.)
    rts
