;*******************************************************************************
;* Tutorial Twenty-Three Basic Gravity Physics Engine                          *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #23                                                                *
;* Date : 7th Nov, 2017                                                        *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

;*******************************************************************************
;*                                                                             *
;*******************************************************************************

*=$9000

    jmp START

GRAVITY             ; Constant Gravity Value
    BYTE 05

XVELOCITY           ; X Velocity Value
    BYTE 00

YVELOCITY           ; Y Velocity Value
    BYTE 00

YPOS                ; Y Position (Height)
    BYTE 00

XPOS                ; X Position
    BYTE 00

START
    ldx #0          ; Reset Value
    stx XPOS        ; Reset X Position
    stx YPOS        ; Reset Y Position
    ldy #$10        
    sty XVELOCITY   ; Reset X Velocity
    ldy #$18
    sty YVELOCITY   ; Reset Y Velocity

PLAYER_UPDATE
    lda XPOS        ; Update the X Position for this cycle
    clc
    adc XVELOCITY   ; Apply X Velocity to X Position
    sta XPOS        ; Store back into X Position

    sec
    lda YVELOCITY   ; Update Y Velocity for this cycle
    sbc GRAVITY     ; Apply Gravity to Y Velocity

    bpl CHECK_POSITIVE_VELOCITY     ; If Y Velocity still positive
    cmp #$F1                ; C4 = -60
    bcc DONT_UPDATE_VELOCITY    ; bigger then dont update Y Velocity
    jmp UPDATE_VELOCITY         ; smaller, then update Y Velocity

CHECK_POSITIVE_VELOCITY
    cmp #$3C                ; 3c = +60
    bcs DONT_UPDATE_VELOCITY    ; bigger then dont update Y Velocity
                                ; smaller, then update Y Velocity

UPDATE_VELOCITY
    sta YVELOCITY   ; Store Y Velocity

DONT_UPDATE_VELOCITY
    lda YPOS        ; Update Y Position for this cycle
    clc
    adc YVELOCITY   ; Apply the Y Velocity to Y Position
    sta YPOS        ; Store Y Position

    cmp #0          ; Is the Y Position equal or lower than floor 
    bpl PLAYER_UPDATE   ; If positive, loop back round for another cycle

    lda #00         ; Reset Y Position and Y Velocity
    sta YPOS
    sta YVELOCITY
    rts
