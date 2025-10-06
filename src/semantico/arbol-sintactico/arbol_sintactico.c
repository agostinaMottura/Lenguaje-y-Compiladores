#include <stdlib.h>
#include "../../utils/utils.h"
#include "./arbol_sintactico.h"
#include "./informes/informes.h"

// Definicion del Arbol Sintactico
t_arbol_sintactico_nodo *arbol_sintactico = NULL;

void arbol_sintactico_crear()
{
    arbol_sintactico = malloc(sizeof(t_arbol_sintactico_nodo));
    if (arbol_sintactico == NULL)
    {
        informes_arbol_sintactico_imprimir_error("No hay memoria suficiente para crear el arbol");
        exit(1);
    }

    arbol_sintactico->hoja_der = NULL;
    arbol_sintactico->hoja_izq = NULL;

    informes_arbol_sintactico_imprimir_mensaje("Arbol Sintactico creado con exito");
}

t_arbol_sintactico_nodo *arbol_sintactico_crear_hoja(t_simbolos_terminales terminal)
{
    t_arbol_sintactico_nodo *hoja = malloc(sizeof(t_arbol_sintactico_nodo));
    if (hoja == NULL)
    {
        informes_arbol_sintactico_imprimir_error("No hay memoria suficiente para crear una hoja");
        exit(1);
    }

    hoja->terminal = terminal;
    hoja->hoja_der = NULL;
    hoja->hoja_izq = NULL;

    informes_arbol_sintactico_imprimir_mensaje("Se creo la hoja correctamente");

    return hoja;
}

t_arbol_sintactico_nodo *arbol_sintactico_crear_nodo(
    t_simbolos_terminales terminal,
    t_arbol_sintactico_nodo *hoja_izq,
    t_arbol_sintactico_nodo *hoja_der)
{
    t_arbol_sintactico_nodo *nodo = malloc(sizeof(t_arbol_sintactico_nodo));
    if (nodo == NULL)
    {
        informes_arbol_sintactico_imprimir_error("No hay memoria suficiente para crear un nodo");
        exit(1);
    }

    nodo->terminal = terminal;
    nodo->hoja_izq = hoja_izq;
    nodo->hoja_der = hoja_der;

    informes_arbol_sintactico_imprimir_mensaje("Se creo el nodo correctamente");

    return nodo;
}

void arbol_sintactico_eliminar_memoria()
{
    arbol_sintactico_eliminar_memoria_nodo(arbol_sintactico);
    informes_arbol_sintactico_imprimir_mensaje("Se libero la memoria correctamente");
}

void arbol_sintactico_eliminar_memoria_nodo(t_arbol_sintactico_nodo *nodo)
{
    if (nodo == NULL)
        return;

    arbol_sintactico_eliminar_memoria_nodo(nodo->hoja_izq);
    arbol_sintactico_eliminar_memoria_nodo(nodo->hoja_der);

    free(nodo);
}
