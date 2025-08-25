%{
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
FILE  *yyin;
int yylval;
char *yyltext;

// Definición de colores ANSI
#define COLOR_RESET   "\033[0m"
#define COLOR_RED     "\033[31m"
#define COLOR_GREEN   "\033[32m"
#define COLOR_YELLOW  "\033[33m"
#define COLOR_BLUE    "\033[34m"
#define COLOR_MAGENTA "\033[35m"
#define COLOR_CYAN    "\033[36m"
#define COLOR_WHITE   "\033[37m"
#define COLOR_BOLD    "\033[1m"
#define COLOR_NARANJA  "\x1B[38;2;255;128;0m"

// Contador de tokens para mejor seguimiento
static int token_count = 0;

void print_lexico(const char* type) {
    token_count++;
    printf(COLOR_CYAN "[LEXICO]" COLOR_RESET " " COLOR_YELLOW "Token #%d" COLOR_RESET " | " COLOR_WHITE "Línea %d" COLOR_RESET " | " COLOR_GREEN "%s" COLOR_RESET " | " COLOR_NARANJA "Valor: '%s'" COLOR_RESET "\n", 
           token_count, yylineno, type, yytext);
}

int yyerror(void);

%}

%option noyywrap  
/* Obtener el numero de linea */
%option yylineno 

/* Palabras reservadas */
IF		        "if"|"IF"
ELSE		    "else"|"ELSE"
WHILE		    "while"|"WHILE"
FOR		        "for"|"FOR"
READ            "read"|"READ"
WRITE           "write"|"WRITE"

/*Operadores logicos*/
AND             "AND"
OR              "OR"
NOT             "NOT"

/* Comparadores */
MAYOR		    ">"
MENOR		    "<"
MAYOR_IGUAL	    ">="
MENOR_IGUAL	    "<="
IGUAL		    "=="
DISTINTO		"!="

/* Operadores */
ASIGNACION   		"="
SUMA		        "+"
MULTIPLICACION      "*"
RESTA		        "-"
DIVISION            "/"

/* Simbolos importantes */
PARENTESIS_A		"("
PARENTESIS_C		")"

LLAVES_A            "{"
LLAVES_C            "}"

COMENTARIO_SIMPLE   "//".* 
COMENTARIO_MULTIPLE "/*"([^*]|\*+[^*/])*\*+"/"

CORCHETE_A          "["
CORCHETE_C          "]"

PUNTO_Y_COMA        ";"


/* Reutilizables */
DIGITO			    [0-9]
LETRA			    [a-zA-Z]
GUION_BAJO          "_"

/* Constantes */
CTE_ENTERA		    {DIGITO}+
CTE_STRING		    \"[^"\n]*\"

/* Identificador */
ID			        ({LETRA}|{GUION_BAJO})({LETRA}|{DIGITO})*

UNKNOWN             "\n"|"\t"|"\n\t"|" "|"\r\n"|.

%%
{IF}                {print_lexico("Palabra Reservada If"); return IF;}
{ELSE}              {print_lexico("Palabra Reservada Else"); return ELSE;}
{WHILE}             {print_lexico("Palabra Reservada While"); return WHILE;}
{FOR}               {print_lexico("Palabra Reservada For"); return FOR;}
{READ}              {print_lexico("Palabra Reservada Read"); return READ;}
{WRITE}             {print_lexico("Palabra Reservada Write"); return WRITE;}

{AND}               {print_lexico("Operador And"); return AND;}
{OR}                {print_lexico("Operador Or"); return OR;}
{NOT}               {print_lexico("Operador Not"); return NOT;}

{MAYOR}             {print_lexico("Operador Mayor"); return MAYOR;}
{MENOR}             {print_lexico("Operador Menor"); return MENOR;}
{MAYOR_IGUAL}       {print_lexico("Operador Mayor Igual"); return MAYOR_IGUAL;}
{MENOR_IGUAL}       {print_lexico("Operador Menor Igual"); return MENOR_IGUAL;}
{IGUAL}             {print_lexico("Operador Igual"); return IGUAL;}
{DISTINTO}          {print_lexico("Operador Distinto"); return DISTINTO;}

{SUMA}		        {print_lexico("Operador Suma"); return SUMA;}
{ASIGNACION}		{print_lexico("Operador Asignación"); return ASIGNACION;}
{MULTIPLICACION}	{print_lexico("Operador Multiplicación"); return MULTIPLICACION;}
{RESTA}		        {print_lexico("Operador Resta"); return RESTA;}
{DIVISION}		    {print_lexico("Operador División"); return DIVISION;}

{PARENTESIS_A}		{print_lexico("Paréntesis Abierto"); return PARENTESIS_A;}
{PARENTESIS_C}		{print_lexico("Paréntesis Cerrado"); return PARENTESIS_C;}

{LLAVES_A}          {print_lexico("Llave Abierta"); return LLAVES_A;}
{LLAVES_C}          {print_lexico("Llave Cerrada"); return LLAVES_C;}

{CORCHETE_A}        {print_lexico("Corchete Abierto"); return CORCHETE_A;}
{CORCHETE_C}        {print_lexico("Corchete Cerrado"); return CORCHETE_C;}

{PUNTO_Y_COMA}      {print_lexico("Punto y Coma"); return PUNTO_Y_COMA;}

{CTE_ENTERA}		{print_lexico("Constante Entera"); return CTE_ENTERA;}
{CTE_STRING}		{print_lexico("Constante String"); return CTE_STRING;}

{ID}			    {print_lexico("Identificador"); return ID;}

{COMENTARIO_SIMPLE}  {}
{COMENTARIO_MULTIPLE} {}
{UNKNOWN} { }
