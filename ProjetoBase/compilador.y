
// Testar se funciona corretamente o empilhamento de par�metros
// passados por valor ou por refer�ncia.


%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "utils.h"
#include "compilador.h"
#include "pilhas/simbolos.h"
#include "pilhas/rotulos.h"

int num_vars;
int nivel_lexico;
int desloc;

char _atribuicao[20];

tabela_de_simbolos *TS;
pilha_de_rotulos *PR;

int rot_id;
%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT ATRIBUICAO

%token LABEL FOR PROCEDURE FUNCTION
%token GOTO IF THEN ELSE WHILE DO OR ASTERISCO
%token DIVISAO AND NOT NUMERO

%token IGUAL DIFERENTE MENOR MENOR_IGUAL MAIOR_IGUAL MAIOR
%token MAIS MENOS

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
                  ts_insere_tipo(TS, num_vars, string2type(token));
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
               | T_BEGIN comandos T_END PONTO_E_VIRGULA
                  {

                  }
;

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
               strncpy(_atribuicao, token, 20);
            } 
            ATRIBUICAO expressao PONTO_E_VIRGULA 
            {
                gera_codigo_com_endereco(TS, "ARMZ", _atribuicao);
            }
;

cmd_repetitivo: WHILE
               {
                  rot_id = gera_rotulos(PR);
                  char rotulo[10];
                  if (rot_id < 9)
                     sprintf(rotulo, "%s%d", "R0", rot_id);
                  else
                     sprintf(rotulo, "%s%d", "R", rot_id);
                  geraCodigo(rotulo, "NADA"); 
               }
                expressao 
               {
                  rot_id = gera_rotulos(PR);
                  char rotulo[10];
                  if (rot_id < 9)
                     sprintf(rotulo, "DVSF %s%d", "R0", rot_id);
                  else
                     sprintf(rotulo, "DVSF %s%d", "R", rot_id);                  
                  geraCodigo(NULL, rotulo); 
               }
                DO comando_composto
               {
                  int rot_nada = pop_rot(PR);
                  int rot_desvia = pop_rot(PR);
                  
                  char rotulo[10];
                  if (rot_id < 9)
                     sprintf(rotulo, "DSVS %s%d", "R0", rot_desvia);
                  else
                     sprintf(rotulo, "DSVS %s%d", "R", rot_desvia);                  
                  geraCodigo(NULL, rotulo); 

                  if (rot_id < 9)
                     sprintf(rotulo, "%s%d", "R0", rot_nada);
                  else
                     sprintf(rotulo, "%s%d", "R", rot_nada);
                  geraCodigo(rotulo, "NADA");
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

expressao: expressao_simples expressa_opt 
;
expressa_opt: IGUAL expressao_simples {geraCodigo(NULL, "CMIG");}
            | DIFERENTE expressao_simples {geraCodigo(NULL, "CMDG");}
            | MENOR expressao_simples {geraCodigo(NULL, "CMME");}
            | MENOR_IGUAL expressao_simples {geraCodigo(NULL, "CMEG");}
            | MAIOR_IGUAL expressao_simples {geraCodigo(NULL, "CMAG");}
            | MAIOR expressao_simples {geraCodigo(NULL, "CMMA");}
            |
;

expressao_simples: MAIS termo | termo 
                | MENOS termo  {geraCodigo(NULL, "CRCT -1"); geraCodigo(NULL, "MULT");}
                | expressao_simples MAIS termo {geraCodigo(NULL, "SOMA");}
                | expressao_simples MENOS termo {geraCodigo(NULL, "SUBT");}
                | expressao_simples OR termo {geraCodigo(NULL, "DISJ");}
;

termo: fator 
      | termo ASTERISCO fator {geraCodigo(NULL, "MULT");}
      | termo DIVISAO fator {geraCodigo(NULL, "DIVI");}
      | termo AND fator {geraCodigo(NULL, "CONJ");}
;

fator:
      IDENT
      { 
        gera_codigo_com_endereco(TS, "CRVL", token);

      }
      | NUMERO 
      { 
         char crctnum[10] = "CRCT ";
         strcat(crctnum, token);
         geraCodigo(NULL, crctnum);
      }
      | ABRE_PARENTESES expressao FECHA_PARENTESES
      | NOT fator {geraCodigo(NULL, "NEGA");}
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
   PR = init_rotulos();
   yyin=fp;
   yyparse();

   return 0;
}

