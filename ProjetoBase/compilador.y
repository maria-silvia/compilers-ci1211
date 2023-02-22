
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
#include "pilhas/desloc.h"

int num_vars;
int nivel_lexico;
int desloc;

tabela_de_simbolos *TS;
pilha_de_rotulos *PR;
pilha_de_deslocs *PD;

int rot_id;
int init_rot;

char ident_aux[100], proc_atual[100];
int modo_param_aux;
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

               init_rot = gera_rotulos(PR);
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
                if (nivel_lexico == 0)
                  gera_codigo_rotulo_faz_nada(init_rot);
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


var         : { } VAR
                    {
                        num_vars=0;
                    }
            declara_vars
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
              }
              PONTO_E_VIRGULA
;

tipo        : IDENT
;

lista_id_var: lista_id_var VIRGULA IDENT
              { 
               /* insere �ltima vars na tabela de s�mbolos */ 
               ts_insere_vs(TS, token, nivel_lexico, desloc);
               num_vars++;
               desloc++;
              }
            | IDENT 
            {
               /* insere vars na tabela de s�mbolos */
               ts_insere_vs(TS, token, nivel_lexico, desloc);
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

comando_sem_rotulo: ident_first
                  | cmd_repetitivo
                  | cmd_condicional
                  | cmd_read | cmd_write
                  | chama_proc
;

ident_first: IDENT 
            {
               strncpy(ident_aux, token, 100);
            }
            ident_continue
;

ident_continue: ATRIBUICAO atribuicao_c | chama_proc;

atribuicao_c:  expressao PONTO_E_VIRGULA 
            {
                gera_codigo_com_endereco(TS, "ARMZ", ident_aux);
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
                    IDENT 
                    {
                        int aux_id = gera_rotulos(PR);
                        nivel_lexico += 1;
                        push_desloc(PD, desloc);                        
                        desloc = -4;

                        ts_insere_proc(TS, token, nivel_lexico, aux_id);

                        gera_codigo_desvia_pra_rotulo("DSVS", init_rot);
                        gera_codigo_rotulo_faz_nada(aux_id);
                        gera_codigo_cmd_e_numero("ENPR", nivel_lexico);

                        sprintf(proc_atual, "%s", token);
                    }
                    lista_param
                    PONTO_E_VIRGULA
                    {
                        desloc = 0;
                    }
                    bloco
                    {
                        char s_aux[30];
                        simb *simb_aux = ts_busca(TS, proc_atual);

                        sprintf(s_aux, "RTPR %d, %d", nivel_lexico, simb_aux->num_param);

                        geraCodigo(NULL, s_aux);
                        nivel_lexico -= 1;
                        desloc = pop_desloc(PD);
                    }
;

lista_param: |
            ABRE_PARENTESES params FECHA_PARENTESES;

params: param | param VIRGULA params;

param: modo
        {
            num_vars = 0;
        }
        arguments DOIS_PONTOS tipo
        {
            ts_insere_tipo(TS, num_vars, string2type(token));
            ts_add_params(TS, proc_atual, modo_param_aux, string2type(token), num_vars);
        }
;

arguments: argument | arguments VIRGULA argument

argument: IDENT 
        {
            ts_insere_vs(TS, token, nivel_lexico, desloc);
            desloc--;
            num_vars++;
        }

modo: VAR 
        {
            modo_param_aux = referencia;
        }
      | 
        {
            modo_param_aux = valor;
        };

chama_proc: ABRE_PARENTESES chama_params FECHA_PARENTESES vai_para_proc | vai_para_proc;

chama_params: expressao | expressao VIRGULA chama_params;

vai_para_proc: 
            PONTO_E_VIRGULA
            {
                char s_aux[30];
                simb *simb_aux = ts_busca(TS, ident_aux);
                // busca na tabela
                // empilha parametros

                sprintf(s_aux, "CHPR R%d, %d", simb_aux->rotulo, nivel_lexico);
                geraCodigo(NULL, s_aux);
            
                // CHPR R01, k
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
   TS = init_tabela();
   PR = init_rotulos();
   PD = init_deslocs();
   yyin=fp;
   yyparse();

   return 0;
}

