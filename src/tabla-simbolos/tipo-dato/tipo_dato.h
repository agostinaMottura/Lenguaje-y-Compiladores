#ifndef TIPO_DATO_H
#define TIPO_DATO_H

#define TIPO_DATO_VALOR_NULL "__"
#define TIPO_DATO_VALOR_CTE_STRING "CTE_STRING"
#define TIPO_DATO_VALOR_CTE_INT "CTE_INT"
#define TIPO_DATO_VALOR_CTE_FLOAT "CTE_FLOAT"

#define TIPO_DATO_VALOR_STRING "STRING"
#define TIPO_DATO_VALOR_INT "INT"
#define TIPO_DATO_VALOR_FLOAT "FLOAT"

typedef enum
{
    TIPO_DATO_DESCONOCIDO,
    TIPO_DATO_CTE_STRING,
    TIPO_DATO_CTE_INT,
    TIPO_DATO_CTE_FLOAT,

    TIPO_DATO_STRING,
    TIPO_DATO_INT,
    TIPO_DATO_FLOAT
} t_tipo_dato;

int tipo_dato_es_constante(t_tipo_dato tipo_dato);
const char *tipo_dato_obtener_valor(t_tipo_dato tipo_dato);
t_tipo_dato tipo_dato_obtener_desde_string(const char *str);

#endif // TIPO_DATO_H