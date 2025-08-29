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
%token FOR
%token READ
%token WRITE
%token INIT

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

%token GUION_BAJO

%token PUNTO

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
  sentencia {print_sintactico("Instrucciones con una sentencia");}
  | instrucciones sentencia {print_sintactico("Instrucciones extendidas con nueva sentencia");}
  ;

sentencia:  	   
  asignacion {print_sintactico("Sentencia de asignación completada");}
  | write {print_sintactico("Sentencia de write completada");}
  | read {print_sintactico("Sentencia de read completada");}
  | ciclo {print_sintactico("Sentencia de ciclo completada");}
  | condicional {print_sintactico("Sentencia de condicional completada");}
  | declaracion {print_sintactico("Sentencia de declaracion completada");}
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
  READ PARENTESIS_A ID PARENTESIS_C PUNTO_Y_COMA {print_sintactico("READ(ID); es READ");}
  ;

ciclo:
  WHILE PARENTESIS_A condicion PARENTESIS_C LLAVES_A instrucciones LLAVES_C {print_sintactico("While es ciclo");}

condicional:
  IF PARENTESIS_A condicion PARENTESIS_C LLAVES_A instrucciones LLAVES_C {print_sintactico("If es condicional");}
  | IF PARENTESIS_A condicion PARENTESIS_C LLAVES_A instrucciones LLAVES_C ELSE LLAVES_A instrucciones LLAVES_C {print_sintactico("If-Else es condicional");}
  ;

condicion:
  termino MAYOR termino {print_sintactico("Termino>Termino es Condicion");}
  |termino MENOR termino {print_sintactico("Termino<Termino es Condicion");}
  |termino MAYOR_IGUAL termino {print_sintactico("Termino>=Termino es Condicion");}
  |termino MENOR_IGUAL termino {print_sintactico("Termino<=Termino es Condicion");}
  |termino IGUAL termino {print_sintactico("Termino==Termino es Condicion");}
  |termino DISTINTO termino {print_sintactico("Termino!=Termino es Condicion");}
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
  | PARENTESIS_A expresion PARENTESIS_C {print_sintactico("Expresion entre parentesis es Factor");}
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

