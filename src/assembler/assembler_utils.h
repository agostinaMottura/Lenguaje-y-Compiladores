#ifndef ASSEMBLER_UTILS_H
#define ASSEMBLER_UTILS_H

#include "../tabla-simbolos/tabla_simbolos.h"

/* Utilidades */
void imprimir_error(const char *mensaje);
int es_valor_nulo_o_vacio(const char *valor);

/* Mapeos */
const char *obtener_tipo_asm(const t_tabla_simbolos_dato *dato);
const char *mapear_operador_aritmetico(const char *op);
const char *mapear_salto_condicional(const char *op);

/* Parseos */
int parsear_indice(const char *s, int *indice);

/* Predicados */
int es_operador_aritmetico(const char *op);
int es_etiqueta(const char *token);
int es_tipo_string(const t_tabla_simbolos_dato *dato);

#endif


