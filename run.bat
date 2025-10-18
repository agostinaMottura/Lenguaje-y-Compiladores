:: Script corregido para windows
@echo off

:: Generar analizador lexico
cd src\lexico
flex Lexico.l
cd ..\..

:: Generar analizador sintactico
cd src\sintactico
bison -dyv Sintactico.y
cd ..\..

:: Copiar archivos generados al directorio raiz
copy "src\lexico\lex.yy.c" .
copy "src\sintactico\y.tab.c" .
copy "src\sintactico\y.tab.h" .

:: Compilar con todas las dependencias y sin warnings
gcc.exe -std=c99 -D_GNU_SOURCE -D_POSIX_C_SOURCE=200809L -Wno-implicit-function-declaration -Wno-int-to-pointer-cast -I./src -I./src/tabla-simbolos -I./src/lexico -I./src/sintactico -I./src/validaciones -I./src/utils -I./src/valores -I./src/simbolos/terminales -I./src/simbolos/no-terminales -I./src/simbolos/no-terminales/punteros -I./src/tabla-simbolos/tipo-dato -I./src/pila -I./src/pila_punteros -I./src/semantico -I./src/gci/tercetos lex.yy.c y.tab.c src/tabla-simbolos/tabla_simbolos.c src/validaciones/validaciones.c src/utils/utils.c src/valores/valores.c src/simbolos/terminales/terminales.c src/simbolos/no-terminales/no_terminales.c src/simbolos/no-terminales/punteros/punteros.c src/tabla-simbolos/tipo-dato/tipo_dato.c src/pila/pila.c src/pila_punteros/pila_punteros.c src/semantico/semantico.c src/gci/tercetos/tercetos.c src/lexico/informes/informes.c src/sintactico/informes/informex.c src/tabla-simbolos/informes/informes.c src/pila/informes/informes.c src/pila_punteros/informes/informes.c src/semantico/informes/informes.c src/gci/tercetos/informes/informes.c -o compilador.exe

:: Ejecutar compilador
if "%~1"=="" (
    compilador.exe prueba.txt
) else (
    compilador.exe %1
)

:: Limpiar archivos temporales
del compilador.exe
del lex.yy.c
del y.tab.c
del y.tab.h
del src\lexico\lex.yy.c
del src\sintactico\y.tab.c
del src\sintactico\y.tab.h
del src\sintactico\y.output