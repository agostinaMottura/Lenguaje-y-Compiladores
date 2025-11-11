include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    var1                                     dd       ?
    _1                                       dd       1.0
    _ewr                                     db       "ewr", '$', 3 dup (?)


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

FLD _1
FSTP var1
displayString _ewr
newLine
DisplayFloat var1,2
newLine

MOV AX,4C00H
INT 21H
END START
