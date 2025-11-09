#include "assembler.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void imprimir_mensaje(char *mensaje) { printf("[ASSEMBLER] %s\n", mensaje); }

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

void escribir_valor_data(FILE *archivo_assembler,
                         const t_tabla_simbolos_dato *dato) {
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
    snprintf(mensaje, sizeof(mensaje), "    %-40s %-8s %s, '$', 3 dup (?)",
             dato->nombre, "db", valor_con_comillas);
    free(valor_con_comillas);
  } else if (dato->tipo_dato == TIPO_DATO_STRING) {
    // Variable string sin valor inicial - reservar espacio para 50 caracteres
    snprintf(mensaje, sizeof(mensaje), "    %-40s %-8s 50 dup (?), '$'",
             dato->nombre, "db");
  } else {
    const char *valor_a_escribir = dato->valor;
    char valor_flotante[256];

    // Si no tiene valor o es "__", usar "?"
    if (!valor_a_escribir || strcmp(valor_a_escribir, "__") == 0 || strlen(valor_a_escribir) == 0) {
      valor_a_escribir = "?";
    } else if (dato->tipo_dato == TIPO_DATO_CTE_INT && dato->valor) {
      snprintf(valor_flotante, sizeof(valor_flotante), "%s.0", dato->valor);
      valor_a_escribir = valor_flotante;
    }

    snprintf(mensaje, sizeof(mensaje), "    %-40s %-8s %s", dato->nombre,
             obtener_tipo_de_dato(dato), valor_a_escribir);
  }

  fprintf(archivo_assembler, "%s\n", mensaje);
}

char *mapear_operador(const char *operador) {
  if (operador == NULL)
    return NULL;
  if (strcmp(operador, "+") == 0)
    return "FADD";
  if (strcmp(operador, "-") == 0)
    return "FSUB";
  if (strcmp(operador, "*") == 0)
    return "FMUL";
  if (strcmp(operador, "/") == 0)
    return "FDIV";
  return NULL;
}

char *mapear_salto_condicional(const char *operador) {
  if (operador == NULL)
    return NULL;
  if (strcmp(operador, "BLE") == 0)
    return "JBE";
  if (strcmp(operador, "BLT") == 0)
    return "JB";
  if (strcmp(operador, "BGT") == 0)
    return "JA";
  if (strcmp(operador, "BGE") == 0)
    return "JAE";
  if (strcmp(operador, "BEQ") == 0)
    return "JE";
  if (strcmp(operador, "BNE") == 0)
    return "JNE";
  if (strcmp(operador, "BI") == 0)
    return "JMP";
  return NULL;
}

int parsear_indice(const char *s, int *out_indice) {
  if (s == NULL)
    return 0;
  size_t len = strlen(s);
  char buffer[64];
  size_t n = len - 2;
  if (n >= sizeof(buffer))
    return 0;
  memcpy(buffer, s + 1, n);
  buffer[n] = '\0';
  char *endptr = NULL;
  long v = strtol(buffer, &endptr, 10);
  if (endptr == buffer || *endptr != '\0')
    return 0;
  *out_indice = (int)v;
  return 1;
}

t_gci_tercetos_dato *
obtener_terceto_por_indice(t_gci_tercetos_lista_tercetos *lista, int indice) {
  if (lista == NULL)
    return NULL;
  t_gci_tercetos_nodo *n = lista->primero;
  while (n) {
    if (n->dato && n->dato->indice == indice)
      return n->dato;
    n = n->siguiente;
  }
  return NULL;
}

const char *tabla_buscar_nombre_por_valor(t_tabla_simbolos *tabla,
                                          const char *valor) {
  if (tabla == NULL || valor == NULL)
    return NULL;
  t_tabla_simbolos_nodo *n = tabla->primero;
  while (n) {
    if (n->dato.valor && strcmp(n->dato.valor, valor) == 0) {
      return n->dato.nombre;
    }
    n = n->siguiente;
  }
  return NULL;
}

int es_operador_aritmetico(const char *a) {
  if (a == NULL)
    return 0;
  return (strcmp(a, "+") == 0 || strcmp(a, "-") == 0 || strcmp(a, "*") == 0 ||
          strcmp(a, "/") == 0);
}

int es_etiqueta(const char *a) {
  if (a == NULL)
    return 0;
  // Una etiqueta empieza con "etiqueta_"
  return (strncmp(a, "etiqueta_", 9) == 0);
}

int es_constante_numerica_token(const char *token) {
  if (token == NULL || token[0] == '\0')
    return 0;
  return ((token[0] >= '0' && token[0] <= '9') || token[0] == '-' ||
          token[0] == '.');
}

const char *resolver_nombre_operando(const char *op,
                                     t_gci_tercetos_lista_tercetos *lista,
                                     t_tabla_simbolos *tabla) {
  if (op == NULL)
    return NULL;
  if (strcmp(op, "__") == 0)
    return NULL;

  int idx = -1;
  const char *token = op;

  if (parsear_indice(op, &idx)) {
    t_gci_tercetos_dato *t = obtener_terceto_por_indice(lista, idx);
    if (t == NULL || t->a == NULL)
      return NULL;
    if (es_operador_aritmetico(t->a)) {
      return NULL;
    }
    token = t->a;
  }

  const char *nombre_en_tabla = tabla_buscar_nombre_por_valor(tabla, token);
  if (nombre_en_tabla) {
    return nombre_en_tabla;
  }

  /* Si no se encuentra en la tabla, usar el token tal cual */
  return token;
}

void generar_assembler(t_gci_tercetos_lista_tercetos *tercetos,
                       t_tabla_simbolos *tabla) {
  FILE *archivo_assembler;
  archivo_assembler = fopen("assembler.asm", "wt");
  if (archivo_assembler == NULL) {
    imprimir_mensaje("Error al abrir el archivo assembler.asm");
    exit(1);
  }

  fprintf(archivo_assembler, ".DATA\n");

  t_tabla_simbolos_nodo *simbolo = tabla->primero;
  while (simbolo) {
    escribir_valor_data(archivo_assembler, &simbolo->dato);
    simbolo = simbolo->siguiente;
  }

  fprintf(archivo_assembler, "\n\n.CODE\n");
  fprintf(archivo_assembler, "MOV EAX,@DATA\n");
  fprintf(archivo_assembler, "MOV DS,EAX\n");
  fprintf(archivo_assembler, "MOV ES,EAX\n\n");

  int max_indice = -1;
  int cantidad = 0;
  t_gci_tercetos_nodo *nodo = tercetos ? tercetos->primero : NULL;
  while (nodo) {
    if (nodo->dato && nodo->dato->indice > max_indice)
      max_indice = nodo->dato->indice;
    cantidad++;
    nodo = nodo->siguiente;
  }
  int vector_size = max_indice + 1;
  t_gci_tercetos_dato **vec = NULL;
  vec = (t_gci_tercetos_dato **)calloc((size_t)vector_size,
                                       sizeof(t_gci_tercetos_dato *));
  if (vec == NULL) {
    imprimir_mensaje("Error de memoria al construir vector de tercetos");
    fclose(archivo_assembler);
    exit(1);
  }

  nodo = tercetos->primero;
  while (nodo) {
    if (nodo->dato && nodo->dato->indice >= 0 &&
        nodo->dato->indice < vector_size)
      vec[nodo->dato->indice] = nodo->dato;
    nodo = nodo->siguiente;
  }

  for (int i = 0; i < vector_size; i++) {
    t_gci_tercetos_dato *t = vec[i];
    if (t == NULL || t->a == NULL)
      continue;

    if (es_etiqueta(t->a)) {
      fprintf(archivo_assembler, "%s:\n", t->a);
      continue;
    }

    if (strcmp(t->a, ":=") == 0) {
      int idx_c = -1;
      int es_operacion_c = 0;

      if (parsear_indice(t->c, &idx_c)) {
        if (idx_c >= 0 && idx_c < vector_size) {
          t_gci_tercetos_dato *tc = vec[idx_c];
          if (tc && tc->a && es_operador_aritmetico(tc->a)) {
            es_operacion_c = 1;
          }
        }
      }

      if (!es_operacion_c) {
        const char *nombre_c = resolver_nombre_operando(t->c, tercetos, tabla);
        if (nombre_c)
          fprintf(archivo_assembler, "FLD %s\n", nombre_c);
      }

      const char *nombre_id = resolver_nombre_operando(t->b, tercetos, tabla);
      if (nombre_id)
        fprintf(archivo_assembler, "FSTP %s\n", nombre_id);

      continue;
    }

    if (strcmp(t->a, "write") == 0) {
      const char *nombre_valor =
          resolver_nombre_operando(t->b, tercetos, tabla);
      if (nombre_valor) {
        t_tabla_simbolos_dato *dato = tabla_simbolos_obtener_dato(nombre_valor);
        if (dato != NULL && (dato->tipo_dato == TIPO_DATO_STRING || 
                             dato->tipo_dato == TIPO_DATO_CTE_STRING)) {
          fprintf(archivo_assembler, "displayString %s\n", nombre_valor);
        } else {
          fprintf(archivo_assembler, "DisplayFloat %s,2\n", nombre_valor);
        }
      }
      continue;
    }

    if (strcmp(t->a, "read") == 0) {
      const char *nombre_variable =
          resolver_nombre_operando(t->b, tercetos, tabla);
      if (nombre_variable) {
        t_tabla_simbolos_dato *dato = tabla_simbolos_obtener_dato(nombre_variable);
        if (dato != NULL && dato->tipo_dato == TIPO_DATO_STRING) {
          fprintf(archivo_assembler, "getString %s\n", nombre_variable);
        } else {
          fprintf(archivo_assembler, "GetFloat %s\n", nombre_variable);
        }
      }
      continue;
    }

    if (strcmp(t->a, "CMP") == 0) {
      const char *nombre_valor_b =
          resolver_nombre_operando(t->b, tercetos, tabla);
      const char *nombre_valor_c =
          resolver_nombre_operando(t->c, tercetos, tabla);
      if (nombre_valor_b && nombre_valor_c) {
        fprintf(archivo_assembler, "FLD %s\n", nombre_valor_b);
        fprintf(archivo_assembler, "FLD %s\n", nombre_valor_c);
        fprintf(archivo_assembler, "FXCH\n");
        fprintf(archivo_assembler, "FCOM\n");
        fprintf(archivo_assembler, "FSTSW AX\n");
        fprintf(archivo_assembler, "SAHF\n");
      }
      continue;
    }

    const char *salto_asm = mapear_salto_condicional(t->a);
    if (salto_asm != NULL) {
      // El destino del salto puede ser una etiqueta directamente o un índice
      const char *destino = t->b;
      
      if (destino != NULL && strcmp(destino, "__") != 0) {
        // Si es una etiqueta, usarla directamente
        if (strncmp(destino, "etiqueta_", 9) == 0) {
          fprintf(archivo_assembler, "%s %s\n", salto_asm, destino);
        } else {
          // Si es un índice [X], convertir a LABEL_X (compatibilidad con código viejo)
          int idx_destino = -1;
          if (parsear_indice(destino, &idx_destino)) {
            fprintf(archivo_assembler, "%s LABEL_%d\n", salto_asm, idx_destino);
          }
        }
      }
      continue;
    }

    const char *mnemonic = mapear_operador(t->a);
    if (mnemonic == NULL)
      continue;

    /* Para cada operando b y c: si es indice y el terceto apuntado no es
       operador, emitir FLD del simbolo (si existe en TS) o del token tal cual
     */
    int idx_b = -1;
    if (parsear_indice(t->b, &idx_b)) {
      if (idx_b >= 0 && idx_b < vector_size) {
        t_gci_tercetos_dato *tb = vec[idx_b];
        if (tb && tb->a && !es_operador_aritmetico(tb->a)) {
          const char *nombre_cte = tabla_buscar_nombre_por_valor(tabla, tb->a);
          const char *simbolo = nombre_cte ? nombre_cte : tb->a;
          if (simbolo)
            fprintf(archivo_assembler, "FLD %s\n", simbolo);
        }
      }
    }
    int idx_c = -1;
    if (parsear_indice(t->c, &idx_c)) {
      if (idx_c >= 0 && idx_c < vector_size) {
        t_gci_tercetos_dato *tc = vec[idx_c];
        if (tc && tc->a && !es_operador_aritmetico(tc->a)) {
          const char *nombre_cte = tabla_buscar_nombre_por_valor(tabla, tc->a);
          const char *simbolo = nombre_cte ? nombre_cte : tc->a;
          if (simbolo)
            fprintf(archivo_assembler, "FLD %s\n", simbolo);
        }
      }
    }
    fprintf(archivo_assembler, "%s\n", mnemonic);
  }

  free(vec);

  fclose(archivo_assembler);
}
