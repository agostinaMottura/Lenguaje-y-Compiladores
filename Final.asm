include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    s                                        dd       ?
    h                                        dd       ?
    contador                                 dd       ?
    _3                                       dd       3.0
    _44                                      dd       44.0
    _10                                      dd       10.0
    _0                                       dd       0.0
    _El_contador_vale_10                     db       "El contador vale 10", '$', 3 dup (?)
    _1                                       dd       1.0
    _7                                       dd       7.0
    _2                                       dd       2.0
    _La_expresion_es_igual_a_cero            db       "La expresion es igual a cero", '$', 3 dup (?)


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

FLD _3
FSTP s
FLD _44
FSTP h
FLD _10
FSTP contador
etiqueta_0:
FLD contador
FLD _10
FSUB
FCOMP _0
FSTSW AX
SAHF
JNE etiqueta_1
displayString _El_contador_vale_10
newLine
FLD contador
FLD _1
FSUB
FSTP contador
JMP etiqueta_0
etiqueta_1:
FLD s
FLD _7
FMUL
FLD _1
FADD
FLD h
FLD _2
FDIV
FSUB
FCOMP _0
FSTSW AX
SAHF
JNE etiqueta_2
displayString _La_expresion_es_igual_a_cero
newLine
etiqueta_2:

MOV AX,4C00H
INT 21H
END START
