;*******************************************************************************
;* Tutorial Twenty-One Input from a device using Kernel Jump Vectors           *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #21                                                                *
;* Date : 29th Sep, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

;*******************************************************************************
;* Kernel Vector Constants                                                     *
;*******************************************************************************

CHROUT  = $FFD2
CHRIN   = $FFCF
CHKIN   = $FFC6
CHKOUT  = $FFC9
OPEN    = $FFC0
SETLFS  = $FFBA
SETNAM  = $FFBD
CLRCHN  = $FFCC
CLOSE   = $FFC3

PRINTSTRING = $AB1E
BUFFERTEXT  = $0200

*=$9000
    ;jmp INPUTFROMDEFAULT
    ;jmp INPUTFROMTAPE
    ;jmp INPUTFROMDISK

TESTFILENAME
    TEXT "johntest"
    BRK

TESTFILENAMEDISK
    TEXT "johntest,seq,read"
    BRK

TESTTEXT
    TEXT "                                                        "
    BRK

INPUTFROMDEFAULT
    jsr INPUTSTRING
    rts

INPUTFROMTAPE
    lda #1      ; Logical File Number
    tax         ; Device Number (Tape Device #1)
    ldy #0      ; Secondary Address (0 = Loading)
    jsr SETLFS
    lda #8
    ldx #<TESTFILENAME
    ldy #>TESTFILENAME
    jsr SETNAM
    jsr OPEN
    ldx #1      ; Logical File Number
    jsr CHKIN
    jsr INPUTFROMDEFAULT
    jsr CLRCHN
    lda #1      ; Logical File Number
    jsr CLOSE
    RTS

INPUTFROMDISK
    lda #8      ; Logical File Number
    tax         ; Device Number (Disk Drive 8)
    ldy #2      ; Secondary Address
    jsr SETLFS
    lda #17
    ldx #<TESTFILENAMEDISK
    ldy #>TESTFILENAMEDISK
    jsr SETNAM
    jsr OPEN
    ldx #8      ; Logical File Number
    jsr CHKIN

NOCHKOUTERRORFOUND
    jsr INPUTFROMDEFAULT
    jsr CLRCHN
    lda #8      ; Logical File Number
    jsr CLOSE
    RTS

INPUTSTRING
    ldx #0
@INPUTSTRINGLOOP
    jsr $e112
    cmp #13
    beq @INPUTEND
    sta TESTTEXT,x
    inx
    cpx #56
    bcc @INPUTSTRINGLOOP
@INPUTEND
    RTS

    
