## Script para Unix
flex Lexico.l
bison -dyv Sintactico.y
gcc lex.yy.c y.tab.c -o compilador
if [ -z "$1" ]; then
    ./compilador prueba.txt
else
    ./compilador $1
fi
rm lex.yy.c
rm y.tab.c
rm y.output
rm y.tab.h
rm compilador