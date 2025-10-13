#include <stdlib.h>
#include "./pila_punteros.h"

t_pila_punteros *pila_punteros_crear()
{
    t_pila_punteros *pila = (t_pila_punteros *)malloc(sizeof(t_pila_punteros));
    if (pila == NULL)
    {
        // Informar falta memoria
        exit(1);
    }

    pila->tope = NULL;

    return pila;
}

int pila_punteros_esta_vacia(t_pila_punteros *pila)
{
    return pila->tope == NULL;
}

void pila_punteros_apilar(t_pila_punteros *pila, void *dato)
{
    t_pila_punteros_nodo *nodo = (t_pila_punteros_nodo *)malloc(sizeof(t_pila_punteros_nodo));
    if (nodo == NULL)
    {
        // Informar falta memoria
        exit(1);
    }

    nodo->dato = dato;

    nodo->siguiente = pila->tope;
    pila->tope = nodo;
}

void pila_punteros_desapilar(t_pila_punteros *pila, void **destino)
{
    if (pila_punteros_esta_vacia(pila))
    {
        return;
    }

    t_pila_punteros_nodo *nodo = pila->tope;
    pila->tope = nodo->siguiente;

    *destino = nodo->dato;

    free(nodo);
}