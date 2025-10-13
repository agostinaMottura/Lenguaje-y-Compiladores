#ifndef COLA_PUNTEROS_H
#define COLA_PUNTEROS_H

typedef struct cola_punteros_nodo
{
    void *dato;
    struct cola_punteros_nodo *siguiente;
} t_cola_punteros_nodo;

typedef struct
{
    t_cola_punteros_nodo *primero;
    t_cola_punteros_nodo *ultimo;
} t_cola_punteros;

t_cola_punteros *cola_punteros_crear();
int cola_punteros_esta_vacia(t_cola_punteros *cola);
void cola_punteros_agregar(t_cola_punteros *cola, void *dato);
void cola_punteros_quitar(t_cola_punteros *cola, void **destino);

#endif // COLA_PUNTEROS_H