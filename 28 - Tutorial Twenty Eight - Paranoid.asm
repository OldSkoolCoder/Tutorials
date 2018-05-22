;*******************************************************************************
;* Tutorial Twenty-Eight Paranoid Coversion                                    *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #28                                                                *
;* Date : 5th Jan, 2018                                                        *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

; 10 SYS (2064)

;*******************************************************************************
;*                                                                             *
;* Debug Watch Variables                                                       *
;*                                                                             *
;*******************************************************************************

WATCH Prog_X
WATCH Prog_Y
WATCH Prog_DX
WATCH Prog_DY
WATCH Prog_Y1
WATCH Prog_X1
WATCH Prog_Pos
WATCH Prog_YA
WATCH Prog_YB
WATCH Prog_XA
WATCH Prog_XB
WATCH Prog_XC

;*******************************************************************************
;*                                                                             *
;* BASIC Auto Run Loader                                                       *
;*                                                                             *
;*******************************************************************************

*=$0801

    BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $36, $34, $29, $00, $00, $00

*=$0810

;*******************************************************************************
;*                                                                             *
;* Assembley Reference Variables                                               *
;*                                                                             *
;*******************************************************************************

VIC         = $D000     ; 53248
SCRNSTART   = $0400     ; 1024
GRAPHICSSRT = $2000     ; 8192

X_START     = 79
Y_START     = 49

POINTADDRESS= $14

;*******************************************************************************
;*                                                                             *
;* Program Start                                                               *
;*                                                                             *
;*******************************************************************************

    jmp START

;*******************************************************************************
;*                                                                             *
;* Code Variables                                                              *
;*                                                                             *
;*******************************************************************************

Prog_BA
    BYTE 00

Prog_PArray
    BYTE %10000000,%01000000,%00100000,%00010000,%00001000
    BYTE %00000100,%00000010,%00000001

Prog_X
    WORD 00

Prog_Y
    WORD 00

Prog_DX
    BYTE 00

Prog_DY
    BYTE 00

Prog_Y1
    WORD 00

Prog_X1
    WORD 00

Prog_Pos
    WORD 00

Prog_YA
    BYTE 00

Prog_YB
    BYTE 00

Prog_XA
    BYTE 00

Prog_XB
    BYTE 00

Prog_XC
    BYTE 00

;*******************************************************************************
;*                                                                             *
;* G^Ray Defender - Randomiser Code from G-Pac Clone Game                      *
;*                                                                             *
;*******************************************************************************

;============================================================
Init_Random
    lda #$FF                ; maximum frequency value
    sta $D40E               ; voice 3 frequency low byte
    sta $D40F               ; voice 3 frequency high byte
    lda #$80                ; noise SIRENform, gate bit off
    sta $D412               ; voice 3 control register
    rts

Rand
    lda $D41B               ; get random value from 0-255
    rts
;============================================================

;*******************************************************************************
;*                                                                             *
;* Defined Macros                                                              *
;*                                                                             *
;*******************************************************************************

;*******************************************************************************
;*                                                                             *
;* Fill Video Memory Bank With A Value                                         *
;*                                                                             *
;*******************************************************************************
defm FillVideoMemoryBank    ; StartAddress
    ; Start Address of Bank
    ldx #0
@Looper
    sta /1,x
    sta /1 + $0100,x
    sta /1 + $0200,x
    sta /1 + $0300,x
    inx
    bne @Looper
    endm

;*******************************************************************************
;*                                                                             *
;* Evaluate a Delta Code from a Random Number                                  *
;*                                                                             *
;*******************************************************************************
defm EvaluateNextDeltaNumber    ; Delta Variable
    
    ;DX=INT(RND(1)*3-1) Results in a number of either -1, 0, +1

    jsr Rand
    and #%00000011          ; just give me the 2 least significant bits
    sec
    sbc #1
    sta /1
    endm

;*******************************************************************************
;*                                                                             *
;* Copy a Word from One Address to Another Address                             *
;*                                                                             *
;*******************************************************************************
defm CopyWord ; WordSource, WordTarget

    lda /1
    sta /2
    lda /1 + 1
    sta /2 + 1
    endm

;*******************************************************************************
;*                                                                             *
;* Subtract a Number from a Memory Location and Store result in another location
;*                                                                             *
;*******************************************************************************
defm SubtractNumberWord ; wrdSourceNumber, wrdSubtract, wrdTarget

    lda #</1
    sec
    sbc /2
    sta /3
    lda #>/1
    sbc /2 + 1
    sta /3 + 1
    endm

;*******************************************************************************
;*                                                                             *
;* Add a twos compliment Byte to an Existing Twos Compliment Word              *
;*                                                                             *
;*******************************************************************************
defm AddTwosComplimentNumbers ; wrdSource, bytAddition, wrdTarget

    clc
    lda /2

    adc /1
    sta /3
    lda /2
    bpl @JumpCLC
    clc
@JumpCLC
    lda #0
    adc /1 + 1
    sta /3 + 1      ; Add the carry over to the HiByte of the wrdTarget
    endm

;*******************************************************************************
;*                                                                             *
;* Multiply a word source by 2                                                 *
;*                                                                             *
;*******************************************************************************
defm MultiplyWordByTwo  ; wrdSource, wrdTarget

    lda /1
    asl
    sta /2
    lda /1 + 1
    rol
    sta /2 + 1
    endm

;*******************************************************************************
;*                                                                             *
;* Divide the Source Word by eight, and store the result and the remainder     *
;*                                                                             *
;*******************************************************************************
defm DivideSourceWordByEight ; wrdSource, bytResult, bytRemainder

    lda /1
    sta /2
    
    lda /1 + 1
    lsr         ; Divide by 2
    ror /2
    lsr         ; Divide By 4
    ror /2
    lsr         ; Divide By 8
    ror /2

    lda /1
    and #%00000111
    sta /3
    endm

;*******************************************************************************
;*                                                                             *
;* Main Routine                                                                *
;*                                                                             *
;*******************************************************************************
START
    jsr Init_Random

Line0               
    ;BACKGROUND=1
    lda #1
    sta Prog_BA

Line5               
    ;POKE55,255:POKE56,31
    ; Dont need to convert line 5, as this is related to protecting basic

Line6               
    ;DIMP(7):FORI=0TO7:P(I)=2^(7-I):NEXT

    ;ldx #0
    ;lda #$80
@Line6Loop
    ;sta p,x
    ;lsr
    ;inx
    ;cpx#8
    ;bne @Line6Loop

Line10              
    ;V=53248:POKEV+32,0:POKEV+33,0
    lda #0
    sta VIC + 32
    sta VIC + 33

Line30              
    ;POKEV+24,PEEK(V+24)OR8
    lda VIC + 24
    ora #8
    sta VIC + 24

Line40              
    ;POKEV+17,PEEK(V+17)OR32
    lda VIC + 17
    ora #32
    sta VIC + 17

Line50              
    ;FORI=1024TO2024:POKEI,BA:NEXT
    lda Prog_BA
    FillVideoMemoryBank SCRNSTART

Line60              
    ;FORI=8192TO8192+8*1024:POKEI,0:NEXT

    lda #0
    FillVideoMemoryBank GRAPHICSSRT
    FillVideoMemoryBank $2400
    FillVideoMemoryBank $2800
    FillVideoMemoryBank $2C00
    FillVideoMemoryBank $3000
    FillVideoMemoryBank $3400
    FillVideoMemoryBank $3800
    FillVideoMemoryBank $3C00

Line100             
    ;X=79:Y=49:DX=INT(RND(1)*3-1):DY=INT(RND(1)*3-1):IFDX=0ANDDY=0THEN100
    ldx #X_START
    stx Prog_X
    ldy #Y_START
    sty Prog_Y

    lda #0
    sta Prog_X + 1
    sta Prog_Y + 1

    EvaluateNextDeltaNumber Prog_DX
    
    EvaluateNextDeltaNumber Prog_DY

    lda Prog_DX
    bne Line105
    lda Prog_DY
    bne Line105
    jmp Line100

Line105
    ;Y1=Y:X1=X:GOSUB1000:X1=319-X:GOSUB1000:Y1=199-Y:GOSUB1000:X1=X:GOSUB1000
    
    CopyWord Prog_Y, Prog_Y1

    CopyWord Prog_X, Prog_X1

    jsr Line1000
    
    SubtractNumberWord $013F, Prog_X, Prog_X1

    jsr Line1000

    SubtractNumberWord $00C7, Prog_Y, Prog_Y1

    jsr Line1000

    CopyWord Prog_X, Prog_X1

    jsr Line1000

Line107
    ;Y1=Y*2:X1=X*2:GOSUB1000:Y1=199-Y1:X1=319-X1:GOSUB1000

    MultiplyWordByTwo Prog_Y, Prog_Y1

    MultiplyWordByTwo Prog_X, Prog_X1

    jsr Line1000
    
    SubtractNumberWord $00C7, Prog_Y1, Prog_Y1

    SubtractNumberWord $013F, Prog_X1, Prog_X1

    jsr Line1000

Line110
    ;X=X+DX:Y=Y+DY:IFX<0ORX>159THENDX=-DX:GOTO110
 
    AddTwosComplimentNumbers Prog_X, Prog_DX, Prog_X

    AddTwosComplimentNumbers Prog_Y, Prog_DY, Prog_Y

    lda Prog_X + 1
    bmi @Line110Error
    lda Prog_X
    cmp #159
    bcs @Line110Error
    jmp Line115

@Line110Error
    lda Prog_DX
    eor #$FF
    clc
    adc #01
    sta Prog_DX
    jmp Line110

Line115
    ;IFY<0ORY>99THENDY=-DY:GOTO110

    lda Prog_Y + 1
    bmi @Line115Error
    lda Prog_Y
    cmp #99
    bcs @Line115Error
    jmp Line120
@Line115Error
    lda Prog_DY
    eor #$FF
    clc
    adc #1
    sta Prog_DY
    jmp Line110

Line120
    ;IFRND(1)>.9THENDX=INT(RND(1)*3-1)
    jsr Rand
    cmp #225            ; 90% of 256
    bcc Line130
    
    EvaluateNextDeltaNumber Prog_DX

Line130
    ;IFRND(1)>.9THENDY=INT(RND(1)*3-1)

    jsr Rand
    cmp #225            ; 90% of 256
    bcc Line135
    
    EvaluateNextDeltaNumber Prog_DY

Line135
    ;IFDX<>0ORDY<>0THEN105
    lda Prog_DX
    bne @Line135
    lda Prog_DY
    bne @Line135
    jmp Line140
@Line135
    jmp Line105

Line140
    ;DX=INT(RND(1)*3-1):DY=INT(RND(1)*3-1):IFDX=0ANDDY=0THEN140

    EvaluateNextDeltaNumber Prog_DX
    
    EvaluateNextDeltaNumber Prog_DY

    lda Prog_DX
    bne Line150
    lda Prog_DY
    bne Line150
    jmp Line140

Line150
    ;GOTO105
    jmp Line105

Line1000
    ;YA=INT(Y1/8):YB=Y1-YA*8:XA=INT(X1/8):XB=X1-XA*8

    DivideSourceWordByEight Prog_Y1, Prog_YA, Prog_YB

    DivideSourceWordByEight Prog_X1, Prog_XA, Prog_XB

Line1005
    ;P=8*1024+YA*320+XA*8+YB:XC=P(XB)

    ; 8*1024
    lda #0
    sta Prog_Pos
    lda #$20
    sta Prog_Pos + 1

    ; YA*320
    ldy Prog_YA
@line1005Loop1
    clc
    lda #$40
    adc Prog_Pos
    sta Prog_Pos
    lda #1
    adc Prog_Pos + 1
    sta Prog_Pos + 1
    dey
    bne @Line1005Loop1

    ; XA*8
    lda Prog_XA
    asl             ; Multiply By 2
    asl             ; Multiply By 4
    asl             ; Multiply By 8
    pha
    ; Add Carry to Position Hi Byte
    lda #0
    adc Prog_Pos + 1
    sta Prog_Pos + 1
    pla
    clc
    adc Prog_Pos
    sta Prog_Pos
    lda Prog_Pos + 1
    adc #0
    sta Prog_Pos + 1

    ; YB
    lda Prog_YB
    clc
    adc Prog_Pos
    sta Prog_Pos
    lda #0
    adc Prog_Pos + 1
    sta Prog_Pos + 1

    ; XC=P(XB)
    ldy Prog_XB
    lda Prog_PArray,y
    sta Prog_XC

Line1010
    ; POKEP,PEEK(P)ORXC:RETURN

    lda Prog_Pos
    sta POINTADDRESS
    lda Prog_Pos + 1
    sta POINTADDRESS + 1

    ldy #0
    lda (POINTADDRESS),y
    ora Prog_XC
    sta (POINTADDRESS),y

    rts
