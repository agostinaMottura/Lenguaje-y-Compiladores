#ifndef ASSEMBLER_GENERADORES_H
#define ASSEMBLER_GENERADORES_H

#include "../gci/tercetos/tercetos.h"
#include "../tabla-simbolos/tabla_simbolos.h"

// Funciones Públicas
void assembler_generadores_asignacion(
    FILE *f, 
    t_gci_tercetos_dato *terceto, 
    t_gci_tercetos_lista_tercetos *lista, 
    t_tabla_simbolos *tabla,
    t_gci_tercetos_dato **vec, 
    int vec_size);

void assembler_generadores_write(
    FILE *f, 
    t_gci_tercetos_dato *terceto,
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla);

void assembler_generadores_read(
    FILE *f, 
    t_gci_tercetos_dato *terceto,
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla);

void assembler_generadores_comparacion(
    FILE *f, 
    t_gci_tercetos_dato *terceto,
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla);

void assembler_generadores_salto(
    FILE *f, 
    t_gci_tercetos_dato *terceto,
    const char *instr_salto);

void assembler_generadores_operacion_aritmetica(
    FILE *f, 
    t_gci_tercetos_dato *terceto,
    const char *operador_asm,
    t_gci_tercetos_dato **vec, 
    int vec_size,
    t_tabla_simbolos *tabla);

// Funciones Privadas
void generar_asignacion_string(
    FILE *f, 
    const char *origen, 
    const char *destino);
void generar_asignacion_numerica(
    FILE *f, 
    const char *valor_c, 
    const char *destino, 
    int es_resultado_operacion);
void resolver_operando(
    const char *op, 
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla);
int parsear_indice(const char *s, int *indice);

#endif // ASSEMBLER_GENERADORES_H