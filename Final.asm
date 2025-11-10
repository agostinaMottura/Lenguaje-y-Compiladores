include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    a                                        dd       ?
    c                                        dd       ?
    d                                        dd       ?
    e                                        dd       ?
    b                                        db       50 dup (?), '$'
    _9                                       dd       9.0
    _asldk__fh_sjf                           db       "asldk  fh sjf", '$', 3 dup (?)
    _M205P0                                  dd       -205.0


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

FLD _9
FSTP a
DisplayFloat a, 2
newLine
LEA ESI, _asldk__fh_sjf
LEA EDI, b
MOV ECX, 14
REP MOVSB

displayString b
newLine
FLD _M205P0
FSTP a
DisplayFloat a, 2
newLine

MOV AX,4C00H
INT 21H
END START
