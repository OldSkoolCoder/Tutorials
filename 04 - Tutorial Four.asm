*=$0900
    jmp MULTIPLY

divisor 
    WORD 115
dividend 
    WORD 14567
remainder
    WORD 0 
result = dividend ;save memory by reusing divident to store the result

divide
    lda #0          ;preset remainder to 0
    sta remainder
    sta remainder + 1
    ldx #16         ;repeat for each bit: ...

divloop
    asl dividend    ;dividend lb & hb*2, msb -> Carry
    rol dividend + 1  
    rol remainder   ;remainder lb & hb * 2 + msb from carry
    rol remainder + 1
    lda remainder
    sec
    sbc divisor     ;substract divisor to see if it fits in
    tay             ;lb result -> Y, for we may need it later
    lda remainder + 1
    sbc divisor + 1
    bcc skip        ;if carry=0 then divisor didn't fit in yet

    sta remainder + 1 ;else save substraction result as new remainder,
    sty remainder   
    inc result  ;and INCrement result cause divisor fit in 1 times

skip
    dex
    bne divloop 
    rts


;16-bit multiply with 32-bit Result 

MULTIPLIER
    WORD 12 
MULTIPLICAND
    WORD 200
RESULT
    WORD 0,0 

MULTIPLY
    lda #$00            ; Load Zero
    sta RESULT          ; clear Lower bytes of product
    sta RESULT + 1      ; 
    sta RESULT + 2      ; clear upper bytes of product
    sta RESULT + 3      ; 
    ldx #$10            ; set binary count to 16 
SHIFT_R 
    lsr MULTIPLIER + 1  ; divide multiplier by 2 
    ror MULTIPLIER      ; 
    bcc ROTATE_R        ; Branch if not digit put in carry
    lda RESULT + 2      ; get upper half of product and add multiplicand
    clc                 ; Clear Carry for Addition
    adc MULTIPLICAND    ; Add Multiplicand
    sta RESULT + 2      ; Store In Result
    lda RESULT + 3      ; Load High Byte
    adc MULTIPLICAND + 1; Add Multiplicand
ROTATE_R 
    ror                 ; rotate partial product 
    sta RESULT + 3      ;
    ror RESULT + 2      ;
    ror RESULT + 1      ;
    ror RESULT          ;
    dex                 ;
    bne SHIFT_R         ;
    rts                 ;