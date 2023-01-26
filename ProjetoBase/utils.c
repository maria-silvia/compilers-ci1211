#include "utils.h"

tipo_t string2type (char *s) {

    if (!strcmp(s, "integer"))
        return Inteiro;
    else if (!strcmp(s, "boolean"))
        return Booleano;
    else
        return -1;
}

/*
    gera string do tipo 
    "COMANDO nl, d"
*/
int gera_codigo_com_endereco(tabela_de_simbolos *TS, char *comando, char *aux_ident) {

    simb *s = ts_busca(TS, aux_ident);
    if (s != NULL) {
        char aux_s[20];
        sprintf(aux_s, "%s %d,%d", comando, s->nivel_lexico, s->deslocamento);
        geraCodigo(NULL, aux_s);
        return 0;
    }
    imprimeErro("variavel nao declarada");
    return 1;
}

/*
    gera string do tipo 
    "R0x:   NADA"
*/
void gera_codigo_rotulo_faz_nada(int rot_id) {
    char rotulo[10];
    if (rot_id < 9)
        sprintf(rotulo, "%s%d", "R0", rot_id);
    else
        sprintf(rotulo, "%s%d", "R", rot_id);
    geraCodigo(rotulo, "NADA");
}

/*
    gera string do tipo 
    "COMANDO R0x"
*/
void gera_codigo_desvia_pra_rotulo(char *comando, int rot_id) {
    char rotulo[10];
    if (rot_id < 9)
        sprintf(rotulo, "%s %s%d", comando, "R0", rot_id);
    else
        sprintf(rotulo, "%s %s%d", comando, "R", rot_id);                  
    geraCodigo(NULL, rotulo); 
}

/*
    gera string do tipo 
    "COMANDO n"
*/
void gera_codigo_cmd_e_numero(char *comando, int num) {
    char codigo[10];
    sprintf(codigo, "%s %d", comando, num);
    geraCodigo(NULL, codigo); 
}