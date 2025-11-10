#include "assembler.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STRING_BUFFER_SIZE 512
#define MAX_INDEX_BUFFER 64
#define STRING_MAX_LENGTH 50
#define STRING_EXTRA_SPACE 3

/* ========== UTILIDADES GENERALES ========== */

static void imprimir_error(const char *mensaje) {
    fprintf(stderr, "[ASSEMBLER ERROR] %s\n", mensaje);
    exit(1);
}

static int es_valor_nulo_o_vacio(const char *valor) {
    return !valor || strcmp(valor, "__") == 0 || strlen(valor) == 0;
}

/* ========== TIPOS DE DATO Y MAPEOS ========== */

static const char *obtener_tipo_asm(const t_tabla_simbolos_dato *dato) {
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
            return "dd";
    }
}

static const char *mapear_operador_aritmetico(const char *op) {
    if (!op) return NULL;
    if (strcmp(op, "+") == 0) return "FADD";
    if (strcmp(op, "-") == 0) return "FSUB";
    if (strcmp(op, "*") == 0) return "FMUL";
    if (strcmp(op, "/") == 0) return "FDIV";
    return NULL;
}

static const char *mapear_salto_condicional(const char *op) {
    if (!op) return NULL;
    if (strcmp(op, "BLE") == 0) return "JBE";
    if (strcmp(op, "BLT") == 0) return "JB";
    if (strcmp(op, "BGT") == 0) return "JA";
    if (strcmp(op, "BGE") == 0) return "JAE";
    if (strcmp(op, "BEQ") == 0) return "JE";
    if (strcmp(op, "BNE") == 0) return "JNE";
    if (strcmp(op, "BI") == 0) return "JMP";
    return NULL;
}

/* ========== PARSEO DE ÍNDICES ========== */

static int parsear_indice(const char *s, int *indice) {
    if (!s || strlen(s) < 3) return 0;
    
    char buffer[MAX_INDEX_BUFFER];
    size_t len = strlen(s) - 2;
    
    if (len >= MAX_INDEX_BUFFER) return 0;
    
    memcpy(buffer, s + 1, len);
    buffer[len] = '\0';
    
    char *endptr;
    long val = strtol(buffer, &endptr, 10);
    
    if (endptr == buffer || *endptr != '\0') return 0;
    
    *indice = (int)val;
    return 1;
}

/* ========== BÚSQUEDA EN TERCETOS Y TABLA DE SÍMBOLOS ========== */

static t_gci_tercetos_dato *buscar_terceto_por_indice(
    t_gci_tercetos_lista_tercetos *lista, int indice) {
    if (!lista) return NULL;
    
    t_gci_tercetos_nodo *nodo = lista->primero;
    while (nodo) {
        if (nodo->dato && nodo->dato->indice == indice)
            return nodo->dato;
        nodo = nodo->siguiente;
    }
    return NULL;
}

static const char *buscar_nombre_por_valor(
    t_tabla_simbolos *tabla, const char *valor) {
    if (!tabla || !valor) return NULL;
    
    t_tabla_simbolos_nodo *nodo = tabla->primero;
    while (nodo) {
        if (nodo->dato.valor && strcmp(nodo->dato.valor, valor) == 0)
            return nodo->dato.nombre;
        nodo = nodo->siguiente;
    }
    return NULL;
}

/* ========== PREDICADOS ========== */

static int es_operador_aritmetico(const char *op) {
    if (!op) return 0;
    return strcmp(op, "+") == 0 || strcmp(op, "-") == 0 ||
           strcmp(op, "*") == 0 || strcmp(op, "/") == 0;
}

static int es_etiqueta(const char *token) {
    return token && strncmp(token, "etiqueta_", 9) == 0;
}

static int es_tipo_string(const t_tabla_simbolos_dato *dato) {
    return dato && (dato->tipo_dato == TIPO_DATO_CTE_STRING ||
                    dato->tipo_dato == TIPO_DATO_STRING);
}

/* ========== RESOLUCIÓN DE OPERANDOS ========== */

static const char *resolver_operando(
    const char *op, 
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla) {
    if (!op || strcmp(op, "__") == 0) return NULL;
    
    int idx;
    const char *token = op;
    
    if (parsear_indice(op, &idx)) {
        t_gci_tercetos_dato *terceto = buscar_terceto_por_indice(lista, idx);
        if (!terceto || !terceto->a || es_operador_aritmetico(terceto->a))
            return NULL;
        token = terceto->a;
    }
    
    const char *nombre = buscar_nombre_por_valor(tabla, token);
    return nombre ? nombre : token;
}

/* ========== ESCRITURA DE DATOS ========== */

static void escribir_string_constante(
    FILE *f, const t_tabla_simbolos_dato *dato) {
    const char *valor = dato->valor ? dato->valor : "";
    char *quoted = malloc(strlen(valor) + 3);
    
    if (!quoted) imprimir_error("Error al formatear string constante");
    
    sprintf(quoted, "\"%s\"", valor);
    fprintf(f, "    %-40s %-8s %s, '$', %d dup (?)\n",
            dato->nombre, "db", quoted, STRING_EXTRA_SPACE);
    free(quoted);
}

static void escribir_string_variable(
    FILE *f, const t_tabla_simbolos_dato *dato) {
    fprintf(f, "    %-40s %-8s %d dup (?), '$'\n",
            dato->nombre, "db", STRING_MAX_LENGTH);
}

static void escribir_dato_numerico(
    FILE *f, const t_tabla_simbolos_dato *dato) {
    const char *valor = dato->valor;
    char buffer[256];
    
    if (es_valor_nulo_o_vacio(valor)) {
        valor = "?";
    } else if (dato->tipo_dato == TIPO_DATO_CTE_INT) {
        snprintf(buffer, sizeof(buffer), "%s.0", dato->valor);
        valor = buffer;
    }
    
    fprintf(f, "    %-40s %-8s %s\n",
            dato->nombre, obtener_tipo_asm(dato), valor);
}

static void escribir_dato(FILE *f, const t_tabla_simbolos_dato *dato) {
    if (dato->tipo_dato == TIPO_DATO_CTE_STRING)
        escribir_string_constante(f, dato);
    else if (dato->tipo_dato == TIPO_DATO_STRING)
        escribir_string_variable(f, dato);
    else
        escribir_dato_numerico(f, dato);
}

/* ========== SECCIÓN DE DATOS ========== */

static void escribir_seccion_datos(FILE *f, t_tabla_simbolos *tabla) {
    fprintf(f, ".DATA\n");
    
    t_tabla_simbolos_nodo *nodo = tabla->primero;
    while (nodo) {
        escribir_dato(f, &nodo->dato);
        nodo = nodo->siguiente;
    }
    fprintf(f, "\n\n");
}

/* ========== CONSTRUCCIÓN DE VECTOR DE TERCETOS ========== */

static t_gci_tercetos_dato **construir_vector_tercetos(
    t_gci_tercetos_lista_tercetos *lista, int *out_size) {
    if (!lista) return NULL;
    
    int max_idx = -1;
    t_gci_tercetos_nodo *nodo = lista->primero;
    
    while (nodo) {
        if (nodo->dato && nodo->dato->indice > max_idx)
            max_idx = nodo->dato->indice;
        nodo = nodo->siguiente;
    }
    
    *out_size = max_idx + 1;
    t_gci_tercetos_dato **vec = calloc(*out_size, sizeof(t_gci_tercetos_dato *));
    
    if (!vec) imprimir_error("Error al construir vector de tercetos");
    
    nodo = lista->primero;
    while (nodo) {
        if (nodo->dato && nodo->dato->indice >= 0 && nodo->dato->indice < *out_size)
            vec[nodo->dato->indice] = nodo->dato;
        nodo = nodo->siguiente;
    }
    
    return vec;
}

/* ========== GENERACIÓN DE INSTRUCCIONES ========== */

static void generar_asignacion_string(
    FILE *f, const char *origen, const char *destino) {
    t_tabla_simbolos_dato *dato_origen = tabla_simbolos_obtener_dato(origen);
    
    if (!dato_origen) return;
    
    fprintf(f, "LEA ESI, %s\n", origen);
    fprintf(f, "LEA EDI, %s\n", destino);
    fprintf(f, "MOV ECX, %d\n", dato_origen->longitud + 1);
    fprintf(f, "REP MOVSB\n\n");

    fprintf(f, "displayString %s\n", destino);
    fprintf(f, "newLine\n");
}

static void generar_asignacion_numerica(
    FILE *f, const char *valor_c, const char *destino, 
    int es_resultado_operacion) {
    if (!es_resultado_operacion && valor_c)
        fprintf(f, "FLD %s\n", valor_c);
    if (destino)
        fprintf(f, "FSTP %s\n", destino);

    // agregar displayFlat para ver el resultado en consola
    if (destino) {
        fprintf(f, "DisplayFloat %s, 2\n", destino);
        fprintf(f, "newLine\n");
    }
}

static void generar_asignacion(
    FILE *f, t_gci_tercetos_dato *terceto, 
    t_gci_tercetos_lista_tercetos *lista, 
    t_tabla_simbolos *tabla,
    t_gci_tercetos_dato **vec, int vec_size) {
    
    const char *destino = resolver_operando(terceto->b, lista, tabla);
    const char *origen = resolver_operando(terceto->c, lista, tabla);
    
    t_tabla_simbolos_dato *dato = origen ? tabla_simbolos_obtener_dato(origen) : NULL;
    
    if (dato && es_tipo_string(dato)) {
        generar_asignacion_string(f, origen, destino);
        return;
    }
    
    int idx_c, es_operacion = 0;
    if (parsear_indice(terceto->c, &idx_c) && 
        idx_c >= 0 && idx_c < vec_size) {
        t_gci_tercetos_dato *tc = vec[idx_c];
        if (tc && tc->a && es_operador_aritmetico(tc->a))
            es_operacion = 1;
    }
    
    generar_asignacion_numerica(f, origen, destino, es_operacion);
}

static void generar_write(
    FILE *f, t_gci_tercetos_dato *terceto,
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla) {
    
    const char *nombre = resolver_operando(terceto->b, lista, tabla);
    if (!nombre) return;
    
    t_tabla_simbolos_dato *dato = tabla_simbolos_obtener_dato(nombre);
    
    if (es_tipo_string(dato))
    {
       fprintf(f, "displayString %s\n", nombre);
        fprintf(f, "newLine\n");
    }
    else
        fprintf(f, "DisplayFloat %s,2\n", nombre);
}

static void generar_read(
    FILE *f, t_gci_tercetos_dato *terceto,
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla) {
    
    const char *nombre = resolver_operando(terceto->b, lista, tabla);
    if (!nombre) return;
    
    t_tabla_simbolos_dato *dato = tabla_simbolos_obtener_dato(nombre);
    
    if (dato && dato->tipo_dato == TIPO_DATO_STRING)
    {
      fprintf(f, "getString %s\n", nombre);
      fprintf(f, "displayString %s\n", nombre);
      fprintf(f, "newLine\n");
    }
    else
        {
      fprintf(f, "GetFloat %s\n", nombre);
      fprintf(f, "DisplayFloat %s, 2\n", nombre); //muestra el valor leído y la cant dsp de la coma
      fprintf(f, "newLine\n");
    }
}

static void generar_comparacion(
    FILE *f, t_gci_tercetos_dato *terceto,
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla) {
    
    const char *op1 = resolver_operando(terceto->b, lista, tabla);
    const char *op2 = resolver_operando(terceto->c, lista, tabla);
    
    if (!op1 || !op2) return;
    
    fprintf(f, "FLD %s\n", op1);
    fprintf(f, "FLD %s\n", op2);
    fprintf(f, "FXCH\n");
    fprintf(f, "FCOM\n");
    fprintf(f, "FSTSW AX\n");
    fprintf(f, "SAHF\n");
}

static void generar_salto(
    FILE *f, t_gci_tercetos_dato *terceto, const char *instr_salto) {
    const char *destino = terceto->b;
    
    if (!destino || strcmp(destino, "__") == 0) return;
    
    if (es_etiqueta(destino)) {
        fprintf(f, "%s %s\n", instr_salto, destino);
    } else {
        int idx;
        if (parsear_indice(destino, &idx))
            fprintf(f, "%s LABEL_%d\n", instr_salto, idx);
    }
}

static void generar_operacion_aritmetica(
    FILE *f, t_gci_tercetos_dato *terceto,
    const char *operador_asm,
    t_gci_tercetos_dato **vec, int vec_size,
    t_tabla_simbolos *tabla) {
    
    int idx_b, idx_c;
    
    if (parsear_indice(terceto->b, &idx_b) && 
        idx_b >= 0 && idx_b < vec_size) {
        t_gci_tercetos_dato *tb = vec[idx_b];
        if (tb && tb->a && !es_operador_aritmetico(tb->a)) {
            const char *nombre = buscar_nombre_por_valor(tabla, tb->a);
            const char *simbolo = nombre ? nombre : tb->a;
            if (simbolo) fprintf(f, "FLD %s\n", simbolo);
        }
    }
    
    if (parsear_indice(terceto->c, &idx_c) && 
        idx_c >= 0 && idx_c < vec_size) {
        t_gci_tercetos_dato *tc = vec[idx_c];
        if (tc && tc->a && !es_operador_aritmetico(tc->a)) {
            const char *nombre = buscar_nombre_por_valor(tabla, tc->a);
            const char *simbolo = nombre ? nombre : tc->a;
            if (simbolo) fprintf(f, "FLD %s\n", simbolo);
        }
    }
    
    fprintf(f, "%s\n", operador_asm);
}

/* ========== PROCESAMIENTO DE TERCETOS ========== */

static void procesar_terceto(
    FILE *f, t_gci_tercetos_dato *terceto,
    t_gci_tercetos_lista_tercetos *lista,
    t_tabla_simbolos *tabla,
    t_gci_tercetos_dato **vec, int vec_size) {
    
    if (!terceto || !terceto->a) return;
    
    if (es_etiqueta(terceto->a)) {
        fprintf(f, "%s:\n", terceto->a);
        return;
    }
    
    if (strcmp(terceto->a, ":=") == 0) {
        generar_asignacion(f, terceto, lista, tabla, vec, vec_size);
        return;
    }
    
    if (strcmp(terceto->a, "write") == 0) {
        generar_write(f, terceto, lista, tabla);
        return;
    }
    
    if (strcmp(terceto->a, "read") == 0) {
        generar_read(f, terceto, lista, tabla);
        return;
    }
    
    if (strcmp(terceto->a, "CMP") == 0) {
        generar_comparacion(f, terceto, lista, tabla);
        return;
    }
    
    const char *instr_salto = mapear_salto_condicional(terceto->a);
    if (instr_salto) {
        generar_salto(f, terceto, instr_salto);
        return;
    }
    
    const char *operador_asm = mapear_operador_aritmetico(terceto->a);
    if (operador_asm) {
        generar_operacion_aritmetica(f, terceto, operador_asm, vec, vec_size, tabla);
        return;
    }
}

static void escribir_seccion_codigo(
    FILE *f, t_gci_tercetos_lista_tercetos *lista, 
    t_tabla_simbolos *tabla) {
    
    fprintf(f, ".CODE\n");

    fprintf(f, "\nSTART:\n");

    fprintf(f, "MOV AX,@DATA\n");
    fprintf(f, "MOV DS,AX\n");
    fprintf(f, "MOV ES,AX\n\n");

    
    
    int vec_size;
    t_gci_tercetos_dato **vec = construir_vector_tercetos(lista, &vec_size);
    
    for (int i = 0; i < vec_size; i++)
        procesar_terceto(f, vec[i], lista, tabla, vec, vec_size);
    
    fprintf(f, "\nMOV AX,4C00H\n");
    fprintf(f, "INT 21H\n");
    fprintf(f, "END START\n");
    
    free(vec);
}

/* ========== FUNCIÓN PRINCIPAL ========== */

void generar_assembler(
    t_gci_tercetos_lista_tercetos *tercetos,
    t_tabla_simbolos *tabla) {
    
    FILE *archivo = fopen("final.asm", "wt");
    if (!archivo) imprimir_error("No se pudo abrir final.asm");

    fprintf(archivo, "include C:\\asm\\macros2.asm\n");
    fprintf(archivo, "include C:\\asm\\number.asm\n");

    fprintf(archivo, ".MODEL LARGE\n");
    fprintf(archivo, ".386\n");
    fprintf(archivo, ".STACK 200h\n\n");
    
    escribir_seccion_datos(archivo, tabla);
    escribir_seccion_codigo(archivo, tercetos, tabla);
    
    fclose(archivo);
}
