; 10 SYS (2304)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28
        BYTE    $32, $33, $30, $34, $29, $00, $00, $00

;*******************************************************************************
;* Tutorial Eight (ASL, ROL, SBC ) 16 bit divider                              *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #12                                                                *
;* Date : 19th Feb, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

*=$0900
    jmp divide

;*******************************************************************************
;*                                                                             *
;* Assembly Includes                                                           *
;*                                                                             *
;*******************************************************************************

incasm "Character_ASCII_Const.asm"
incasm "Tutorial Routines.asm"

;*******************************************************************************
;* Strings                                                                     *
EnterNumberTXT
    TEXT "please enter a number?"
    BRK

EnterDividerTXT
    TEXT "enter number to divided by?"
    BRK

TheAnswerIsTXT
    TEXT "and the result is : "
    BRK

WithRemainderTXT
    TEXT "with the remainder of : "
    BRK

;*******************************************************************************
;* Division 16 bit to 16 bit                                                   *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #12                                                                *
;* Date : 19th Feb, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

;*******************************************************************************
;* Variables                                                                   *
divisor 
    WORD 0
dividend 
    WORD 0
remainder
    WORD 0 
result = dividend ;save memory by reusing divident to store the result 

;*******************************************************************************
;* Code                                                                        *
divide
    jsr CarrageReturn           ; Add a Screen Line
    PrintText EnterNumberTXT    ; Show Enter a number text
    jsr Get16BitNumber          ; Get the 16 Bit Number
    stx dividend
    sta dividend+1
    jsr CarrageReturn           ; Add a Screen Line
    PrintText EnterDividerTXT   ; Show Enter a Number to Divide by
    jsr GetNumber               ; get 8 Bit Number
    stx divisor                 ; Store in Divisor
    lda #0                      ; preset remainder to 0
    sta remainder               ; initialise remainder
    sta remainder + 1

    ldx #16                     ; repeat for each bit: ...
divloop 
    asl dividend                ; dividend lb & hb*2, msb -> Carry
    rol dividend+1  
    rol remainder               ; remainder lb & hb * 2 + msb from carry
    rol remainder+1
    lda remainder
    sec
    sbc divisor                 ; substract divisor to see if it fits in
    tay                         ; lb result -> Y, for we may need it later
    lda remainder+1
    sbc divisor+1
    bcc skip                    ; if carry=0 then divisor didn't fit in yet

    sta remainder+1             ; else save substraction result as new remainder,
    sty remainder   
    inc result                  ; and INCrement result cause divisor fit in 1 times
    bne skip
    inc result+1
skip    
    dex
    bne divloop 
    
    ; Print Result
    jsr CarrageReturn           ; Add a Screen Line
    PrintText TheAnswerIsTXT    ; Print The Result Text
    lda result+1                      
    ldx result                  ; Load X Register to dividend
    jsr $bdcd                   ; Jump To Basic Decimal Number Print Routine
    jsr CarrageReturn           ; Add a screen line
    PrintText WithRemainderTXT  ; Print The Remainder
    lda remainder + 1           ; Load remainder
    ldx remainder
    jsr $bdcd                   ; Jump To Basic Decimal Number Print Routine
    pla
    pla
    jmp $A474
    rts


