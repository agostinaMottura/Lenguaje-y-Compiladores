#ifndef ASSEMBLER_UTILS_H
#define ASSEMBLER_UTILS_H

#include <stdio.h>
#include "../tabla-simbolos/tabla_simbolos.h"

void assembler_utils_escribir_dato(
    FILE *f, 
    const t_tabla_simbolos_dato *dato);

int assembler_utils_es_etiqueta(const char *token);
int assembler_utils_es_operador_aritmetico(const char *op);
int assembler_utils_es_tipo_string(const t_tabla_simbolos_dato *dato);
int assembler_utils_es_valor_nulo_o_vacio(const char *valor);

const char *assembler_utils_obtener_tipo(const t_tabla_simbolos_dato *dato);
const char *assembler_utils_mapear_operador_aritmetico(const char *op);
const char *assembler_utils_mapear_salto_condicional(const char *op);

#endif // ASSEMBLER_UTILS_H