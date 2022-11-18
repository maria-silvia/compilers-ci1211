#ifndef __SIMB__
#define __SIMB__

#include <string.h>
#include "pilha.h"

typedef struct simb {
    char *ident;
    char *cat;
    //outros atributos
} simb;

typedef struct tabela_de_simbolos {

    stack_t *s;

} tabela_de_simbolos;

tabela_de_simbolos *init_tabela();
void print_tabela(tabela_de_simbolos *t);
void insere(tabela_de_simbolos *t, char *ident, char *cat);
simb *busca(tabela_de_simbolos *t, char *ident);
void retira(tabela_de_simbolos *t, int n);
#endif
