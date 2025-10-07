#ifndef ARBOL_SINTACTICO_H
#define ARBOL_SINTACTICO_H

#include "../../simbolos/terminales/terminales.h"
#include "../../simbolos/no-terminales/no_terminales.h"

typedef struct arbol_sintactico_nodo
{
    t_simbolos_terminales terminal;
    const char *lexema;
    void *hoja_izq;
    void *hoja_der;
} t_arbol_sintactico_nodo;

// Revisar si es necesario los lexemas o no
t_arbol_sintactico_nodo *arbol_sintactico_crear_hoja(
    t_simbolos_terminales terminal,
    const char *lexema);
t_arbol_sintactico_nodo *arbol_sintactico_crear_nodo(
    t_simbolos_terminales terminal,
    const char *lexema,
    t_arbol_sintactico_nodo *hoja_izq,
    t_arbol_sintactico_nodo *hoja_der);

void arbol_sintactico_crear();
void arbol_sintactico_eliminar_memoria();
void arbol_sintactico_eliminar_memoria_nodo(t_arbol_sintactico_nodo *nodo);
#endif // ARBOL_SINTACTICO_H