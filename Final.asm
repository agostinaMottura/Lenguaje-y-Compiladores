include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    a                                        dd       ?
    b                                        dd       ?
    x                                        dd       ?
    _5P0                                     dd       5.0
    _10P0                                    dd       10.0
    _20P0                                    dd       20.0
    _wow                                     db       "wow", '$', 3 dup (?)
    _b                                       db       "b", '$', 3 dup (?)
    _a                                       db       "a", '$', 3 dup (?)
    _hola                                    db       "hola", '$', 3 dup (?)
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
FLD _20P0
FSTP x
FLD _5P0
FLD a
FCOM
FSTSW AX
SAHF
JNE etiqueta_2
FLD x
FLD b
FCOM
FSTSW AX
SAHF
JAE etiqueta_2
displayString _wow
newLine
FLD _10P0
FLD b
FCOM
FSTSW AX
SAHF
JB etiqueta_0
displayString _b
newLine
JMP etiqueta_1
etiqueta_0:
displayString _a
newLine
etiqueta_1:
JMP etiqueta_3
etiqueta_2:
displayString _hola
newLine
etiqueta_3:
displayString _chau
newLine

MOV AX,4C00H
INT 21H
END START
