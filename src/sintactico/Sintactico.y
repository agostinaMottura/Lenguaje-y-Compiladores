// Usa Lexico_ClasePractica
//Solo expresiones sin ()
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "./src/validaciones/validaciones.h"
#include "./src/tabla-simbolos/tabla_simbolos.h"
#include "./src/tabla-simbolos/tipo-dato/tipo_dato.h"
#include "./src/valores/valores.h"
#include "./src/sintactico/informes/informes.h"
#include "./src/utils/utils.h"
#include "./src/simbolos/no-terminales/no_terminales.h"
#include "./src/simbolos/no-terminales/punteros/punteros.h"
#include "./src/gci/tercetos/tercetos.h"
#include "./src/pila/pila.h"
#include "./src/cola/cola.h"


int yystopparser=0;
FILE  *yyin;

int yyerror(const char *s);
int yylex();

// Pilas
t_pila *pila_factor;
t_pila *pila_termino;
t_pila *pila_expresion;
t_pila *pila_comparacion;
t_pila *pila_sumar_ultimos;

// Colas
t_cola *cola_tercetos;

// Declaracion variables tabla de simbolos 
int i=0;
int cant_id = 0;
t_gci_tercetos_dato* aux;

t_validaciones_nombre_id ids_declarados[VALIDACIONES_MAX_IDS_DECLARADOS];

%}
%union {
    char cadena[50]; // Bison no me deja poner una macro aca :(
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
  instrucciones 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_PROGRAMA, "instrucciones");
      punteros_simbolos_no_terminales_programa = punteros_simbolos_no_terminales_instrucciones;
    }
  ;

instrucciones:
  instrucciones sentencia {informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_INSTRUCCIONES, "instrucciones sentencia");}
  |sentencia 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_INSTRUCCIONES, "sentencia");
      punteros_simbolos_no_terminales_instrucciones = punteros_simbolos_no_terminales_sentencia;
    }
  ;

sentencia:  	   
  asignacion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "asignacion");
      punteros_simbolos_no_terminales_sentencia = punteros_simbolos_no_terminales_asignacion;
    }
  | write 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "write");
      punteros_simbolos_no_terminales_sentencia = punteros_simbolos_no_terminales_write;
    }
  | read 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "read");
      punteros_simbolos_no_terminales_sentencia = punteros_simbolos_no_terminales_read;
    }
  | ciclo
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "ciclo");
      punteros_simbolos_no_terminales_sentencia = punteros_simbolos_no_terminales_ciclo;
    }
  | if
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "if");
      punteros_simbolos_no_terminales_sentencia = punteros_simbolos_no_terminales_if;
    }
  | declaracion
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "declaracion");
      punteros_simbolos_no_terminales_sentencia = punteros_simbolos_no_terminales_declaracion;
    }
  | funcion
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "funcion");
      punteros_simbolos_no_terminales_sentencia = punteros_simbolos_no_terminales_funcion;
    }
  ;

funcion:
  funcion_numerica 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FUNCION, "funcion_numerica");
      punteros_simbolos_no_terminales_funcion = punteros_simbolos_no_terminales_funcion_numerica;
    }
  | funcion_booleana 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FUNCION, "funcion_booleana");
      punteros_simbolos_no_terminales_funcion = punteros_simbolos_no_terminales_funcion_booleana;
    }
  ;

funcion_numerica:
  triangleAreaMaximum 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_FUNCION_NUMERICA, 
        "triangleAreaMaximum");

      punteros_simbolos_no_terminales_funcion_numerica = punteros_simbolos_no_terminales_triangleAreaMaximum;
    }
  ;

funcion_booleana:
  isZero 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FUNCION_BOOLEANA, "isZero");

      punteros_simbolos_no_terminales_funcion_booleana = punteros_simbolos_no_terminales_isZero;
    }
  ;

isZero:
  IS_ZERO PARENTESIS_A expresion PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_IS_ZERO, 
        "IS_ZERO PARENTESIS_A expresion PARENTESIS_C");
    
      // TODO: Agregar punteros de tercetos
    }
  ;

triangleAreaMaximum:
  TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_TRIANGLE_AREA_MAXIMUM, 
      "TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C");

    // TODO: Agregar punteros de tercetos
  }
  ;
  
triangulo:
  CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_TRIANGULO, 
        "CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C");
      
      // TODO: Agregar punteros de tercetos
    }
  ;

coordenada:
  expresion COMA expresion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_COORDENADA, "expresion COMA expresion");
      
      // TODO: Agregar punteros de tercetos
    }
  ;

declaracion:
  INIT LLAVES_A lista_declaraciones LLAVES_C 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_DECLARACION, 
        "INIT LLAVES_A lista_declaraciones LLAVES_C"
      );
    
      // TODO: Agregar punteros de tercetos
    }
  ;

lista_declaraciones:
  declaracion_var 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_LISTA_DECLARACIONES, 
        "declaracion_var");
      
      punteros_simbolos_no_terminales_lista_declaraciones = punteros_simbolos_no_terminales_declaracion_var;
    }
  | lista_declaraciones declaracion_var 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_LISTA_DECLARACIONES, 
        "lista_declaraciones declaracion_var");

      // TODO: Agregar punteros de tercetos
    }
  ;

declaracion_var:
  lista_ids DOS_PUNTOS tipo
   {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_DECLARACION_VAR, "lista_ids DOS_PUNTOS tipo");

    // TODO: Agregar punteros de tercetos

    for(i=0;i<cant_id;i++)
      {
        tabla_simbolos_insertar_dato(ids_declarados[i].cadena, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
      }
    cant_id=0;
   }
  ;

lista_ids:
  ID 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_LISTA_IDS, "ID");
    
    // TODO: Agregar punteros de tercetos

    strcpy(ids_declarados[cant_id].cadena, $1);
    cant_id++;
  }
  | lista_ids COMA ID 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_LISTA_IDS, "lista_ids COMA ID");
      
      // TODO: Agregar punteros de tercetos
      
      strcpy(ids_declarados[cant_id].cadena, $3);
      cant_id++;
    }
    ;

tipo:
  FLOAT 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "FLOAT");

    // TODO: Agregar punteros de tercetos
  }
  | INT 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "INT");

    // TODO: Agregar punteros de tercetos
  }
  | STRING 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "STRING");

    // TODO: Agregar punteros de tercetos
  }
  ;

asignacion: 
  ID ASIGNACION expresion 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_ASIGNACION, "ID ASIGNACION expresion");
    aux = gci_tercetos_agregar_terceto(
      $1,
      NULL,
      NULL
    );
    punteros_simbolos_no_terminales_asignacion = gci_tercetos_agregar_terceto(
      ":=",
      aux,
      punteros_simbolos_no_terminales_expresion
    );
    tabla_simbolos_insertar_dato($1, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
  }
  ;

write:
  WRITE PARENTESIS_A expresion PARENTESIS_C 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_WRITE, "WRITE PARENTESIS_A expresion PARENTESIS_C");

    // TODO: Agregar punteros de tercetos
  }
  ;

read:
  READ PARENTESIS_A ID PARENTESIS_C 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_READ, "READ PARENTESIS_A ID PARENTESIS_C");
    tabla_simbolos_insertar_dato($3, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
  
    // TODO: Agregar punteros de tercetos
  }
  ;

ciclo:
  WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_CICLO, 
      "WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");
  
    // TODO: Agregar punteros de tercetos
  }
  ;

if:
  bloque_if 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_IF, "bloque_if");
    punteros_simbolos_no_terminales_if = punteros_simbolos_no_terminales_bloque_if;
  }
  | bloque_if else 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_IF, "bloque_if else");
    // TODO: Agregar punteros de tercetos
  }
  ;

bloque_if:
  IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_BLOQUE_IF, 
      "IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");
  
    // TODO: Agregar punteros de tercetos
  }
  ;

else:
   ELSE bloque_if 
   {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_ELSE, "ELSE bloque_if");
    // TODO: Agregar punteros de tercetos
   }
  | ELSE LLAVES_A instrucciones LLAVES_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_ELSE, "ELSE LLAVES_A instrucciones LLAVES_C");
      // TODO: Agregar punteros de tercetos
    }
  ;

condicional:
  condicion_compuesta 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICIONAL, "condicion_compuesta");
    punteros_simbolos_no_terminales_condicional = punteros_simbolos_no_terminales_condicion_compuesta;
  }
  ;

condicion_compuesta:
  condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA, "condicion_unaria");
      punteros_simbolos_no_terminales_condicion_compuesta = punteros_simbolos_no_terminales_condicion_unaria;
    }
  | condicion_compuesta AND condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA, 
        "condicion_compuesta AND condicion_unaria");
    
      // TODO: Agregar punteros de tercetos
    }
  | condicion_compuesta OR condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA, 
        "condicion_compuesta OR condicion_unaria");

      // TODO: Agregar punteros de tercetos
    }
  ;

condicion_unaria:
  NOT condicion_unaria 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_CONDICION_UNARIA, 
      "NOT condicion_unaria");

    // TODO: Agregar punteros de tercetos
  }
  | predicado 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICION_UNARIA, "predicado");
      punteros_simbolos_no_terminales_condicion_unaria = punteros_simbolos_no_terminales_predicado;
    }
  ;

predicado:
  expresion operador_comparacion expresion 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_PREDICADO, 
        "expresion operador_comparacion expresion");

      // TODO: Agregar punteros de tercetos
    }
  | PARENTESIS_A condicional PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_PREDICADO, 
        "PARENTESIS_A condicional PARENTESIS_C");

      // TODO: Agregar punteros de tercetos
    }
  | funcion_booleana 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_PREDICADO, "funcion_booleana");
      punteros_simbolos_no_terminales_predicado = punteros_simbolos_no_terminales_funcion_booleana;
    }
  ;

operador_comparacion:
  MAYOR 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MAYOR");
      punteros_simbolos_no_terminales_operador_comparacion = gci_tercetos_agregar_terceto(
        ">",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );
    }
  | MAYOR_IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MAYOR_IGUAL");
      punteros_simbolos_no_terminales_operador_comparacion = gci_tercetos_agregar_terceto(
        ">=",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );
    }
  | MENOR_IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MENOR_IGUAL");

      punteros_simbolos_no_terminales_operador_comparacion = gci_tercetos_agregar_terceto(
        "<=",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );
    }
  | MENOR 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MENOR");
      punteros_simbolos_no_terminales_operador_comparacion = gci_tercetos_agregar_terceto(
        "<",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );  
    }
  | IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "IGUAL");
      punteros_simbolos_no_terminales_operador_comparacion = gci_tercetos_agregar_terceto(
        "==",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );  
    }
  | DISTINTO 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "DISTINTO");
      punteros_simbolos_no_terminales_operador_comparacion = gci_tercetos_agregar_terceto(
        "!=",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );  
    }
;

expresion:
  expresion SUMA termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion SUMA termino");
      punteros_simbolos_no_terminales_expresion = gci_tercetos_agregar_terceto(
        "+",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );
    }
  |expresion RESTA termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion RESTA termino");
      punteros_simbolos_no_terminales_expresion = gci_tercetos_agregar_terceto(
        "-",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );
    }
  |termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion");
      punteros_simbolos_no_terminales_expresion = punteros_simbolos_no_terminales_termino;
    }
  ;

termino: 
  termino MULTIPLICACION factor 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "termino MULTIPLICACION factor");
      punteros_simbolos_no_terminales_termino = gci_tercetos_agregar_terceto(
        "*", 
        punteros_simbolos_no_terminales_termino, 
        punteros_simbolos_no_terminales_factor);
    }
  |termino DIVISION factor 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "termino DIVISION factor");
      punteros_simbolos_no_terminales_termino = gci_tercetos_agregar_terceto(
        "/", 
        punteros_simbolos_no_terminales_termino, 
        punteros_simbolos_no_terminales_factor);
    }
  |factor 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "factor");
      punteros_simbolos_no_terminales_termino = punteros_simbolos_no_terminales_factor;
    }
  ;

factor: 
  ID {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "ID");
    punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto($1, NULL, NULL);
    tabla_simbolos_insertar_dato($1, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
  }
  | CTE_INT 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_INT");
        punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto($1, NULL, NULL);
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_INT, $1);
      }
  | CTE_FLOAT 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_FLOAT");
        punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto($1, NULL, NULL);
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_FLOAT, $1);
      }
  | RESTA CTE_INT
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "RESTA CTE_INT");

        const char* nro_negativo = utils_obtener_string_numero_negativo($2);

        punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto(
          nro_negativo, 
          NULL, 
          NULL);

        tabla_simbolos_insertar_dato(nro_negativo, TIPO_DATO_CTE_INT, nro_negativo);
      }
  | RESTA CTE_FLOAT
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "RESTA CTE_FLOAT");

        const char* nro_negativo = utils_obtener_string_numero_negativo($2); 

        punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto(
          nro_negativo, 
          NULL, 
          NULL);

        tabla_simbolos_insertar_dato(nro_negativo, TIPO_DATO_CTE_FLOAT, nro_negativo);
      }
  | RESTA ID
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "RESTA ID");
        
        // TODO: Como manejamos este negativo de ID?
        // TODO: Agregar punteros de tercetos

        tabla_simbolos_insertar_dato($2, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
      }
  | CTE_STRING 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_STRING");
        punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto($1, NULL, NULL);
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_STRING, $1);
      }
  | PARENTESIS_A expresion PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_FACTOR, 
        "PARENTESIS_A expresion PARENTESIS_C");
        
      // TODO: Agregar punteros de tercetos
    }
  | funcion_numerica 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "funcion_numerica");
      punteros_simbolos_no_terminales_factor = punteros_simbolos_no_terminales_funcion_numerica;
    }
  ;

%%

void crear_pilas_para_cada_no_terminal()
{
  pila_factor = pila_crear();
  pila_termino = pila_crear();
  pila_expresion = pila_crear();
  pila_comparacion = pila_crear();
  pila_sumar_ultimos = pila_crear();
}

void crear_cola_tercetos()
{
  cola_tercetos = cola_crear();
}

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        char mensaje[100];
        sprintf(mensaje, "No se puede abrir el archivo: %s", argv[1]);
        utils_imprimir_error(mensaje);
        return 1;
    }


    tabla_simbolos_crear();
    crear_pilas_para_cada_no_terminal();
    crear_cola_tercetos();
    gci_tercetos_crear_lista();

    yyparse();        

    tabla_simbolos_guardar();
    gci_tercetos_guardar();
    
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