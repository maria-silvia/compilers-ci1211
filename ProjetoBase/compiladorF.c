
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

void ts_inicia(TabelaDeSimbolos_t *TS) {
  TS->topo = (struct Simbolo_t *) malloc (sizeof (struct Simbolo_t));
  TS->topo->prox = NULL;
  TS->tamanho=0;
}

void ts_insere(TabelaDeSimbolos_t *TS, char* nome, int nl, int deslocamento, categoria_t categoria) {
    TS->topo->nome = nome;
    TS->topo->categoria = categoria;
    
    TS->topo->nivel_lexico = nl ;
    TS->topo->deslocamento = deslocamento;

   	Simbolo_t *aux;
	  aux = (struct Simbolo_t *) malloc (sizeof ( struct Simbolo_t) );
	  aux->prox = TS->topo; 
    TS->topo = aux;
	  TS->tamanho++;
}

void ts_insere_tipo(TabelaDeSimbolos_t *TS, int quantidade, tipo_t tipo) {
    int conta = 0;
    Simbolo_t *simbolo = TS->topo->prox; 
    while (conta != quantidade)
    {
      simbolo->tipo = tipo;
      simbolo = simbolo->prox;
      conta++;
    }
}

Simbolo_t* ts_busca(TabelaDeSimbolos_t *TS, char* nome) {
    Simbolo_t *simbolo = TS->topo->prox; 
    while (simbolo->nome != nome && simbolo != NULL)
    {
      simbolo = simbolo->prox;
    }
    return simbolo;
}

void ts_retira(TabelaDeSimbolos_t *TS, int n) {
    if (TS->tamanho < n)
    {
      fprintf (stderr, "ts_retira: n maior que o tamanho da TS\n");
      return;
    }

    Simbolo_t *simbolo = TS->topo; 
    Simbolo_t *aux;   
    int novo_tam = TS->tamanho - n;
    while (TS->tamanho != novo_tam)
    {
      aux = simbolo->prox;
      free(simbolo);
      simbolo = aux;
      TS->tamanho--;
    }
    TS->topo = simbolo;
}