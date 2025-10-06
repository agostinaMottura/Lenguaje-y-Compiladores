#include <stdio.h>
#include <string.h>
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