#include <stdio.h>
#include <string.h>
#include "../tabla-simbolos/tabla_simbolos.h"
#include "../tabla-simbolos/tipo-dato/tipo_dato.h"
#include "../valores/valores.h"
#include "../tabla-simbolos/informes/informes.h"

#define VAR_AUX_PREFIX "@var_aux_"
#define VAR_AUX_PREFIX_LEN 9

// Verifica si una cadena comienza con el prefijo de variable auxiliar
static int es_variable_auxiliar(const char* nombre) {
    return nombre != NULL && 
           strlen(nombre) > VAR_AUX_PREFIX_LEN &&
           strncmp(nombre, VAR_AUX_PREFIX, VAR_AUX_PREFIX_LEN) == 0;
}

void cargar_variable_auxiliar_si_no_existe(const char* nombre_variable, t_tipo_dato tipo) {
    // Verificamos que:
    // 1. Sea una variable auxiliar válida (comienza con @var_aux_)
    // 2. No exista ya en la tabla de símbolos
    if (es_variable_auxiliar(nombre_variable) && 
        !tabla_simbolos_existe_dato(nombre_variable)) {
            
        // Insertamos la variable auxiliar en la tabla de símbolos
        if (!tabla_simbolos_insertar_dato(nombre_variable, tipo, VALORES_NULL)) {
            char mensaje[100];
            sprintf(mensaje, "Error al insertar la variable auxiliar %s en la tabla de símbolos", nombre_variable);
            informes_tabla_simbolos_imprimir_mensaje(mensaje);
        }
    }
}