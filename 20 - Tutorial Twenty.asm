;*******************************************************************************
;* Tutorial Nineteen Output to a device using Kernel Jump Vectors              *
;*                                                                             *
;* Written By John C. Dale                                                     *
;* Tutorial #20                                                                *
;* Date : 24th Aug, 2017                                                       *
;*                                                                             *
;*******************************************************************************
;*                                                                             *
;*******************************************************************************

;*******************************************************************************
;* Kernel Vector Constants                                                     *
;*******************************************************************************

CHROUT  = $FFD2
CHKOUT  = $FFC9
OPEN    = $FFC0
SETLFS  = $FFBA
SETNAM  = $FFBD
CLRCHN  = $FFCC
CLOSE   = $FFC3

PRINTSTRING = $AB1E

*=$9000
    ;jmp PRINTTODEFAULT
    ;jmp PRINTTOPRINTER
    ;jmp PRINTTOTAPE
    jmp PRINTTODISK

TESTFILENAME
    TEXT "johntest"
    BRK

TESTFILENAMEDISK
    TEXT "johntest,seq,write"
    BRK

TESTTEXT
    TEXT "this is to test the output jump vectors"
    BYTE 15
    BRK

PRINTTODEFAULT
    ldx #$00
    lda #<TESTTEXT
    ldy #>TESTTEXT
    jsr PRINTSTRING
    rts

PRINTTOPRINTER
    lda #4      ; Logical File Number
    tax         ; Device Number (Printer Device #4)
    ldy #2      ; Secondary Address
    jsr SETLFS
    lda #0
    ldx #255
    ldy #255
    jsr SETNAM
    jsr OPEN
    ldx #4      ; Logical File Number
    jsr CHKOUT
    jsr PRINTTODEFAULT
    ;ldx #$00
    ;lda #<TESTTEXT
    ;ldy #>TESTTEXT
    ;jsr PRINTSTRING
    jsr CLRCHN
    lda #4      ; Logical File Number
    jsr CLOSE
    rts
    
PRINTTOTAPE
    lda #1      ; Logical File Number
    tax         ; Device Number (Tape Device #1)
    ldy #255    ; Secondary Address
    jsr SETLFS
    lda #8
    ldx #<TESTFILENAME
    ldy #>TESTFILENAME
    jsr SETNAM
    jsr OPEN
    ldx #1      ; Logical File Number
    jsr CHKOUT
    jsr PRINTTODEFAULT
    ;ldx #$00
    ;lda #<TESTTEXT
    ;ldy #>TESTTEXT
    ;jsr PRINTSTRING
    jsr CLRCHN
    lda #1      ; Logical File Number
    jsr CLOSE
    RTS

PRINTTODISK
    lda #8      ; Logical File Number
    tax         ; Device Number (Disk Drive 8)
    ldy #2      ; Secondary Address
    jsr SETLFS
    lda #18
    ldx #<TESTFILENAMEDISK
    ldy #>TESTFILENAMEDISK
    jsr SETNAM
    jsr OPEN
;    bcc NOOPENERRORFOUND
;    cmp #1      ; To Many Files Open
;    bne @NEXT
;    jmp TOOMANYFILESOPENERROR
;@NEXT
;    cmp #2      ; File Already Open
;    bne @NEXT2
;    jmp FILEALREADYOPENERROR
;@NEXT2
;    cmp #4      ; File Not Found
;    bne @NEXT3
;    jmp FILENOTFOUNDERROR
;@NEXT3
;    cmp #5      ; Device Not Present
;    bne @NEXT4
;    jmp DEVICENOTPRESENTERROR
;@NEXT4
;    cmp #6      ; File is not an Input File
;    bne NOOPENERRORFOUND
;    jmp FILENOTINPUTFILEERROR
;NOOPENERRORFOUND
    ldx #8      ; Logical File Number
    jsr CHKOUT
    bcc NOCHKOUTERRORFOUND
    cmp #0      ; Routine Terminated By Stop Key
    cmp #3      ; File Not Open
    cmp #5      ; Device Not Present
    cmp #7      ; File is not an Output File

NOCHKOUTERRORFOUND
    jsr PRINTTODEFAULT
    ;ldx #$00
    ;lda #<TESTTEXT
    ;ldy #>TESTTEXT
    ;jsr PRINTSTRING
    jsr CLRCHN
    lda #8      ; Logical File Number
    jsr CLOSE
    RTS
