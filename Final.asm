include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    c                                        dd       ?
    f                                        dd       ?
    r                                        dd       ?
    z                                        dd       ?
    x                                        dd       ?
    _27P0                                    dd       27.0
    _3                                       dd       3.0
    _2                                       dd       2.0
    _500P0                                   dd       500.0
    _0P0                                     dd       0.0
    _27                                      dd       27.0
    _500                                     dd       500.0
    _34                                      dd       34.0


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

FLD _27P0
FSTP z
FLD _3
FSTP c
FLD _2
FSTP f
FLD _500P0
FSTP r
FLD _0P0
FSTP x
FLD _27
FLD c
FSUB
FSTP x
DisplayFloat x,2
newLine
FLD r
FLD _500
FADD
FSTP x
DisplayFloat x,2
newLine
FLD _34
FLD _3
FMUL
FSTP x
DisplayFloat x,2
newLine
FLD z
FLD f
FDIV
FSTP x
DisplayFloat x,2
newLine

MOV AX,4C00H
INT 21H
END START
