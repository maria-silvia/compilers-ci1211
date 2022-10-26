
%{
#include <stdio.h>

%}

%token INT BOOL MAIS MENOS OR AND ASTERISCO DIV ABRE_PARENTESES FECHA_PARENTESES

%%

raiz       : expr_int | expr_bool

expr_int   : expr_int MAIS termo_int {printf ("+"); } |
             expr_int MENOS termo_int {printf ("-"); } | 
             termo_int 
;

expr_bool  : expr_bool AND fator_bool {printf ("&"); } |
             expr_bool OR fator_bool {printf ("|"); } | 
             fator_bool
;

termo_int  : termo_int ASTERISCO fator_int  {printf ("*"); }| 
             termo_int DIV fator_int  {printf ("/"); }|
             fator_int
;

fator_int  : INT {printf ("A"); }
;

fator_bool : BOOL {printf ("B"); }
;

%%

int main (int argc, char** argv) {
   yyparse();
   printf("\n");
}

