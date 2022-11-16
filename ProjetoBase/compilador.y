
// Testar se funciona corretamente o empilhamento de par�metros
// passados por valor ou por refer�ncia.


%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"

int num_vars;
int nivel_lexico;
int desloc;

TabelaDeSimbolos_t TS;  

%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO

%token LABEL FOR PROCEDURE FUNCTION
%token GOTO IF THEN ELSE WHILE DO OR ASTERISCO
%token DIVISAO AND NOT NUMERO

%%

programa    :{
               geraCodigo (NULL, "INPP");
             }
             PROGRAM IDENT
             ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA
             bloco PONTO {
               //finalizaCompilador();
               geraCodigo (NULL, "PARA");
             }
;

bloco       :
              parte_declara_vars
              {
              }

              comando_composto
              ;




parte_declara_vars:  var
;


var         : { } VAR declara_vars
            |
;

declara_vars: declara_vars declara_var
            | declara_var
;

declara_var : { }
              lista_id_var DOIS_PONTOS
              tipo
              { 
                  ts_insere_tipo(&TS, num_vars, $3);
                  char amemk[10] = "AMEM ";
                  char aux_s[5];
                  sprintf(aux_s, "%d", num_vars);
                  strcat(amemk, aux_s);
                  geraCodigo (NULL, amemk); //amem parcial
                  num_vars=0;
              }
              PONTO_E_VIRGULA
;

tipo        : IDENT
;

lista_id_var: lista_id_var VIRGULA IDENT
              { 
               /* insere �ltima vars na tabela de s�mbolos */ 
               ts_insere(&TS, "exemplo", nivel_lexico, num_vars, VS);
               num_vars++;
              }
            | IDENT 
            {
               /* insere vars na tabela de s�mbolos */
               ts_insere(&TS, "exemplo", nivel_lexico, num_vars, VS);
               num_vars++;
            }
;

lista_idents: lista_idents VIRGULA IDENT
            | IDENT
;


comando_composto: T_BEGIN comandos T_END

comandos: comandos comando
        | comando
;

comando: comando_sem_rotulo
        |
;

comando_sem_rotulo: atribuicao
;

atribuicao: IDENT ATRIBUICAO expressao PONTO_E_VIRGULA
;

expressao: expressao_simples
;

expressao_simples: termo
;

termo: fator
;

fator: NUMERO 
      { 
         char crctnum[10] = "CRCT ";
         char aux_s[5];
         sprintf(aux_s, "%d", token[$1]);
         strcat(crctnum, aux_s);
         geraCodigo(NULL, crctnum);
      }
;

%%

void yyerror(char *s) {
   fprintf(stderr, "%s\n", s);
   // return 0;
}

int main (int argc, char** argv) {
   FILE* fp;
   extern FILE* yyin;

   if (argc<2 || argc>2) {
         printf("usage compilador <arq>a %d\n", argc);
         return(-1);
      }

   fp=fopen (argv[1], "r");
   if (fp == NULL) {
      printf("usage compilador <arq>b\n");
      return(-1);
   }


/* -------------------------------------------------------------------
 *  Inicia a Tabela de S�mbolos
 * ------------------------------------------------------------------- */
   ts_inicia(&TS);
   yyin=fp;
   yyparse();

   return 0;
}

