#ifndef GCI_TERCETOS_H
#define GCI_TERCETOS_H
#include <stdio.h>

#define GCI_TECETOS_NOMBRE_ARCHIVO "gci-tercetos.txt"

typedef struct
{
    int indice;
    char *a;
    char *b;
    char *c;
} t_gci_tercetos_dato;

typedef struct nodo
{
    t_gci_tercetos_dato dato;
    struct nodo *siguiente;
} t_gci_tercetos_nodo;

typedef struct lista
{
    t_gci_tercetos_nodo *primero;
} t_gci_tercetos_lista_tercetos;

extern t_gci_tercetos_lista_tercetos lista_tercetos;

// Funciones publicas
void gci_tercetos_crear_lista();
t_gci_tercetos_dato *gci_tercetos_agregar_terceto(
    const char *a,
    void *b,
    void *c);
void gci_tercetos_guardar();

// Funciones privadas
t_gci_tercetos_dato *crear_terceto(
    const char *a,
    const char *b,
    const char *c);
void liberar_memoria_nodo(t_gci_tercetos_nodo *nodo);
void liberar_memoria_terceto(t_gci_tercetos_dato *terceto);
void escribir_terceto_en_archivo(FILE *arch, t_gci_tercetos_nodo *nodo);
char *obtener_valor_a_de_un_terceto(void *c);

#endif // GCI_TERCETOS_H