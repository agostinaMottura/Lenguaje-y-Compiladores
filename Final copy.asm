include C:\asm\macros2.asm
include C:\asm\number.asm
 
.MODEL LARGE  ; Modelo de Memoria
.386          ; Tipo de Procesador
.STACK 200h   ; Bytes en el Stack
 
MAXTEXTSIZE EQU 256
 
 
.DATA
; variables tabla simbolos
varInt dd ?
_cte_str_0 db "Hola",'$', 4 dup (?)
 
 
.CODE
 
; ------------------------ mi programa ------------------------ 
START:
; inicializa el segmento de datos
	MOV AX,@DATA
	MOV DS,AX
	MOV es,ax ;
 
; funcion write
	displayString _cte_str_0
	newLine
 
 
; indica que debe finalizar la ejecución
MOV AX,4C00H
INT 21H
END START