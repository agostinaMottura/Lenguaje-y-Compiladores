// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "./src/tabla-simbolos/tabla_simbolos.h"

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

void print_sintactico(const char* message) {
    printf(COLOR_MAGENTA "[SINTACTICO]" COLOR_RESET COLOR_WHITE " %s" COLOR_RESET "\n", message);
}

int yystopparser=0;
FILE  *yyin;

  int yyerror(const char *s);
  int yylex();

// Declaracion variables tabla de simbolos 
int i=0;
char tipo_dato[10];
int cant_id = 0;
char nombre_id[55];
int constante_aux_int;
float constante_aux_float;
char constante_aux_string[55];
char aux_string[55];
t_nombresId t_ids[10];

%}

%union {
    int entero;
    float flotante;
    char cadena[100];
}

%type <cadena> CTE_STRING ID
%type <entero> CTE_INT
%type <flotante> CTE_FLOAT

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
  instrucciones {print_sintactico("programa -> instrucciones");}
  ;

instrucciones:
  instrucciones sentencia {print_sintactico("instrucciones -> instrucciones sentencia");}
  |sentencia {print_sintactico("instrucciones -> sentencia");}
  ;

sentencia:  	   
  asignacion {print_sintactico("sentencia -> asignacion");}
  | write {print_sintactico("sentencia -> write");}
  | read {print_sintactico("sentencia -> read");}
  | ciclo {print_sintactico("sentencia -> ciclo");}
  | if {print_sintactico("sentencia -> if");}
  | declaracion {print_sintactico("sentencia -> declaracion");}
  | funcion {print_sintactico("sentencia -> funcion");}
  ;

funcion:
  funcion_numerica {print_sintactico("funcion -> funcion_numerica");}
  | funcion_booleana {print_sintactico("funcion -> funcion_booleana");}
  ;

funcion_numerica:
  triangleAreaMaximum {print_sintactico("funcion_numerica -> triangleAreaMaximum");}
  ;

funcion_booleana:
  isZero {print_sintactico("funcion_booleana -> isZero");}
  ;

isZero:
  IS_ZERO PARENTESIS_A expresion PARENTESIS_C {print_sintactico("isZero -> IS_ZERO PARENTESIS_A expresion PARENTESIS_C");}
  ;

triangleAreaMaximum:
  TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C {print_sintactico("triangleAreaMaximum -> TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C");}
  ;
  
triangulo:
  CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C {print_sintactico("triangulo -> CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C");}
  ;

coordenada:
  expresion COMA expresion {print_sintactico("coordenada -> expresion COMA expresion");}
  ;

declaracion:
  INIT LLAVES_A lista_declaraciones LLAVES_C {print_sintactico("declaracion -> INIT LLAVES_A lista_declaraciones LLAVES_C");}
  ;

lista_declaraciones:
  declaracion_var {print_sintactico("lista_declaraciones -> declaracion_var");}
  | lista_declaraciones declaracion_var {print_sintactico("lista_declaraciones -> lista_declaraciones declaracion_var");}
  ;

declaracion_var:
  lista_ids DOS_PUNTOS tipo
   {
    print_sintactico("declaracion_var -> lista_ids DOS_PUNTOS tipo");
    for(i=0;i<cant_id;i++)
      {
        insertar_tabla_simbolos(t_ids[i].cadena, tipo_dato, "", 0, 0);
      }
    cant_id=0;
   }
  ;

lista_ids:
  ID {
    print_sintactico("lista_ids -> ID");
    strcpy(t_ids[cant_id].cadena, $1);
    cant_id++;
  }
  | lista_ids COMA ID {
    print_sintactico("lista_ids -> lista_ids COMA ID");
    strcpy(t_ids[cant_id].cadena, $3);
    cant_id++;
  }
  ;

tipo:
  FLOAT {
    print_sintactico("tipo -> FLOAT");
    strcpy(tipo_dato, "FLOAT");
  }
  | INT {
    print_sintactico("tipo -> INT");
    strcpy(tipo_dato, "INT");
  }
  | STRING {
    print_sintactico("tipo -> STRING");
    strcpy(tipo_dato, "STRING");
  }
  ;

asignacion: 
  ID ASIGNACION expresion {
    print_sintactico("asignacion -> ID ASIGNACION expresion");
    insertar_tabla_simbolos($1, "ID", "", 0, 0.0);
  }
  ;

write:
  WRITE PARENTESIS_A expresion PARENTESIS_C {print_sintactico("write -> WRITE PARENTESIS_A expresion PARENTESIS_C");}
  ;

read:
  READ PARENTESIS_A ID PARENTESIS_C {
    print_sintactico("read -> READ PARENTESIS_A ID PARENTESIS_C");
    insertar_tabla_simbolos($3, "ID", "", 0, 0.0);
  }
  ;

ciclo:
  WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C {print_sintactico("ciclo -> WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");}
  ;

if:
  bloque_if {print_sintactico("if -> bloque_if");}
  | bloque_if else {print_sintactico("if -> bloque_if else");}
  ;

bloque_if:
  IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C {print_sintactico("bloque_if -> IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");}
  ;

else:
   ELSE bloque_if {print_sintactico("else -> ELSE bloque_if");}
  | ELSE LLAVES_A instrucciones LLAVES_C {print_sintactico("else -> ELSE LLAVES_A instrucciones LLAVES_C");}
  ;

condicional:
  condicion_compuesta {print_sintactico("condicional -> condicion_compuesta");}
  ;

condicion_compuesta:
  condicion_unaria {print_sintactico("condicion_compuesta -> condicion_unaria");}
  | condicion_compuesta AND condicion_unaria {print_sintactico("condicion_compuesta -> condicion_compuesta AND condicion_unaria");}
  | condicion_compuesta OR condicion_unaria {print_sintactico("condicion_compuesta -> condicion_compuesta OR condicion_unaria");}
  ;

condicion_unaria:
  NOT condicion_unaria {print_sintactico("condicion_unaria -> NOT condicion_unaria");}
  | predicado {print_sintactico("condicion_unaria -> predicado");}
  ;

predicado:
  expresion operador_comparacion expresion {print_sintactico("predicado -> expresion operador_comparacion expresion");}
  | PARENTESIS_A condicional PARENTESIS_C {print_sintactico("predicado -> PARENTESIS_A condicional PARENTESIS_C");}
  | funcion_booleana {print_sintactico("predicado -> funcion_booleana");}
  ;

operador_comparacion:
  MAYOR {print_sintactico("operador_comparacion -> MAYOR");}
  | MAYOR_IGUAL {print_sintactico("operador_comparacion -> MAYOR_IGUAL");}
  | MENOR_IGUAL {print_sintactico("operador_comparacion -> MENOR_IGUAL");}
  | MENOR {print_sintactico("operador_comparacion -> MENOR");}
  | IGUAL {print_sintactico("operador_comparacion -> IGUAL");}
  | DISTINTO {print_sintactico("operador_comparacion -> DISTINTO");}
;

expresion:
  expresion SUMA termino {print_sintactico("expresion -> expresion SUMA termino");}
  |expresion RESTA termino {print_sintactico("expresion -> expresion RESTA termino");}
  |termino {print_sintactico("expresion -> termino");}
  ;

termino: 
  termino MULTIPLICACION factor {print_sintactico("termino -> termino MULTIPLICACION factor");}
  |termino DIVISION factor {print_sintactico("termino -> termino DIVISION factor");}
  |factor {print_sintactico("termino -> factor");}
  ;

factor: 
  ID {
    print_sintactico("factor -> ID");
    insertar_tabla_simbolos($1, "ID", "", 0, 0.0);
  }
  | CTE_INT 
      {
        print_sintactico("factor -> CTE_INT");
        constante_aux_int=$1;
        sprintf(nombre_id, "%d", constante_aux_int);
        insertar_tabla_simbolos(nombre_id, "CTE_INT", "", $1, 0.0);
      }
  | CTE_FLOAT 
      {
        print_sintactico("factor -> CTE_FLOAT");
        constante_aux_float=$1;
        sprintf(nombre_id, "%f", $1); 
        insertar_tabla_simbolos(nombre_id, "CTE_FLOAT", "", 0, $1);
      }
  | RESTA CTE_INT
      {
        print_sintactico("factor -> RESTA CTE_INT");

        constante_aux_int=$2;
        int cteneg = constante_aux_int * (-1);
        sprintf(nombre_id, "%d", cteneg);
        
        insertar_tabla_simbolos(nombre_id, "CTE_INT", "", cteneg, 0.0);
      }
  | RESTA CTE_FLOAT
      {
        constante_aux_float=$2;
        float cteneg = constante_aux_float * (-1);
        sprintf(nombre_id, "%f", cteneg);  
        print_sintactico("factor -> RESTA CTE_FLOAT");
      
        insertar_tabla_simbolos(nombre_id, "CTE_FLOAT", "", 0, cteneg);
      }
  | RESTA ID
      {
        print_sintactico("factor -> RESTA ID");
        insertar_tabla_simbolos($2, "ID", "", 0, 0.0);
      }
  | CTE_STRING 
      {
        print_sintactico("factor -> CTE_STRING");
        strcpy(constante_aux_string, $1);
        insertar_tabla_simbolos($1, "CTE_STRING", $1, 0, 0.0);
      }
  | PARENTESIS_A expresion PARENTESIS_C {print_sintactico("factor -> PARENTESIS_A expresion PARENTESIS_C");}
  | funcion_numerica {print_sintactico("factor -> funcion_numerica");}
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
        crear_tabla_simbolos();

        yyparse();        

        guardar_tabla_simbolos();
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
    printf(COLOR_RED "[ERROR SINTACTICO] Linea: %d" COLOR_RESET "\n", yylineno);
    printf(COLOR_RED "[ERROR SINTACTICO] Token inesperado: '%s'" COLOR_RESET "\n", yytext ? yytext : "EOF");
    printf(COLOR_RED "[ERROR SINTACTICO] ================================================" COLOR_RESET "\n");
    exit(1);
}