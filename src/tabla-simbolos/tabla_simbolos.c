#include "tabla_simbolos.h"
#include "./valores/valores.h"
#include "./informes/informes.h"
#include "../utils.h"

// Definición de la tabla de símbolos global
t_tabla_simbolos tabla_simbolos;

// Validaciones
int existe_nombre_en_tabla_de_simbolos(const char *nombre, const char *valor, t_nodo *nodo)
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
void crear_tabla_simbolos()
{
    tabla_simbolos.primero = NULL;
    informes_tabla_simbolos_imprimir_mensaje("Tabla de simbolos creada con exito");
}

int insertar_tabla_simbolos(const char *nombre, t_tipo_dato tipo_dato, const char *valor)
{
    if (existe_nombre_en_tabla_de_simbolos(nombre, valor, tabla_simbolos.primero))
    {
        char mensaje[MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Elmento duplicado. (%s: %s | %s: %s)",
            VALOR_COLUMNA_NOMBRE, nombre, VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return 1;
    }

    t_dato *dato = crearDatos(nombre, tipo_dato, valor);
    if (dato == NULL)
    {
        char mensaje[MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Error al crear el dato. (%s: %s | %s: %d | %s: %s)",
            VALOR_COLUMNA_NOMBRE, nombre,
            VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return 0;
    }

    t_nodo *nodo = (t_nodo *)malloc(sizeof(t_nodo));
    if (nodo == NULL)
    {
        free(dato->nombre);
        free(dato->valor);
        free(dato);

        char mensaje[MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Error al crear el nodo. (%s: %s | %s: %d | %s: %s)",
            VALOR_COLUMNA_NOMBRE, nombre,
            VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            VALOR_COLUMNA_VALOR, valor);
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

    t_nodo *actual = tabla_simbolos.primero;
    while (actual->siguiente != NULL)
    {
        actual = actual->siguiente;
    }
    actual->siguiente = nodo;

    return 1;
}

t_dato *crearDatos(const char *nombre, t_tipo_dato tipo_dato,
                   const char *valor)
{
    t_dato *dato = (t_dato *)calloc(1, sizeof(t_dato));
    if (dato == NULL)
    {
        char mensaje[MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Memoria insuficiente para crear el dato. (%s: %s | %s: %d | %s: %s)",
            VALOR_COLUMNA_NOMBRE, nombre,
            VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return NULL;
    }

    dato->tipo_dato = tipo_dato;

    dato->valor = (char *)malloc(sizeof(char) * (strlen(valor) + 1));
    if (dato->valor == NULL)
    {
        free(dato);

        char mensaje[MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Memoria insuficiente para crear el valor del dato. (%s: %s | %s: %d | %s: %s)",
            VALOR_COLUMNA_NOMBRE, nombre,
            VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            VALOR_COLUMNA_VALOR, valor);
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

            char mensaje[MAX_STRING_MENSAJE_LONGITUD];
            sprintf(
                mensaje,
                "Memoria insuficiente para crear el nombre del dato. (%s: %s | %s: %d | %s: %s)",
                VALOR_COLUMNA_NOMBRE, nombre,
                VALOR_COLUMNA_TIPO_DATO, tipo_dato,
                VALOR_COLUMNA_VALOR, valor);
            informes_tabla_simbolos_imprimir_mensaje(mensaje);

            return NULL;
        }
        strcpy(dato->nombre, nombre);

        return dato;
    }

    char nombre_cte[100] = "_";
    strcat(nombre_cte, nombre);

    dato->nombre = (char *)malloc(sizeof(char) * (strlen(nombre_cte) + 1));
    if (dato->nombre == NULL)
    {
        free(dato->valor);
        free(dato);

        char mensaje[MAX_STRING_MENSAJE_LONGITUD];
        sprintf(
            mensaje,
            "Memoria insuficiente para crear el nombre del dato. (%s: %s | %s: %d | %s: %s)",
            VALOR_COLUMNA_NOMBRE, nombre,
            VALOR_COLUMNA_TIPO_DATO, tipo_dato,
            VALOR_COLUMNA_VALOR, valor);
        informes_tabla_simbolos_imprimir_mensaje(mensaje);

        return NULL;
    }

    strcpy(dato->nombre, nombre_cte);
    return dato;
}

void guardar_tabla_simbolos()
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
            VALOR_COLUMNA_NOMBRE,
            VALOR_COLUMNA_TIPO_DATO,
            VALOR_COLUMNA_VALOR,
            VALOR_COLUMNA_LONGITUD);

    t_nodo *nodo = tabla_simbolos.primero;
    char valor[100];
    char longitud[20];

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