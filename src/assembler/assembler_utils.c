#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../utils/utils.h"
#include "./assembler_utils.h"

#define ASSEMBLER_MAX_INDEX_BUFFER 64

/* ========== UTILIDADES GENERALES ========== */

void imprimir_error(const char *mensaje) {
    utils_imprimir_error(mensaje);
    exit(1);
}

int es_valor_nulo_o_vacio(const char *valor) {
    return !valor || strcmp(valor, "__") == 0 || strlen(valor) == 0;
}

/* ========== TIPOS DE DATO Y MAPEOS ========== */

const char *obtener_tipo_asm(const t_tabla_simbolos_dato *dato) {
    switch (dato->tipo_dato) {
        case TIPO_DATO_CTE_INT:
        case TIPO_DATO_CTE_FLOAT:
        case TIPO_DATO_INT:
        case TIPO_DATO_FLOAT:
            return "dd";
        case TIPO_DATO_CTE_STRING:
        case TIPO_DATO_STRING:
            return "db";
        default:
            return "dd";
    }
}

const char *mapear_operador_aritmetico(const char *op) {
    if (!op) return NULL;
    if (strcmp(op, "+") == 0) return "FADD";
    if (strcmp(op, "-") == 0) return "FSUB";
    if (strcmp(op, "*") == 0) return "FMUL";
    if (strcmp(op, "/") == 0) return "FDIV";
    return NULL;
}

const char *mapear_salto_condicional(const char *op) {
    if (!op) return NULL;
    if (strcmp(op, "BLE") == 0) return "JBE";
    if (strcmp(op, "BLT") == 0) return "JB";
    if (strcmp(op, "BGT") == 0) return "JA";
    if (strcmp(op, "BGE") == 0) return "JAE";
    if (strcmp(op, "BEQ") == 0) return "JE";
    if (strcmp(op, "BNE") == 0) return "JNE";
    if (strcmp(op, "BI") == 0) return "JMP";
    return NULL;
}

/* ========== PARSEO DE ÍNDICES ========== */

int parsear_indice(const char *s, int *indice) {
    if (!s || strlen(s) < 3) return 0;
    
    char buffer[ASSEMBLER_MAX_INDEX_BUFFER];
    size_t len = strlen(s) - 2;
    
    if (len >= ASSEMBLER_MAX_INDEX_BUFFER) return 0;
    
    memcpy(buffer, s + 1, len);
    buffer[len] = '\0';
    
    char *endptr;
    long val = strtol(buffer, &endptr, 10);
    
    if (endptr == buffer || *endptr != '\0') return 0;
    
    *indice = (int)val;
    return 1;
}

/* ========== PREDICADOS ========== */

int es_operador_aritmetico(const char *op) {
    if (!op) return 0;
    return strcmp(op, "+") == 0 || strcmp(op, "-") == 0 ||
           strcmp(op, "*") == 0 || strcmp(op, "/") == 0;
}

int es_etiqueta(const char *token) {
    return token && strncmp(token, "etiqueta_", 9) == 0;
}

int es_tipo_string(const t_tabla_simbolos_dato *dato) {
    return dato && (dato->tipo_dato == TIPO_DATO_CTE_STRING ||
                    dato->tipo_dato == TIPO_DATO_STRING);
}


