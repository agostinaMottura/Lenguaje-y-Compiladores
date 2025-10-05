#include <stdio.h>
#include "../../utils.h"
#include "./informes.h"

void informes_lexico_imprimir_mensaje(
    int nro_token,
    int nro_linea,
    const char *terminal,
    const char *lexema)
{
    printf(
        UTILS_COLOR_CYAN "[LEXICO]" UTILS_COLOR_RESET " " UTILS_COLOR_YELLOW "Token #%d" UTILS_COLOR_RESET " | " UTILS_COLOR_WHITE "Linea %d" UTILS_COLOR_RESET " | " UTILS_COLOR_GREEN "%s" UTILS_COLOR_RESET " | " UTILS_COLOR_NARANJA "Valor: %s" UTILS_COLOR_RESET "\n",

        nro_token,
        nro_linea,
        terminal,
        lexema);
}

void informes_lexico_imprimir_error(const char *mensaje, const char *lexema, const char *detalle)
{
    fprintf(stderr, "Error léxico: %s\n", mensaje);
    fprintf(stderr, "Lexema: %s\n", lexema);
    fprintf(stderr, "Detalle: %s\n", detalle);
}
