#include <stdio.h>
#include "./informes.h"
#include "../../utils/utils.h"

void informes_sintactico_imprimir_mensaje(t_simbolos_no_terminales no_terminal, const char *produccion)
{
    const char *no_terminal_valor = simbolos_no_terminales_obtener_valor(no_terminal);
    printf(
        UTILS_COLOR_MAGENTA "[SINTACTICO]" UTILS_COLOR_RESET " " UTILS_COLOR_WHITE "%s -> %s\n", no_terminal_valor, produccion);
}

void informes_sintactico_imprimir_error(
    int nro_linea,
    const char *terminal)
{
    printf(UTILS_COLOR_RED "[ERROR SINTACTICO] Linea: %d" UTILS_COLOR_RESET "\n", nro_linea);
    printf(UTILS_COLOR_RED "[ERROR SINTACTICO] Token inesperado: %s" UTILS_COLOR_RESET "\n", terminal ? terminal : "EOF");
}