#include "simbolos.h"

tabela_de_simbolos *init_tabela() {

    tabela_de_simbolos *t = malloc(sizeof(tabela_de_simbolos));

    t->s = init_pilha();

}

void print_simb(void *s) {
    printf("[ident=%s,", ((simb *)s)->ident);
    printf("cat=%d,", (int)((simb *)s)->cat);
    printf("nivel_lexico=%d,",(int)((simb *)s)->nivel_lexico );
    printf("deslocamento=%d,", (int)((simb *)s)->deslocamento);
    printf("tipo=%d]\n", (int)((simb *)s)->tipo);
}

void print_tabela(tabela_de_simbolos *t) {
    printf("TABELA SIMBOLOS: \n");
    print_pilha(t->s, print_simb);

}

void ts_insere_vs(tabela_de_simbolos *t, char *ident, int nivel_lexico, int deslocamento) {

    simb *s = (simb *)malloc(sizeof(simb));

    //s->ident = ident;
    //s->cat = cat;

    s->ident = (char *)malloc(sizeof(char)*strlen(ident));
    strcpy(s->ident, ident);

    s->cat = VS;
    s->nivel_lexico = nivel_lexico;
    s->deslocamento = deslocamento;

    push(t->s, s);

}

void ts_insere_proc(tabela_de_simbolos *t, char *ident, int nivel_lexico, int rotulo) {

    simb *s = (simb *)malloc(sizeof(simb));

    s->ident = (char *)malloc(sizeof(char)*strlen(ident));
    strcpy(s->ident, ident);

    s->cat = PROC;
    s->nivel_lexico = nivel_lexico;
    s->rotulo = rotulo;

    s->num_param = 0;

    s->tam_param = 10;
    s->param = (int *)malloc(s->tam_param*2*sizeof(int));

    push(t->s, s);

}

int igual_ident(void *a, void *b) {

    return !strcmp( ((simb *)a)->ident, (char *)b );
}

void ts_add_params(tabela_de_simbolos *t, char *ident, modo_param_t mp, tipo_t tipo, int n){

    simb *proc = (simb *)search(t->s, igual_ident, (void *)ident);

    for (int i=0; i<n; i++) {

        if (proc->num_param >= proc->tam_param) {
            proc->tam_param = 2*proc->tam_param;
            proc->param = realloc(proc->param, proc->tam_param*2*sizeof(int));
        }

        proc->param[2*proc->num_param] = tipo; 
        proc->param[2*proc->num_param+1] = mp;

        proc->num_param += 1; 
    }
}


simb *ts_busca(tabela_de_simbolos *t, char *ident) {

    simb *aux = (simb *)search(t->s, igual_ident, (void *)ident);

    return aux;
}

void ts_retira(tabela_de_simbolos *t, int n) {

    for (int i=0; i<n; i++)
        pop(t->s);

}


void ts_insere_tipo(tabela_de_simbolos *t, int n, tipo_t tipo) {

    for (int i=t->s->tam-1; i>=t->s->tam-n; i--) {
        simb *aux_s = t->s->p[i];
        aux_s->tipo = tipo;
    }

}

