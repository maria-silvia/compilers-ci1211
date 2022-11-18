#include "simbolos.h"

tabela_de_simbolos *init_tabela() {

    tabela_de_simbolos *t = malloc(sizeof(tabela_de_simbolos));

    t->s = init_pilha();

}

void print_simb(void *s) {
    printf("[ident=%s, cat=%s]", ((simb *)s)->ident, ((simb *)s)->cat);
}

void print_tabela(tabela_de_simbolos *t) {

    print_pilha(t->s, print_simb);

}

void insere(tabela_de_simbolos *t, char *ident, char *cat) {

    simb *s = (simb *)malloc(sizeof(simb));

    s->ident = ident;
    s->cat = cat;

    push(t->s, s);

}

int igual_ident(void *a, void *b) {

    return !strcmp( ((simb *)a)->ident, (char *)b );
}

simb *busca(tabela_de_simbolos *t, char *ident) {

    simb *aux = (simb *)search(t->s, igual_ident, (void *)ident);

    return aux;
}

void retira(tabela_de_simbolos *t, int n) {

    for (int i=0; i<n; i++)
        pop(t->s);

}
