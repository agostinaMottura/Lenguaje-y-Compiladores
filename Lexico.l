%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <errno.h>

#include "y.tab.h"
FILE  *yyin;


/*Definicion para validaciones*/
#define MAX_STRING 50

#define MAX_INT 65535
#define MAX_INT_LENGTH 5
#define MAX_INT_BITS 16

#define MAX_FLOAT_BITS 32
#define COTA_INFERIOR_FLOAT 1.17549e-38f
#define COTA_SUPERIOR_FLOAT 3.40282e+38f


// Definicion de colores ANSI
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
    printf(COLOR_CYAN "[LEXICO]" COLOR_RESET " " COLOR_YELLOW "Token #%d" COLOR_RESET " | " COLOR_WHITE "Linea %d" COLOR_RESET " | " COLOR_GREEN "%s" COLOR_RESET " | " COLOR_NARANJA "Valor: '%s'" COLOR_RESET "\n", 
           token_count, yylineno, type, yytext);
}

int yyerror(const char *s);
void informar_error_lexico(const char *mensaje_error, const char *cadena, const char *aclaracion);

typedef struct {
    int es_valido;
    char mensaje_error[100];
    char aclaracion[100];
} ResultadoValidacion;

ResultadoValidacion es_string_valido(char cadena[]);
ResultadoValidacion es_float_valido(char* cadena);
ResultadoValidacion es_int_valido(char* cadena);

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

{INIT}              {print_lexico("Palabra Reservada Init"); return INIT;}
{FLOAT}             {print_lexico("Palabra Reservada Float"); return FLOAT;}
{INT}               {print_lexico("Palabra Reservada Int"); return INT;}
{STRING}            {print_lexico("Palabra Reservada String"); return STRING;}

{IF}                {print_lexico("Palabra Reservada If"); return IF;}
{ELSE}              {print_lexico("Palabra Reservada Else"); return ELSE;}
{WHILE}             {print_lexico("Palabra Reservada While"); return WHILE;}
{READ}              {print_lexico("Palabra Reservada Read"); return READ;}
{WRITE}             {print_lexico("Palabra Reservada Write"); return WRITE;}

{TRIANGLE_AREA_MAXIMUM} {print_lexico("Funcion especial triangleAreaMaximum"); return TRIANGLE_AREA_MAXIMUM;}
{IS_ZERO}               {print_lexico("Funcion especial isZero"); return IS_ZERO;}

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
{ASIGNACION}		{print_lexico("Operador Asignacion"); return ASIGNACION;}
{MULTIPLICACION}	{print_lexico("Operador Multiplicacion"); return MULTIPLICACION;}
{RESTA}		        {print_lexico("Operador Resta"); return RESTA;}
{DIVISION}		    {print_lexico("Operador Division"); return DIVISION;}

{PARENTESIS_A}		{print_lexico("Parentesis Abierto"); return PARENTESIS_A;}
{PARENTESIS_C}		{print_lexico("Parentesis Cerrado"); return PARENTESIS_C;}

{LLAVES_A}          {print_lexico("Llave Abierta"); return LLAVES_A;}
{LLAVES_C}          {print_lexico("Llave Cerrada"); return LLAVES_C;}

{CORCHETE_A}        {print_lexico("Corchete Abierto"); return CORCHETE_A;}
{CORCHETE_C}        {print_lexico("Corchete Cerrado"); return CORCHETE_C;}

{DOS_PUNTOS}        {print_lexico("Dos Puntos"); return DOS_PUNTOS;}
{COMA}              {print_lexico("Coma"); return COMA;}
{PUNTO_Y_COMA}      {print_lexico("Punto y Coma"); return PUNTO_Y_COMA;}

{CTE_STRING}	{
                    ResultadoValidacion res = es_string_valido(yytext);
                    if (!res.es_valido) {
                        informar_error_lexico(res.mensaje_error, yytext, res.aclaracion);
                        exit(1);
                    }

                    print_lexico("Constante String");
                    strcpy(yylval.cadena, yytext);
                    return CTE_STRING;
                }
{CTE_FLOAT}	    {
                    ResultadoValidacion res = es_float_valido(yytext);
                    if (!res.es_valido) {
                        informar_error_lexico(res.mensaje_error, yytext, res.aclaracion);
                        exit(1);
                    }

                    print_lexico("Constante Float");
                    yylval.flotante = atof(yytext);
                    return CTE_FLOAT;
                }    	
{CTE_INT}	    {
                    ResultadoValidacion res = es_int_valido(yytext);
                    if (!res.es_valido) {
                        informar_error_lexico(res.mensaje_error, yytext, res.aclaracion);
                        exit(1);
                    }

                    print_lexico("Constante Int");
                    yylval.entero = atoi(yytext);
                    return CTE_INT;
                } 

{ID}			{
                    print_lexico("Identificador"); 
                    strcpy(yylval.cadena, yytext);
                    return ID;
                }

{INVALIDO}  { 
                informar_error_lexico(
                    "Caracter desconocido", 
                    yytext, 
                    "Caracter no permitido en el lenguaje"
                );
                exit(1);
            }

%%

/* Funciones para validar los tipos de datos */

ResultadoValidacion es_string_valido(char cadena[])
{
    ResultadoValidacion resultado;
    int largo = strlen(cadena);

    if(largo > MAX_STRING)
    {
        resultado.es_valido = 0;
        sprintf(resultado.aclaracion, "Se permite un maximo de %d caracteres", MAX_STRING);
        sprintf(resultado.mensaje_error, "Cadena de texto supera el maximo de caracteres permitido");
        return resultado;
    }

    resultado.es_valido = 1;
    return resultado;
}

ResultadoValidacion es_float_valido(char* cadena) {
    ResultadoValidacion resultado;
    char* endptr;
    errno = 0;
    double numero = strtod(cadena, &endptr); // strtod convierte la cadena a double y deja en endptr un puntero al primer carácter que no pudo convertir.

    if (*endptr != '\0') {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Formato de float invalido");
        sprintf(resultado.aclaracion, "Debe ser un numero decimal");
        return resultado;
    }

    float numero_float = (float)numero;

    if (numero_float < COTA_INFERIOR_FLOAT || numero_float > COTA_SUPERIOR_FLOAT) {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Float fuera de rango");
        sprintf(resultado.aclaracion, "Floats validos entre %.5e y %.5e", COTA_INFERIOR_FLOAT, COTA_SUPERIOR_FLOAT);
        return resultado;
    }

    if (errno == ERANGE) {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Float fuera de rango");
        sprintf(resultado.aclaracion, "Floats validos hasta %d bits", MAX_FLOAT_BITS);
        return resultado;
    }

    if (isnan(numero_float)) {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Float no es un numero (NaN)");
        sprintf(resultado.aclaracion, "Debe ser un numero decimal valido");
        return resultado;
    }

    resultado.es_valido = 1;
    return resultado;
}

ResultadoValidacion es_int_valido(char* cadena)
{
    ResultadoValidacion resultado;
    int longitud = strlen(cadena);
    if (longitud > MAX_INT_LENGTH) {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Entero supera la longitud maxima permitida");
        sprintf(resultado.aclaracion, "Maximo %d caracteres", MAX_INT_LENGTH);
        return resultado;
    }
    
    long numero_long = atol(cadena);
    if(numero_long > MAX_INT) {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Entero fuera de rango");
        sprintf(resultado.aclaracion, "Enteros validos hasta %d", MAX_INT);
        return resultado;
    }

    resultado.es_valido = 1;
    return resultado;
}


void informar_error_lexico(const char *mensaje_error, const char *cadena, const char *aclaracion)
{
    printf("\n");
    printf(COLOR_RED "[ERROR LEXICO] ===============================================================" COLOR_RESET "\n");
    printf(COLOR_RED "[ERROR LEXICO] Linea: %d" COLOR_RESET "\n", yylineno);
    printf(COLOR_RED "[ERROR LEXICO] %s: %s" COLOR_RESET "\n",mensaje_error, cadena);
    printf(COLOR_RED "[ERROR LEXICO] Aclaracion: %s" COLOR_RESET "\n",aclaracion);
    printf(COLOR_RED "[ERROR LEXICO] ===============================================================" COLOR_RESET "\n");
}