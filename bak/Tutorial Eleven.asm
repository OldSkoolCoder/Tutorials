; 10 SYS (2304)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28
        BYTE    $32, $33, $30, $34, $29, $00, $00, $00

;*******************************************************************************
;* Tutorial Eleven (AND, ORA, EOR ) Screen Reverser                            *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #11                                                                *
;* Date : 29th Jan, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

*=$0900
    jmp SCREENREVERSER

;*******************************************************************************
;*                                                                             *
;* Assembly Includes                                                           *
;*                                                                             *
;*******************************************************************************

incasm "Character_ASCII_Const.asm"
incasm "Tutorial Routines.asm"

;*******************************************************************************
;* Screen Reverser                                                             *
;*                                                                             *
;* Written By John C. Dale                                                     *
;*                                                                             *
;* Date : 29th Jan, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

;*******************************************************************************
;* Variables                                                                   *
CURRENTMASK
    BRK 

;*******************************************************************************
;* Strings                                                                     *

;*******************************************************************************
;* Code                                                                        *
SCREENREVERSER
    ldx #$00                ; Initialise X Register
    lda $0400               ; Loads first screen location
    and #%10000000          ; Find out if reverse flag is set
    sta CURRENTMASK         ; store result into flag location
    bmi UNREVERSE           ; Branch to Unreverse routine
LOOPBACK
    lda $0400,x             ; Load bank 0 location + x
    ora #%10000000          ; Set the Most Significant Bit (MSB) On
    sta $0400,x             ; Store result back into bank 0 loaction + x
    lda $0500,x             ; Load bank 1 location + x
    ora #%10000000          ; Set the Most Significant Bit (MSB) On
    sta $0500,x             ; Store result back into bank 1 loaction + x
    lda $0600,x             ; Load bank 2 location + x
    ora #%10000000          ; Set the Most Significant Bit (MSB) On
    sta $0600,x             ; Store result back into bank 2 loaction + x
    lda $0700,x             ; Load bank 3 location + x
    ora #%10000000          ; Set the Most Significant Bit (MSB) On
    sta $0700,x             ; Store result back into bank 3 loaction + x
    inx
    bne LOOPBACK
    jmp FINISH
UNREVERSE
    lda $0400,x             ; Load bank 0 location + x
    and #%01111111          ; Set the Most Significant Bit (MSB) Off
    sta $0400,x             ; Store result back into bank 0 loaction + x
    lda $0500,x             ; Load bank 1 location + x
    and #%01111111          ; Set the Most Significant Bit (MSB) Off
    sta $0500,x             ; Store result back into bank 1 loaction + x
    lda $0600,x             ; Load bank 2 location + x
    and #%01111111          ; Set the Most Significant Bit (MSB) Off
    sta $0600,x             ; Store result back into bank 2 loaction + x
    lda $0700,x             ; Load bank 3 location + x
    and #%01111111          ; Set the Most Significant Bit (MSB) Off
    sta $0700,x             ; Store result back into bank 3 loaction + x
    inx
    bne UNREVERSE
FINISH
    pla
    pla
    jmp $A474                   ; Return To BASIC

