#include "utils.h"

tipo_t string2type (char *s) {

    if (!strcmp(s, "integer"))
        return Inteiro;
    else if (!strcmp(s, "boolean"))
        return Booleano;
    else
        return -1;
}

int gera_codigo_com_endereco(tabela_de_simbolos *TS, char *comando, char *aux_ident) {

    simb *s = ts_busca(TS, aux_ident);
    if (s != NULL) {
        char aux_s[20];
        sprintf(aux_s, "%s %d, %d", comando, s->nivel_lexico, s->deslocamento);
        geraCodigo(NULL, aux_s);
        return 0;
    }
    imprimeErro("variavel nao declarada");
    return 1;
}