#include "simbolos.h"

tabela_de_simbolos *init_tabela() {

    tabela_de_simbolos *t = malloc(sizeof(tabela_de_simbolos));

    t->s = init_pilha();

}

void print_simb(void *s) {
    printf("[ident=%s,", ((simb *)s)->ident);
    printf("cat=%d,", (int)((simb *)s)->cat);
    printf("nivel_lexico=%d,",(int)((simb *)s)->nivel_lexico );
    printf("deslocamento=%d]\n", (int)((simb *)s)->deslocamento);
}

void print_tabela(tabela_de_simbolos *t) {

    print_pilha(t->s, print_simb);

}

void ts_insere(tabela_de_simbolos *t, char *ident, categoria_t cat, int nivel_lexico, int deslocamento) {

    simb *s = (simb *)malloc(sizeof(simb));

    //s->ident = ident;
    //s->cat = cat;

    s->ident = (char *)malloc(sizeof(char)*strlen(ident));
    strcpy(s->ident, ident);

    s->cat = cat;
    s->nivel_lexico = nivel_lexico;
    s->deslocamento = deslocamento;

    push(t->s, s);

}

int igual_ident(void *a, void *b) {

    return !strcmp( ((simb *)a)->ident, (char *)b );
}

simb *ts_busca(tabela_de_simbolos *t, char *ident) {

    simb *aux = (simb *)search(t->s, igual_ident, (void *)ident);

    return aux;
}

void ts_retira(tabela_de_simbolos *t, int n) {

    for (int i=0; i<n; i++)
        pop(t->s);

}
