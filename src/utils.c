#include <stdio.h>
#include "./utils.h"

void utils_print_error(const char *message)
{
    printf(UTILS_COLOR_RED "[ERROR] %s" UTILS_COLOR_RESET "\n", message);
}