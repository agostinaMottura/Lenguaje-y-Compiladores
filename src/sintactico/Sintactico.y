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
#include "./src/pila_punteros/pila_punteros.h"
#include "./src/semantico/semantico.h"
#include "./src/semantico/informes/informes.h"
#include "./src/assembler/assembler.h"
#include "./src/utils/aux_variables.h"


int yystopparser=0;
FILE  *yyin;

int yyerror(const char *s);
int yylex();

// Pilas
t_pila *pila_expresion;
t_pila *pila_triangulo;
t_pila *pila_coordenada;
t_pila *pila_tipo_dato;
t_pila *pila_termino;

// Pilas punteros
t_pila_punteros* pila_saltos_comparacion;
t_pila_punteros* pila_saltos_or;
t_pila_punteros* pila_ciclos_while;



// Declaracion variables tabla de simbolos
int i=0;
int cant_id = 0;
int aux_condicion_not = 0;
int aux_if_id = -1;
int funcion_booleana_aux = 0;
int aux_cantidad_comparaciones_if[10] = {0,0,0,0,0,0,0,0,0,0};
size_t tamano_terceto = sizeof(t_gci_tercetos_dato);
size_t tamano_tipo_dato = sizeof(t_tipo_dato);
char salto_comparacion[VALIDACIONES_MAX_LONGITUD_STRING];
t_tipo_dato tipo_dato_aux;
t_tipo_dato tipo_dato_comparacion_aux;

t_gci_tercetos_dato* aux_terceto_if_else;
t_gci_tercetos_dato* aux_terceto_salto_comparacion;
t_gci_tercetos_dato* aux_expresion;

t_validaciones_nombre_id ids_declarados[VALIDACIONES_MAX_IDS_DECLARADOS];

// Triangulos
int punto_aux = 0;
int triangulo_numero = 0;

t_gci_tercetos_dato* punto_a_x;
t_gci_tercetos_dato* punto_a_y;

t_gci_tercetos_dato* punto_b_x;
t_gci_tercetos_dato* punto_b_y;

t_gci_tercetos_dato* punto_c_x;
t_gci_tercetos_dato* punto_c_y;

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

      generar_assembler(&lista_tercetos, &tabla_simbolos);
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

      // Agregamos el 0 a la tabla de símbolos como constante
      tabla_simbolos_insertar_dato("0", TIPO_DATO_CTE_INT, "0");
      
      // Buscamos el nombre generado (con prefijo _) en la tabla
      t_tabla_simbolos_dato* dato_cero = NULL;
      t_tabla_simbolos_nodo* nodo = tabla_simbolos.primero;
      while (nodo != NULL) {
          if ((nodo->dato.tipo_dato == TIPO_DATO_CTE_INT || nodo->dato.tipo_dato == TIPO_DATO_CTE_FLOAT) && 
              strcmp(nodo->dato.valor, "0") == 0) {
              dato_cero = &(nodo->dato);
              break;
          }
          nodo = nodo->siguiente;
      }
      
      const char* nombre_cero = (dato_cero != NULL) ? dato_cero->nombre : "0";
      void* cero = gci_tercetos_agregar_terceto(nombre_cero, NULL, NULL);

      punteros_simbolos_no_terminales_isZero = gci_tercetos_agregar_terceto(
        "CMP",
        punteros_simbolos_no_terminales_expresion,
        cero
      );

      aux_terceto_salto_comparacion = gci_tercetos_agregar_terceto(
        "BNE",
        NULL,
        NULL
      );
      
      pila_punteros_apilar(pila_saltos_comparacion, aux_terceto_salto_comparacion);
      aux_cantidad_comparaciones_if[aux_if_id]++;
    }
  ;

triangleAreaMaximum:
  TRIANGLE_AREA_MAXIMUM PARENTESIS_A {
    triangulo_numero = 0;
  } triangulo PUNTO_Y_COMA {
    triangulo_numero = 1;
  } triangulo PARENTESIS_C 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_TRIANGLE_AREA_MAXIMUM, 
      "TRIANGLE_AREA_MAXIMUM PARENTESIS_A triangulo PUNTO_Y_COMA triangulo PARENTESIS_C");

    void* primer_triangulo = pila_desapilar(pila_triangulo);
    void* segundo_triangulo = pila_desapilar(pila_triangulo);



    // Comparamos los triangulos y nos quedamos con el de mayor area
    void* variable_asignacion = gci_tercetos_agregar_terceto(
      "@var_aux_area_triangulo_maxima",
      NULL,
      NULL
    );

    punteros_simbolos_no_terminales_triangleAreaMaximum = variable_asignacion;

    void* area_triangulo_a = gci_tercetos_agregar_terceto(
      "@var_aux_area_triangulo_a",
      NULL,
      NULL
    );
    void* area_triangulo_b = gci_tercetos_agregar_terceto(
      "@var_aux_area_triangulo_b",
      NULL,
      NULL
    );

    gci_tercetos_agregar_terceto(
      "CMP",
      area_triangulo_a,
      area_triangulo_b
    );
    void* salto_menor_que = gci_tercetos_agregar_terceto(
      "BLT",
      NULL,
      NULL
    );

    gci_tercetos_agregar_terceto(
      ":=",
      variable_asignacion,
      area_triangulo_a
    );
    void* salto_incondicional = gci_tercetos_agregar_terceto(
      "BI",
      NULL,
      NULL
    );

    void* etiqueta_segundo_mayor = gci_tercetos_agregar_etiqueta();
    gci_tercetos_actualizar_salto_con_etiqueta(salto_menor_que, etiqueta_segundo_mayor);

    gci_tercetos_agregar_terceto(
      ":=",
      variable_asignacion,
      area_triangulo_b
    );
    
    void* etiqueta_fin_comparacion = gci_tercetos_agregar_etiqueta();
    gci_tercetos_actualizar_salto_con_etiqueta(salto_incondicional, etiqueta_fin_comparacion);

     
  }
  ;
  
triangulo:
  CORCHETE_A
  {
    punto_aux = 0;
  } coordenada PUNTO_Y_COMA
  {
    punto_aux = 1;
  } coordenada PUNTO_Y_COMA
  {
    punto_aux = 2;
  } coordenada CORCHETE_C 
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

      // Calcular el area de este triangulo
      void* area_triangulo_variable_resultado = NULL;

      if (triangulo_numero == 0)
      {
        area_triangulo_variable_resultado = gci_tercetos_agregar_terceto(
          "@var_aux_area_triangulo_a",
          NULL,
          NULL
        );
      }
      else
      {
        area_triangulo_variable_resultado = gci_tercetos_agregar_terceto(
          "@var_aux_area_triangulo_b",
          NULL,
          NULL
        );
      }

      // Calculo del primer termino
      void* area_triangulo_aux_a = gci_tercetos_agregar_terceto("*", punto_a_x, punto_b_y); // A.x * B.y
      void* aux_area_a_primer_termino_a = gci_tercetos_agregar_terceto("@aux_area_a_primer_termino_a", NULL, NULL);
      gci_tercetos_agregar_terceto(":=", aux_area_a_primer_termino_a, area_triangulo_aux_a);

      void* area_triangulo_aux_b = gci_tercetos_agregar_terceto("*", punto_b_x, punto_c_y); // B.x * C.y
      void* aux_area_a_primer_termino_b = gci_tercetos_agregar_terceto("@aux_area_a_primer_termino_b", NULL, NULL);
      gci_tercetos_agregar_terceto(":=", aux_area_a_primer_termino_b, area_triangulo_aux_b);

      void* area_triangulo_aux_c = gci_tercetos_agregar_terceto("*", punto_c_x, punto_a_y); // C.x * A.y
      void* aux_area_a_primer_termino_c = gci_tercetos_agregar_terceto("@aux_area_a_primer_termino_c", NULL, NULL);
      gci_tercetos_agregar_terceto(":=", aux_area_a_primer_termino_c, area_triangulo_aux_c);


      void* aux_primer_suma = gci_tercetos_agregar_terceto("+", aux_area_a_primer_termino_a, aux_area_a_primer_termino_b);
      void* area_triangulo_primer_termino = gci_tercetos_agregar_terceto("+", aux_primer_suma, aux_area_a_primer_termino_c);

      void* area_a_primer_termino = gci_tercetos_agregar_terceto("@area_a_primer_termino", NULL, NULL);
      void* aux_area_a_primer_termino = gci_tercetos_agregar_terceto(
        ":=",
        area_a_primer_termino,
        area_triangulo_primer_termino
      );

      // Calculo del segundo termino
      area_triangulo_aux_a = gci_tercetos_agregar_terceto("*", punto_a_y, punto_b_x); // A.y * B.x
      void* aux_area_a_segundo_termino_a = gci_tercetos_agregar_terceto("@aux_area_a_segundo_termino_a", NULL, NULL);
      gci_tercetos_agregar_terceto(":=", aux_area_a_segundo_termino_a, area_triangulo_aux_a);

      area_triangulo_aux_b = gci_tercetos_agregar_terceto("*", punto_b_y, punto_c_x); // B.y * C.x
      void* aux_area_a_segundo_termino_b = gci_tercetos_agregar_terceto("@aux_area_a_segundo_termino_b", NULL, NULL);
      gci_tercetos_agregar_terceto(":=", aux_area_a_segundo_termino_b, area_triangulo_aux_b);

      area_triangulo_aux_c = gci_tercetos_agregar_terceto("*", punto_c_y, punto_a_x); // C.y * A.x
      void* aux_area_a_segundo_termino_c = gci_tercetos_agregar_terceto("@aux_area_a_segundo_termino_c", NULL, NULL);
      gci_tercetos_agregar_terceto(":=", aux_area_a_segundo_termino_c, area_triangulo_aux_c);

      void* aux_primer_suma_segundo_termino = gci_tercetos_agregar_terceto("+", aux_area_a_segundo_termino_a, aux_area_a_segundo_termino_b);
      void* area_triangulo_segundo_termino = gci_tercetos_agregar_terceto("+", aux_primer_suma_segundo_termino, aux_area_a_segundo_termino_c);


      void* area_a_segundo_termino = gci_tercetos_agregar_terceto(
        "@area_a_segundo_termino",
        NULL,
        NULL
      );
      void* aux_area_a_segundo_termino = gci_tercetos_agregar_terceto(
        ":=",
        area_a_segundo_termino,
        area_triangulo_segundo_termino
      );

      void* numerador = gci_tercetos_agregar_terceto(
        "-",
        area_a_primer_termino,
        area_a_segundo_termino
      );
      void* numerador_abs = gci_tercetos_agregar_terceto(
        "ABS",
        numerador,
        NULL
      );

      void* area_triangulo = gci_tercetos_agregar_terceto(
        "/",
        numerador_abs,
        gci_tercetos_agregar_terceto("2", NULL, NULL)
      );

      void* area_triangulo_asignacion = gci_tercetos_agregar_terceto(
        ":=",
        area_triangulo_variable_resultado,
        area_triangulo
      );
    }
  ;

coordenada:
  expresion {
    if (punto_aux == 0)
    {
      punto_a_x = punteros_simbolos_no_terminales_expresion;
    }

    if (punto_aux == 1)
    {
      punto_b_x = punteros_simbolos_no_terminales_expresion;
    }

    if (punto_aux == 2)
    {
      punto_c_x = punteros_simbolos_no_terminales_expresion;
    }
  } COMA expresion 
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

      if (punto_aux == 0)
      {
        punto_a_y = punteros_simbolos_no_terminales_expresion;
      }

      if (punto_aux == 1)
      {
        punto_b_y = punteros_simbolos_no_terminales_expresion;
      }

      if (punto_aux == 2)
      {
        punto_c_y = punteros_simbolos_no_terminales_expresion;
      }
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
    }
  ;

declaracion_var:
  lista_ids DOS_PUNTOS tipo
   {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_DECLARACION_VAR, "lista_ids DOS_PUNTOS tipo");

    for(i=0;i<cant_id;i++)
    {
      if (!semantico_validacion_no_existe_simbolo_en_tabla_simbolos(ids_declarados[i].cadena)) {
        exit(1);
      }
      tabla_simbolos_insertar_dato(ids_declarados[i].cadena, tipo_dato_aux, VALORES_NULL);
    }

    cant_id=0;
   }
  ;

lista_ids:
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
    tipo_dato_aux = TIPO_DATO_FLOAT;
  }
  | INT 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "INT");
    tipo_dato_aux = TIPO_DATO_INT;
  }
  | STRING 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TIPO, "STRING");
    tipo_dato_aux = TIPO_DATO_STRING;
  }
  ;

asignacion: 
  ID {
      if (!semantico_validacion_existe_simbolo_en_tabla_simbolos($1)) {
        exit(1);
      }
  } 
  ASIGNACION expresion 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_ASIGNACION, "ID ASIGNACION expresion");

    t_tipo_dato* tipo_dato_a = pila_desapilar(pila_tipo_dato);

    // Con una expresion como isZero, tambien funciona?
    if (!semantico_validacion_tipo_dato($1, *tipo_dato_a)) {
      exit(1);
    }

    t_gci_tercetos_dato* aux = gci_tercetos_agregar_terceto(
      $1,
      NULL,
      NULL
    );
    punteros_simbolos_no_terminales_asignacion = gci_tercetos_agregar_terceto(
      ":=",
      aux,
      punteros_simbolos_no_terminales_expresion
    );
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

    if (!semantico_validacion_existe_simbolo_en_tabla_simbolos($3)) {
      exit(1);
    }

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
    punteros_simbolos_no_terminales_ciclo = gci_tercetos_agregar_etiqueta();
    pila_punteros_apilar(pila_ciclos_while, punteros_simbolos_no_terminales_ciclo);
  } condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_CICLO, 
      "WHILE PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");

      void* puntero_etiqueta_inicio_ciclo;
      pila_punteros_desapilar(pila_ciclos_while, &puntero_etiqueta_inicio_ciclo);
      
      aux_terceto_salto_comparacion = gci_tercetos_agregar_terceto(
          "BI",
          NULL, 
          NULL);
      
      gci_tercetos_actualizar_salto_con_etiqueta(aux_terceto_salto_comparacion, puntero_etiqueta_inicio_ciclo);

      void* etiqueta_fin_ciclo = gci_tercetos_agregar_etiqueta();
      
      void* terceto_salto_comparacion;
      pila_punteros_desapilar(pila_saltos_comparacion, &terceto_salto_comparacion);
      gci_tercetos_actualizar_salto_con_etiqueta(terceto_salto_comparacion, etiqueta_fin_ciclo);
  }
  ;

if:
  bloque_if 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_IF, "bloque_if");
    punteros_simbolos_no_terminales_if = punteros_simbolos_no_terminales_bloque_if;
  }
  ;

if_contador: IF {
  aux_if_id++;
}

bloque_if:
  if_contador PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_BLOQUE_IF, 
      "IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C");
    
      void* etiqueta_fin_if = gci_tercetos_agregar_etiqueta();
      
      void* terceto_salto_comparacion;
      while(!pila_punteros_esta_vacia(pila_saltos_comparacion) && aux_cantidad_comparaciones_if[aux_if_id] > 0)
      {
        pila_punteros_desapilar(pila_saltos_comparacion, &terceto_salto_comparacion);
        gci_tercetos_actualizar_salto_con_etiqueta(terceto_salto_comparacion, etiqueta_fin_if);
        aux_cantidad_comparaciones_if[aux_if_id]--;
      }

      aux_if_id--;
  }
  | if_contador PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C ELSE
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_BLOQUE_IF, 
        "IF PARENTESIS_A condicional PARENTESIS_C LLAVES_A instrucciones LLAVES_C ELSE LLAVES_A instrucciones LLAVES_C");
      
        aux_terceto_salto_comparacion = gci_tercetos_agregar_terceto(
          "BI",
          NULL, 
          NULL);

        void* etiqueta_inicio_else = gci_tercetos_agregar_etiqueta();

        void* terceto_salto_comparacion;
        while(!pila_punteros_esta_vacia(pila_saltos_comparacion) && aux_cantidad_comparaciones_if[aux_if_id] > 0)
        {
          pila_punteros_desapilar(pila_saltos_comparacion, &terceto_salto_comparacion);
          gci_tercetos_actualizar_salto_con_etiqueta(terceto_salto_comparacion, etiqueta_inicio_else);
          aux_cantidad_comparaciones_if[aux_if_id]--;
        }

        pila_punteros_apilar(pila_saltos_comparacion, aux_terceto_salto_comparacion);

        aux_if_id--;
    } LLAVES_A instrucciones LLAVES_C
    {
        void* etiqueta_fin_if_else = gci_tercetos_agregar_etiqueta();
        
        void* terceto_salto_comparacion;
        pila_punteros_desapilar(pila_saltos_comparacion, &terceto_salto_comparacion);
        gci_tercetos_actualizar_salto_con_etiqueta(terceto_salto_comparacion, etiqueta_fin_if_else);
    }
  ;
condicional:
  condicion_compuesta 
  {
    informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICIONAL, "condicion_compuesta");
    punteros_simbolos_no_terminales_condicional = punteros_simbolos_no_terminales_condicion_compuesta;

    if (!pila_punteros_esta_vacia(pila_saltos_or))
    {
      void* etiqueta_continuacion_or = gci_tercetos_agregar_etiqueta();
      
      void* terceto_salto_comparacion;
      while(!pila_punteros_esta_vacia(pila_saltos_or))
      {
        pila_punteros_desapilar(pila_saltos_or, &terceto_salto_comparacion);
        gci_tercetos_actualizar_salto_con_etiqueta(terceto_salto_comparacion, etiqueta_continuacion_or);
      }
    }
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
    }
  | condicion_compuesta OR 
  {
    
    void* terceto_salto_comparacion;
    pila_punteros_desapilar(pila_saltos_comparacion, &terceto_salto_comparacion);
    gci_tercetos_actualizar_primera_posicion(terceto_salto_comparacion, utils_obtener_salto_comparacion_opuesto(salto_comparacion));
    pila_punteros_apilar(pila_saltos_or, terceto_salto_comparacion);

  } condicion_unaria 
    {
      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA, 
        "condicion_compuesta OR condicion_unaria");
    }
  ;

condicion_unaria:
  NOT 
  {
    aux_condicion_not = 1; // Empieza el NOT
  } condicion_unaria 
  {
    informes_sintactico_imprimir_mensaje(
      SIMBOLOS_NO_TERMINALES_CONDICION_UNARIA, 
      "NOT condicion_unaria");

    aux_condicion_not = 0; // Termina el NOT
  }
  | predicado 
    {
      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_CONDICION_UNARIA, "predicado");
      punteros_simbolos_no_terminales_condicion_unaria = punteros_simbolos_no_terminales_predicado;
    }
  ;

predicado:
  expresion {
      tipo_dato_comparacion_aux = tipo_dato_aux;
  } operador_comparacion expresion 
    {
      void* segunda_expresion = pila_desapilar(pila_expresion);
      void* primera_expresion = pila_desapilar(pila_expresion);

      if (tipo_dato_aux != tipo_dato_comparacion_aux) 
      {
        informes_semantico_imprimir_mensaje("Error de tipos en la comparacion de expresiones.");
        exit(1);
      }

      informes_sintactico_imprimir_mensaje(
        SIMBOLOS_NO_TERMINALES_PREDICADO, 
        "expresion operador_comparacion expresion");

      punteros_simbolos_no_terminales_predicado = gci_tercetos_agregar_terceto(
                                                    "CMP", 
                                                    primera_expresion, 
                                                    segunda_expresion);

      if (aux_condicion_not)
      {
        aux_terceto_salto_comparacion = gci_tercetos_agregar_terceto(
          utils_obtener_salto_comparacion_opuesto(salto_comparacion), // Saltos: BGE, BGT, BLT, BLE, BNE. BEQ
          NULL, 
          NULL);
      }
      else
      {
        aux_terceto_salto_comparacion = gci_tercetos_agregar_terceto(
          salto_comparacion, // Saltos: BGE, BGT, BLT, BLE, BNE. BEQ
          NULL, 
          NULL);
      }
      pila_punteros_apilar(pila_saltos_comparacion, aux_terceto_salto_comparacion);
      aux_cantidad_comparaciones_if[aux_if_id]++;
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

      funcion_booleana_aux = 1;
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
  expresion 
  {
    pila_apilar(
      pila_expresion, 
      punteros_simbolos_no_terminales_expresion, 
      tamano_terceto);
  } SUMA termino 
    {
      t_tipo_dato* tipo_dato_a = pila_desapilar(pila_tipo_dato);
      t_tipo_dato* tipo_dato_b = pila_desapilar(pila_tipo_dato);

      t_tipo_dato tipo_dato_resultante = semantico_obtener_tipo_de_dato_resultante(
        *tipo_dato_b,
        *tipo_dato_a);

      if (tipo_dato_resultante == TIPO_DATO_DESCONOCIDO)
      {
        exit(1);
      }

      pila_apilar(pila_tipo_dato, &tipo_dato_resultante, tamano_tipo_dato);
      tipo_dato_aux = tipo_dato_resultante;

      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion SUMA termino");
      punteros_simbolos_no_terminales_expresion = pila_desapilar(pila_expresion);
      punteros_simbolos_no_terminales_expresion = gci_tercetos_agregar_terceto(
        "+",
        punteros_simbolos_no_terminales_expresion,
        punteros_simbolos_no_terminales_termino
      );
      pila_apilar(
        pila_expresion, 
        punteros_simbolos_no_terminales_expresion, 
       tamano_terceto);
    }
  |expresion 
  {
    pila_apilar(
      pila_expresion, 
      punteros_simbolos_no_terminales_expresion, 
      tamano_terceto);
  } RESTA termino 
    {
      t_tipo_dato* tipo_dato_a = pila_desapilar(pila_tipo_dato);
      t_tipo_dato* tipo_dato_b = pila_desapilar(pila_tipo_dato);

      t_tipo_dato tipo_dato_resultante = semantico_obtener_tipo_de_dato_resultante(
        *tipo_dato_b,
        *tipo_dato_a);

      if (tipo_dato_resultante == TIPO_DATO_DESCONOCIDO)
      {
        exit(1);
      }

      pila_apilar(pila_tipo_dato, &tipo_dato_resultante, tamano_tipo_dato);
      tipo_dato_aux = tipo_dato_resultante;

      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_EXPRESION, "expresion RESTA termino");
      punteros_simbolos_no_terminales_expresion = pila_desapilar(pila_expresion);
      punteros_simbolos_no_terminales_expresion = gci_tercetos_agregar_terceto(
        "-",
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
  termino 
  {
    pila_apilar(
      pila_termino, 
      punteros_simbolos_no_terminales_termino, 
      tamano_terceto);
  } MULTIPLICACION factor 
    {
      t_tipo_dato* tipo_dato_a = pila_desapilar(pila_tipo_dato);
      t_tipo_dato* tipo_dato_b = pila_desapilar(pila_tipo_dato);

      t_tipo_dato tipo_dato_resultante = semantico_obtener_tipo_de_dato_resultante(
        *tipo_dato_b,
        *tipo_dato_a);

      if (tipo_dato_resultante == TIPO_DATO_DESCONOCIDO)
      {
        exit(1);
      }

      pila_apilar(pila_tipo_dato, &tipo_dato_resultante, tamano_tipo_dato);
      tipo_dato_aux = tipo_dato_resultante;

      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "termino MULTIPLICACION factor");
      punteros_simbolos_no_terminales_termino = pila_desapilar(pila_termino);
      punteros_simbolos_no_terminales_termino = gci_tercetos_agregar_terceto(
        "*", 
        punteros_simbolos_no_terminales_termino, 
        punteros_simbolos_no_terminales_factor);
    }
  |termino 
  {
    pila_apilar(
      pila_termino, 
      punteros_simbolos_no_terminales_termino, 
      tamano_terceto);
  } DIVISION factor 
    {
      t_tipo_dato* tipo_dato_a = pila_desapilar(pila_tipo_dato);
      t_tipo_dato* tipo_dato_b = pila_desapilar(pila_tipo_dato);

      t_tipo_dato tipo_dato_resultante = semantico_obtener_tipo_de_dato_resultante(
        *tipo_dato_b,
        *tipo_dato_a);

      if (tipo_dato_resultante == TIPO_DATO_DESCONOCIDO)
      {
        exit(1);
      }

      pila_apilar(pila_tipo_dato, &tipo_dato_resultante, tamano_tipo_dato);
      tipo_dato_aux = tipo_dato_resultante;

      informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_TERMINO, "termino DIVISION factor");
      punteros_simbolos_no_terminales_termino = pila_desapilar(pila_termino);
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
    
    if (!semantico_validacion_existe_simbolo_en_tabla_simbolos($1)) {
      exit(1);
    }
    
    t_tabla_simbolos_dato *simbolo = tabla_simbolos_obtener_dato($1);
    if (simbolo != NULL) {
      pila_apilar(pila_tipo_dato, &(simbolo->tipo_dato), tamano_tipo_dato);
      tipo_dato_aux = simbolo->tipo_dato;
    }
  }
  | CTE_INT 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_INT");
        punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto($1, NULL, NULL);
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_INT, $1);
        
        tipo_dato_aux = TIPO_DATO_INT;
        pila_apilar(pila_tipo_dato, &tipo_dato_aux, tamano_tipo_dato);
      }
  | CTE_FLOAT 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_FLOAT");
        punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto($1, NULL, NULL);
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_FLOAT, $1);
        
        tipo_dato_aux = TIPO_DATO_FLOAT;
        pila_apilar(pila_tipo_dato, &tipo_dato_aux, tamano_tipo_dato);
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
        
        tipo_dato_aux = TIPO_DATO_INT;
        pila_apilar(pila_tipo_dato, &tipo_dato_aux, tamano_tipo_dato);
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

        tipo_dato_aux = TIPO_DATO_FLOAT;
        pila_apilar(pila_tipo_dato, &tipo_dato_aux, tamano_tipo_dato);
      }
  | RESTA ID
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "RESTA ID");
        if (!semantico_validacion_existe_simbolo_en_tabla_simbolos($2)) {
          exit(1);
        }

        t_tabla_simbolos_dato *simbolo = tabla_simbolos_obtener_dato($2);
        if (simbolo != NULL) {
          pila_apilar(pila_tipo_dato, &(simbolo->tipo_dato), tamano_tipo_dato);
          tipo_dato_aux = simbolo->tipo_dato;
        }

      }
  | CTE_STRING 
      {
        informes_sintactico_imprimir_mensaje(SIMBOLOS_NO_TERMINALES_FACTOR, "CTE_STRING");
        tabla_simbolos_insertar_dato($1, TIPO_DATO_CTE_STRING, $1);
        
        t_tabla_simbolos_dato* dato = NULL;
        t_tabla_simbolos_nodo* nodo = tabla_simbolos.primero;
        while (nodo != NULL) {
            if (nodo->dato.tipo_dato == TIPO_DATO_CTE_STRING && 
                strcmp(nodo->dato.valor, $1) == 0) {
                dato = &(nodo->dato);
                break;
            }
            nodo = nodo->siguiente;
        }
        
        const char* nombre_a_usar = (dato != NULL) ? dato->nombre : $1;
        punteros_simbolos_no_terminales_factor = gci_tercetos_agregar_terceto(nombre_a_usar, NULL, NULL);
        
        tipo_dato_aux = TIPO_DATO_CTE_STRING;
        pila_apilar(pila_tipo_dato, &tipo_dato_aux, tamano_tipo_dato);
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
  pila_triangulo = pila_crear();
  pila_coordenada = pila_crear();
  pila_tipo_dato = pila_crear();
  pila_termino = pila_crear();
  
  
  pila_saltos_comparacion = pila_punteros_crear();
  pila_ciclos_while = pila_punteros_crear();
  pila_saltos_or = pila_punteros_crear();
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