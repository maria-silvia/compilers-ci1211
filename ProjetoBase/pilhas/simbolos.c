#include "simbolos.h"

tabela_de_simbolos *init_tabela() {

    tabela_de_simbolos *t = malloc(sizeof(tabela_de_simbolos));

    t->s = init_pilha();

}

void print_simb(void *s) {
    printf("[ident=%s, cat=%d]", ((simb *)s)->ident, (int)*((simb *)s)->cat);
}

void print_tabela(tabela_de_simbolos *t) {

    print_pilha(t->s, print_simb);

}

void ts_insere(tabela_de_simbolos *t, char *ident, categoria_t cat) {

    simb *s = (simb *)malloc(sizeof(simb));

    //s->ident = ident;
    //s->cat = cat;

    s->ident = (char *)malloc(sizeof(char)*strlen(ident));
    strcpy(s->ident, ident);
    s->cat = (categoria_t *)malloc(sizeof(categoria_t));
    *(s->cat) = cat;

    push(t->s, s);

}

int igual_ident(void *a, void *b) {

    return !strcmp( ((simb *)a)->ident, (char *)b );
}

simb *busca(tabela_de_simbolos *t, char *ident) {

    simb *aux = (simb *)search(t->s, igual_ident, (void *)ident);

    return aux;
}

void ts_retira(tabela_de_simbolos *t, int n) {

    for (int i=0; i<n; i++)
        pop(t->s);

}
