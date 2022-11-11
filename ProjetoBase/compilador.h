/* -------------------------------------------------------------------
 *            Arquivo: compilador.h
 * -------------------------------------------------------------------
 *              Autor: Bruno Muller Junior
 *               Data: 08/2007
 *      Atualizado em: [09/08/2020, 19h:01m]
 *
 *              Autor: Maria Ruy
 *               Data: 10/2022
 *
 * -------------------------------------------------------------------
 *
 * Tipos, protótipos e variáveis globais do compilador (via extern)
 *
 * ------------------------------------------------------------------- */

#define TAM_TOKEN 16

typedef enum simbolos {
  simb_program, simb_var, simb_begin, simb_end,
  simb_identificador, simb_numero,
  simb_ponto, simb_virgula, simb_ponto_e_virgula, simb_dois_pontos,
  simb_atribuicao, simb_abre_parenteses, simb_fecha_parenteses,
  // alteracoes minhas:
  simb_label, simb_for, simb_procedure, 
  simb_function, simb_goto, simb_if, simb_then, simb_else, simb_while, 
  simb_do, simb_or, simb_asterisco, simb_divisao, simb_and, simb_not
} simbolos;



/* -------------------------------------------------------------------
 * variáveis globais
 * ------------------------------------------------------------------- */

extern simbolos simbolo, relacao;
extern char token[TAM_TOKEN];
extern int nivel_lexico;
extern int desloc;
extern int nl;


/* -------------------------------------------------------------------
 * prototipos globais
 * ------------------------------------------------------------------- */

void geraCodigo (char*, char*, int k);
int yylex();
void yyerror(char *s);


/* -------------------------------------------------------------------
 *  PILHA para TABELA DE SIMBOLOS
 * ------------------------------------------------------------------- */
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

typedef struct Simbolo_t {
  char* nome;
  tipo_t tipo;
  categoria_t categoria; 
  int nivel_lexico;
  int deslocamento;
  struct Simbolo_t *prox;
} Simbolo_t; 

typedef struct {
  int tamanho;
  struct Simbolo_t *topo;
} TabelaDeSimbolos_t;

void ts_inicia(TabelaDeSimbolos_t *TS);

void ts_insere(TabelaDeSimbolos_t *TS, char* nome, int nl, int deslocamento, categoria_t categoria);

void ts_insere_tipo(TabelaDeSimbolos_t *TS, int quantidade, tipo_t tipo);

Simbolo_t* ts_busca(TabelaDeSimbolos_t *TS, char* nome);

void ts_retira(TabelaDeSimbolos_t *TS, int n);
