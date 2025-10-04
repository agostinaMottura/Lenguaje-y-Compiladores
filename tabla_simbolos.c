#include "tabla_simbolos.h"

// Definición de la tabla de símbolos global
t_tabla tabla_simbolos;

void crear_tabla_simbolos()
{
    tabla_simbolos.primero = NULL;
}

int insertar_tabla_simbolos(const char *nombre, const char *tipo,
           const char *valor_string, int valor_var_int,
           float valor_var_float)
{
    t_simbolo *tabla = tabla_simbolos.primero;
    char nombreCTE[100] = "_";
    strcat(nombreCTE, nombre);

    while (tabla)
    {
        if (strcmp(tipo, "STRING") == 0 || strcmp(tipo, "INT") == 0 || strcmp(tipo, "FLOAT") == 0 || strcmp(tipo, "ID") == 0)
        {
            if (strcmp(tabla->data.nombre, nombre) == 0)
            {
                return 1;
            }
        }
        else if (strcmp(tipo, "CTE_STRING") == 0)
        {
            if (strcmp(tabla->data.tipo, "CTE_STRING") == 0 &&
                strcmp(tabla->data.valor.valor_var_str, valor_string) == 0)
            {
                return 1;
            }
        }
        else if (strcmp(tipo, "CTE_INT") == 0)
        {
            if (strcmp(tabla->data.tipo, "CTE_INT") == 0 &&
                tabla->data.valor.valor_var_int == valor_var_int)
            {
                return 1;
            }
        }
        else if (strcmp(tipo, "CTE_FLOAT") == 0)
        {
            if (strcmp(tabla->data.tipo, "CTE_FLOAT") == 0 &&
                tabla->data.valor.valor_var_float == valor_var_float)
            {
                return 1;
            }
        }

        if (tabla->next == NULL)
        {
            break;
        }
        tabla = tabla->next;
    }

    t_data *data = crearDatos(nombre, tipo, valor_string, valor_var_int, valor_var_float);
    if (data == NULL)
    {
        return 1;
    }

    t_simbolo *nuevo = (t_simbolo *)malloc(sizeof(t_simbolo));
    if (nuevo == NULL)
    {
        free(data);
        return 2;
    }

    nuevo->data = *data;
    nuevo->next = NULL;

    if (tabla_simbolos.primero == NULL)
    {
        tabla_simbolos.primero = nuevo;
    }
    else
    {
        tabla->next = nuevo;
    }

    return 0;
}

t_data *crearDatos(const char *nombre, const char *tipo,
    const char *valString, int valor_var_int,
    float valor_var_float)
{
    t_data *data = (t_data *)calloc(1, sizeof(t_data));
    if (data == NULL)
    {
        return NULL;
    }

    data->tipo = (char *)malloc(sizeof(char) * (strlen(tipo) + 1));
    if (data->tipo == NULL)
    {
        free(data);
        return NULL;
    }
    strcpy(data->tipo, tipo);

    if (strcmp(tipo, "STRING") == 0 || strcmp(tipo, "INT") == 0 || strcmp(tipo, "FLOAT") == 0 || strcmp(tipo, "ID") == 0)
    {
        data->nombre = (char *)malloc(sizeof(char) * (strlen(nombre) + 1));
        if (data->nombre == NULL)
        {
            free(data->tipo);
            free(data);
            return NULL;
        }
        strcpy(data->nombre, nombre);
        // Inicializar explícitamente el valor a cero para IDs
        data->valor.valor_var_int = 0;
        data->valor.valor_var_float = 0.0;
        data->valor.valor_var_str = NULL;
        data->longitud = 0;
        return data;
    }
    else
    {
        char nombreCte[100] = "_";
        strcat(nombreCte, nombre);

        data->nombre = (char *)malloc(sizeof(char) * (strlen(nombreCte) + 1));
        if (data->nombre == NULL)
        {
            free(data->tipo);
            free(data);
            return NULL;
        }
        strcpy(data->nombre, nombreCte);

        if (strcmp(tipo, "CTE_STRING") == 0)
        {
            data->valor.valor_var_str = (char *)malloc(sizeof(char) * (strlen(valString) + 1));
            if (data->valor.valor_var_str == NULL)
            {
                free(data->nombre);
                free(data->tipo);
                free(data);
                return NULL;
            }
            strcpy(data->valor.valor_var_str, valString);
            data->longitud = strlen(valString) - 2; // Restar comillas
        }
        else if (strcmp(tipo, "CTE_FLOAT") == 0)
        {
            data->valor.valor_var_float = valor_var_float;
        }
        else if (strcmp(tipo, "CTE_INT") == 0)
        {
            data->valor.valor_var_int = valor_var_int;
        }

        return data;
    }

    // En caso de algún error
    free(data->tipo);
    free(data);
    return NULL;
}

void guardar_tabla_simbolos()
{
    FILE *arch;
    if ((arch = fopen("symbol-table.txt", "wt")) == NULL)
    {
        printf("\nNo se pudo crear la tabla de simbolos.\n\n");
        return;
    }
    else if (tabla_simbolos.primero == NULL)
    {
        printf("\nLa tabla de simbolos está vacía.\n\n");
        fclose(arch);
        return;
    }

    fprintf(arch, "%-55s%-30s%-55s%-30s\n", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");

    t_simbolo *tabla = tabla_simbolos.primero;
    char valor[100];
    char longitud[20];

    while (tabla)
    {
        strcpy(valor, "--");
        strcpy(longitud, "--");

        if (strcmp(tabla->data.tipo, "INT") == 0 ||
            strcmp(tabla->data.tipo, "FLOAT") == 0 ||
            strcmp(tabla->data.tipo, "STRING") == 0)
        {
            fprintf(arch, "%-55s%-30s%-55s%-30s\n",
                tabla->data.nombre,
                "--",
                "--",
                "--");
        }
        else if (strcmp(tabla->data.tipo, "ID") == 0)
        {
            fprintf(arch, "%-55s%-30s%-55s%-30s\n",
                tabla->data.nombre,
                "--",
                "--",
                "--");
        }
        else if (strcmp(tabla->data.tipo, "CTE_INT") == 0)
        {
            sprintf(valor, "%d", tabla->data.valor.valor_var_int);
            fprintf(arch, "%-55s%-30s%-55s%-30s\n",
                tabla->data.nombre,
                "CTE_INT",
                valor,
                "--");
        }
        else if (strcmp(tabla->data.tipo, "CTE_FLOAT") == 0)
        {
            sprintf(valor, "%f", tabla->data.valor.valor_var_float);
            fprintf(arch, "%-55s%-30s%-55s%-30s\n",
                tabla->data.nombre,
                "CTE_FLOAT",
                valor,
                "--");
        }
        else if (strcmp(tabla->data.tipo, "CTE_STRING") == 0)
        {
            char aux_string[100];
            if (strlen(tabla->data.valor.valor_var_str) >= 2)
            {
                strncpy(aux_string, tabla->data.valor.valor_var_str + 1,
                    strlen(tabla->data.valor.valor_var_str) - 2);
                aux_string[strlen(tabla->data.valor.valor_var_str) - 2] = '\0';

                sprintf(longitud, "%d", (int)strlen(aux_string));

                fprintf(arch, "%-55s%-30s%-55s%-30s\n",
                    tabla->data.nombre,
                    "CTE_STRING",
                    aux_string,
                    longitud);
            }
            else
            {
                fprintf(arch, "%-55s%-30s%-55s%-30s\n",
                    tabla->data.nombre,
                    "CTE_STRING",
                    tabla->data.valor.valor_var_str,
                    "0");
            }
        }

        t_simbolo *temp = tabla;
        tabla = tabla->next;
    }

    fclose(arch);
    printf("\nTabla de simbolos guardada correctamente.\n\n");
}
