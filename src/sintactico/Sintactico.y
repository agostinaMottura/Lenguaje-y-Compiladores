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
#include "./src/tabla-simbolos/valores/valores.h"
#include "./src/sintactico/informes/informes.h"
#include "./src/utils/utils.h"
#include "./src/simbolos/no-terminales/no_terminales.h"
#include "./src/semantico/arbol-sintactico/arbol_sintactico.h"
#include "./src/semantico/arbol-sintactico/punteros/punteros.h"

int yystopparser=0;
FILE  *yyin;

int yyerror(const char *s);
int yylex();

// Declaracion variables tabla de simbolos 
int i=0;
int cant_id = 0;

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
  instrucciones {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_PROGRAMA, "instrucciones");
    punteros_arbol_sintactico_programa = punteros_arbol_sintactico_instrucciones;
  }
  ;

instrucciones:
  instrucciones sentencia 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_INSTRUCCIONES, "instrucciones sentencia");
      // TODO: Tengo dudas de como se implementa
      hoja_izq = punteros_arbol_sintactico_instrucciones;
      hoja_der = NULL;

      punteros_arbol_sintactico_instrucciones = arbol_sintactico_crear_nodo(
        punteros_arbol_sintactico_sentencia->terminal,
        punteros_arbol_sintactico_sentencia->lexema,
        hoja_izq,
        hoja_der
      );
    }
  | sentencia 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_INSTRUCCIONES, "sentencia");
      punteros_arbol_sintactico_instrucciones = punteros_arbol_sintactico_sentencia;
    }
  ;

sentencia:  	   
  asignacion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "asignacion");
      punteros_arbol_sintactico_sentencia = punteros_arbol_sintactico_asignacion;
    }
  | write 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "write");
      punteros_arbol_sintactico_sentencia = punteros_arbol_sintactico_write;
    }
  | read 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "read");
      punteros_arbol_sintactico_sentencia = punteros_arbol_sintactico_read;
    }
  | ciclo 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "ciclo");
      punteros_arbol_sintactico_sentencia = punteros_arbol_sintactico_ciclo;
    }
  | if 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "if");
      punteros_arbol_sintactico_sentencia = punteros_arbol_sintactico_if;
    }
  | declaracion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "declaracion");
      punteros_arbol_sintactico_sentencia = punteros_arbol_sintactico_declaracion;
    }
  | funcion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_SENTENCIA, "funcion");
      punteros_arbol_sintactico_sentencia = punteros_arbol_sintactico_funcion;
    }
  ;

funcion:
  funcion_numerica 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FUNCION, "funcion_numerica");
      punteros_arbol_sintactico_funcion = punteros_arbol_sintactico_funcion_numerica;
    }
  | funcion_booleana 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FUNCION, "funcion_booleana");
      punteros_arbol_sintactico_funcion = punteros_arbol_sintactico_funcion_booleana;
    }
  ;

funcion_numerica:
  triangleAreaMaximum 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FUNCION_NUMERICA, "triangleAreaMaximum");
      punteros_arbol_sintactico_funcion_numerica = punteros_arbol_sintactico_triangleAreaMaximum;
    }
  ;

funcion_booleana:
  isZero 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FUNCION_BOOLEANA, "isZero");
      punteros_arbol_sintactico_funcion_booleana = punteros_arbol_sintactico_isZero;
    }
  ;

isZero:
  IS_ZERO PARENTESIS_A expresion PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_IS_ZERO, "IS_ZERO PARENTESIS_A expresion PARENTESIS_C");
      // TODO: Tengo dudas de como se implementa
    }
  ;

triangleAreaMaximum:
  TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TRIANGLE_AREA_MAXIMUM, "TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C");
      // TODO: Tengo dudas de como se implementa
    }
  ;
  
triangulo:
  CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TRIANGULO, "CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C");
      // TODO: Tengo dudas de como se implementa
    }
  ;

coordenada:
  expresion COMA expresion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_COORDENADA, "expresion COMA expresion");
      // TODO: Tengo dudas de como se implementa
      hoja_izq = punteros_arbol_sintactico_expresion;
      hoja_der = punteros_arbol_sintactico_expresion;

      punteros_arbol_sintactico_coordenada = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_COMA,
        $2,
        hoja_izq,
        hoja_der
      );
    }
  ;

declaracion:
  INIT LLAVES_A lista_declaraciones LLAVES_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_DECLARACION, "INIT LLAVES_A lista_declaraciones LLAVES_C");
      // TODO: Tengo dudas de como se implementa
    }
  ;

lista_declaraciones:
  declaracion_var 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_LISTA_DECLARACIONES, "declaracion_var");
    punteros_arbol_sintactico_lista_declaraciones = punteros_arbol_sintactico_declaracion_var;
  }
  | lista_declaraciones declaracion_var 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_LISTA_DECLARACIONES, "lista_declaraciones declaracion_var");

      // TODO: Tengo dudas de como se implementa
      hoja_izq = punteros_arbol_sintactico_lista_declaraciones;
      hoja_der = NULL;

      punteros_arbol_sintactico_lista_declaraciones = arbol_sintactico_crear_nodo(
        punteros_arbol_sintactico_declaracion_var->terminal,
        punteros_arbol_sintactico_declaracion_var->lexema,
        hoja_izq,
        hoja_der
      );
    }
  ;

declaracion_var:
  lista_ids DOS_PUNTOS tipo
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_DECLARACION_VAR, "lista_ids DOS_PUNTOS tipo");
      for(i=0;i<cant_id;i++)
        {
          tabla_simbolos_insertar_dato(ids_declarados[i].cadena, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
        }
      cant_id=0;

      hoja_izq = punteros_arbol_sintactico_lista_ids;
      hoja_der = punteros_arbol_sintactico_tipo;
      
      punteros_arbol_sintactico_declaracion_var = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_DOS_PUNTOS,
        $2,
        hoja_izq,
        hoja_der
      );
    }
  ;

lista_ids:
  ID {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_LISTA_IDS, "ID");
    strcpy(ids_declarados[cant_id].cadena, $1);
    cant_id++;
    
    punteros_arbol_sintactico_lista_ids = arbol_sintactico_crear_hoja(
      SIMBOLOS_TERMINALES_ID,
      $1
    );
  }
  | lista_ids COMA ID {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_LISTA_IDS, "lista_ids COMA ID");
    strcpy(ids_declarados[cant_id].cadena, $3);
    cant_id++;
    
    hoja_izq = punteros_arbol_sintactico_lista_ids;
    hoja_der = arbol_sintactico_crear_hoja(
      SIMBOLOS_TERMINALES_ID,
      $1
    );

    punteros_arbol_sintactico_lista_ids = arbol_sintactico_crear_nodo(
      SIMBOLOS_TERMINALES_COMA,
      $2,
      hoja_izq,
      hoja_der
    )
  }
  ;

tipo:
  FLOAT 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "FLOAT");
      punteros_arbol_sintactico_tipo = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_FLOAT,
        $1
      );
    }
  | INT 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "INT");
      punteros_arbol_sintactico_tipo = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_INT,
        $1
      );
    }
  | STRING 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "STRING");
      punteros_arbol_sintactico_tipo = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_STRING,
        $1
      );
    };

asignacion: 
  ID ASIGNACION expresion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_ASIGNACION, "ID ASIGNACION expresion");
      tabla_simbolos_insertar_dato($1, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
      hoja_izq = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_ID,
        $1
      );
      hoja_der = punteros_arbol_sintactico_expresion;
      punteros_arbol_sintactico_asignacion = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_ASIGNACION,
        $2,
        hoja_izq,
        hoja_der
      );
    };

write:
  WRITE PARENTESIS_A expresion PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_WRITE, "WRITE PARENTESIS_A expresion PARENTESIS_C");
      // TODO: Tengo dudas de como se implementa
    };

read:
  READ PARENTESIS_A ID PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_READ, "READ PARENTESIS_A ID PARENTESIS_C");
      tabla_simbolos_insertar_dato($3, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
      // TODO: Tengo dudas de como se implementa
    };

ciclo:
  WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CICLO, "WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");
      // TODO: Tengo dudas de como se implementa
    };

if:
  bloque_if 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_IF, "bloque_if");
      punteros_arbol_sintactico_if = punteros_arbol_sintactico_bloque_if;
    }
  | bloque_if else 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_IF, "bloque_if else");
      // TODO: Tengo dudas de como se implementa
      hoja_izq = punteros_arbol_sintactico_bloque_if;
      hoja_der = NULL;
      punteros_arbol_sintactico_if = arbol_sintactico_crear_nodo(
        punteros_arbol_sintactico_else->terminal,
        punteros_arbol_sintactico_else->lexema,
        hoja_izq,
        hoja_der
      );
    };

bloque_if:
  IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_BLOQUE_IF, "IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");
      // TODO: Tengo dudas de como se implementa
    };

else:
   ELSE bloque_if 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_ELSE, "ELSE bloque_if");
      // TODO: Tengo dudas de como se implementa
      hoja_izq = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_ELSE_VALOR,
        $1
      );
      hoja_der = NULL;
      punteros_arbol_sintactico_else = arbol_sintactico_crear_nodo(
        punteros_arbol_sintactico_bloque_if->terminal,
        punteros_arbol_sintactico_bloque_if->lexema,
        hoja_izq,
        hoja_der
      );
    }
  | ELSE LLAVES_A instrucciones LLAVES_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_ELSE, "ELSE LLAVES_A instrucciones LLAVES_C");
      // TODO: Tengo dudas de como se implementa
    };

condicional:
  condicion_compuesta 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICIONAL, "condicion_compuesta");
      punteros_arbol_sintactico_condicional = punteros_arbol_sintactico_condicion_compuesta;
    };

condicion_compuesta:
  condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA, "condicion_unaria");
      punteros_arbol_sintactico_condicion_compuesta = punteros_arbol_sintactico_condicion_unaria;
    }
  | condicion_compuesta AND condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA, "condicion_compuesta AND condicion_unaria");
      punteros_arbol_sintactico_condicion_compuesta = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_AND_VALOR,
        $1,
        punteros_arbol_sintactico_condicion_compuesta,
        punteros_arbol_sintactico_condicion_unaria
      );
    }
  | condicion_compuesta OR condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA, "condicion_compuesta OR condicion_unaria");
      punteros_arbol_sintactico_condicion_compuesta = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_OR_VALOR,
        $1,
        punteros_arbol_sintactico_condicion_compuesta,
        punteros_arbol_sintactico_condicion_unaria
      );
    };

condicion_unaria:
  NOT condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICION_UNARIA, "NOT condicion_unaria");
      
      // TODO: Tengo dudas de como se implementa
      hoja_izq = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_NOT_VALOR,
        $1
      );
      hoja_der = NULL;
      punteros_arbol_sintactico_condicion_unaria = arbol_sintactico_crear_nodo(
        punteros_arbol_sintactico_condicion_unaria->terminal,
        punteros_arbol_sintactico_condicion_unaria->lexema,
        hoja_izq,
        hoja_der
      );
    }
  | predicado 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICION_UNARIA, "predicado");
      punteros_arbol_sintactico_condicion_unaria = punteros_arbol_sintactico_predicado;
    };

predicado:
  expresion operador_comparacion expresion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_PREDICADO, "expresion operador_comparacion expresion");
      // TODO: Tengo dudas de como se implementa
      punteros_arbol_sintactico_predicado = arbol_sintactico_crear_nodo(
        punteros_arbol_sintactico_operador_comparacion->terminal,
        punteros_arbol_sintactico_operador_comparacion->lexema,
        punteros_arbol_sintactico_expresion,
        punteros_arbol_sintactico_expresion
      );
    }
  | PARENTESIS_A condicional PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_PREDICADO, "PARENTESIS_A condicional PARENTESIS_C");
      // TODO: Tengo dudas de como se implementa
      hoja_izq = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_PARENTESIS_A_VALOR,
        $1
      );
      hoja_der = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_PARENTESIS_C_VALOR,
        $3
      );
      punteros_arbol_sintactico_predicado = arbol_sintactico_crear_nodo(
        punteros_arbol_sintactico_condicional->terminal,
        punteros_arbol_sintactico_condicional->lexema,
        hoja_izq,
        hoja_der
      );
    }
  | funcion_booleana 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_PREDICADO, "funcion_booleana");
      punteros_arbol_sintactico_predicado = punteros_arbol_sintactico_funcion_booleana;
    };

operador_comparacion:
  MAYOR 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MAYOR");
    punteros_arbol_sintactico_operador_comparacion = arbol_sintactico_crear_hoja(
      SIMBOLOS_TERMINALES_MAYOR_VALOR,
      $1
    );
  }
  | MAYOR_IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MAYOR_IGUAL");
      punteros_arbol_sintactico_operador_comparacion = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_MAYOR_IGUAL_VALOR,
        $1
      );
    }
  | MENOR_IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MENOR_IGUAL");
      punteros_arbol_sintactico_operador_comparacion = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_MENOR_IGUAL_VALOR,
        $1
      );
    }
  | MENOR 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MENOR");
      punteros_arbol_sintactico_operador_comparacion = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_MENOR_VALOR,
        $1
      );
    }
  | IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "IGUAL");
      punteros_arbol_sintactico_operador_comparacion = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_IGUAL_VALOR,
        $1
      );
    }
  | DISTINTO 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "DISTINTO");
      punteros_arbol_sintactico_operador_comparacion = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_DISTINTO_VALOR,
        $1
      );
    };
expresion:
  expresion SUMA termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion SUMA termino");
      punteros_arbol_sintactico_expresion = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_SUMA_VALOR,
        $2,
        punteros_arbol_sintactico_expresion,
        punteros_arbol_sintactico_termino
      );
    }
  |expresion RESTA termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion RESTA termino");
      punteros_arbol_sintactico_expresion = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_RESTA_VALOR,
        $2,
        punteros_arbol_sintactico_expresion,
        punteros_arbol_sintactico_termino
      );
    }
  |termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "termino");
      punteros_arbol_sintactico_expresion = punteros_arbol_sintactico_termino;
    }
  ;

termino: 
  termino MULTIPLICACION factor 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "termino MULTIPLICACION factor");
      punteros_arbol_sintactico_termino = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_MULTIPLICACION,
        $2,
        punteros_arbol_sintactico_termino,
        punteros_arbol_sintactico_factor
      );
    }
  |termino DIVISION factor 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "termino DIVISION factor");
      punteros_arbol_sintactico_termino = arbol_sintactico_crear_nodo(
        SIMBOLOS_TERMINALES_DIVISION,
        $2,
        punteros_arbol_sintactico_termino,
        punteros_arbol_sintactico_factor
      );
    }
  |factor 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "factor");
      punteros_arbol_sintactico_termino = punteros_arbol_sintactico_factor;
    }
  ;

factor: 
  ID {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "ID");
    tabla_simbolos_insertar_dato($1, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
    punteros_arbol_sintactico_factor = arbol_sintactico_crear_hoja(SIMBOLOS_TERMINALES_ID, $1);
  }
  | CTE_INT 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_INT");
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_INT, $1);
        punteros_arbol_sintactico_factor = arbol_sintactico_crear_hoja(SIMBOLOS_TERMINALES_CTE_INT, $1);
      }
  | CTE_FLOAT 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_FLOAT");
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_FLOAT, $1);
        punteros_arbol_sintactico_factor = arbol_sintactico_crear_hoja(SIMBOLOS_TERMINALES_CTE_FLOAT, $1);
      }
  | RESTA CTE_INT
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "RESTA CTE_INT");

        const char* nro_negativo = utils_obtener_string_numero_negativo($2); 

        tabla_simbolos_insertar_dato(nro_negativo, TIPO_DATO_CTE_INT, nro_negativo);

        punteros_arbol_sintactico_factor = arbol_sintactico_crear_hoja(SIMBOLOS_TERMINALES_CTE_INT, nro_negativo);
      }
  | RESTA CTE_FLOAT
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "RESTA CTE_FLOAT");

        const char* nro_negativo = utils_obtener_string_numero_negativo($2); 

        tabla_simbolos_insertar_dato(nro_negativo, TIPO_DATO_CTE_FLOAT, nro_negativo);

        punteros_arbol_sintactico_factor = arbol_sintactico_crear_hoja(SIMBOLOS_TERMINALES_CTE_FLOAT, nro_negativo);
      }
  | RESTA ID
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "RESTA ID");
        tabla_simbolos_insertar_dato($2, TIPO_DATO_DESCONOCIDO, VALORES_NULL);
        punteros_arbol_sintactico_factor = arbol_sintactico_crear_hoja(SIMBOLOS_TERMINALES_ID, $2);
      }
  | CTE_STRING 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_STRING");
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_STRING, $1);
        punteros_arbol_sintactico_factor = arbol_sintactico_crear_hoja(SIMBOLOS_TERMINALES_CTE_STRING, $1);
      }
  | PARENTESIS_A expresion PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "PARENTESIS_A expresion PARENTESIS_C");
      
      // TODO: Tengo dudas de como se implementa
      hoja_izq = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_PARENTESIS_A_VALOR,
        $1
      );
      hoja_der = arbol_sintactico_crear_hoja(
        SIMBOLOS_TERMINALES_PARENTESIS_C_VALOR,
        $3
      );
      punteros_arbol_sintactico_factor = arbol_sintactico_crear_nodo(
        punteros_arbol_sintactico_expresion->terminal,
        punteros_arbol_sintactico_expresion->lexema,
        hoja_izq,
        hoja_der
      );
    }
  | funcion_numerica 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "funcion_numerica");
      punteros_arbol_sintactico_factor = punteros_arbol_sintactico_funcion_numerica;
    };

%%

int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        char mensaje[100];
        sprintf(mensaje, "No se puede abrir el archivo: %s", argv[1]);
        utils_imprimir_error(mensaje);
        return 1;
    }
    else
    {   
        tabla_simbolos_crear();
        arbol_sintactico_crear();

        yyparse();        

        tabla_simbolos_guardar();
        arbol_sintactico_eliminar_memoria();
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