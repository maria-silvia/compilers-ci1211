#ifndef __DESLOC__
#define __DESLOC__

#include <string.h>
#include "pilha.h"

typedef struct deslocamento {
    int x;
} deslocamento; 


typedef struct pilha_de_deslocs {
    stack_t *s;
} pilha_de_deslocs;

pilha_de_deslocs *init_deslocs();
void print_desloc(void *r);
void print_deslocs(pilha_de_deslocs *pd);
void push_desloc(pilha_de_deslocs *pd, int x);
int pop_desloc(pilha_de_deslocs *pd);

#endif
