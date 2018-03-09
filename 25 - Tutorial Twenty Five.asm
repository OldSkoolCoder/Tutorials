;*******************************************************************************
;* Tutorial Twenty-Five Debugging Test Program                                 *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #25     CBM Prg Studio Tutorial 005                                *
;* Date : 18th Nov, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

;*******************************************************************************
;*                                                                             *
;* Create DEBUG WatchList                                                      *
;*                                                                             *
;*******************************************************************************
WATCH SCREENLOCATIONLO
WATCH SCREENLOCATIONHI

;*******************************************************************************
;*                                                                             *
;* Assembler Static Variables                                                  *
;*                                                                             *
;*******************************************************************************

SCREENLOCATIONLO = SCREENLOCATION + 1
SCREENLOCATIONHI = SCREENLOCATION + 2

*=$9000

    lda #0
    tax
    tay
LOOPER
    lda #'a'
SCREENLOCATION
    sta $0400,x
    inx
    iny
    lda SCREENLOCATION+1
    clc
    adc #40
    sta SCREENLOCATION+1
    lda SCREENLOCATION+2
    adc #0
    sta SCREENLOCATION+2
    cpy #20
    bne LOOPER
    rts
    
