include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    var1                                     dd       ?
    _ewr                                     db       "ewr", '$', 3 dup (?)


.CODE
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX

displayString _ewr
DisplayFloat var1,2

mov ax,4c00h
Int 21h
End
