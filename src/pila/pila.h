#ifndef PILA_H
#define PILA_H

#include <stddef.h>

typedef struct nodo
{
    void *dato;
    struct nodo *siguiente;
} t_pila_nodo;

typedef struct pila
{
    t_pila_nodo *tope;
} t_pila;

t_pila *pila_crear();
void pila_apilar(t_pila *pila, void *dato, size_t tamano);
void *pila_desapilar(t_pila *pila);
int pila_esta_vacia(t_pila *pila);
void pila_destruir(t_pila *pila);
// int pila_ver_tope(t_pila *pila);

#endif // PILA_H