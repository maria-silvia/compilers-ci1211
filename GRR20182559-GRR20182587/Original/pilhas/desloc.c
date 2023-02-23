#include "desloc.h"

pilha_de_deslocs *init_deslocs() {

    pilha_de_deslocs *p;

    p = (pilha_de_deslocs *)malloc(sizeof(pilha_de_deslocs));

    p->s = init_pilha();

    return p;
    
}

void print_desloc(void *d) {
    printf("%d ", ((deslocamento *)d)->x);
}

void print_deslocs(pilha_de_deslocs *pd) {

    print_pilha(pd->s, print_desloc);

}


void push_desloc(pilha_de_deslocs *pd, int x) {
    printf("> PUSH DESLOC %d \n", x);
    deslocamento *d = (deslocamento *)malloc(sizeof(deslocamento));
    d->x = x;

    push(pd->s, d);
}


int pop_desloc(pilha_de_deslocs *pd) {
    printf("> POP DESLOC: \n");
    deslocamento *topo = pop(pd->s);
    print_deslocs(pd);
    return topo->x;
}
