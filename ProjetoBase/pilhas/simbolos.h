#ifndef __SIMB__
#define __SIMB__

#include <string.h>
#include "pilha.h"

typedef enum
{
    Booleano,
    Inteiro
} tipo_t;

typedef enum
{
    referencia,
    valor
} modo_param_t;

typedef enum
{
    VS,
    PROC,
    FUNC,
    PF,
    ROT
} categoria_t;

typedef struct simb {
  char* ident;
  categoria_t cat; 
  int nivel_lexico;

  int deslocamento;
  tipo_t tipo;

  int rotulo;
  int num_param;
  int *param;
  int tam_param;

} simb; 


typedef struct tabela_de_simbolos {

    stack_t *s;

} tabela_de_simbolos;

tabela_de_simbolos *init_tabela();
void print_simb(void *s);
void print_tabela(tabela_de_simbolos *t);
void ts_insere_vs(tabela_de_simbolos *t, char *ident, int nivel_lexico, int deslocamento);
void ts_insere_pf(tabela_de_simbolos *t, char *ident, int nivel_lexico);
void ts_insere_proc(tabela_de_simbolos *t, char *ident, int nivel_lexico, int rotulo);
void ts_atualiza_desloc_params(tabela_de_simbolos *t, char *ident);

void ts_add_params(tabela_de_simbolos *t, char *ident, modo_param_t mp, tipo_t tipo, int n);

simb *ts_busca(tabela_de_simbolos *t, char *ident);
void ts_retira(tabela_de_simbolos *t, int n);
void ts_insere_tipo(tabela_de_simbolos *t, int n, tipo_t tipo);
#endif
