#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "assembler.h"

void imprimir_mensaje(char *mensaje)
{
    printf("[ASSEMBLER] %s\n", mensaje);
}

const char *obtener_tipo_de_dato(const t_tabla_simbolos_dato *dato) {
    switch (dato->tipo_dato) {
        case TIPO_DATO_CTE_INT:
        case TIPO_DATO_CTE_FLOAT:
        case TIPO_DATO_INT:
        case TIPO_DATO_FLOAT:
            return "dd";
        case TIPO_DATO_CTE_STRING:
        case TIPO_DATO_STRING:
            return "db";
        default:
            return "unknown";
    }
}

void escribir_valor_data(FILE *archivo_assembler, const t_tabla_simbolos_dato *dato)
{
    char mensaje[512];
    if (dato->tipo_dato == TIPO_DATO_CTE_STRING) {
        const char *valor = dato->valor ? dato->valor : "";
        size_t longitud_valor = strlen(valor);
        char *valor_con_comillas = (char *)malloc(longitud_valor + 3);
        if (valor_con_comillas == NULL) {
            imprimir_mensaje("Error de memoria al formatear CTE_STRING");
            exit(1);
        }
        sprintf(valor_con_comillas, "\"%s\"", valor);
        snprintf(mensaje, sizeof(mensaje), "    %-40s %-8s %s, '$', 3 dup (?)", dato->nombre, "db", valor_con_comillas);
        free(valor_con_comillas);
    } else {
        snprintf(mensaje, sizeof(mensaje), "    %-40s %-8s %s", dato->nombre, obtener_tipo_de_dato(dato), dato->valor ? dato->valor : "");
    }

    fprintf(archivo_assembler, "%s\n", mensaje);
}

void generar_assembler(t_gci_tercetos_lista_tercetos *tercetos, t_tabla_simbolos *tabla)
{
    (void)tercetos;

    FILE* archivo_assembler;
    archivo_assembler = fopen("assembler.asm","wt");
    if (archivo_assembler == NULL)
    {
        imprimir_mensaje("Error al abrir el archivo assembler.asm");
        exit(1);
    }

    fprintf(archivo_assembler, ".data\n");

    t_tabla_simbolos_nodo *simbolo = tabla->primero;
    while (simbolo)
    {
        escribir_valor_data(archivo_assembler, &simbolo->dato);
        simbolo = simbolo->siguiente;
    }

    fprintf(archivo_assembler, ".code\n");

    fclose(archivo_assembler);
}


