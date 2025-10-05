#ifndef INFORMES_SINTACTICO_H
#define INFORMES_SINTACTICO_H

void print_sintactico(const char *no_terminal, const char *produccion);
void informar_error_sintactico(
    int nro_linea,
    const char *terminal);
void informar_error_generico(const char *mensaje);

#endif // INFORMES_SINTACTICO_H