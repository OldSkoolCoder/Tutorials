;*******************************************************************************
;* Tutorial Nineteen Output to a device using Kernel Jump Vectors              *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #19                                                                *
;* Date : 22nd Aug, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

*=$0900





    jsr input
    cmp #"y"
    beq OUT1
    jsr $ffcc
    lda #4
    jsr $ffc3
    jmp ready
OUT1
    lda #4
    tax 
    ldy #255
    jsr $ffba
    lda #0
    ldx #255
    ldy #255
    jsr $ffbd
    jsr $ffc0
    ldx #4
    jsr $ffc9
    jmp ready
