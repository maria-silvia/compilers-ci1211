#ifndef __SIMB__
#define __SIMB__

#include <string.h>
#include "pilha.h"

/*
typedef struct simb {
    char *ident;
    char *cat;
    //outros atributos
} simb;
*/

typedef enum
{
    Inteiro,
    Booleano
} tipo_t;

typedef enum
{
    VS,
    PROC,
    FUNC,
    ParametroFormal,
    ROT
} categoria_t;

typedef struct simb {
  char* ident;
  tipo_t tipo;
  categoria_t *cat; 
  int nivel_lexico;
  int deslocamento;
} simb; 


typedef struct tabela_de_simbolos {

    stack_t *s;

} tabela_de_simbolos;

tabela_de_simbolos *init_tabela();
void print_tabela(tabela_de_simbolos *t);
void ts_insere(tabela_de_simbolos *t, char *ident, categoria_t cat);
simb *ts_busca(tabela_de_simbolos *t, char *ident);
void ts_retira(tabela_de_simbolos *t, int n);
#endif
