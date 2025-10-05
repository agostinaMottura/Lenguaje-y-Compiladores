#include <stdio.h>
#include "../../utils.h"
#include "./informes.h"

void informes_tabla_simbolos_imprimir_mensaje(const char *mensaje)
{
    printf(
        UTILS_COLOR_BLUE "[TABLA_SIMBOLOS]" UTILS_COLOR_RESET " %s\n", mensaje);
}