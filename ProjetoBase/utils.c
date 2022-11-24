#include "utils.h"

tipo_t string2type (char *s) {

    if (!strcmp(s, "integer"))
        return Inteiro;
    else if (!strcmp(s, "boolean"))
        return Booleano;
    else
        return -1;
}
