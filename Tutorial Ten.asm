; 10 SYS (2304)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28
        BYTE    $32, $33, $30, $34, $29, $00, $00, $00

;*******************************************************************************
;* Tutorial Ten (LDA, STA, ADC ) Fibonacii Series Generator                    *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #10                                                                *
;* Date : 25th Jan, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

*=$0900
    jmp FIBONACII

;*******************************************************************************
;*                                                                             *
;* Assembly Includes                                                           *
;*                                                                             *
;*******************************************************************************

incasm "Character_ASCII_Const.asm"
incasm "Tutorial Routines.asm"

;*******************************************************************************
;* Fibonacci Series Generator                                                  *
;*                                                                             *
;* Written By John C. Dale                                                     *
;*                                                                             *
;* Date : 25th Jan, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

;*******************************************************************************
;* Variables                                                                   *
CURRENTVALUE_Y
    BRK 
PREVIOUSVALUE_X
    BRK
NEWVALUE_Z
    BRK 

;*******************************************************************************
;* Strings                                                                     *
StartTEXT
    TEXT "fibonacii series"
    BYTE CHR_Return
    BRK

;*******************************************************************************
;* Code                                                                        *
FIBONACII
    ldx #$00
    stx PREVIOUSVALUE_X         ; X = 0
    stx NEWVALUE_Z              ; Z = 0
    inx
    stx CURRENTVALUE_Y          ; Y = 1
    PrintText StartTEXT
    lda #$00
    ldx PREVIOUSVALUE_X         ; Print X
    jsr $bdcd                   ; Jump To Basic Decimal Number Print Routine
LOOPBACK                        ; Loop Until x > 256
    jsr CarrageReturn
    lda #$00
    ldx CURRENTVALUE_Y          ; Print Y
    jsr $bdcd                   ; Jump To Basic Decimal Number Print Routine
    lda PREVIOUSVALUE_X
    clc
    adc CURRENTVALUE_Y          ; 
    sta NEWVALUE_Z              ; Z = X + Y
    lda CURRENTVALUE_Y
    sta PREVIOUSVALUE_X         ; X = Y
    lda NEWVALUE_Z
    sta CURRENTVALUE_Y          ; Y = Z
    bcc LOOPBACK                ; Loop Until y > 256

    jsr CarrageReturn           ; New Line
    pla
    pla
    jmp $A474                   ; Return To BASIC

