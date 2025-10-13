#include "../tabla-simbolos/tabla_simbolos.h"
#include "../validaciones/validaciones.h"
#include "./informes/informes.h"
#include "./semantico.h"

int semantico_validacion_existe_simbolo_en_tabla_simbolos(
    const char *nombre)
{
    void *simbolo = tabla_simbolos_obtener_dato(nombre);
    if (simbolo == NULL)
    {
        char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
        sprintf(mensaje, "Simbolo no encontrado en la tabla de simbolos: %s", nombre);
        informes_semantico_imprimir_mensaje(mensaje);

        return 0;
    }

    return 1;
}

int semantico_validacion_no_existe_simbolo_en_tabla_simbolos(
    const char *nombre)
{
    void *simbolo = tabla_simbolos_obtener_dato(nombre);
    if (simbolo == NULL)
    {
        return 1;
    }

    char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
    sprintf(mensaje, "Simbolo ya existe en la tabla de simbolos: %s", nombre);
    informes_semantico_imprimir_mensaje(mensaje);

    return 0;
}

int semantico_validacion_tipo_dato(
    const char *nombre,
    t_tipo_dato tipo_dato_buscado)
{
    t_tabla_simbolos_dato *simbolo = tabla_simbolos_obtener_dato(nombre);
    if (simbolo == NULL)
    {
        char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
        sprintf(mensaje, "No se encontro el simbolo en la tabla de simbolos: %s", nombre);
        informes_semantico_imprimir_mensaje(mensaje);
        return 0;
    }

    if (simbolo->tipo_dato != tipo_dato_buscado)
    {
        char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
        sprintf(
            mensaje,
            "Tipos de datos diferentes: Tabla Simbolos [%s] - Leido [%s]",
            tipo_dato_obtener_valor(simbolo->tipo_dato),
            tipo_dato_obtener_valor(tipo_dato_buscado));
        informes_semantico_imprimir_mensaje(mensaje);
        return 0;
    }

    return 1;
}

int semantico_son_tipos_de_datos_compatibles(
    t_tipo_dato tipo_dato_a,
    t_tipo_dato tipo_dato_b)
{
    // Los string solo son validos con los string
    if (tipo_dato_a == TIPO_DATO_STRING)
    {
        if (tipo_dato_b == TIPO_DATO_STRING)
        {
            return 1;
        }

        char mensaje[VALIDACIONES_MAX_MENSAJE_ERROR_LONGITUD];
        sprintf(mensaje, "Tipos de datos incompatibles: %s con %s",
                tipo_dato_obtener_valor(tipo_dato_a),
                tipo_dato_obtener_valor(tipo_dato_b));
        informes_semantico_imprimir_mensaje(mensaje);
        return 0;
    }

    // Int y float son compatibles
    return 1;
}

t_tipo_dato semantico_obtener_tipo_de_dato_resultante(
    t_tipo_dato tipo_dato_a,
    t_tipo_dato tipo_dato_b)
{
    // Antes de llamar a esta funcion, siempre llamar a semantico_son_tipos_de_datos_compatibles
    if (!semantico_son_tipos_de_datos_compatibles(tipo_dato_a, tipo_dato_b))
    {
        return TIPO_DATO_DESCONOCIDO;
    }

    if (tipo_dato_a == TIPO_DATO_STRING && tipo_dato_b == TIPO_DATO_STRING)
    {
        return TIPO_DATO_STRING;
    }

    if (tipo_dato_a == TIPO_DATO_INT && tipo_dato_b == TIPO_DATO_INT)
    {
        return TIPO_DATO_INT;
    }

    return TIPO_DATO_CTE_FLOAT;
}