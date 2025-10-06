#include <stdio.h>
#include "./informes.h"
#include "../../../utils/utils.h"

void informes_arbol_sintactico_imprimir_mensaje(const char *mensaje)
{
    printf(
        UTILS_COLOR_NARANJA "[ARBOL_SINTACTICO]" UTILS_COLOR_RESET " %s\n", mensaje);
}

void informes_arbol_sintactico_imprimir_error(const char *mensaje)
{
    printf(
        UTILS_COLOR_RED "[ERROR_ARBOL_SINTACTICO]" UTILS_COLOR_RESET " %s\n", mensaje);
}