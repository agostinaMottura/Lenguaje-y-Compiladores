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
            return "string";
        default:
            return "unknown";
    }
}

void escribir_valor_data(FILE *archivo_assembler, const t_tabla_simbolos_dato *dato)
{
    char mensaje[100];
    sprintf(mensaje, "    %-40s %-8s %s", dato->nombre, obtener_tipo_de_dato(dato), dato->valor ? dato->valor : "");
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

    fclose(archivo_assembler);
}


