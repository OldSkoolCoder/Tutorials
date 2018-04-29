;*******************************************************************************
;* Tutorial Twenty-Six Basic Gravity Physics Engine                            *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #26                                                                *
;* Date : 13th Dec, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************
WATCH XVELOCITY
WATCH YVELOCITY
WATCH YPOS

;*******************************************************************************
;*                                                                             *
;*******************************************************************************

*=$9000
GetKey  = $FFE4

    jmp START

GRAVITY             ; Constant Gravity Value
    BYTE 05

THRUST              ; Constant Thrust Value
    BYTE 10 

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
    ldx #100
    stx YPOS        ; Reset Y Position
    ldy #$10        
    sty XVELOCITY   ; Reset X Velocity
    ldy #$0
    sty YVELOCITY   ; Reset Y Velocity

PLAYER_UPDATE
    lda XPOS        ; Update the X Position for this cycle
    clc
    adc XVELOCITY   ; Apply X Velocity to X Position
    sta XPOS        ; Store back into X Position

    sec
    lda YVELOCITY   ; Update Y Velocity for this cycle
    sbc GRAVITY     ; Apply Gravity to Y Velocity

    pha             ; Push Current Velocity Value onto Stack
    ;jsr DELAY
    ;jsr GetKey      ; Grab the Next Key Value
SIMULATION
    lda #0          ; For CBM Prg Studio Simulation use only
    cmp #" "        ; is SPACE applied
    bne ThrustNotUsed   ; No
    pla             ; Yes, Retrieve Velociity Value fromn Stack
    clc
    adc THRUST      ; Add counteracting Thrust value
    pha             ; Place back on stack

ThrustNotUsed
    pla
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

DELAY
KT_LOOPER
    ldx #255             ; Loop For 255 Y Cycles

KT_OUTERLOOP
    ldy #255            ; Loop 255 times

KT_INNERLOOP
    dey                 ; Decrease Inner Loop Index
    bne KT_INNERLOOP    ; Hit Zero?, No, Loop Round
    dex                 ; Yes, Decrease Outer Loop Index
    bne KT_OUTERLOOP    ; Hit Zero?, No, Loop Round
    rts                 ; Yes, Exit