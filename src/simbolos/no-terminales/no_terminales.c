#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "./no_terminales.h"
#include "../../utils/utils.h"
#include "../../validaciones/validaciones.h"

const char *simbolos_no_terminales_obtener_valor(t_simbolos_no_terminales no_terminal)
{
    static const char *valores[] = {
        SIMBOLOS_NO_TERMINALES_PROGRAMA_VALOR,
        SIMBOLOS_NO_TERMINALES_INSTRUCCIONES_VALOR,
        SIMBOLOS_NO_TERMINALES_SENTENCIA_VALOR,
        SIMBOLOS_NO_TERMINALES_FUNCION_VALOR,
        SIMBOLOS_NO_TERMINALES_FUNCION_NUMERICA_VALOR,
        SIMBOLOS_NO_TERMINALES_FUNCION_BOOLEANA_VALOR,
        SIMBOLOS_NO_TERMINALES_IS_ZERO_VALOR,
        SIMBOLOS_NO_TERMINALES_TRIANGLE_AREA_MAXIMUM_VALOR,
        SIMBOLOS_NO_TERMINALES_TRIANGULO_VALOR,
        SIMBOLOS_NO_TERMINALES_COORDENADA_VALOR,
        SIMBOLOS_NO_TERMINALES_DECLARACION_VALOR,
        SIMBOLOS_NO_TERMINALES_LISTA_DECLARACIONES_VALOR,
        SIMBOLOS_NO_TERMINALES_DECLARACION_VAR_VALOR,
        SIMBOLOS_NO_TERMINALES_LISTA_IDS_VALOR,
        SIMBOLOS_NO_TERMINALES_TIPO_VALOR,
        SIMBOLOS_NO_TERMINALES_ASIGNACION_VALOR,
        SIMBOLOS_NO_TERMINALES_WRITE_VALOR,
        SIMBOLOS_NO_TERMINALES_READ_VALOR,
        SIMBOLOS_NO_TERMINALES_CICLO_VALOR,
        SIMBOLOS_NO_TERMINALES_IF_VALOR,
        SIMBOLOS_NO_TERMINALES_BLOQUE_IF_VALOR,
        SIMBOLOS_NO_TERMINALES_ELSE_VALOR,
        SIMBOLOS_NO_TERMINALES_CONDICIONAL_VALOR,
        SIMBOLOS_NO_TERMINALES_CONDICION_COMPUESTA_VALOR,
        SIMBOLOS_NO_TERMINALES_CONDICION_UNARIA_VALOR,
        SIMBOLOS_NO_TERMINALES_PREDICADO_VALOR,
        SIMBOLOS_NO_TERMINALES_OPERADOR_COMPARACION_VALOR,
        SIMBOLOS_NO_TERMINALES_EXPRESION_VALOR,
        SIMBOLOS_NO_TERMINALES_TERMINO_VALOR,
        SIMBOLOS_NO_TERMINALES_FACTOR_VALOR};

    if (no_terminal >= 0 && no_terminal < SIMBOLOS_NO_TERMINALES_CANT)
        return valores[no_terminal];

    char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
    sprintf(
        mensaje,
        "No existe un valor definido para el Simbolo No Terminal %d",
        no_terminal);

    utils_imprimir_error(mensaje);
    exit(1);
}

t_simbolos_no_terminales simbolos_no_terminales_obtener_desde_string(const char *str)
{
    for (int i = 0; i < SIMBOLOS_NO_TERMINALES_CANT; i++)
    {
        if (strcmp(str, simbolos_no_terminales_obtener_valor(i)) == 0)
            return (t_simbolos_no_terminales)i;
    }

    char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
    sprintf(
        mensaje,
        "No existe Simbolo No Terminal para el valor %s",
        str);

    utils_imprimir_error(mensaje);

    exit(1);
}