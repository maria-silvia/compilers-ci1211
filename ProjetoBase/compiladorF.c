
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

typedef enum
{
    INT,
    BOOL
} tipo_t;

//diferenca declarar struct simbolo_t, sem typedef?
// https://stackoverflow.com/questions/4698600/whats-the-syntactically-proper-way-to-declare-a-c-struct/4698618#4698618
typedef struct {
  char* nome_simbolo;
  int nivel_lexico;
  int deslocamento;
  tipo_t tipo; 
  int valor;
  struct simbolo_t *prox;
} simbolo_t; 

typedef struct {
  int tamanho;
  struct simbolo_t *topo;
} tabela_de_simbolos_t;

void ts_inicia(tabela_de_simbolos_t *TS) {
  TS->topo = (struct simbolo_t *) malloc (sizeof (struct simbolo_t));
  TS->topo->prox = NULL;
  TS->tamanho=0;
}

void ts_insere(tabela_de_simbolos_t TS, char* nome, int valor, tipo_t tipo) {
   	struct simbolo_t *aux;

	  aux = (struct simbolo_t *) malloc (sizeof ( struct simbolo_t) );
	  aux->prox = TS->topo; 

	  TS->topo->nome_simbolo = nome;
	  TS->topo->valor = valor;
	  TS->topo->tipo = tipo;
	  // TS->topo->nivel_lexico ;
	  // TS->topo->deslocamento ;
	  
    TS->topo = aux;
	  TS->tamanho++;
}

void ts_busca(tabela_de_simbolos_t TS, char* nome) {
    simbolo_t simbolo = TS->topo->prox; // meu topo tem coisa?
    while (simbolo->nome != nome && simbolo != NULL)
    {
      simbolo = simbolo->prox;
    }
    return simbolo;
}

void ts_retira(int n) {
   
}