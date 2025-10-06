#ifndef INFORMES_SINTACTICO_H
#define INFORMES_SINTACTICO_H

#include "../../simbolos/no-terminales/no_terminales.h"

void informes_sintactico_imprimir_mensaje(t_simbolos_no_terminales no_terminal, const char *produccion);
void informes_sintactico_imprimir_error(
    int nro_linea,
    const char *terminal);

#endif // INFORMES_SINTACTICO_H