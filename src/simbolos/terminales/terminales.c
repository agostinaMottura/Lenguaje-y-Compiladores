#include <string.h>
#include "./terminales.h"
#include "../../utils/utils.h"
#include "../../validaciones/validaciones.h"

const char *simbolos_terminales_obtener_valor(t_simbolos_terminales terminal)
{
    static const char *valores[] = {
        SIMBOLOS_TERMINALES_INIT_VALOR,

        SIMBOLOS_TERMINALES_FLOAT_VALOR,
        SIMBOLOS_TERMINALES_INT_VALOR,
        SIMBOLOS_TERMINALES_STRING_VALOR,

        SIMBOLOS_TERMINALES_IF_VALOR,
        SIMBOLOS_TERMINALES_ELSE_VALOR,
        SIMBOLOS_TERMINALES_WHILE_VALOR,
        SIMBOLOS_TERMINALES_READ_VALOR,
        SIMBOLOS_TERMINALES_WRITE_VALOR,

        SIMBOLOS_TERMINALES_TRIANGLE_AREA_MAXIMUM_VALOR,
        SIMBOLOS_TERMINALES_IS_ZERO_VALOR,

        SIMBOLOS_TERMINALES_AND_VALOR,
        SIMBOLOS_TERMINALES_OR_VALOR,
        SIMBOLOS_TERMINALES_NOT_VALOR,

        SIMBOLOS_TERMINALES_MAYOR_VALOR,
        SIMBOLOS_TERMINALES_MENOR_VALOR,
        SIMBOLOS_TERMINALES_MAYOR_IGUAL_VALOR,
        SIMBOLOS_TERMINALES_MENOR_IGUAL_VALOR,
        SIMBOLOS_TERMINALES_IGUAL_VALOR,
        SIMBOLOS_TERMINALES_DISTINTO_VALOR,

        SIMBOLOS_TERMINALES_SUMA_VALOR,
        SIMBOLOS_TERMINALES_ASIGNACION_VALOR,
        SIMBOLOS_TERMINALES_MULTIPLICACION_VALOR,
        SIMBOLOS_TERMINALES_RESTA_VALOR,
        SIMBOLOS_TERMINALES_DIVISION_VALOR,

        SIMBOLOS_TERMINALES_PARENTESIS_A_VALOR,
        SIMBOLOS_TERMINALES_PARENTESIS_C_VALOR,

        SIMBOLOS_TERMINALES_LLAVES_A_VALOR,
        SIMBOLOS_TERMINALES_LLAVES_C_VALOR,

        SIMBOLOS_TERMINALES_CORCHETE_A_VALOR,
        SIMBOLOS_TERMINALES_CORCHETE_C_VALOR,

        SIMBOLOS_TERMINALES_DOS_PUNTOS_VALOR,
        SIMBOLOS_TERMINALES_COMA_VALOR,
        SIMBOLOS_TERMINALES_PUNTO_Y_COMA_VALOR,

        SIMBOLOS_TERMINALES_CTE_STRING_VALOR,
        SIMBOLOS_TERMINALES_CTE_FLOAT_VALOR,
        SIMBOLOS_TERMINALES_CTE_INT_VALOR,

        SIMBOLOS_TERMINALES_ID_VALOR};

    if (terminal >= 0 && terminal < SIMBOLOS_TERMINALES_CANT)
        return valores[terminal];

    char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
    sprintf("No existe un valor definido para el Simbolo Terminal %d", terminal);

    utils_imprimir_error(mensaje);
    exit(1);
}

t_simbolos_terminales simbolos_terminales_obtener_desde_string(const char *str)
{
    for (int i = 0; i < SIMBOLOS_TERMINALES_CANT; i++)
    {
        if (strcmp(str, simbolos_terminales_obtener_valor(i)) == 0)
            return (t_simbolos_terminales)i;
    }

    char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
    sprintf("No existe Simbolo Terminal para el valor %s", str);

    utils_imprimir_error(mensaje);

    exit(1);
}