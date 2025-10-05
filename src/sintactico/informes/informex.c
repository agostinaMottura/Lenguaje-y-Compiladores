#include <stdio.h>
#include "./informes.h"
#include "../../utils.h"

void print_sintactico(const char *no_terminal, const char *produccion)
{
    printf(
        UTILS_COLOR_MAGENTA "[SINTACTICO]" UTILS_COLOR_RESET " " UTILS_COLOR_WHITE "%s -> %s\n", no_terminal, produccion);
}

void informar_error_sintactico(
    int nro_linea,
    const char *terminal)
{
    printf(UTILS_COLOR_RED "[ERROR SINTACTICO] Linea: %d" UTILS_COLOR_RESET "\n", nro_linea);
    printf(UTILS_COLOR_RED "[ERROR SINTACTICO] Token inesperado: %s" UTILS_COLOR_RESET "\n", terminal ? terminal : "EOF");
}

void informar_error_generico(const char *mensaje)
{
    printf(UTILS_COLOR_RED "[ERROR] %s" UTILS_COLOR_RESET "\n", mensaje);
}