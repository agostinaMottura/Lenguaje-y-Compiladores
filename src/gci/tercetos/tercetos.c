#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "../../valores/valores.h"
#include "./informes/informes.h"
#include "./tercetos.h"
#include "../../validaciones/validaciones.h"
#include "../../tabla-simbolos/tipo-dato/tipo_dato.h"
#include "../../utils/aux_variables.h"

// Declaración explícita de strdup para evitar warnings
char *strdup(const char *s);

t_gci_tercetos_lista_tercetos lista_tercetos;
int cantidad_tercetos_en_lista = 0;
int contador_etiquetas = 0;  

void gci_tercetos_crear_lista()
{
    lista_tercetos.primero = NULL;
    informes_gci_tercetos_imprimir_mensaje("Lista de tercetos creada correctamente");
}

t_gci_tercetos_dato *gci_tercetos_obtener_siguiente_indice()
{
    t_gci_tercetos_dato *nuevo_terceto = malloc(
        sizeof(t_gci_tercetos_dato));
    if (nuevo_terceto == NULL)
    {
        informes_gci_tercetos_imprimir_error("No hay memoria suficiente para crear un nuevo terceto");
        exit(1);
    }

    nuevo_terceto->indice = cantidad_tercetos_en_lista;

    return nuevo_terceto;
}

t_gci_tercetos_dato *
gci_tercetos_agregar_terceto(
    const char *a,
    void *b,
    void *c)
{
    // Si es una variable auxiliar (comienza con @), la cargamos en la tabla de símbolos
    if (a != NULL && (a[0] == '@' || a[1] == '@')) {
        cargar_variable_auxiliar_si_no_existe(a, TIPO_DATO_INT);
    }

    t_gci_tercetos_dato *nuevo_terceto = crear_terceto(
        a,
        obtener_indice_de_un_terceto(b),
        obtener_indice_de_un_terceto(c));

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

    nuevo_nodo->dato = nuevo_terceto;
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

void gci_tercetos_actualizar(
    t_gci_tercetos_dato *nuevo_dato,
    t_gci_tercetos_dato *terceto_a_actualizar)
{
    terceto_a_actualizar->c = obtener_indice_de_un_terceto(nuevo_dato);
}

void gci_tercetos_actualizar_indice(void *terceto)
{
    if (terceto == NULL)
        return;

    t_gci_tercetos_dato *dato = (t_gci_tercetos_dato *)terceto;

    dato->b = malloc(100);
    if (dato->b == NULL)
    {
        informes_gci_tercetos_imprimir_error("Falta de memoria");
        exit(1);
    }

    sprintf(dato->b, "[%d]", cantidad_tercetos_en_lista);
}

void gci_tercetos_actualizar_primera_posicion(void *terceto, const char *valor)
{
    if (terceto == NULL)
        return;

    t_gci_tercetos_dato *dato = (t_gci_tercetos_dato *)terceto;

    if (valor == NULL)
    {
        dato->a = NULL;
    }
    else
    {
        dato->a = strdup(valor);
    }
}

void gci_tercetos_actualizar_indice_izq(void *terceto)
{
    if (terceto == NULL)
        return;

    t_gci_tercetos_dato *dato = (t_gci_tercetos_dato *)terceto;

    dato->b = malloc(100);
    if (dato->b == NULL)
    {
        informes_gci_tercetos_imprimir_error("Falta de memoria");
        exit(1);
    }

    sprintf(dato->b, "[%d]", cantidad_tercetos_en_lista);
}

void gci_tercetos_guardar()
{
    if (lista_tercetos.primero == NULL)
    {
        informes_gci_tercetos_imprimir_mensaje("Lista de tercetos vacia - no se genera archivo");
        return;  
    }

    FILE *arch = fopen(GCI_TECETOS_NOMBRE_ARCHIVO, "wt");
    if (arch == NULL)
    {
        informes_gci_tercetos_imprimir_error("Abriendo el archivo para almacenar los tercetos");
        exit(1);
    }

    t_gci_tercetos_nodo *nodo = lista_tercetos.primero;

    while (nodo)
    {
        escribir_terceto_en_archivo(arch, nodo);
        nodo = nodo->siguiente;
    }

    liberar_memoria_nodo(nodo);

    fclose(arch);
    informes_gci_tercetos_imprimir_mensaje("Lista de tercetos almacenada correctamente");
}

void gci_imprimir_terceto(void *terceto)
{
    if (terceto == NULL)
        return;

    t_gci_tercetos_dato *dato = (t_gci_tercetos_dato *)terceto;
    char mensaje[100];
    obtener_terceto_en_string(dato, mensaje);

    printf("[GCI] %s\n", mensaje);
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


t_gci_tercetos_dato *gci_tercetos_agregar_etiqueta()
{
    char nombre_etiqueta[50];
    sprintf(nombre_etiqueta, "etiqueta_%d", contador_etiquetas);
    contador_etiquetas++;
    
    return gci_tercetos_agregar_terceto(nombre_etiqueta, NULL, NULL);
}

void gci_tercetos_actualizar_salto_con_etiqueta(void *terceto_salto, void *terceto_etiqueta)
{
    if (terceto_salto == NULL || terceto_etiqueta == NULL)
        return;

    t_gci_tercetos_dato *salto = (t_gci_tercetos_dato *)terceto_salto;
    t_gci_tercetos_dato *etiqueta = (t_gci_tercetos_dato *)terceto_etiqueta;

    if (salto->b != NULL)
    {
        free(salto->b);
    }

    salto->b = strdup(etiqueta->a);
}

void liberar_memoria_nodo(t_gci_tercetos_nodo *nodo)
{
    if (nodo == NULL)
        return;

    t_gci_tercetos_nodo *siguiente = nodo->siguiente;

    liberar_memoria_terceto(nodo->dato);
    free(nodo);

    liberar_memoria_nodo(siguiente);
}

void liberar_memoria_terceto(t_gci_tercetos_dato *terceto)
{
    free(terceto->a);
    free(terceto->b);
    free(terceto->c);
}

void escribir_terceto_en_archivo(FILE *arch, t_gci_tercetos_nodo *nodo)
{
    if (nodo->siguiente == NULL)
    {
        fprintf(
            arch,
            "[%d]   (%s, %s, %s)",
            nodo->dato->indice,
            nodo->dato->a,
            valores_obtener_para_almacenar(nodo->dato->b),
            valores_obtener_para_almacenar(nodo->dato->c));

        return;
    }

    fprintf(
        arch,
        "[%d]   (%s, %s, %s)\n",
        nodo->dato->indice,
        nodo->dato->a,
        valores_obtener_para_almacenar(nodo->dato->b),
        valores_obtener_para_almacenar(nodo->dato->c));
}

char *obtener_indice_de_un_terceto(void *c)
{
    if (c == NULL)
        return c;

    t_gci_tercetos_dato *dato = (t_gci_tercetos_dato *)c;

    char *valor = malloc(VALIDACIONES_MAX_LONGITUD_STRING);
    if (valor == NULL)
    {
        informes_gci_tercetos_imprimir_error("No hay memoria suficiente para crear el string del indice");
        exit(1);
    }

    sprintf(valor, "[%d]", dato->indice);

    return valor;
}

void *obtener_terceto_en_string(t_gci_tercetos_dato *dato, char *mensaje)
{
    // char mensaje[VALIDACIONES_MAX_LONGITUD_STRING];
    sprintf(mensaje,
            "[%d]   (%s, %s, %s)",
            dato->indice,
            dato->a,
            valores_obtener_para_almacenar(dato->b),
            valores_obtener_para_almacenar(dato->c));

    return mensaje;
}