## Script para Unix
flex src/lexico/Lexico.l # Genera el analizador léxico (lex.yy.c)
bison -dyv src/sintactico/Sintactico.y # Genera el analizador sintáctico (y.tab.c y y.tab.h)

C_FILES=$(find src -name "*.c")

gcc lex.yy.c y.tab.c $C_FILES -o compilador

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