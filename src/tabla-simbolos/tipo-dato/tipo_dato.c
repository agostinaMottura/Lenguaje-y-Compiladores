#include <string.h>
#include "./tipo_dato.h"

int tipo_dato_es_constante(t_tipo_dato tipo_dato)
{
    return (tipo_dato == TIPO_DATO_CTE_STRING || tipo_dato == TIPO_DATO_CTE_INT || tipo_dato == TIPO_DATO_CTE_FLOAT);
}

const char *tipo_dato_obtener_valor(t_tipo_dato tipo_dato)
{
    switch (tipo_dato)
    {
    case TIPO_DATO_DESCONOCIDO:
        return TIPO_DATO_VALOR_NULL;
    case TIPO_DATO_CTE_STRING:
        return TIPO_DATO_VALOR_CTE_STRING;
    case TIPO_DATO_CTE_INT:
        return TIPO_DATO_VALOR_CTE_INT;
    case TIPO_DATO_CTE_FLOAT:
        return TIPO_DATO_VALOR_CTE_FLOAT;
    }
}

t_tipo_dato tipo_dato_obtener_desde_string(const char *str)
{
    if (strcmp(str, TIPO_DATO_VALOR_CTE_STRING) == 0)
    {
        return TIPO_DATO_CTE_STRING;
    }

    if (strcmp(str, TIPO_DATO_VALOR_CTE_INT) == 0)
    {
        return TIPO_DATO_CTE_INT;
    }

    if (strcmp(str, TIPO_DATO_VALOR_CTE_FLOAT) == 0)
    {
        return TIPO_DATO_CTE_FLOAT;
    }

    return TIPO_DATO_DESCONOCIDO;
}