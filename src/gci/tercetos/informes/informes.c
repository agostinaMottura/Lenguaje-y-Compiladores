#include <stdio.h>
#include "../../../utils/utils.h"

void informes_gci_tercetos_imprimir_mensaje(const char *mensaje)
{
    printf(
        UTILS_COLOR_NARANJA "[GCI_TERCETOS]" UTILS_COLOR_RESET " %s\n", mensaje);
}

void informes_gci_tercetos_imprimir_error(const char *mensaje)
{
    printf(
        UTILS_COLOR_RED "[GCI_TERCETOS]" UTILS_COLOR_RESET " %s\n", mensaje);
}