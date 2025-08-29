// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

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

void print_sintactico(const char* message) {
    printf(COLOR_MAGENTA "[SINTACTICO]" COLOR_RESET COLOR_WHITE " %s" COLOR_RESET "\n", message);
}

int yystopparser=0;
FILE  *yyin;

  int yyerror(const char *s);
  int yylex();

%}

/* Palabras reservadas */
%token IF
%token ELSE
%token WHILE
%token FOR
%token READ
%token WRITE

/*Operadores logicos*/
%token AND
%token OR
%token NOT

/* Comparadores */
%token MAYOR
%token MENOR
%token MAYOR_IGUAL
%token MENOR_IGUAL
%token IGUAL
%token DISTINTO

/* Operadores */
%token ASIGNACION
%token SUMA
%token MULTIPLICACION
%token RESTA
%token DIVISION

/* Simbolos importantes */
%token PARENTESIS_A
%token PARENTESIS_C

%token LLAVES_A
%token LLAVES_C

%token CORCHETE_A
%token CORCHETE_C

%token PUNTO_Y_COMA

%token GUION_BAJO

/* Constantes */
%token CTE_ENTERA
%token CTE_STRING

/* Identificador */
%token ID


%%
programa:
  sentencia {print_sintactico("Programa completado");} ;
  | programa sentencia {print_sintactico("Programa extendido con nueva sentencia");} 
  ;

sentencia:  	   
	asignacion {print_sintactico("Sentencia de asignación completada");} ;

asignacion: 
  ID ASIGNACION expresion {print_sintactico("ID = Expresion es ASIGNACION");}
  ;

expresion:
  termino {print_sintactico("Termino es Expresion");}
  |expresion SUMA termino {print_sintactico("Expresion+Termino es Expresion");}
  |expresion RESTA termino {print_sintactico("Expresion-Termino es Expresion");}
  |CTE_STRING {print_sintactico("CTE_STRING es Expresion");}
  ;

termino: 
  factor {print_sintactico("Factor es Termino");}
  |termino MULTIPLICACION factor {print_sintactico("Termino*Factor es Termino");}
  |termino DIVISION factor {print_sintactico("Termino/Factor es Termino");}
  ;

factor: 
  ID {print_sintactico("ID es Factor");}
  | CTE_ENTERA {print_sintactico("CTE_ENTERA es Factor");}
  | PARENTESIS_A expresion PARENTESIS_C {print_sintactico("Expresion entre parentesis es Factor");}
  ;
%%


int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf(COLOR_RED "[ERROR] No se puede abrir el archivo de prueba: %s" COLOR_RESET "\n", argv[1]);
        return 1;
    }
    else
    {   
        yyparse();        
    }
	fclose(yyin);
    return 0;
}

int yyerror(const char *s)
{
    extern int yylineno;
    extern char *yytext;
    
    printf("\n");
    printf(COLOR_RED "[ERROR SINTACTICO] ================================================" COLOR_RESET "\n");
    printf(COLOR_RED "[ERROR SINTACTICO] Línea: %d" COLOR_RESET "\n", yylineno);
    printf(COLOR_RED "[ERROR SINTACTICO] Token inesperado: '%s'" COLOR_RESET "\n", yytext ? yytext : "EOF");
    printf(COLOR_RED "[ERROR SINTACTICO] ================================================" COLOR_RESET "\n");
    exit(1);
}

