#ifndef VALIDACIONES_LEXICO_H
#define VALIDACIONES_LEXICO_H

#define MAX_MSG_ERROR_LONGITUD 100

#define MAX_STRING_LONGITUD 50

#define MAX_INT_VALOR 65535
#define MAX_INT_LONGITUD 5

#define MAX_FLOAT_VALOR 3.40282e+38f
#define MIN_FLOAT_VALOR 1.17549e-38f

typedef struct
{
    int es_valido;
    char mensaje_error[MAX_MSG_ERROR_LONGITUD];
    char aclaracion[MAX_MSG_ERROR_LONGITUD];
} ResultadoValidacion;

ResultadoValidacion es_string_valido(char cadena[]);
ResultadoValidacion es_float_valido(char *cadena);
ResultadoValidacion es_int_valido(char *cadena);

#endif // VALIDACIONES_LEXICO_H