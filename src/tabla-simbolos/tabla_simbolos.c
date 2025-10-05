#include "tabla_simbolos.h"

// Definición de la tabla de símbolos global
t_tabla_simbolos tabla_simbolos;

// Validaciones
int es_cte(t_tipo_dato tipo)
{
    return (tipo == TIPO_DATO_CTE_STRING || tipo == TIPO_DATO_CTE_INT || tipo == TIPO_DATO_CTE_FLOAT);
}

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

// Mappers para la tabla de contenidos (tipos de datos)
const char *from_tipo_dato_to_str(t_tipo_dato tipo_dato)
{
    switch (tipo_dato)
    {
    case TIPO_DATO_DESCONOCIDO:
        return VALOR_NULL_STRING;
    case TIPO_DATO_CTE_STRING:
        return VALOR_CTE_STRING;
    case TIPO_DATO_CTE_INT:
        return VALOR_CTE_INT;
    case TIPO_DATO_CTE_FLOAT:
        return VALOR_CTE_FLOAT;
    }
}

t_tipo_dato from_str_to_tipo_dato(const char *str)
{
    if (strcmp(str, VALOR_CTE_STRING) == 0)
    {
        return TIPO_DATO_CTE_STRING;
    }

    if (strcmp(str, VALOR_CTE_INT) == 0)
    {
        return TIPO_DATO_CTE_INT;
    }

    if (strcmp(str, VALOR_CTE_FLOAT) == 0)
    {
        return TIPO_DATO_CTE_FLOAT;
    }

    return TIPO_DATO_DESCONOCIDO;
}

// Valor
const char *obtener_valor_para_almacenar_en_tabla_de_contenidos(const char *str)
{
    if (str == NULL)
    {
        return VALOR_NULL_STRING;
    }

    return str;
}

const char *obtener_valor_desde_la_tabla_de_contenidos(const char *str)
{
    if (strcmp(str, VALOR_NULL_STRING) == 0)
    {
        return NULL;
    }

    return str;
}

// Funciones propias de la tabla de simbolos
void crear_tabla_simbolos()
{
    tabla_simbolos.primero = NULL;
}

int insertar_tabla_simbolos(const char *nombre, t_tipo_dato tipo_dato, const char *valor)
{
    if (existe_nombre_en_tabla_de_simbolos(nombre, valor, tabla_simbolos.primero))
    {
        printf("El nombre ya existe en la tabla de simbolos\n");
        return 1;
    }

    t_dato *dato = crearDatos(nombre, tipo_dato, valor);
    if (dato == NULL)
    {
        printf("Error al crear datos\n");
        return 0;
    }

    t_nodo *nodo = (t_nodo *)malloc(sizeof(t_nodo));
    if (nodo == NULL)
    {
        free(dato);
        printf("Error al crear nodo\n");
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
        printf("No hay memoria suficiente para crear el dato\n");
        return NULL;
    }

    dato->tipo_dato = tipo_dato;

    if (valor != NULL)
    {
        dato->valor = (char *)malloc(sizeof(char) * (strlen(valor) + 1));
        if (dato->valor == NULL)
        {
            free(dato);
            printf("Error al asignar memoria para el valor\n");
            return NULL;
        }
        strcpy(dato->valor, valor);
        dato->longitud = strlen(valor); // Hacer funcion de calcular_logitud
    }

    if (!es_cte(dato->tipo_dato))
    {
        dato->nombre = (char *)malloc(sizeof(char) * (strlen(nombre) + 1));
        if (dato->nombre == NULL)
        {
            printf("No hay memoria suficiente para almacenar el nombre del nuevo dato\n");
            free(dato->valor);
            free(dato);
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
        printf("No hay memoria suficiente para almacenar el nombre del nuevo dato\n");
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
        printf("\nNo se pudo crear la tabla de simbolos.\n\n");
        return;
    }
    else if (tabla_simbolos.primero == NULL)
    {
        printf("\nLa tabla de simbolos está vacía.\n\n");
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
                from_tipo_dato_to_str(nodo->dato.tipo_dato),
                obtener_valor_para_almacenar_en_tabla_de_contenidos(nodo->dato.valor),
                nodo->dato.longitud);

        nodo = nodo->siguiente;
    }

    fclose(arch);
    printf("\nTabla de simbolos guardada correctamente.\n\n");
}