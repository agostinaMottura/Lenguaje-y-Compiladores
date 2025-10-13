#include <stdio.h>
#include "../../utils/utils.h"
#include "./informes.h"

void informes_semantico_imprimir_mensaje(const char *mensaje)
{
    printf(
        UTILS_COLOR_RED "[SEMANTICO]" UTILS_COLOR_RESET " %s\n", mensaje);
}