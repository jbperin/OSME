
;; Author: Jean-Baptiste PERIN 

#include "via.h"

.zero

_ayReg0      .dsb 1    ; R : 
_ayReg1      .dsb 1    ; R : 
_ayReg2      .dsb 1    ; R : 
_ayReg3      .dsb 1    ; R : 
_ayReg4      .dsb 1    ; R : 
_ayReg5      .dsb 1    ; R : 
_ayReg6      .dsb 1    ; R : 
_ayReg7      .dsb 1    ; R : 
_ayReg8      .dsb 1    ; R : 
_ayReg9      .dsb 1    ; R : 
_ayReg10     .dsb 1    ; R : 
_ayReg11     .dsb 1    ; R : 
_ayReg12     .dsb 1    ; R : 
_ayReg13     .dsb 1    ; R : 

; store precalculated values to write in via PCR for latch sequence
ayLatch_N   .dsb 1
ayLatch_V   .dsb 1
ayUnlatch   .dsb 1

; temporary variable
ayTmp       .dsb 1

.text

#define LATCH_REG_NUMBER     sta via_porta:lda ayLatch_N:sta via_pcr:lda ayUnlatch: sta via_pcr
#define LATCH_REG_VALUE      sta via_porta:lda ayLatch_V:sta via_pcr:lda ayUnlatch: sta via_pcr


_ayInit:
    lda #0 
    sta _ayReg0 
    sta _ayReg1 
    sta _ayReg2 
    sta _ayReg3 
    sta _ayReg4 
    sta _ayReg5 
    sta _ayReg6 
    sta _ayReg7 
    sta _ayReg8 
    sta _ayReg9 
    sta _ayReg10
    sta _ayReg11
    sta _ayReg12
    sta _ayReg13
    
_ayUpdate:

    sei

    ;; Save bits 
    lda     $30F
    and     #$11
    sta     ayTmp

    ;; Prepare values used in latch sequence of VIA 6522
    and     #$EE     
    sta     ayLatch_N
    lda     ayTmp
    and     #$EC
    sta     ayLatch_V
    lda     ayTmp
    and     #$CC
    sta     ayUnlatch

    ;; Tranfert registers one by one

;    lda     #0
;    LATCH_REG_NUMBER
;    sta     via_porta 
;    lda     ayLatch_N
;    sta     via_pcr 
;    lda     ayUnlatch
;    sta     via_pcr
;    lda     _ayReg0
;    LATCH_REG_VALUE
;    sta     via_porta 
;    lda     ayLatch_V
;    sta     via_pcr 
;    lda     ayUnlatch
;    sta     via_pcr

    lda #0 : LATCH_REG_NUMBER: lda _ayReg0 : LATCH_REG_VALUE
    lda #1 : LATCH_REG_NUMBER: lda _ayReg1 : LATCH_REG_VALUE
    lda #2 : LATCH_REG_NUMBER: lda _ayReg2 : LATCH_REG_VALUE
    lda #3 : LATCH_REG_NUMBER: lda _ayReg3 : LATCH_REG_VALUE
    lda #4 : LATCH_REG_NUMBER: lda _ayReg4 : LATCH_REG_VALUE
    lda #5 : LATCH_REG_NUMBER: lda _ayReg5 : LATCH_REG_VALUE
    lda #6 : LATCH_REG_NUMBER: lda _ayReg6 : LATCH_REG_VALUE
    lda #7 : LATCH_REG_NUMBER: lda _ayReg7 : ORA #$40: LATCH_REG_VALUE
    lda #8 : LATCH_REG_NUMBER: lda _ayReg8 : LATCH_REG_VALUE
    lda #9 : LATCH_REG_NUMBER: lda _ayReg9 : LATCH_REG_VALUE
    lda #10: LATCH_REG_NUMBER: lda _ayReg10: LATCH_REG_VALUE
    lda #11: LATCH_REG_NUMBER: lda _ayReg11: LATCH_REG_VALUE
    lda #12: LATCH_REG_NUMBER: lda _ayReg12: LATCH_REG_VALUE
    lda #13: LATCH_REG_NUMBER: lda _ayReg13: LATCH_REG_VALUE    
    
    cli
    rts     