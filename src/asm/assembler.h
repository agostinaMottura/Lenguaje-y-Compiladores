#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include "../gci/tercetos/tercetos.h"
#include "../tabla-simbolos/tabla_simbolos.h"

// Funciones Públicas
void assembler_generar(
    t_gci_tercetos_lista_tercetos *tercetos, 
    t_tabla_simbolos *tabla);

// Funciones Privadas
void escribir_seccion_datos(
    FILE *f, 
    t_tabla_simbolos *tabla);

void escribir_dato(
    FILE *f, 
    const t_tabla_simbolos_dato *dato);

void escribir_dato_numerico(
    FILE *f, 
    const t_tabla_simbolos_dato *dato);

void escribir_string_variable(
    FILE *f, 
    const t_tabla_simbolos_dato *dato);

void escribir_string_constante(
    FILE *f, 
    const t_tabla_simbolos_dato *dato);

void escribir_seccion_codigo(
    FILE *f, 
    t_gci_tercetos_lista_tercetos *lista, 
    t_tabla_simbolos *tabla);

void procesar_terceto(
    FILE *f, 
    t_gci_tercetos_dato *terceto,
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla,
    t_gci_tercetos_dato **vec, 
    int vec_size);



#endif