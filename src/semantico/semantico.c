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
    return 1;
}