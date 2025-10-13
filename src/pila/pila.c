#include <stdlib.h>
#include <string.h>
#include "pila.h"
#include "./informes/informes.h"

t_pila *pila_crear()
{
    t_pila *pila = (t_pila *)malloc(sizeof(t_pila));
    if (pila == NULL)
    {
        informes_pila_imprimir_mensaje("No hay memoria suficiente para crear la pila");
        exit(1);
    }

    pila->tope = NULL;

    return pila;
}

void pila_apilar(t_pila *pila, void *dato, size_t tamano)
{
    t_pila_nodo *nodo = (t_pila_nodo *)malloc(sizeof(t_pila_nodo));
    if (nodo == NULL)
    {
        informes_pila_imprimir_mensaje("No hay memoria suficiente para crear un nodo de la pila");
        exit(1);
    }

    nodo->dato = malloc(tamano);
    if (nodo->dato == NULL)
    {
        informes_pila_imprimir_mensaje("No hay memoria suficiente para almacenar el dato de un nodo de la pila");
        exit(1);
    }

    memcpy(nodo->dato, dato, tamano);

    nodo->siguiente = pila->tope;
    pila->tope = nodo;
}

void *pila_desapilar(t_pila *pila)
{
    if (pila_esta_vacia(pila))
        return NULL;

    t_pila_nodo *nodo = pila->tope;
    void *dato = nodo->dato;
    pila->tope = nodo->siguiente;

    free(nodo);

    return dato;
}

int pila_esta_vacia(t_pila *pila)
{
    return pila->tope == NULL;
}

void pila_destruir(t_pila *pila)
{
    while (!pila_esta_vacia(pila))
    {
        void *dato = pila_desapilar(pila);
        free(dato);
    }

    free(pila);
}