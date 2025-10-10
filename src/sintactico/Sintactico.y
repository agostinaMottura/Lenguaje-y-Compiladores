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
#include "./src/simbolos/terminales/terminales.h"
#include "./src/simbolos/no-terminales/no_terminales.h"
#include "./src/simbolos/no-terminales/punteros/punteros.h"
#include "./src/gci/tercetos/tercetos.h"
#include "./src/pila/pila.h"
#include "./src/cola_punteros/cola_punteros.h"


int yystopparser=0;
FILE  *yyin;

int yyerror(const char *s);
int yylex();

// Pilas
t_pila *pila_expresion;
t_pila *pila_comparacion;
t_pila *pila_nro_tercetos;
t_pila *pila_triangulo;
t_pila *pila_coordenada;

// Colas
t_cola_punteros *cola_saltos_comparacion;


// Declaracion variables tabla de simbolos
int aux_hay_else = 0; 
int i=0;
int cant_id = 0;
size_t tamano_terceto = sizeof(t_gci_tercetos_dato);
char salto_comparacion[VALIDACIONES_MAX_LONGITUD_STRING];
t_tipo_dato tipo_dato_aux;

t_gci_tercetos_dato* aux_terceto_if_else;
t_gci_tercetos_dato* aux_terceto_salto_comparacion;

t_validaciones_nombre_id ids_declarados[VALIDACIONES_MAX_IDS_DECLARADOS];

%}

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE_PREC

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
  instrucciones sentencia 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_INSTRUCCIONES, "instrucciones sentencia");
    // Como los tercetos los manejamos con una lista enlazada, no hace falta volver a asignar el puntero de instrucciones
  }
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
    
      punteros_simbolos_no_terminales_isZero = gci_tercetos_agregar_terceto(
        SIMBOLOS_NO_TERMINALES_IS_ZERO_VALOR,
        punteros_simbolos_no_terminales_expresion,
        NULL
      );
    }
  ;

triangleAreaMaximum:
  TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_TRIANGLE_AREA_MAXIMUM, 
      "TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C");

    void* primer_triangulo = pila_desapilar(pila_triangulo);
    void* segundo_triangulo = pila_desapilar(pila_triangulo);

    punteros_simbolos_no_terminales_triangleAreaMaximum = gci_tercetos_agregar_terceto(
      SIMBOLOS_NO_TERMINALES_TRIANGLE_AREA_MAXIMUM_VALOR, 
      primer_triangulo, 
      segundo_triangulo);
  }
  ;
  
triangulo:
  CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_TRIANGULO, 
        "CORCHETE_A coordenada PUNTO_Y_COMA coordenada PUNTO_Y_COMA coordenada CORCHETE_C");
      
      void* coordenada_x = pila_desapilar(pila_coordenada);
      void* coordenada_y = pila_desapilar(pila_coordenada);
      void* coordenada_z = pila_desapilar(pila_coordenada);

      punteros_simbolos_no_terminales_triangulo = gci_tercetos_agregar_terceto(
        SIMBOLOS_NO_TERMINALES_TRIANGULO_VALOR,
        coordenada_x,
        coordenada_y
      );
      punteros_simbolos_no_terminales_triangulo = gci_tercetos_agregar_terceto(
        SIMBOLOS_NO_TERMINALES_TRIANGULO_VALOR,
        punteros_simbolos_no_terminales_triangulo,
        coordenada_z
      );

      pila_apilar(
        pila_triangulo, 
        punteros_simbolos_no_terminales_triangulo,
        tamano_terceto);
    }
  ;

coordenada:
  expresion COMA expresion 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_COORDENADA, "expresion COMA expresion");
      
      void* primera_expresion = pila_desapilar(pila_expresion);
      void* segunda_expresion = pila_desapilar(pila_expresion);
      punteros_simbolos_no_terminales_coordenada = gci_tercetos_agregar_terceto(
        SIMBOLOS_NO_TERMINALES_COORDENADA_VALOR,
        primera_expresion,
        segunda_expresion
      );

      pila_apilar(
        pila_coordenada, 
        punteros_simbolos_no_terminales_coordenada, 
       tamano_terceto);
    }
  ;

declaracion:
  INIT LLAVES_A lista_declaraciones LLAVES_C 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_DECLARACION, 
        "INIT LLAVES_A lista_declaraciones LLAVES_C"
      );
    
      punteros_simbolos_no_terminales_declaracion = punteros_simbolos_no_terminales_lista_declaraciones;
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

      // Como los tercetos los manejamos con una lista enlazada, no hace falta volver a asignar el puntero de lista_declaraciones
    }
  ;

declaracion_var:
  lista_ids DOS_PUNTOS tipo
   {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_DECLARACION_VAR, "lista_ids DOS_PUNTOS tipo");

    for(i=0;i<cant_id;i++)
      {
        tabla_simbolos_insertar_dato(ids_declarados[i].cadena, tipo_dato_aux, VALORES_NULL);
        void *terceto_id = gci_tercetos_agregar_terceto(
          ids_declarados[i].cadena, 
          NULL, 
          NULL);
        punteros_simbolos_no_terminales_declaracion_var = gci_tercetos_agregar_terceto(
          SIMBOLOS_NO_TERMINALES_DECLARACION_VAR_VALOR, 
          terceto_id, 
          punteros_simbolos_no_terminales_tipo);
      }
    cant_id=0;
   }
  ;

lista_ids: // No aporta nada de valor al GCI esta regla no terminal, despues los asignamos todos juntos en declaracion_var
  ID 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_LISTA_IDS, "ID");
    
    strcpy(ids_declarados[cant_id].cadena, $1);
    cant_id++;
  }
  | lista_ids COMA ID 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_LISTA_IDS, "lista_ids COMA ID");
      
      strcpy(ids_declarados[cant_id].cadena, $3);
      cant_id++;
    }
    ;

tipo:
  FLOAT 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "FLOAT");
    punteros_simbolos_no_terminales_tipo = gci_tercetos_agregar_terceto(
      SIMBOLOS_TERMINALES_FLOAT_VALOR, 
      NULL, 
      NULL);
    tipo_dato_aux = TIPO_DATO_FLOAT;
  }
  | INT 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "INT");
    punteros_simbolos_no_terminales_tipo = gci_tercetos_agregar_terceto(
      SIMBOLOS_TERMINALES_INT_VALOR, 
      NULL, 
      NULL);
      tipo_dato_aux = TIPO_DATO_INT;
  }
  | STRING 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "STRING");
    punteros_simbolos_no_terminales_tipo = gci_tercetos_agregar_terceto(
      SIMBOLOS_TERMINALES_STRING_VALOR, 
      NULL, 
      NULL);
    tipo_dato_aux = TIPO_DATO_STRING;
  }
  ;

asignacion: 
  ID ASIGNACION expresion 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_ASIGNACION, "ID ASIGNACION expresion");
    t_gci_tercetos_dato* aux = gci_tercetos_agregar_terceto(
      $1,
      NULL,
      NULL
    );
    punteros_simbolos_no_terminales_asignacion = gci_tercetos_agregar_terceto(
      SIMBOLOS_TERMINALES_ASIGNACION_VALOR,
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
    punteros_simbolos_no_terminales_write = gci_tercetos_agregar_terceto(
      SIMBOLOS_NO_TERMINALES_WRITE_VALOR,
      punteros_simbolos_no_terminales_expresion,
      NULL
    );
  }
  ;

read:
  READ PARENTESIS_A ID PARENTESIS_C 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_READ, "READ PARENTESIS_A ID PARENTESIS_C");
    tabla_simbolos_insertar_dato($3, TIPO_DATO_DESCONOCIDO, VALORES_NULL);

    void* terceto_id = gci_tercetos_agregar_terceto(
      $3,
      NULL,
      NULL
    );
    punteros_simbolos_no_terminales_read = gci_tercetos_agregar_terceto(
      SIMBOLOS_NO_TERMINALES_READ_VALOR,
      terceto_id,
      NULL
    );
  }
  ;

ciclo:
  WHILE PARENTESIS_A
  {
    punteros_simbolos_no_terminales_ciclo = gci_tercetos_agregar_terceto(
                                              "InicioCiclo", 
                                              NULL, 
                                              NULL);
    pila_apilar(
      pila_nro_tercetos, 
      punteros_simbolos_no_terminales_ciclo, 
     tamano_terceto);
  } condicional PARENTESIS_C
  {

  } LLAVES_A instrucciones LLAVES_C 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_CICLO, 
      "WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");
  
    // TODO: Revisar
    void* terceto_a_actualizar = pila_desapilar(pila_nro_tercetos);
    t_gci_tercetos_dato* siguiente_indice = gci_tercetos_obtener_siguiente_indice();
    gci_tercetos_actualizar(siguiente_indice, terceto_a_actualizar);

    gci_tercetos_agregar_terceto(
      "BI",
      NULL,
      punteros_simbolos_no_terminales_ciclo
    );
  }
  ;

// TODO: Queda pendiente
if:
  bloque_if 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_IF, "bloque_if");
    punteros_simbolos_no_terminales_if = punteros_simbolos_no_terminales_bloque_if;
  }
  ;

bloque_if:
  IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C %prec LOWER_THAN_ELSE
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_BLOQUE_IF, 
      "IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");
    
      void* terceto_salto_comparacion;
      cola_punteros_quitar(cola_saltos_comparacion, &terceto_salto_comparacion);

      gci_tercetos_actualizar_indice(terceto_salto_comparacion);
  }
  | IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C ELSE 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_BLOQUE_IF, 
        "IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C ELSE LLAVES_A instrucciones LLAVES_C");
      
        void* terceto_salto_comparacion;
        cola_punteros_quitar(cola_saltos_comparacion, &terceto_salto_comparacion);

        aux_terceto_salto_comparacion = gci_tercetos_agregar_terceto(
          "BI",
          NULL, 
          NULL);

        gci_tercetos_actualizar_indice(terceto_salto_comparacion);


      cola_punteros_agregar(cola_saltos_comparacion, aux_terceto_salto_comparacion);
    } LLAVES_A instrucciones LLAVES_C
    {
      while(!cola_punteros_esta_vacia(cola_saltos_comparacion))
      {
        void* terceto_salto_comparacion;
        cola_punteros_quitar(cola_saltos_comparacion, &terceto_salto_comparacion);

        gci_tercetos_actualizar_indice(terceto_salto_comparacion);
      }
    }
  /* | ELSE bloque_if
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_BLOQUE_IF, "ELSE bloque_if");
    } */
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
    
      punteros_simbolos_no_terminales_condicion_compuesta = gci_tercetos_agregar_terceto(
        SIMBOLOS_TERMINALES_AND_VALOR,
        punteros_simbolos_no_terminales_condicion_compuesta,
        punteros_simbolos_no_terminales_condicion_unaria);
    }
  | condicion_compuesta OR condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA, 
        "condicion_compuesta OR condicion_unaria");

      punteros_simbolos_no_terminales_condicion_compuesta = gci_tercetos_agregar_terceto(
        SIMBOLOS_TERMINALES_OR_VALOR,
        punteros_simbolos_no_terminales_condicion_compuesta,
        punteros_simbolos_no_terminales_condicion_unaria);
    }
  ;

condicion_unaria:
  NOT condicion_unaria 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_CONDICION_UNARIA, 
      "NOT condicion_unaria");

    
    punteros_simbolos_no_terminales_condicion_unaria = gci_tercetos_agregar_terceto(
        SIMBOLOS_TERMINALES_NOT_VALOR,
        punteros_simbolos_no_terminales_condicion_unaria,
        NULL);
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
      void* primera_expresion = pila_desapilar(pila_expresion);
      void* segunda_expresion = pila_desapilar(pila_expresion);

      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_PREDICADO, 
        "expresion operador_comparacion expresion");

      punteros_simbolos_no_terminales_predicado = gci_tercetos_agregar_terceto(
                                                    "CMP", 
                                                    primera_expresion, 
                                                    segunda_expresion);
      aux_terceto_salto_comparacion = gci_tercetos_agregar_terceto(
        salto_comparacion, // Saltos: BGE, BGT, BLT, BLE, BNE. BEQ
        NULL, 
        NULL);
      cola_punteros_agregar(cola_saltos_comparacion, aux_terceto_salto_comparacion);
    }
  | PARENTESIS_A condicional PARENTESIS_C 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_PREDICADO, 
        "PARENTESIS_A condicional PARENTESIS_C");

      punteros_simbolos_no_terminales_predicado = punteros_simbolos_no_terminales_condicional;
    }
  | funcion_booleana 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_PREDICADO, "funcion_booleana");
      punteros_simbolos_no_terminales_predicado = punteros_simbolos_no_terminales_funcion_booleana;
    }
  ;

operador_comparacion: // No creo los GCI aca, sino que los creamos en el predicado
  MAYOR 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MAYOR");
      strcpy(salto_comparacion, "BLE");
    }
  | MAYOR_IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MAYOR_IGUAL");
      strcpy(salto_comparacion, "BLT");
    }
  | MENOR_IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MENOR_IGUAL");
      strcpy(salto_comparacion, "BGT");
    }
  | MENOR 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "MENOR");
      strcpy(salto_comparacion, "BGE");
    }
  | IGUAL 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "IGUAL");
      strcpy(salto_comparacion, "BNE");
    }
  | DISTINTO 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION, "DISTINTO");
      strcpy(salto_comparacion, "BEQ");
    }
;

expresion:
  expresion SUMA termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion SUMA termino");
      punteros_simbolos_no_terminales_expresion = gci_tercetos_agregar_terceto(
        SIMBOLOS_TERMINALES_SUMA_VALOR,
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );
      pila_apilar(
        pila_expresion, 
        punteros_simbolos_no_terminales_expresion, 
       tamano_terceto);
    }
  |expresion RESTA termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion RESTA termino");
      punteros_simbolos_no_terminales_expresion = gci_tercetos_agregar_terceto(
        SIMBOLOS_TERMINALES_RESTA_VALOR,
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );
      pila_apilar(
        pila_expresion, 
        punteros_simbolos_no_terminales_expresion, 
       tamano_terceto);
    }
  |termino 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion");
      punteros_simbolos_no_terminales_expresion = punteros_simbolos_no_terminales_termino;
      pila_apilar(
        pila_expresion, 
        punteros_simbolos_no_terminales_expresion, 
       tamano_terceto);
    }
  ;

termino: 
  termino MULTIPLICACION factor 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "termino MULTIPLICACION factor");
      punteros_simbolos_no_terminales_termino = gci_tercetos_agregar_terceto(
        SIMBOLOS_TERMINALES_MULTIPLICACION_VALOR, 
        punteros_simbolos_no_terminales_termino, 
        punteros_simbolos_no_terminales_factor);
    }
  |termino DIVISION factor 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "termino DIVISION factor");
      punteros_simbolos_no_terminales_termino = gci_tercetos_agregar_terceto(
        SIMBOLOS_TERMINALES_DIVISION_VALOR, 
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
        
      punteros_simbolos_no_terminales_factor = punteros_simbolos_no_terminales_expresion;
    }
  | funcion_numerica 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "funcion_numerica");
      punteros_simbolos_no_terminales_factor = punteros_simbolos_no_terminales_funcion_numerica;
    }
  ;

%%

void crear_pilas()
{
  pila_expresion = pila_crear();
  pila_comparacion = pila_crear();
  pila_nro_tercetos = pila_crear();
  pila_triangulo = pila_crear();
  pila_coordenada = pila_crear();
}

void crear_colas()
{
  cola_saltos_comparacion = cola_punteros_crear();
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
    crear_pilas();
    crear_colas();
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