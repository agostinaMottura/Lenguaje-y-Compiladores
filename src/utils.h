#ifndef UTILS_H
#define UTILS_H

#define UTILS_COLOR_RESET "\033[0m"
#define UTILS_COLOR_RED "\033[31m"
#define UTILS_COLOR_GREEN "\033[32m"
#define UTILS_COLOR_YELLOW "\033[33m"
#define UTILS_COLOR_BLUE "\033[34m"
#define UTILS_COLOR_MAGENTA "\033[35m"
#define UTILS_COLOR_CYAN "\033[36m"
#define UTILS_COLOR_WHITE "\033[37m"
#define UTILS_COLOR_BOLD "\033[1m"
#define UTILS_COLOR_NARANJA "\x1B[38;2;255;128;0m"

#define UTILS_MAX_STRING_MENSAJE_LONGITUD 256

void utils_imprimir_error(const char *mensaje);
const char *utils_obtener_string_sin_comillas(const char *str);
#endif // UTILS_H