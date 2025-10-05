#ifndef INFORMES_SINTACTICO_H
#define INFORMES_SINTACTICO_H

void informes_sintactico_imprimir_mensaje(const char *no_terminal, const char *produccion);
void informes_sintactico_imprimir_error(
    int nro_linea,
    const char *terminal);

#endif // INFORMES_SINTACTICO_H