#ifndef INFORMES_H
#define INFORMES_H

void print_sintactico(const char *produccion, const char *no_terminal);
void informar_error_sintactico(
    int nro_linea,
    const char *terminal);
void informar_error_generico(const char *mensaje);

#endif // INFORMES_H