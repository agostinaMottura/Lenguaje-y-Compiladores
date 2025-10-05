// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "./src/tabla-simbolos/tabla_simbolos.h"
#include "./src/tabla-simbolos/tipo-dato/tipo_dato.h"
#include "./src/tabla-simbolos/valores/valores.h"
#include "./src/sintactico/informes/informes.h"
#include "./src/utils.h"


#define MAX_IDS_DECLARADOS 10
#define MAX_STRING_LONGITUD_ID 55


typedef struct
{
    char cadena[MAX_IDS_DECLARADOS];
} t_nombre_id;

const char* obtener_string_numero_negativo(const char *nro)
{
  static char str[MAX_STRING_LONGITUD_ID];

  strcat(str, "-");
  strcat(str, nro);

  return str;
}

int yystopparser=0;
FILE  *yyin;

int yyerror(const char *s);
int yylex();

// Declaracion variables tabla de simbolos 
int i=0;
int cant_id = 0;

t_nombre_id ids_declarados[MAX_IDS_DECLARADOS];

%}
%union {
    char cadena[55]; // Bison no me deja poner una macro aca :(
}

%type <cadena> CTE_STRING ID CTE_INT CTE_FLOAT

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
  instrucciones {informes_sintactico_imprimir_mensaje("programa", "instrucciones");}
  ;

instrucciones:
  instrucciones sentencia {informes_sintactico_imprimir_mensaje("instrucciones", "instrucciones sentencia");}
  |sentencia {informes_sintactico_imprimir_mensaje("instrucciones", "sentencia");}
  ;

sentencia:  	   
  asignacion {informes_sintactico_imprimir_mensaje("sentencia", "asignacion");}
  | write {informes_sintactico_imprimir_mensaje("sentencia", "write");}
  | read {informes_sintactico_imprimir_mensaje("sentencia", "read");}
  | ciclo {informes_sintactico_imprimir_mensaje("sentencia", "ciclo");}
  | if {informes_sintactico_imprimir_mensaje("sentencia", "if");}
  | declaracion {informes_sintactico_imprimir_mensaje("sentencia", "declaracion");}
  | funcion {informes_sintactico_imprimir_mensaje("sentencia", "funcion");}
  ;

funcion:
  funcion_numerica {informes_sintactico_imprimir_mensaje("funcion", "funcion_numerica");}
  | funcion_booleana {informes_sintactico_imprimir_mensaje("funcion", "funcion_booleana");}
  ;

funcion_numerica:
  triangleAreaMaximum {informes_sintactico_imprimir_mensaje("funcion_numerica", "triangleAreaMaximum");}
  ;

funcion_booleana:
  isZero {informes_sintactico_imprimir_mensaje("funcion_booleana", "isZero");}
  ;

isZero:
  IS_ZERO PARENTESIS_A expresion PARENTESIS_C {informes_sintactico_imprimir_mensaje("isZero", "IS_ZERO PARENTESIS_A expresion PARENTESIS_C");}
  ;

triangleAreaMaximum:
  TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C {informes_sintactico_imprimir_mensaje("triangleAreaMaximum", "TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C");}
  ;
  
triangulo:
  CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C {informes_sintactico_imprimir_mensaje("triangulo", "CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C");}
  ;

coordenada:
  expresion COMA expresion {informes_sintactico_imprimir_mensaje("coordenada", "expresion COMA expresion");}
  ;

declaracion:
  INIT LLAVES_A lista_declaraciones LLAVES_C {informes_sintactico_imprimir_mensaje("declaracion", "INIT LLAVES_A lista_declaraciones LLAVES_C");}
  ;

lista_declaraciones:
  declaracion_var {informes_sintactico_imprimir_mensaje("lista_declaraciones", "declaracion_var");}
  | lista_declaraciones declaracion_var {informes_sintactico_imprimir_mensaje("lista_declaraciones", "lista_declaraciones declaracion_var");}
  ;

declaracion_var:
  lista_ids DOS_PUNTOS tipo
   {
    informes_sintactico_imprimir_mensaje("declaracion_var", "lista_ids DOS_PUNTOS tipo");
    for(i=0;i<cant_id;i++)
      {
        tabla_simbolos_insertar_dato(ids_declarados[i].cadena, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
      }
    cant_id=0;
   }
  ;

lista_ids:
  ID {
    informes_sintactico_imprimir_mensaje("lista_ids", "ID");
    strcpy(ids_declarados[cant_id].cadena, $1);
    cant_id++;
  }
  | lista_ids COMA ID {
    informes_sintactico_imprimir_mensaje("lista_ids", "lista_ids COMA ID");
    strcpy(ids_declarados[cant_id].cadena, $3);
    cant_id++;
  }
  ;

tipo:
  FLOAT {
    informes_sintactico_imprimir_mensaje("tipo", "FLOAT");
  }
  | INT {
    informes_sintactico_imprimir_mensaje("tipo", "INT");
  }
  | STRING {
    informes_sintactico_imprimir_mensaje("tipo", "STRING");
  }
  ;

asignacion: 
  ID ASIGNACION expresion {
    informes_sintactico_imprimir_mensaje("asignacion", "ID ASIGNACION expresion");
    tabla_simbolos_insertar_dato($1, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
  }
  ;

write:
  WRITE PARENTESIS_A expresion PARENTESIS_C {informes_sintactico_imprimir_mensaje("write", "WRITE PARENTESIS_A expresion PARENTESIS_C");}
  ;

read:
  READ PARENTESIS_A ID PARENTESIS_C {
    informes_sintactico_imprimir_mensaje("read", "READ PARENTESIS_A ID PARENTESIS_C");
    tabla_simbolos_insertar_dato($3, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
  }
  ;

ciclo:
  WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C {informes_sintactico_imprimir_mensaje("ciclo", "WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");}
  ;

if:
  bloque_if {informes_sintactico_imprimir_mensaje("if", "bloque_if");}
  | bloque_if else {informes_sintactico_imprimir_mensaje("if", "bloque_if else");}
  ;

bloque_if:
  IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C {informes_sintactico_imprimir_mensaje("bloque_if", "IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");}
  ;

else:
   ELSE bloque_if {informes_sintactico_imprimir_mensaje("else", "ELSE bloque_if");}
  | ELSE LLAVES_A instrucciones LLAVES_C {informes_sintactico_imprimir_mensaje("else", "ELSE LLAVES_A instrucciones LLAVES_C");}
  ;

condicional:
  condicion_compuesta {informes_sintactico_imprimir_mensaje("condicional", "condicion_compuesta");}
  ;

condicion_compuesta:
  condicion_unaria {informes_sintactico_imprimir_mensaje("condicion_compuesta", "condicion_unaria");}
  | condicion_compuesta AND condicion_unaria {informes_sintactico_imprimir_mensaje("condicion_compuesta", "condicion_compuesta AND condicion_unaria");}
  | condicion_compuesta OR condicion_unaria {informes_sintactico_imprimir_mensaje("condicion_compuesta", "condicion_compuesta OR condicion_unaria");}
  ;

condicion_unaria:
  NOT condicion_unaria {informes_sintactico_imprimir_mensaje("condicion_unaria", "NOT condicion_unaria");}
  | predicado {informes_sintactico_imprimir_mensaje("condicion_unaria", "predicado");}
  ;

predicado:
  expresion operador_comparacion expresion {informes_sintactico_imprimir_mensaje("predicado", "expresion operador_comparacion expresion");}
  | PARENTESIS_A condicional PARENTESIS_C {informes_sintactico_imprimir_mensaje("predicado", "PARENTESIS_A condicional PARENTESIS_C");}
  | funcion_booleana {informes_sintactico_imprimir_mensaje("predicado", "funcion_booleana");}
  ;

operador_comparacion:
  MAYOR {informes_sintactico_imprimir_mensaje("operador_comparacion", "MAYOR");}
  | MAYOR_IGUAL {informes_sintactico_imprimir_mensaje("operador_comparacion", "MAYOR_IGUAL");}
  | MENOR_IGUAL {informes_sintactico_imprimir_mensaje("operador_comparacion", "MENOR_IGUAL");}
  | MENOR {informes_sintactico_imprimir_mensaje("operador_comparacion", "MENOR");}
  | IGUAL {informes_sintactico_imprimir_mensaje("operador_comparacion", "IGUAL");}
  | DISTINTO {informes_sintactico_imprimir_mensaje("operador_comparacion", "DISTINTO");}
;

expresion:
  expresion SUMA termino {informes_sintactico_imprimir_mensaje("expresion", "expresion SUMA termino");}
  |expresion RESTA termino {informes_sintactico_imprimir_mensaje("expresion", "expresion RESTA termino");}
  |termino {informes_sintactico_imprimir_mensaje("expresion", "termino");}
  ;

termino: 
  termino MULTIPLICACION factor {informes_sintactico_imprimir_mensaje("termino", "termino MULTIPLICACION factor");}
  |termino DIVISION factor {informes_sintactico_imprimir_mensaje("termino", "termino DIVISION factor");}
  |factor {informes_sintactico_imprimir_mensaje("termino", "factor");}
  ;

factor: 
  ID {
    informes_sintactico_imprimir_mensaje("factor", "ID");
    tabla_simbolos_insertar_dato($1, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
  }
  | CTE_INT 
      {
        informes_sintactico_imprimir_mensaje("factor", "CTE_INT");
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_INT, $1);
      }
  | CTE_FLOAT 
      {
        informes_sintactico_imprimir_mensaje("factor", "CTE_FLOAT");
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_FLOAT, $1);
      }
  | RESTA CTE_INT
      {
        informes_sintactico_imprimir_mensaje("factor", "RESTA CTE_INT");

        const char* nro_negativo = obtener_string_numero_negativo($2); 

        tabla_simbolos_insertar_dato(nro_negativo, TIPO_DATO_CTE_INT, nro_negativo);
      }
  | RESTA CTE_FLOAT
      {
        informes_sintactico_imprimir_mensaje("factor", "RESTA CTE_FLOAT");

        const char* nro_negativo = obtener_string_numero_negativo($2); 

        tabla_simbolos_insertar_dato(nro_negativo, TIPO_DATO_CTE_FLOAT, nro_negativo);
      }
  | RESTA ID
      {
        informes_sintactico_imprimir_mensaje("factor", "RESTA ID");
        tabla_simbolos_insertar_dato($2, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
      }
  | CTE_STRING 
      {
        informes_sintactico_imprimir_mensaje("factor", "CTE_STRING");
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_STRING, $1);
      }
  | PARENTESIS_A expresion PARENTESIS_C {informes_sintactico_imprimir_mensaje("factor", "PARENTESIS_A expresion PARENTESIS_C");}
  | funcion_numerica {informes_sintactico_imprimir_mensaje("factor", "funcion_numerica");}
  ;

%%

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        char msg[100];
        sprintf(msg, "No se puede abrir el archivo: %s", argv[1]);
        utils_print_error(msg);
        return 1;
    }
    else
    {   
        tabla_simbolos_crear();

        yyparse();        

        tabla_simbolos_guardar();
    }
	fclose(yyin);
    return 0;
}

int yyerror(const char *s)
{
    extern int yylineno;
    extern char *yytext;
    
    informes_sintactico_imprimir_error(yylineno, yytext);
    exit(1);
}