#include <stdio.h>
#include "./utils.h"

void print_error(const char *message)
{
    printf(COLOR_RED "[ERROR] %s" COLOR_RESET "\n", message);
}