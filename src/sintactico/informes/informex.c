#include <stdio.h>
#include "./informes.h"
#include "../../utils.h"

void print_sintactico(const char *produccion, const char *no_terminal)
{
    printf(
        COLOR_MAGENTA "[SINTACTICO]" COLOR_RESET " " COLOR_WHITE "%s -> %s\n", no_terminal, produccion);
}

void informar_error_sintactico(
    int nro_linea,
    const char *terminal)
{
    printf(COLOR_RED "[ERROR SINTACTICO] Linea: %d" COLOR_RESET "\n", nro_linea);
    printf(COLOR_RED "[ERROR SINTACTICO] Token inesperado: %s" COLOR_RESET "\n", terminal ? terminal : "EOF");
}

void informar_error_generico(const char *mensaje)
{
    printf(COLOR_RED "[ERROR] %s" COLOR_RESET "\n", mensaje);
}