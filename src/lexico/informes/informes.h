#ifndef INFORMES_LEXICO_H
#define INFORMES_LEXICO_H

void informes_lexico_imprimir_mensaje(
    int nro_token,
    int nro_linea,
    const char *terminal,
    const char *lexema);
void informes_lexico_imprimir_error(const char *mensaje, const char *lexema, const char *detalle);

#endif // INFORMES_LEXICO_H