#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "./validaciones.h"

t_validaciones_lexico_resultado_validacion validaciones_lexico_es_string_valido(char cadena[])
{
    t_validaciones_lexico_resultado_validacion resultado;
    int largo = strlen(cadena);

    if (largo > MAX_STRING_LONGITUD)
    {
        resultado.es_valido = 0;
        sprintf(resultado.aclaracion, "Se permite un maximo de %d caracteres", MAX_STRING_LONGITUD);
        sprintf(resultado.mensaje_error, "Cadena de texto supera el maximo de caracteres permitido");
        return resultado;
    }

    resultado.es_valido = 1;
    return resultado;
}

t_validaciones_lexico_resultado_validacion validaciones_lexico_es_float_valido(char *cadena)
{
    t_validaciones_lexico_resultado_validacion resultado;
    char *endptr;
    double numero = strtod(cadena, &endptr); // strtod convierte la cadena a double y deja en endptr un puntero al primer carácter que no pudo convertir.

    if (*endptr != '\0')
    {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Formato de float invalido");
        sprintf(resultado.aclaracion, "Debe ser un numero decimal");
        return resultado;
    }

    float numero_float = (float)numero;

    if (numero_float < VALIDACIONES_LEXICO_MIN_VALOR_FLOAT || numero_float > VALIDACIONES_LEXICO_MAX_VALOR_FLOAT)
    {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Float fuera de rango");
        sprintf(resultado.aclaracion, "Floats validos entre %.5e y %.5e", VALIDACIONES_LEXICO_MIN_VALOR_FLOAT, VALIDACIONES_LEXICO_MAX_VALOR_FLOAT);
        return resultado;
    }

    if (isnan(numero_float))
    {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Float no es un numero (NaN)");
        sprintf(resultado.aclaracion, "Debe ser un numero decimal valido");
        return resultado;
    }

    resultado.es_valido = 1;
    return resultado;
}

t_validaciones_lexico_resultado_validacion validaciones_lexico_es_int_valido(char *cadena)
{
    t_validaciones_lexico_resultado_validacion resultado;
    int longitud = strlen(cadena);
    if (longitud > VALIDACIONES_LEXICO_MAX_LONGITUD_INT)
    {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Entero supera la longitud maxima permitida");
        sprintf(resultado.aclaracion, "Maximo %d caracteres", VALIDACIONES_LEXICO_MAX_LONGITUD_INT);
        return resultado;
    }

    long numero_long = atol(cadena);
    if (numero_long > VALIDACIONES_LEXICO_MAX_VALOR_INT)
    {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Entero fuera de rango");
        sprintf(resultado.aclaracion, "Enteros validos hasta %d", VALIDACIONES_LEXICO_MAX_VALOR_INT);
        return resultado;
    }

    resultado.es_valido = 1;
    return resultado;
}