#ifndef PILA_PUNTEROS_H
#define PILA_PUNTEROS_H

typedef struct pila_punteros_nodo
{
    void *dato;
    struct pila_punteros_nodo *siguiente;
} t_pila_punteros_nodo;

typedef struct
{
    t_pila_punteros_nodo *tope;
} t_pila_punteros;

t_pila_punteros *pila_punteros_crear();
int pila_punteros_esta_vacia(t_pila_punteros *pila);
void pila_punteros_apilar(t_pila_punteros *pila, void *dato);
void pila_punteros_desapilar(t_pila_punteros *pila, void **destino);

#endif // PILA_PUNTERpila