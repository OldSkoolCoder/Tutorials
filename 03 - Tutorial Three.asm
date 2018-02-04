; 10 SYS (2304)

*=$0801

        BYTE    $0E, $08, $0A, $00, $9E, $20, $28
        BYTE    $32, $33, $30, $34, $29, $00, $00, $00

;*******************************************************************************
;* Reverses the screen                                                         *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #03                                                                *
;* Date : 07th Jan, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

*=$0900
    jmp Start

SCRN_START=$0400
Print=$ffd2
Basin=$ffcf

addlo=247
addhi=248
htlo=$14
hthi=$15

;*******************************************************************************
;*                                                                             *
;* Assembly Includes                                                           *
;*                                                                             *
;*******************************************************************************

incasm "Character_ASCII_Const.asm"

defm    PrintText
    ldy #>/1             ; Load Hi Byte to Y
    lda #</1             ; Load Lo Byte to Acc.
    jsr String              ; Print The text until hit Zero
    endm

Start
    lda #$83
    clc
    sbc #$02
    jsr PrintAccumlator
    rts

    lda #%10010011
    ora #%00100101
    ; 01001001 -> C=1
    ;eor #%00100101
    ;INC $0830
    brk


ClearCarry
    Brk

SetCarry
    Brk

    sec
    adc #$01
    adc #$ff
    lda #$ff
    adc #$ff


    lda #$10
    lda #$90
    lda #$ff

    ;beq EqualToZero
    ;bne NotEquatToZero
    ;bpl ItsPositiveNumber
    ;bmi ItsMinusNumber


    ;lda #$00
    ;lda #$a0
    ;lda #$ff

    ;jsr PrintAccumlator
    ;ldy #$08
    ;lda ($88),y
    ;jsr PrintAccumlator
    ;lsr
    ;jsr PrintAccumlator
    ;rts
    brk

Equals_TEXT
    TEXT "equals to zero"
    BYTE 13
    BRK

NotEquals_TEXT
    TEXT "not equal to zero"
    BYTE 13
    BRK

PositiveNumber_TEXT
    TEXT "this is a positive number"
    BYTE 13
    BRK

NegativeNumber_TEXT
    TEXT "this is a negative number"
    BYTE 13
    BRK

EqualToZero
    PrintText Equals_TEXT
    RTS

NotEquatToZero
    PrintText NotEquals_TEXT
    RTS

ItsPositiveNumber
    PrintText PositiveNumber_TEXT
    RTS

ItsMinusNumber
    PrintText NegativeNumber_TEXT
    RTS























;*******************************************************************************
;*                                                                             *
;* PrintAccumlator                                                             *
;*                                                                             *
;*******************************************************************************
;* This prints the number from the Accumulator to binary / Hex / Decimal       *
;*******************************************************************************
;*  Inputs : Accumulator : Number To Print Out                                 *
;*******************************************************************************
;* Variables                                                                   *
StatusState
    brk
NumberToPrint
    brk
NumberToWork
    brk
;*******************************************************************************
;* Code                                                                        *
PrintAccumlator
    PHP
    sta NumberToPrint       ; Store away the Accumulator
    pha                     ; Push the Acc to Stack
    txa                     ; Move X to Acc.
    pha                     ; Push Acc (x) to Stack
    tya                     ; Move Y to Acc.
    pha                     ; Push Acc (y) to Stack
    ldy #>rgtxt             ; Load Hi Byte to Y
    lda #<rgtxt             ; Load Lo Byte to Acc.
    jsr String              ; Print The text until hit Zero

    jsr BinPrint            ; Print Binary Array for NumberToPrint
    jsr space               ; Add a space
    jsr HexadecimalPrint    ; Print Hexadecimal for NumberToPrint
    jsr space               ; Add a space
    jsr DecimalPrint        ; Print Decimal for NumberToPrint
    pla                     ; Pull Acc (y) off Stack
    tay                     ; Move Acc. To Y
    pla                     ; Pull Acc (x) off Stack
    tax                     ; Move Acc. to X
    pla                     ; Pull Acc off Stack
    pla
    jsr status_register
    rts                     ; Return Back
;*******************************************************************************

;*******************************************************************************
;*                                                                             *
;* space                                                                       *
;*                                                                             *
;*******************************************************************************
;* This rotuines prints a space on the screen                                  *
;*******************************************************************************
;*  Inputs : None                                                              *
;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************
;* Code                                                                        *
space
    lda #CHR_Space          ; Load Space Character 
    jmp Print               ; Print This Character
;*******************************************************************************

;*******************************************************************************
;*                                                                             *
;* String                                                                      *
;*                                                                             *
;*******************************************************************************
;* This routine prints a string of characters terminating in a zero byte       *
;*******************************************************************************
;*  Inputs : Accumulator : Lo Byte Address of String                           *
;*         : Y Register  : Hi Byte Address of String                           *
;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************
;* Code                                                                        *
String
    sta htlo                ; Store Lo Byte Address of String
    sty hthi                ; Store Hi Byte Address of String
string_nxtchr
    ldy #0                  ; Initialise Index Y
    lda (htlo),y            ; Load Character at address + Y
    cmp #0                  ; Is it Zero?
    beq string_rts          ; If Zero, goto end of routine
    jsr Print               ; Print this character
    clc                     ; Clear The Carry
    inc htlo                ; Increase Lo Byte
    bne string_nxtchr       ; Branch away if Page Not Crossed
    inc hthi                ; Increase Hi byte
    jmp string_nxtchr       ; Jump back to get Next Character
string_rts
    rts                     ; Return Back
;*******************************************************************************

rgtxt
    byte CHR_Return
    text "binary    hex   dec.  nv-bdizc"
    byte CHR_Return
    brk 

;*******************************************************************************
;*                                                                             *
;* status_register                                                             *
;*                                                                             *
;*******************************************************************************
;* This routine prints the contents of the status register                     *
;*******************************************************************************
;*  Inputs : Accumulator : Status Register                                     *
;*******************************************************************************
;* Variables                                                                   *
streg
    brk
;*******************************************************************************
;* Code                                                                        *
status_register
    ldy #0                  ; Initialise Y Register
streg1
    sta streg               ; Store Acc. into Status Register Variable
streg3 
    asl streg               ; logically shift the acc left, and carry set or not
    lda #0                  ; Load Zero into Accu.
    adc #"0"                ; Add "0" to Acc. with  carry
    cpy #2                  ; is y = 2
    bne streg2              ; if yes, branch past the '-' symbol
    lda #"-"                ; Load Acc with "-"
streg2
    jsr Print               ; Print The contents of the Acc
    iny                     ; increase the index Y
    cpy#8                   ; test for 8 (8th bit of the number)
    bne streg3              ; Branch if not equal back to next bit
    rts                     ; Return Back
;*******************************************************************************

;*******************************************************************************
;*                                                                             *
;* BinPrint                                                                    *
;*                                                                             *
;*******************************************************************************
;* This routine prints the contents NumberToPrint as a binary number           *
;*******************************************************************************
;*  Inputs : None                                                              *
;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************
;* Code                                                                        *
BinPrint
    jsr prPercent           ; Print "%"
    ldy #0                  ; Initialise Y Index Register with zero
    lda NumberToPrint       ; Load Acc with number to print
    sta NumberToWork        ; Store Acc to Number To Work
binpr4
    asl NumberToWork        ; Logically shift left Number to Work into Carry
    lda #0                  ; Load Acc with Zero
    adc #"0                 ; Add Acc with "0" plus Carry
    jsr Print               ; Print this character either '0' ot '1'
    iny                     ; increase Y index
    cpy #8                  ; have we hit bit 8?
    bne binpr4              ; No, get next Bit
    rts                     ; Return Back 
;*******************************************************************************


;*******************************************************************************
;*                                                                             *
;* DecimalPrint                                                                *
;*                                                                             *
;*******************************************************************************
;* This routine prints the contents NumberToPrint as a decimal number          *
;*******************************************************************************
;*  Inputs : None                                                              *
;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************
;* Code                                                                        *
DecimalPrint
    jsr prHash              ; Print "#"
    lda #$00                ; Initialise Acc with zero
    ldx NumberToPrint       ; Load X Register with NumberToPrint
    stx NumberToWork        ; Store X Register to NumberToWork
    jmp $bdcd               ; Jump To Basic Decimal Number Print Routine
;*******************************************************************************

prDollar
    lda #"$"
    byte 44
prBracketOpen
    lda #"("
    byte 44
prBracketClosed
    lda #")"
    byte 44
prComma
    lda #","
    byte 44
prx
    lda #"x"
    byte 44
pry
    lda #"y"
    byte 44
prPercent 
    lda #"%"
    byte 44
prHash
    lda #"#"
    jmp Print

;*******************************************************************************
;*                                                                             *
;* HexaDecimalPrint                                                            *
;*                                                                             *
;*******************************************************************************
;* This routine prints the contents NumberToPrint as a hexadecimal number      *
;*******************************************************************************
;*  Inputs : None                                                              *
;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************
;* Code                                                                        *
HexadecimalPrint
    jsr prDollar            ; Print a "$"
    ldx #$00                ; Initialise X Register with Zero
    lda NumberToPrint       ; Load Acc with NumberToPrint
    sta NumberToWork        ; Store Acc to NumberToPrint
    jmp pbyte2              ; Jump to Hexadecimal routine
;*******************************************************************************

;*******************************************************************************
;*                                                                             *
;* pbyte2                                                                      *
;*                                                                             *
;*******************************************************************************
;* This routine evaluates and prints a four character hexadecimal number       *
;*******************************************************************************
;*  Inputs : Accumulator : Lo Byte of the number to be converted               *
;*           X Register  : Hi Byte of the number to be converted               *
;*******************************************************************************
;* Variables                                                                   *
;*******************************************************************************
;* Code                                                                        *
pbyte2
    pha                     ; Push Acc to the Stack 
    txa                     ; Tansfer X register To Acc
    jsr pbyte1              ; Execute 2 digit Hexadecimal convertor
    pla                     ; Pull Acc from Stack
pbyte1
    pha                     ; Push Acc to the Stack 
                            ; Convert Acc into a nibble Top '4 bits'
    lsr                     ; Logically shift Right Acc
    lsr                     ; Logically shift Right Acc
    lsr                     ; Logically shift Right Acc
    lsr                     ; Logically shift Right Acc
    jsr pbyte               ; Execute 1 digit Hexadecimal number
    tax                     ; Transfer Acc back into X Register 
    pla                     ; Pull Acc from the Stack
    and #15                 ; AND with %00001111 to filter out lower nibble
pbyte
    clc                     ; Clear the Carry
                            ; Perform Test weather number is greater than 10
    adc #$f6                ; Add #$F6 to Acc with carry
    bcc pbyte_skip          ; Branch is carry  is still clear
    adc #6                  ; Add #$06 to Acc to align PETSCII Character 'A'
pbyte_skip
    adc #$3a                ; Add #$3A to align for PETSCII Character '0'
    jmp Print               ; Jump to the Print Routine for that character
;*******************************************************************************
