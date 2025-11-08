#include "tabla_simbolos.h"
#include "../valores/valores.h"
#include "./informes/informes.h"
#include "../utils/utils.h"
#include "../validaciones/validaciones.h"

// Definición de la tabla de símbolos global
t_tabla_simbolos tabla_simbolos;

// Validaciones
int existe_nombre_en_tabla_de_simbolos(const char *nombre, const char *valor, t_tabla_simbolos_nodo *nodo)
{
    while (nodo)
    {
        if (strcmp(nodo->dato.nombre, nombre) == 0 &&
            strcmp(nodo->dato.valor, valor) == 0)
        {
            return 1;
        }
        nodo = nodo->siguiente;
    }

    return 0;
}

// Funciones propias de la tabla de simbolos
void tabla_simbolos_crear()
{
    tabla_simbolos.primero = NULL;
    informes_tabla_simbolos_imprimir_mensaje("Tabla de simbolos creada con exito");
}

int tabla_simbolos_insertar_dato(const char *nombre, t_tipo_dato tipo_dato, const char *valor)
{
    if (existe_nombre_en_tabla_de_simbolos(nombre, valor, tabla_simbolos.primero))
    {
        char mensaje[UTILS_MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Elemento duplicado. (%s: %s | %s: %s)",
            TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE, nombre,
            TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return 1;
    }

    t_tabla_simbolos_dato *dato = tabla_simbolos_crear_dato(nombre, tipo_dato, valor);
    if (dato == NULL)
    {
        char mensaje[UTILS_MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Error al crear el dato. (%s: %s | %s: %d | %s: %s)",
            TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE, nombre,
            TABLA_SIMBOLOS_VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return 0;
    }

    t_tabla_simbolos_nodo *nodo = (t_tabla_simbolos_nodo *)malloc(sizeof(t_tabla_simbolos_nodo));
    if (nodo == NULL)
    {
        free(dato->nombre);
        free(dato->valor);
        free(dato);

        char mensaje[UTILS_MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Error al crear el nodo. (%s: %s | %s: %d | %s: %s)",
            TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE, nombre,
            TABLA_SIMBOLOS_VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return 0;
    }
    nodo->dato = *dato;
    nodo->siguiente = NULL;

    if (tabla_simbolos.primero == NULL)
    {
        tabla_simbolos.primero = nodo;
        return 1;
    }

    t_tabla_simbolos_nodo *actual = tabla_simbolos.primero;
    while (actual->siguiente != NULL)
    {
        actual = actual->siguiente;
    }
    actual->siguiente = nodo;

    return 1;
}

t_tabla_simbolos_dato *tabla_simbolos_crear_dato(const char *nombre, t_tipo_dato tipo_dato,
                                                 const char *valor)
{
    t_tabla_simbolos_dato *dato = (t_tabla_simbolos_dato *)calloc(1, sizeof(t_tabla_simbolos_dato));
    if (dato == NULL)
    {
        char mensaje[UTILS_MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Memoria insuficiente para crear el dato. (%s: %s | %s: %d | %s: %s)",
            TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE, nombre,
            TABLA_SIMBOLOS_VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return NULL;
    }

    dato->tipo_dato = tipo_dato;

    dato->valor = (char *)malloc(sizeof(char) * (strlen(valor) + 1));
    if (dato->valor == NULL)
    {
        free(dato);

        char mensaje[UTILS_MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Memoria insuficiente para crear el valor del dato. (%s: %s | %s: %d | %s: %s)",
            TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE, nombre,
            TABLA_SIMBOLOS_VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return NULL;
    }
    strcpy(dato->valor, valor);
    dato->longitud = strlen(valor);

    if (!tipo_dato_es_constante(dato->tipo_dato))
    {
        dato->nombre = (char *)malloc(sizeof(char) * (strlen(nombre) + 1));
        if (dato->nombre == NULL)
        {
            free(dato->valor);
            free(dato);

            char mensaje[UTILS_MAX_STRING_MENSAJE_LONGITUD];
            sprintf(
                mensaje,
                "Memoria insuficiente para crear el nombre del dato. (%s: %s | %s: %d | %s: %s)",
                TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE, nombre,
                TABLA_SIMBOLOS_VALOR_COLUMNA_TIPO_DATO, tipo_dato,
                TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR, valor);
            informes_tabla_simbolos_imprimir_mensaje(mensaje);

            return NULL;
        }
        strcpy(dato->nombre, nombre);

        return dato;
    }

    char nombre_cte[VALIDACIONES_MAX_LONGITUD_STRING + 1] = "_";
    strcat(nombre_cte, nombre);

    dato->nombre = (char *)malloc(sizeof(char) * (strlen(nombre_cte) + 1));
    if (dato->nombre == NULL)
    {
        free(dato->valor);
        free(dato);

        char mensaje[UTILS_MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Memoria insuficiente para crear el nombre del dato. (%s: %s | %s: %d | %s: %s)",
            TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE, nombre,
            TABLA_SIMBOLOS_VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return NULL;
    }

    strcpy(dato->nombre, nombre_cte);
    return dato;
}

t_tabla_simbolos_dato *tabla_simbolos_obtener_dato(const char *nombre)
{
    t_tabla_simbolos_nodo *nodo = tabla_simbolos.primero;

    while (nodo != NULL && strcmp(nodo->dato.nombre, nombre) != 0)
    {
        nodo = nodo->siguiente;
    }

    if (nodo == NULL)
    {
        return NULL;
    }

    return &(nodo->dato);
}

void tabla_simbolos_guardar()
{
    FILE *arch;

    if ((arch = fopen("symbol-table.txt", "wt")) == NULL)
    {
        informes_tabla_simbolos_imprimir_mensaje("Error al guardar la tabla de simbolos");
        return;
    }

    if (tabla_simbolos.primero == NULL)
    {
        informes_tabla_simbolos_imprimir_mensaje("La tabla de simbolos está vacia");
        fclose(arch);
        return;
    }

    fprintf(arch, "%-55s%-30s%-55s%-30s\n",
            TABLA_SIMBOLOS_VALOR_COLUMNA_NOMBRE,
            TABLA_SIMBOLOS_VALOR_COLUMNA_TIPO_DATO,
            TABLA_SIMBOLOS_VALOR_COLUMNA_VALOR,
            TABLA_SIMBOLOS_VALOR_COLUMNA_LONGITUD);

    t_tabla_simbolos_nodo *nodo = tabla_simbolos.primero;

    while (nodo)
    {
        fprintf(arch,
                "%-55s%-30s%-55s%-30d\n",
                nodo->dato.nombre,
                tipo_dato_obtener_valor(nodo->dato.tipo_dato),
                valores_obtener_para_almacenar(nodo->dato.valor),
                nodo->dato.longitud);

        nodo = nodo->siguiente;
    }

    fclose(arch);
    informes_tabla_simbolos_imprimir_mensaje("Guardado completo");
}