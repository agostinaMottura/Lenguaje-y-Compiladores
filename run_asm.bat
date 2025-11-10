PATH=C:\asm\TASM;

tasm C:\asm\numbers.asm
tasm C:final.asm
tlink final.obj numbers.obj
final.exe
del final.obj 
del numbers.obj 
del FINAL.exe
del FINAL.map