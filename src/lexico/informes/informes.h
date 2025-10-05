#ifndef INFORMES_LEXICO_H
#define INFORMES_LEXICO_H

void print_lexico(
    int nro_token,
    int nro_linea,
    const char *terminal,
    const char *lexema);
void informar_error_lexico(const char *mensaje, const char *lexema, const char *detalle);

#endif // INFORMES_LEXICO_H