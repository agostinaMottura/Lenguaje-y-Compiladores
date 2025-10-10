#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "./cola.h"
#include "../utils/utils.h"

t_cola *cola_crear()
{
    t_cola *cola = (t_cola *)malloc(sizeof(t_cola));
    if (cola == NULL)
    {
        // Informar falta de memoria
        printf("[COLA] Falta de memoria\n");
        exit(1);
    }

    cola->primero = NULL;
    cola->ultimo = NULL;

    return cola;
}

void cola_agregar(t_cola *cola, void *dato, unsigned tamano)
{
    t_cola_nodo *nodo = (t_cola_nodo *)malloc(sizeof(t_cola_nodo));
    if (nodo == NULL)
    {
        // Informar falta de memoria
        printf("[COLA] Falta de memoria\n");
        exit(1);
    }

    nodo->dato = malloc(tamano);
    if (nodo->dato == NULL)
    {
        // Informar falta de memoria
        printf("[COLA] Falta de memoria\n");
        free(nodo);
        exit(1);
    }

    memcpy(nodo->dato, dato, tamano);

    nodo->tamano = tamano;
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

void cola_quitar(t_cola *cola, void *destino, unsigned tamano_esperado)
{
    t_cola_nodo *nodo = cola->primero;
    if (nodo == NULL)
        return;
    printf("primero no es null\n");

    cola->primero = nodo->siguiente;
    printf("primero ahora es el segundo\n");

    memcpy(destino, nodo->dato, MINIMO(nodo->tamano, tamano_esperado));

    printf("copiamos los datos del primero en destino\n");

    free(nodo->dato);
    free(nodo);

    if (cola->primero == NULL)
        cola->ultimo = NULL;
}

void cola_vaciar(t_cola *cola)
{
    t_cola_nodo *aux;

    while (cola->primero)
    {
        aux = cola->primero;
        cola->primero = aux->siguiente;

        free(aux->dato);
        free(aux);
    }

    cola->ultimo = NULL;
}

void cola_ver_primero(const t_cola *cola, void *destino, unsigned tamano_esperado)
{
    if (cola_esta_vacia(cola))
    {
        // Informar cola vacia
        return;
    }

    memcpy(destino, cola->primero->dato, MINIMO(tamano_esperado, cola->primero->tamano));
}

int cola_esta_vacia(const t_cola *cola)
{
    return cola->primero == NULL;
}