; 10 SYS (2304)

*=$0801

    BYTE $0E, $08, $0A, $00, $9E, $20, $28
    BYTE $32, $33, $30, $34, $29, $00, $00, $00

*=$0900

;*************************************************
;* Variables
;*************************************************

SCREEN_Start_Location$ = $0400

VAR_BINARY = %01010101
VAR_HEX = $1F
VAR_OCTAL = @13
VAR_DECIMAL = 123

Start
    ldy #0
@Looper
    tya
    sta SCREEN_Start_Location$,y
    iny
    bne @Looper
    rts




