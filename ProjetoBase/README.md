# Trabalho compiladores

#### to do
 - [ ] Pilha genérica       //Arthur
 - [ ] Tabela simbolos      //Arthur
 - [X] AMEN k
 - [ ] ser capaz de traduzir varGlobais.pas             //aula 6
    - [x] CRCT
    - [ ] ARMZ
    - [ ] DMEM
 - [ ] ser capaz de traduzir varGlobaisInvalido.pas     //aula 7

 - [ ] regras 25 a 30
 - [ ] while    //aula 8
 - [ ] if       //aula 9


 - [ ] procedimentos //aula 10+

















_____







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

> compilar o lex.yy.c e compilador.tab.c juntos para gerar o executavel final

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