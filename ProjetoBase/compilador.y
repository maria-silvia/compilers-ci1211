
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
%token MAIS MENOS READ WRITE

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
                  gera_codigo_cmd_e_numero("DMEM", desloc);
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
                  gera_codigo_cmd_e_numero("AMEM", num_vars);
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
                  | cmd_read | cmd_write
                  | chama_proc
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
                  gera_codigo_rotulo_faz_nada(rot_id); // rotulo usado no DSVS
               }
                expressao 
               {
                  rot_id = gera_rotulos(PR);
                  gera_codigo_desvia_pra_rotulo("DSVF", rot_id);
               }
                DO comando_composto
               {
                  int rot_nada = pop_rot(PR);
                  int rot_desvia = pop_rot(PR);
                  gera_codigo_desvia_pra_rotulo("DSVS", rot_desvia); 
                  gera_codigo_rotulo_faz_nada(rot_nada); // rotulo usado no DSVF
               }
;

cmd_condicional:  if_then cond_else 
                  { 
                    // em_if_finaliza (); 
                     int rot_do_fim = pop_rot(PR);
                     gera_codigo_rotulo_faz_nada(rot_do_fim); 
                  }
;

if_then     : IF expressao 
            {
               // em_if_apos_expr ();
               rot_id = gera_rotulos(PR);
               gera_codigo_desvia_pra_rotulo("DSVF", rot_id);
            }
             THEN comando_sem_rotulo
            {
              // em_if_apos_then ();

            }
;
cond_else   : ELSE {
               rot_id = gera_rotulos(PR);
               gera_codigo_desvia_pra_rotulo("DSVS", rot_id); 
               int rot_do_fim = pop_rot(PR);
               int rot_do_else = pop_rot(PR);
               push_rot(PR, rot_do_fim);
               gera_codigo_rotulo_faz_nada(rot_do_else);    
            } comando_sem_rotulo
            | %prec LOWER_THAN_ELSE
;

cmd_read    : READ ABRE_PARENTESES read_idents FECHA_PARENTESES PONTO_E_VIRGULA 
;
read_idents: read_idents VIRGULA IDENT
            { 
               geraCodigo(NULL, "LEIT");
               gera_codigo_com_endereco(TS, "ARMZ", token);
            }
            | IDENT 
            { 
               geraCodigo(NULL, "LEIT");
               gera_codigo_com_endereco(TS, "ARMZ", token);
            }
;

cmd_write    : WRITE ABRE_PARENTESES write_fatores FECHA_PARENTESES PONTO_E_VIRGULA 
;
write_fatores: write_fatores VIRGULA fator
            { 
               geraCodigo(NULL, "IMPR");
            }
            | fator 
            { 
               geraCodigo(NULL, "IMPR");
            }
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
declara_procedimento:   
                    PROCEDURE
                    IDENT PONTO_E_VIRGULA
                    {
                        // DSVS R00
                        // R00: ENPR k
                    }
                     bloco
                     {
                        // RTPR k, n
                     }
;

chama_proc: IDENT 
            { 
                // busca na tabela
                // empilha parametros
                // CHPR R01, k
            }
            PONTO_E_VIRGULA
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

