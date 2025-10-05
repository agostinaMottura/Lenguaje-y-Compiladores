#include <string.h>
#include "./valores.h"

const char *valores_obtener_para_almacenar(const char *str)
{
    if (str == NULL)
    {
        return VALOR_NULL;
    }

    return str;
}

const char *valores_obtener(const char *str)
{
    if (strcmp(str, VALOR_NULL) == 0)
    {
        return NULL;
    }

    return str;
}