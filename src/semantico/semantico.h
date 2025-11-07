#ifndef SEMANTICO_H
#define SEMANTICO_H

#include "../tabla-simbolos/tipo-dato/tipo_dato.h"

int semantico_validacion_existe_simbolo_en_tabla_simbolos(
    const char *nombre);
int semantico_validacion_no_existe_simbolo_en_tabla_simbolos(
    const char *nombre);
int semantico_validacion_tipo_dato(
    const char *nombre,
    t_tipo_dato tipo_dato_buscado);
int semantico_son_tipos_de_datos_compatibles(
    t_tipo_dato tipo_dato_a,
    t_tipo_dato tipo_dato_b);

t_tipo_dato semantico_obtener_tipo_de_dato_resultante(
    t_tipo_dato tipo_dato_a,
    t_tipo_dato tipo_dato_b);
    
#endif // SEMANTICO_H