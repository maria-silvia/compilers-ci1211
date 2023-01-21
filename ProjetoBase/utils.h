#ifndef __UTILS__
#define __UTILS__

#include "pilhas/simbolos.h"
#include "compilador.h"

tipo_t string2type (char *s);
int gera_codigo_com_endereco(tabela_de_simbolos *TS, char *comando, char *aux_ident);
void gera_codigo_rotulo_faz_nada(int rot_id);
void gera_codigo_desvia_pra_rotulo(char *comando, int rot_id);

#endif
