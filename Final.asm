include macros2.asm
include number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    a                                        dd       ?
    b                                        dd       ?
    _a_es_mas_grande_que_b                   db       "a es mas grande que b", '$', 3 dup (?)
    _a_es_mas_chico_o_igual_a_b              db       "a es mas chico o igual a b", '$', 3 dup (?)


.CODE
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX

FLD b
FLD a
FXCH
FCOM
FSTSW AX
SAHF
JBE etiqueta_0
displayString _a_es_mas_grande_que_b
JMP etiqueta_1
etiqueta_0:
displayString _a_es_mas_chico_o_igual_a_b
etiqueta_1:

mov ax,4c00h
Int 21h
End
