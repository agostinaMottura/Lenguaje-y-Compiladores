#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "../../valores/valores.h"
#include "./informes/informes.h"
#include "./tercetos.h"

t_gci_tercetos_lista_tercetos lista_tercetos;
int cantidad_tercetos_en_lista = 0;

void gci_tercetos_crear_lista()
{
    lista_tercetos.primero = NULL;
    informes_gci_tercetos_imprimir_mensaje("Lista de tercetos creada correctamente");
}

t_gci_tercetos_dato *
gci_tercetos_agregar_terceto(
    const char *a,
    const char *b,
    const char *c)
{
    informes_gci_tercetos_imprimir_mensaje("Se agrega un terceto");

    t_gci_tercetos_dato *nuevo_terceto = crear_terceto(a, b, c);
    if (nuevo_terceto == NULL)
    {
        informes_gci_tercetos_imprimir_error("No hay memoria suficiente para almacenar u nuevo terceto");
        exit(1);
    }

    cantidad_tercetos_en_lista++;

    t_gci_tercetos_nodo *nuevo_nodo = malloc(
        sizeof(t_gci_tercetos_nodo));
    if (nuevo_nodo == NULL)
    {
        liberar_memoria_terceto(nuevo_terceto);

        informes_gci_tercetos_imprimir_error("No hay memoria suficiente para crear un nuevo nodo de tercetos");
        exit(1);
    }

    nuevo_nodo->dato = *nuevo_terceto;
    nuevo_nodo->siguiente = NULL;

    if (lista_tercetos.primero == NULL)
    {
        lista_tercetos.primero = nuevo_nodo;
        return nuevo_terceto;
    }

    t_gci_tercetos_nodo *actual = lista_tercetos.primero;
    while (actual->siguiente != NULL)
    {
        actual = actual->siguiente;
    }
    actual->siguiente = nuevo_nodo;

    return nuevo_terceto;
}

void gci_tercetos_guardar()
{
    FILE *arch = fopen(GCI_TECETOS_NOMBRE_ARCHIVO, "wt");
    if (arch == NULL)
    {
        informes_gci_tercetos_imprimir_error("Abriendo el archivo para almacenar los tercetos");
        exit(1);
    }

    if (lista_tercetos.primero == NULL)
    {
        informes_gci_tercetos_imprimir_error("Lista de tercetos vacia");
        fclose(arch);
        exit(1);
    }

    t_gci_tercetos_nodo *nodo = lista_tercetos.primero;

    while (nodo)
    {
        fprintf(
            arch,
            "[%d]   (%s, %s, %s)\n",
            nodo->dato.indice,
            nodo->dato.a,
            valores_obtener_para_almacenar(nodo->dato.b),
            valores_obtener_para_almacenar(nodo->dato.c));

        liberar_memoria_nodo(nodo);
        nodo = nodo->siguiente;
    }

    fclose(arch);
    informes_gci_tercetos_imprimir_mensaje("Lista de tercetos almacenada correctametne");
}

t_gci_tercetos_dato *crear_terceto(
    const char *a,
    const char *b,
    const char *c)
{
    t_gci_tercetos_dato *nuevo_terceto = malloc(
        sizeof(t_gci_tercetos_dato));
    if (nuevo_terceto == NULL)
    {
        informes_gci_tercetos_imprimir_error("No hay memoria suficiente para crear un nuevo terceto");
        exit(1);
    }

    nuevo_terceto->a = strdup(a);

    if (b == NULL)
    {
        nuevo_terceto->b = NULL;
    }
    else
    {
        nuevo_terceto->b = strdup(b);
    }

    if (c == NULL)
    {
        nuevo_terceto->c = NULL;
    }
    else
    {
        nuevo_terceto->c = strdup(c);
    }

    nuevo_terceto->indice = cantidad_tercetos_en_lista;

    return nuevo_terceto;
}

void liberar_memoria_nodo(t_gci_tercetos_nodo *nodo)
{
    liberar_memoria_terceto(&nodo->dato);
    free(nodo);
}

void liberar_memoria_terceto(t_gci_tercetos_dato *terceto)
{
    free(terceto->a);
    free(terceto->b);
    free(terceto->c);
}