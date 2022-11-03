# Trabalho compiladores

- compiladorF.c ??????

#### Flex
- compilador.l -  definicoes, regras, subrotinas
- compilador.h - header do lex.yy.c

`flex compilador.l` gera:
- lex.yy.c - Analisador Lexico gerado (AFD)  


#### Bison
- compilador.y - definicoes, regras, subrotinas

`bison compilador.y -d -v` gera: 
- compilador.tab.c - automato finito a pilha
- compilador.tab.h - header do lex.yy.c
- compilador.output - automato legivel


### 1. Adição de todos os tokens para Pascal

Add em `compilador.l` na segunda parte, de regras  
Ex para `label`:  
```c
{ 
    simbolo = simb_label;
    strncpy (token, yytext, TAM_TOKEN);
    IMPRIME(" label ");
    return LABEL;
}
```

Add em `compilador.h`, no `enum simbolos` o simb usado em `compilador.l`  