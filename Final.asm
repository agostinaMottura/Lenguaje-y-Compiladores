include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    base                                     db       50 dup (?), '$'
    prueba                                   dd       ?


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

getString base
displayString base
newLine
GetFloat prueba
DisplayFloat prueba, 2
newLine

MOV AX,4C00H
INT 21H
END START
