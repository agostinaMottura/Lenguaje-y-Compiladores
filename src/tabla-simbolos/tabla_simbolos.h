#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./tipo-dato/tipo_dato.h"

#define VALOR_COLUMNA_NOMBRE "NOMBRE"
#define VALOR_COLUMNA_TIPO_DATO "TIPO_DATO"
#define VALOR_COLUMNA_VALOR "VALOR"
#define VALOR_COLUMNA_LONGITUD "LONGITUD"

#define MAX_ID_LONGITUD 55

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

typedef struct
{
    char cadena[MAX_ID_LONGITUD];
} t_nombre_id;

// Variables globales
extern t_tabla_simbolos tabla_simbolos;

// Declaración de funciones
void crear_tabla_simbolos();
int insertar_tabla_simbolos(const char *nombre, t_tipo_dato tipo_dato, const char *valor);
t_dato *crearDatos(
    const char *nombre,
    t_tipo_dato tipo_dato,
    const char *valor);
void guardar_tabla_simbolos();

#endif // TABLA_SIMBOLOS_H
