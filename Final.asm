include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    a                                        dd       ?
    b                                        dd       ?
    c                                        dd       ?
    _2                                       dd       2.0
    _1                                       dd       1.0
    _a_es_mas_grande_que_b_y_c_es_mas_grande_que_b db       "a es mas grande que b y c es mas grande que b", '$', 3 dup (?)
    _a_no_es_mas_grande_que_b                db       "a no es mas grande que b", '$', 3 dup (?)
    _a_es_mas_grande_que_b_o_c_es_mas_grande_que_b db       "a es mas grande que b o c es mas grande que b", '$', 3 dup (?)


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

FLD _2
FSTP a
FLD _1
FSTP b
FLD _2
FSTP c
FLD b
FLD a
FCOM
FSTSW AX
SAHF
JBE etiqueta_0
FLD b
FLD c
FCOM
FSTSW AX
SAHF
JBE etiqueta_0
displayString _a_es_mas_grande_que_b_y_c_es_mas_grande_que_b
newLine
etiqueta_0:
FLD b
FLD a
FCOM
FSTSW AX
SAHF
JA etiqueta_1
displayString _a_no_es_mas_grande_que_b
newLine
etiqueta_1:
FLD b
FLD a
FCOM
FSTSW AX
SAHF
JA etiqueta_2
FLD b
FLD c
FCOM
FSTSW AX
SAHF
JBE etiqueta_3
etiqueta_2:
displayString _a_es_mas_grande_que_b_o_c_es_mas_grande_que_b
newLine
etiqueta_3:
FLD b
FLD c
FADD
FSTP a

MOV AX,4C00H
INT 21H
END START
