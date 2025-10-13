#include <stdio.h>
#include "../../utils/utils.h"
#include "./informes.h"

void informes_pila_punteros_imprimir_mensaje(const char *mensaje)
{
    printf(
        UTILS_COLOR_MAGENTA "[PILA_PUNTEROS]" UTILS_COLOR_RESET " %s\n", mensaje);
}