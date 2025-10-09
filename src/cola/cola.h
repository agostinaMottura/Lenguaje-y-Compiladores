#ifndef COLA_H
#define COLA_H

#define COLA_MINIMO

typedef struct nodo
{
    void *dato;
    unsigned tamano;
    struct nodo *siguiente;
} t_cola_nodo;

typedef struct
{
    t_cola_nodo *primero;
    t_cola_nodo *ultimo;
} t_cola;

t_cola *cola_crear();
void cola_agregar(t_cola *cola, const void *dato, unsigned tamano);
void *cola_quitar(t_cola *cola, void *destino, unsigned tamano_esperado);

void cola_vaciar(t_cola *cola);
void cola_ver_primero(const t_cola *cola, void *destino, unsigned tamano_esperado);

int cola_esta_vacia(const t_cola *cola);

#endif // COLA_H