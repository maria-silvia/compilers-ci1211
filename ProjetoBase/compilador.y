
// Testar se funciona corretamente o empilhamento de par�metros
// passados por valor ou por refer�ncia.


%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "pilhas/simbolos.h"

int num_vars;
int nivel_lexico;
int desloc;

char ident[20];

tabela_de_simbolos *TS;

%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO

%token LABEL FOR PROCEDURE FUNCTION
%token GOTO IF THEN ELSE WHILE DO OR ASTERISCO
%token DIVISAO AND NOT NUMERO

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

programa    :{
               nivel_lexico = 0;
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
              {
                desloc = 0;
              }
              parte_declara_vars
              subrotinas_opcional
              {
               print_tabela(TS);
              }
              comando_composto
              {
                  ts_retira(TS, desloc);
                  char dmemk[20] = "DMEM ";
                  char aux_s[5];
                  sprintf(aux_s, "%d", desloc);
                  strcat(dmemk, aux_s);
                  geraCodigo (NULL, dmemk); 
                  print_tabela(TS);
              }
;

subrotinas_opcional: subrotinas | ;

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
                  // ts_insere_tipo(&TS, token);
                  char amemk[20] = "AMEM ";
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
               ts_insere(TS, token, VS, nivel_lexico, desloc);
               num_vars++;
               desloc++;
              }
            | IDENT 
            {
               /* insere vars na tabela de s�mbolos */
               ts_insere(TS, token, VS, nivel_lexico, desloc);
               num_vars++;
               desloc++;
            }
;

lista_idents: lista_idents VIRGULA IDENT
            | IDENT
;


comando_composto: T_BEGIN comandos T_END
                  {

                  }

comandos: comandos comando
        | comando
;

comando: comando_sem_rotulo
        |
;

comando_sem_rotulo: atribuicao
                  | cmd_repetitivo
                  | cmd_condicional
;

atribuicao: IDENT 
            {
               strncpy(ident, token, 20);
            } 
            ATRIBUICAO expressao PONTO_E_VIRGULA 
            {
                simb *s = ts_busca(TS, ident);
                if (s != NULL) {
                    char aux_s[20];
                    char armazena[10] = "ARMZ ";
                    sprintf(aux_s, "%d, %d", s->nivel_lexico, s->deslocamento);
                    strcat(armazena, aux_s);
                    geraCodigo (NULL, armazena); 
                }
                else
                  imprimeErro("variavel nao declarada");
            }
;

cmd_repetitivo: WHILE
               {
                  // empilhar os dois rotulos
                  geraCodigo ("R00", "NADA"); 
               }
                expressao 
               {
                  geraCodigo (NULL, "DVSF R01"); 
               }
                DO comando_composto
               {
                  geraCodigo (NULL, "DVSS R00"); 
                  geraCodigo ("R01", "NADA");
                  // desempilhar os dois rotulos
               }
;

cmd_condicional:  if_then cond_else 
                  { 
                    // em_if_finaliza (); 
                  }
;

if_then     : IF expressao 
            {
              // em_if_apos_expr ();
            }
             THEN comando_sem_rotulo
            {
              // em_if_apos_then ();
            }
;
cond_else   : ELSE comando_sem_rotulo
            | %prec LOWER_THAN_ELSE
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
         strcat(crctnum, token);
         geraCodigo(NULL, crctnum);
      }
;


subrotinas: declara_procedimento
;
declara_procedimento:   PROCEDURE IDENT PONTO_E_VIRGULA bloco
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
   TS = init_tabela();
   yyin=fp;
   yyparse();

   return 0;
}

