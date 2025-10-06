#include <stdio.h>
#include <string.h>
#include "../validaciones/validaciones.h"
#include "./utils.h"

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

    strcat(str, "-");
    strcat(str, nro);

    return str;
}