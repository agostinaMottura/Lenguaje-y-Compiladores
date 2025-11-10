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

typedef struct
{
    char *nombre;
    t_tipo_dato tipo_dato;
    char *valor;
    int longitud;
} t_tabla_simbolos_dato;

typedef struct tabla_simbolos_nodo
{
    t_tabla_simbolos_dato dato;
    struct tabla_simbolos_nodo *siguiente;
} t_tabla_simbolos_nodo;

typedef struct
{
    t_tabla_simbolos_nodo *primero;
} t_tabla_simbolos;

// Variables globales
extern t_tabla_simbolos tabla_simbolos;

// Declaración de funciones
void tabla_simbolos_crear();
void tabla_simbolos_guardar();

int tabla_simbolos_insertar_dato(const char *nombre, t_tipo_dato tipo_dato, const char *valor);

t_tabla_simbolos_dato *tabla_simbolos_crear_dato(
    const char *nombre,
    t_tipo_dato tipo_dato,
    const char *valor);

t_tabla_simbolos_dato *tabla_simbolos_obtener_dato(const char *nombre);

// Función para verificar si un dato existe en la tabla de símbolos
int tabla_simbolos_existe_dato(const char *nombre);

const char *tabla_simbolos_buscar_nombre_por_valor(
    t_tabla_simbolos *tabla, const char *valor);

#endif // TABLA_SIMBOLOS_H
