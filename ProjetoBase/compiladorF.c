
/* -------------------------------------------------------------------
 *            Aquivo: compilador.c
 * -------------------------------------------------------------------
 *              Autor: Bruno Muller Junior
 *               Data: 08/2007
 *      Atualizado em: [09/08/2020, 19h:01m]
 *
 * -------------------------------------------------------------------
 *
 * Funções auxiliares ao compilador
 *
 * ------------------------------------------------------------------- */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"


/* -------------------------------------------------------------------
 *  variáveis globais
 * ------------------------------------------------------------------- */

simbolos simbolo, relacao;
char token[TAM_TOKEN];

FILE* fp=NULL;
void geraCodigo (char* rot, char* comando) {

  if (fp == NULL) {
    fp = fopen ("MEPA", "w");
  }

  if ( rot == NULL ) {
    fprintf(fp, "     %s\n", comando); fflush(fp);
  } else {
    fprintf(fp, "%s: %s \n", rot, comando); fflush(fp);
  }
}

int imprimeErro ( char* erro ) {
  fprintf (stderr, "Erro na linha %d - %s\n", nl, erro);
  exit(-1);
}


/* -------------------------------------------------------------------
 *  PILHA para TABELA DE SIMBOLOS
 * ------------------------------------------------------------------- */
struct TipoEntradaTS{
  string nome_simbolo;
  int nivel_lexico;
  int tipo; // enum?
  int deslocamento;
  struct TipoEntradaTS *prox;
}; 


typedef struct {
  int tamanho;
  struct TipoEntradaTS *topo;
}TipoTS;

void ts_inicia(TipoEntradaTS *TS) {
  TS->topo = (struct TipoEntradaTS *) malloc (sizeof (struct TipoEntradaTS));
  TS->topo->prox = NULL;
  TS->tamanho=0;
}
// https://gitlab.com/maria_silvia/alg2_ci056/-/blob/master/duracell_dinamica.c
void ts_insere(string ident, atributos) {
   
}

void ts_busca(string ident) {
   
}

void ts_retira(int n) {
   
}