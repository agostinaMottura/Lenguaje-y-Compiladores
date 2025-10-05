#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./tipo-dato/tipo_dato.h"

#define TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE "NOMBRE"
#define TABLA_SIMBOLOS_VALOR_COLUMNA_TIPO_DATO "TIPO_DATO"
#define TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR "VALOR"
#define TABLA_SIMBOLOS_VALOR_COLUMNA_LONGITUD "LONGITUD"

// Esto no va aca
#define TABLA_SIMBOLOS_MAX_VALOR_LONGITUD 20

#define TABLA_SIMBOLOS_MAX_STRING_NOMBRE_LONGITUD 100

/* --- Estructura de la tabla de simbolos --- */

typedef struct
{
    char *nombre;
    t_tipo_dato tipo_dato;
    char *valor;
    int longitud;
} t_dato;

typedef struct nodo
{
    t_dato dato;
    struct nodo *siguiente;
} t_nodo;

typedef struct
{
    t_nodo *primero;
} t_tabla_simbolos;

// Variables globales
extern t_tabla_simbolos tabla_simbolos;

// Declaración de funciones
void tabla_simbolos_crear();
int tabla_simbolos_insertar_dato(const char *nombre, t_tipo_dato tipo_dato, const char *valor);
t_dato *tabla_simbolos_crear_dato(
    const char *nombre,
    t_tipo_dato tipo_dato,
    const char *valor);
void tabla_simbolos_guardar();

#endif // TABLA_SIMBOLOS_H
