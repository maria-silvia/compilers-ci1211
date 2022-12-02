#ifndef __ROT__
#define __ROT__

#include <string.h>
#include "pilha.h"

typedef struct rotulo {
    int id;
} rotulo; 


typedef struct pilha_de_rotulos {
    stack_t *s;
} pilha_de_rotulos;

pilha_de_rotulos *init_rotulos();
void print_rotulo(void *r);
void print_rotulos(pilha_de_rotulos *pr);
void gera_rotulos(pilha_de_rotulos *pr, int quant);
int pop_rot(pilha_de_rotulos *pr);
// void ts_insere(pilha_de_rotulos *pr, char *ident, categoria_t cat, int nivel_lexico, int deslocamento);
// simb *ts_busca(pilha_de_rotulos *pr, char *ident);
#endif
