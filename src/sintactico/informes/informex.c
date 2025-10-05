#include <stdio.h>
#include "./informes.h"
#include "../../utils.h"

void informes_sintactico_imprimir_mensaje(const char *no_terminal, const char *produccion)
{
    printf(
        UTILS_COLOR_MAGENTA "[SINTACTICO]" UTILS_COLOR_RESET " " UTILS_COLOR_WHITE "%s -> %s\n", no_terminal, produccion);
}

void informes_sintactico_imprimir_error(
    int nro_linea,
    const char *terminal)
{
    printf(UTILS_COLOR_RED "[ERROR SINTACTICO] Linea: %d" UTILS_COLOR_RESET "\n", nro_linea);
    printf(UTILS_COLOR_RED "[ERROR SINTACTICO] Token inesperado: %s" UTILS_COLOR_RESET "\n", terminal ? terminal : "EOF");
}