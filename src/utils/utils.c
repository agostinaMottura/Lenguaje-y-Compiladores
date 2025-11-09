#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "../validaciones/validaciones.h"
#include "./utils.h"

// Declaración explícita de strdup para evitar warnings
char *strdup(const char *s);

void utils_imprimir_error(const char *mensaje)
{
    printf(UTILS_COLOR_RED "[ERROR] %s" UTILS_COLOR_RESET "\n", mensaje);
}

const char *utils_obtener_string_sin_comillas(const char *str)
{
    char *literal = strdup(str + 1);
    literal[strlen(literal) - 1] = '\0';

    return literal;
}

const char *utils_obtener_string_numero_negativo(const char *nro)
{
    static char str[VALIDACIONES_MAX_LONGITUD_STRING];
    
    // Limpia el buffer antes de usarlo
    str[0] = '\0';
    
    strcat(str, "-");
    strcat(str, nro);

    return str;
}

const char* utils_obtener_salto_comparacion_opuesto(const char* salto_comparacion)
{
    if (strcmp(salto_comparacion, "BLE") == 0)
    {
        return "BGT";
    }

    if (strcmp(salto_comparacion, "BNE") == 0)
    {
        return "BEQ";
    }

    if (strcmp(salto_comparacion, "BEQ") == 0)
    {
        return "BNE";
    }

    if (strcmp(salto_comparacion, "BGE") == 0)
    {
        return "BLT";
    }
    
    if (strcmp(salto_comparacion, "BGT") == 0)
    {
        return "BLE";
    }
    
    if (strcmp(salto_comparacion, "BLT") == 0)
    {
        return "BGE";
    }

    utils_imprimir_error("Salto de comparacion incorrecto");
    exit(1);
}