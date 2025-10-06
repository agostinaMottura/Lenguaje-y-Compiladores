%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <errno.h>
#include "y.tab.h"
#include "./src/lexico/validaciones/validaciones.h"
#include "./src/lexico/informes/informes.h"
#include "./src/utils.h"

FILE  *yyin;

// Contador de tokens para mejor seguimiento
static int nro_token = 0;

void procesar_token(const char* terminal) {
    nro_token++;
    informes_lexico_imprimir_mensaje(nro_token, yylineno, terminal, yytext);
}

int yyerror(const char *s);

%}

%option noyywrap  
/* Obtener el numero de linea */
%option yylineno 


/* Palabras reservadas */
IF		        "if"
ELSE		    "else"
WHILE		    "while"
READ            "read"
WRITE           "write"
INIT            "init"
FLOAT           "float"
INT             "int"
STRING          "string"

/* Temas especiales */
IS_ZERO                 "isZero"  
TRIANGLE_AREA_MAXIMUM   "triangleAreaMaximum"

/*Operadores logicos*/
AND             "and"
OR              "or"
NOT             "not"

/* Comparadores */
MAYOR		    ">"
MENOR		    "<"
MAYOR_IGUAL	    ">="
MENOR_IGUAL	    "<="
IGUAL		    "=="
DISTINTO		"!="

/* Operadores */
ASIGNACION   		":="
SUMA		        "+"
MULTIPLICACION      "*"
RESTA		        "-"
DIVISION            "/"

/* Simbolos importantes */
PARENTESIS_A		"("
PARENTESIS_C		")"

LLAVES_A            "{"
LLAVES_C            "}"

CORCHETE_A          "["
CORCHETE_C          "]"

GUION_BAJO          "_"
PUNTO_Y_COMA        ";"
PUNTO               "."
DOS_PUNTOS          ":"
COMA                ","

/* Reutilizables */
DIGITO			    [0-9]
LETRA			    [a-zA-Z]

INVALIDO        "~"|"`"|"^"|"¨"|"´"|"¬"

/* Constantes */
CTE_INT		        {DIGITO}+
CTE_FLOAT         ({DIGITO}+{PUNTO}{DIGITO}+)|({DIGITO}+{PUNTO}{DIGITO}+[eE][+-]?{DIGITO}+)|({DIGITO}+[eE][+-]?{DIGITO}+)
CTE_STRING		  \"[^"~`^¨´¬]*\"

/* Identificador */
ID			        ({LETRA}|{GUION_BAJO})({LETRA}|{DIGITO}|{GUION_BAJO})*

ESPACIOS         "\n"|"\t"|"\n\t"|" "|"\r\n"

/* Comentarios */
COMENTARIO \#\+.*\+\#

%%
{COMENTARIO}       {}

{ESPACIOS}       {}

{INIT}              {procesar_token("INIT"); return INIT;}
{FLOAT}             {procesar_token("FLOAT"); return FLOAT;}
{INT}               {procesar_token("INT"); return INT;}
{STRING}            {procesar_token("STRING"); return STRING;}

{IF}                {procesar_token("IF"); return IF;}
{ELSE}              {procesar_token("ELSE"); return ELSE;}
{WHILE}             {procesar_token("WHILE"); return WHILE;}
{READ}              {procesar_token("READ"); return READ;}
{WRITE}             {procesar_token("WRITE"); return WRITE;}

{TRIANGLE_AREA_MAXIMUM} {procesar_token("TRIANGLE_AREA_MAXIMUM"); return TRIANGLE_AREA_MAXIMUM;}
{IS_ZERO}               {procesar_token("IS_ZERO"); return IS_ZERO;}

{AND}               {procesar_token("AND"); return AND;}
{OR}                {procesar_token("OR"); return OR;}
{NOT}               {procesar_token("NOT"); return NOT;}

{MAYOR}             {procesar_token("MAYOR"); return MAYOR;}
{MENOR}             {procesar_token("MENOR"); return MENOR;}
{MAYOR_IGUAL}       {procesar_token("MAYOR_IGUAL"); return MAYOR_IGUAL;}
{MENOR_IGUAL}       {procesar_token("MENOR_IGUAL"); return MENOR_IGUAL;}
{IGUAL}             {procesar_token("IGUAL"); return IGUAL;}
{DISTINTO}          {procesar_token("DISTINTO"); return DISTINTO;}

{SUMA}		        {procesar_token("SUMA"); return SUMA;}
{ASIGNACION}		{procesar_token("ASIGNACION"); return ASIGNACION;}
{MULTIPLICACION}	{procesar_token("MULTIPLICACION"); return MULTIPLICACION;}
{RESTA}		        {procesar_token("RESTA"); return RESTA;}
{DIVISION}		    {procesar_token("DIVISION"); return DIVISION;}

{PARENTESIS_A}		{procesar_token("PARENTESIS_A"); return PARENTESIS_A;}
{PARENTESIS_C}		{procesar_token("PARENTESIS_C"); return PARENTESIS_C;}

{LLAVES_A}          {procesar_token("LLAVES_A"); return LLAVES_A;}
{LLAVES_C}          {procesar_token("LLAVES_C"); return LLAVES_C;}

{CORCHETE_A}        {procesar_token("CORCHETE_A"); return CORCHETE_A;}
{CORCHETE_C}        {procesar_token("CORCHETE_C"); return CORCHETE_C;}

{DOS_PUNTOS}        {procesar_token("DOS_PUNTOS"); return DOS_PUNTOS;}
{COMA}              {procesar_token("COMA"); return COMA;}
{PUNTO_Y_COMA}      {procesar_token("PUNTO_Y_COMA"); return PUNTO_Y_COMA;}

{CTE_STRING}	{
                    t_validaciones_lexico_resultado_validacion res = validaciones_lexico_es_string_valido(yytext);
                    if (!res.es_valido) {
                        informes_lexico_imprimir_error(res.mensaje_error, yytext, res.aclaracion);
                        exit(1);
                    }

                    procesar_token("CTE_STRING");
                    strcpy(yylval.cadena, utils_obtener_string_sin_comillas(yytext));
                    return CTE_STRING;
                }
{CTE_FLOAT}	    {
                    t_validaciones_lexico_resultado_validacion res = validaciones_lexico_es_float_valido(yytext);
                    if (!res.es_valido) {
                        informes_lexico_imprimir_error(res.mensaje_error, yytext, res.aclaracion);
                        exit(1);
                    }

                    procesar_token("CTE_FLOAT");
                    strcpy(yylval.cadena, yytext);
                    return CTE_FLOAT;
                }    	
{CTE_INT}	    {
                    t_validaciones_lexico_resultado_validacion res = validaciones_lexico_es_int_valido(yytext);
                    if (!res.es_valido) {
                        informes_lexico_imprimir_error(res.mensaje_error, yytext, res.aclaracion);
                        exit(1);
                    }

                    procesar_token("CTE_INT");
                    strcpy(yylval.cadena, yytext);
                    return CTE_INT;
                } 

{ID}			{
                    procesar_token("ID"); 
                    strcpy(yylval.cadena, yytext);
                    return ID;
                }

{INVALIDO}  { 
                informes_lexico_imprimir_error(
                    "Caracter desconocido", 
                    yytext, 
                    "Caracter no permitido en el lenguaje"
                );
                exit(1);
            }

%%