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

// Variables auxiliares para constantes
int constante_aux_int;
float constante_aux_float;

%}

/* Palabras reservadas */
%token IF
%token ELSE
%token WHILE
%token READ
%token WRITE
%token INIT

/* Funciones */
%token IS_ZERO
%token TRIANGLE_AREA_MAXIMUM

/* Tipos de datos */
%token FLOAT
%token INT
%token STRING

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

%token DOS_PUNTOS

%token COMA

/* Constantes */
%token CTE_INT
%token CTE_STRING
%token CTE_FLOAT

/* Identificador */
%token ID

%%
programa:
  instrucciones {print_sintactico("Programa completado");}
  ;

instrucciones:
  instrucciones sentencia {print_sintactico("Instrucciones extendidas con nueva sentencia");}
  |sentencia {print_sintactico("Instrucciones con una sentencia");}
  ;

sentencia:  	   
  asignacion {print_sintactico("Sentencia de asignación completada");}
  | write {print_sintactico("Sentencia de write completada");}
  | read {print_sintactico("Sentencia de read completada");}
  | ciclo {print_sintactico("Sentencia de ciclo completada");}
  | if {print_sintactico("Sentencia de condicional completada");}
  | declaracion {print_sintactico("Sentencia de declaracion completada");}
  | funcion {print_sintactico("Sentencia de funcion completada");}
  ;

funcion:
  funcion_numerica {print_sintactico("Funcion numerica");}
  | funcion_booleana {print_sintactico("Funcion booleana");}
  ;

funcion_numerica:
  triangleAreaMaximum {print_sintactico("Funcion es funcion numerica");}
  ;

funcion_booleana:
  isZero {print_sintactico("Funcion es funcion booleana");}
  ;

isZero:
  IS_ZERO PARENTESIS_A expresion PARENTESIS_C {print_sintactico("Funcion booleana isZero completada");}
  ;

triangleAreaMaximum:
  TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C {print_sintactico("Funcion numerica triangleAreaMaximum completada");}
  ;
  
triangulo:
  CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C {print_sintactico("Coordenadas entre corchetes es triangulo");}
  ;

coordenada: 
  expresion COMA expresion {print_sintactico("Expresion coma Expresion es coordenada");}
  ;

declaracion:
  INIT LLAVES_A lista_declaraciones LLAVES_C {print_sintactico("Bloque de declaraciones completado");}
  ;

lista_declaraciones:
  declaracion_var {print_sintactico("Declaracion de variable");}
  | lista_declaraciones declaracion_var {print_sintactico("Lista de declaraciones extendida");}
  ;

declaracion_var:
  lista_ids DOS_PUNTOS tipo {print_sintactico("Declaracion de variable con tipo");}
  ;

lista_ids:
  ID {print_sintactico("Identificador en lista");}
  | lista_ids COMA ID {print_sintactico("Lista de identificadores extendida");}
  ;

tipo:
  FLOAT {print_sintactico("Tipo float");}
  | INT {print_sintactico("Tipo int");}
  | STRING {print_sintactico("Tipo string");}
  ;

asignacion: 
  ID ASIGNACION expresion {print_sintactico("ID = Expresion es ASIGNACION");}
  ;

write:
  WRITE PARENTESIS_A write_element PARENTESIS_C {print_sintactico("WRITE(Expresion); es WRITE");}
  ;

read:
  READ PARENTESIS_A ID PARENTESIS_C {print_sintactico("READ(ID); es READ");}
  ;

ciclo:
  WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C {print_sintactico("While es ciclo");}
  ;

if:
  bloque_if 
  | bloque_if else
  ;

bloque_if:
  IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C {print_sintactico("If es condicional");}
  ;

else:
   ELSE bloque_if
  | ELSE LLAVES_A instrucciones LLAVES_C {print_sintactico("Else es bloque else");}
  ;

condicional:
  condicion_compuesta {print_sintactico("PA condicion PC es condicional");}
  ;

condicion_compuesta:
  condicion_compuesta AND condicion_unaria {print_sintactico("Condicion AND Condicion es Condicion compuesta");}
  | condicion_compuesta OR condicion_unaria {print_sintactico("Condicion OR Condicion es Condicion compuesta");}
  | condicion_unaria {print_sintactico("Condicion es Condicion compuesta");}
  ;

condicion_unaria:
  NOT condicion_unaria {print_sintactico("NOT condicion es condicion unaria");}
  | predicado {print_sintactico("Predicado es condicion unaria");}
  ;

predicado:
  expresion operador_comparacion expresion {print_sintactico("Expresion==Expresion es Predicado");}
  | PARENTESIS_A condicional PARENTESIS_C {print_sintactico("Parentesis_A Condicional Parentesis_C es Predicado");}
  | funcion_booleana {print_sintactico("Funcion booleana es Predicado");}
  ;

operador_comparacion:
  MAYOR {print_sintactico("Mayor es Operador de comparacion");}
  | MAYOR_IGUAL {print_sintactico("Mayor Igual es Operador de comparacion");}
  | MENOR_IGUAL {print_sintactico("Menor Igual es Operador de comparacion");}
  | MENOR {print_sintactico("Menor es Operador de comparacion");}
  | IGUAL {print_sintactico("Igual es Operador de comparacion");}
  | DISTINTO {print_sintactico("Distinto es Operador de comparacion");}
;

expresion:
  expresion SUMA termino {print_sintactico("Expresion+Termino es Expresion");}
  |expresion RESTA termino {print_sintactico("Expresion-Termino es Expresion");}
  |termino {print_sintactico("Termino es Expresion");}
  ;

termino: 
  termino MULTIPLICACION factor {print_sintactico("Termino*Factor es Termino");}
  |termino DIVISION factor {print_sintactico("Termino/Factor es Termino");}
  |factor {print_sintactico("Factor es Termino");}
  ;

factor: 
  ID {print_sintactico("ID es Factor");}
  | CTE_INT {print_sintactico("CTE_INT es Factor");}
  | CTE_FLOAT {print_sintactico("CTE_FLOAT es Factor");}
  | RESTA CTE_INT
      {
        /* esta Mmuskeherramienta misteriosa nos servirá más adelante para la tabla */
        constante_aux_int=$2;
        int cteneg = constante_aux_int * (-1); 
        print_sintactico("NEG CTE_INT es Factor");
      }
  | RESTA CTE_FLOAT
  {
    constante_aux_float=$2; 
    float cteneg = constante_aux_float * (-1); 
     print_sintactico("NEG CTE_FLOAT es Factor");
  }
  | CTE_STRING {print_sintactico("CTE_STRING es Expresion");}
  | PARENTESIS_A expresion PARENTESIS_C %prec PARENTESIS_C {print_sintactico("Expresion entre parentesis es Factor");}
  | funcion_numerica {print_sintactico("Funcion numerica es factor");}
  ;

write_element:
  ID {print_sintactico("ID es Write_element");}
  | CTE_STRING {print_sintactico("CTE_STRING es Write_element");}
  | CTE_INT {print_sintactico("CTE_INT es Write_element");}
  | CTE_FLOAT {print_sintactico("CTE_FLOAT es Write_element");}
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

