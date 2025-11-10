include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    a                                        dd       ?
    _0                                       dd       0.0
    _1                                       dd       1.0
    _a_es_cero                               db       "a es cero", '$', 3 dup (?)
    _2                                       dd       2.0
    _a_no_es_cero                            db       "a no es cero", '$', 3 dup (?)


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

FLD _0
FSTP a
FLD _0
FLD a
FCOM
FSTSW AX
SAHF
JNE etiqueta_0
FLD _1
FSTP a
displayString _a_es_cero
newLine
JMP etiqueta_1
etiqueta_0:
FLD _2
FSTP a
displayString _a_no_es_cero
newLine
etiqueta_1:

MOV AX,4C00H
INT 21H
END START
