#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* --- Estructura de la tabla de simbolos --- */

typedef struct
{
    char *nombre;
    char *tipo;
    union Valor{
        int valor_var_int;
        float valor_var_float;
        char *valor_var_str;
    }valor;
    int longitud;
}t_data;

typedef struct s_simbolo
{
    t_data data;
    struct s_simbolo *next;
}t_simbolo;

typedef struct
{
    t_simbolo *primero;
}t_tabla;

typedef struct{
    char cadena[40];
}t_nombresId;

// Variables globales
extern t_tabla tabla_simbolos;

// Declaración de funciones
void crear_tabla_simbolos();
int insertar_tabla_simbolos(const char*, const char*, const char*, int, float);
t_data* crearDatos(const char*, const char*, const char*, int, float);
void guardar_tabla_simbolos();

#endif // TABLA_SIMBOLOS_H
