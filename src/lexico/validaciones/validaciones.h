#ifndef VALIDACIONES_LEXICO_H
#define VALIDACIONES_LEXICO_H

#define VALIDACIONES_LEXICO_MAX_MENSAJE_ERROR_LONGITUD 100

#define VALIDACIONES_LEXICO_MAX_VALOR_INT 65535
#define VALIDACIONES_LEXICO_MAX_LONGITUD_INT 5

#define VALIDACIONES_LEXICO_MAX_VALOR_FLOAT 3.40282e+38f
#define VALIDACIONES_LEXICO_MIN_VALOR_FLOAT 1.17549e-38f

typedef struct
{
    int es_valido;
    char mensaje_error[VALIDACIONES_LEXICO_MAX_MENSAJE_ERROR_LONGITUD];
    char aclaracion[VALIDACIONES_LEXICO_MAX_MENSAJE_ERROR_LONGITUD];
} t_validaciones_lexico_resultado_validacion;

t_validaciones_lexico_resultado_validacion validaciones_lexico_es_string_valido(char cadena[]);
t_validaciones_lexico_resultado_validacion validaciones_lexico_es_float_valido(char *cadena);
t_validaciones_lexico_resultado_validacion validaciones_lexico_es_int_valido(char *cadena);

#endif // VALIDACIONES_LEXICO_H