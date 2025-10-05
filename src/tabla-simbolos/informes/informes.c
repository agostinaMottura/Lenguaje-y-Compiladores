#include <stdio.h>
#include "../../utils.h"
#include "./informes.h"

void informes_tabla_simbolos_imprimir_mensaje(const char *mensaje)
{
    printf(
        COLOR_BLUE "[TABLA_SIMBOLOS]" COLOR_RESET " %s\n", mensaje);
}