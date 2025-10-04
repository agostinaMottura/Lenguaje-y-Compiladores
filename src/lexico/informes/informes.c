#include <stdio.h>
#include "../../utils.h"
#include "./informes.h"

void print_lexico(
    int nro_token,
    int nro_linea,
    const char *terminal,
    const char *lexema)
{
    printf(
        COLOR_CYAN "[LEXICO]" COLOR_RESET " " COLOR_YELLOW "Token #%d" COLOR_RESET " | " COLOR_WHITE "Linea %d" COLOR_RESET " | " COLOR_GREEN "%s" COLOR_RESET " | " COLOR_NARANJA "Valor: %s" COLOR_RESET "\n",

        nro_token,
        nro_linea,
        terminal,
        lexema);
}

void informar_error_lexico(const char *mensaje, const char *lexema, const char *detalle)
{
    fprintf(stderr, "Error léxico: %s\n", mensaje);
    fprintf(stderr, "Lexema: %s\n", lexema);
    fprintf(stderr, "Detalle: %s\n", detalle);
}
