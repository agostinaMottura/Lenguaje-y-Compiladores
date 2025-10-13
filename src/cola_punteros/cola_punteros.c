#include <stdlib.h>
#include <stdio.h>
#include "./cola_punteros.h"

t_cola_punteros *cola_punteros_crear()
{
    t_cola_punteros *cola = (t_cola_punteros *)malloc(sizeof(t_cola_punteros));
    if (cola == NULL)
    {
        // Informar falta de memoria
        printf("[COLA_PUNTEROS] Falta de memoria\n");
        exit(1);
    }

    cola->primero = NULL;
    cola->ultimo = NULL;

    return cola;
}

int cola_punteros_esta_vacia(t_cola_punteros *cola)
{
    return cola->primero == NULL;
}

void cola_punteros_agregar(t_cola_punteros *cola, void *dato)
{
    t_cola_punteros_nodo *nodo = (t_cola_punteros_nodo *)malloc(sizeof(t_cola_punteros_nodo));
    if (nodo == NULL)
    {
        // Informar falta de memoria
        printf("[COLA_PUNTEROS] Falta de memoria\n");
        exit(1);
    }

    nodo->dato = dato;
    nodo->siguiente = NULL;

    if (cola->ultimo)
    {
        cola->ultimo->siguiente = nodo;
    }
    else
    {
        cola->primero = nodo;
    }

    cola->ultimo = nodo;
    return;
}

void cola_punteros_quitar(t_cola_punteros *cola, void **destino)
{
    t_cola_punteros_nodo *nodo = cola->primero;
    if (nodo == NULL)
        return;

    cola->primero = nodo->siguiente;

    // Copiamos el puntero
    *destino = nodo->dato;

    free(nodo);
    if (cola->primero == NULL)
        cola->ultimo = NULL;
}