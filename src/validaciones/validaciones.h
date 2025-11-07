#ifndef VALIDACIONES_H
#define VALIDACIONES_H

#define VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD 100

#define VALIDACIONES_MAX_LONGITUD_STRING 50

#define VALIDACIONES_MAX_VALOR_INT 65535
#define VALIDACIONES_MAX_LONGITUD_INT 5

#define VALIDACIONES_MAX_VALOR_FLOAT 3.40282e+38f
#define VALIDACIONES_MIN_VALOR_FLOAT 1.17549e-38f
#define VALIDACIONES_FLOAT_CERO 0.0f

#define VALIDACIONES_MAX_IDS_DECLARADOS 10

typedef struct
{
    int es_valido;
    char mensaje_error[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
    char aclaracion[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
} t_validaciones_resultado_validacion;

typedef struct
{
    char cadena[VALIDACIONES_MAX_IDS_DECLARADOS];
} t_validaciones_nombre_id;

t_validaciones_resultado_validacion validaciones_es_string_valido(char cadena[]);
t_validaciones_resultado_validacion validaciones_es_float_valido(char *cadena);
t_validaciones_resultado_validacion validaciones_es_int_valido(char *cadena);

#endif // VALIDACIONES_H