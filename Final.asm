include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    a                                        dd       ?
    b                                        dd       ?
    _5P0                                     dd       5.0
    _10P0                                    dd       10.0
    _a_es_mas_grande_que_b                   db       "a es mas grande que b", '$', 3 dup (?)
    _a_es_mas_chico_o_igual_a_b              db       "a es mas chico o igual a b", '$', 3 dup (?)
    _chau                                    db       "chau", '$', 3 dup (?)


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

FLD _5P0
FSTP a
FLD _10P0
FSTP b
FLD b
FLD a
FCOM
FSTSW AX
SAHF
JBE etiqueta_0
displayString _a_es_mas_grande_que_b
newLine
JMP etiqueta_1
etiqueta_0:
displayString _a_es_mas_chico_o_igual_a_b
newLine
etiqueta_1:
displayString _chau
newLine

MOV AX,4C00H
INT 21H
END START
