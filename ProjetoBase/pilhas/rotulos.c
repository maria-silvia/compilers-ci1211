#include "rotulos.h"

int rot_num;

pilha_de_rotulos *init_rotulos() {

    pilha_de_rotulos *p;

    p = (pilha_de_rotulos *)malloc(sizeof(pilha_de_rotulos));

    rot_num = 0;
    p->s = init_pilha();

    return p;
    
}

void print_rotulo(void *r) {
    printf("R%d ", ((rotulo *)r)->id);
}

void print_rotulos(pilha_de_rotulos *pr) {

    print_pilha(pr->s, print_rotulo);

}

int gera_rotulos(pilha_de_rotulos *pr) {
    printf("> GERA ROTULO: \n");
    rotulo *rot = (rotulo *)malloc(sizeof(rotulo));

    rot->id = rot_num;
    push(pr->s, rot);
    rot_num++;
    print_rotulos(pr);
    return rot->id;
}

int pop_rot(pilha_de_rotulos *pr) {
    printf("> POP ROTULO: \n");
    rotulo *topo = pop(pr->s);
    print_rotulos(pr);
    return topo->id;
}
