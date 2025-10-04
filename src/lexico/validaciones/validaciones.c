#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "./validaciones.h"

ResultadoValidacion es_string_valido(char cadena[])
{
    ResultadoValidacion resultado;
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

ResultadoValidacion es_float_valido(char *cadena)
{
    ResultadoValidacion resultado;
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

    if (numero_float < MIN_FLOAT_VALOR || numero_float > MAX_FLOAT_VALOR)
    {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Float fuera de rango");
        sprintf(resultado.aclaracion, "Floats validos entre %.5e y %.5e", MIN_FLOAT_VALOR, MAX_FLOAT_VALOR);
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

ResultadoValidacion es_int_valido(char *cadena)
{
    ResultadoValidacion resultado;
    int longitud = strlen(cadena);
    if (longitud > MAX_INT_LONGITUD)
    {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Entero supera la longitud maxima permitida");
        sprintf(resultado.aclaracion, "Maximo %d caracteres", MAX_INT_LONGITUD);
        return resultado;
    }

    long numero_long = atol(cadena);
    if (numero_long > MAX_INT_VALOR)
    {
        resultado.es_valido = 0;
        sprintf(resultado.mensaje_error, "Entero fuera de rango");
        sprintf(resultado.aclaracion, "Enteros validos hasta %d", MAX_INT_VALOR);
        return resultado;
    }

    resultado.es_valido = 1;
    return resultado;
}