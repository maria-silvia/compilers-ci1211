# Trabalho compiladores

## Como rodar testes do compilador

`./run.sh testes/teste1.pas`
E entao consultar resultado no arquivo MEPA.



## to do
 - [x] Pilha genérica       //Arthur
 - [x] Tabela simbolos      //Arthur

### aula 6
- [X] ser capaz de traduzir varGlobais.pas             
- [x] CRCT
- [X] ARMZ
- [X] DMEM
- [x] testar retira
- [X] atualizar tipo na TS

Desafios:
- [ ] não for um símbolo ∈ Variável Simples, Parâmetro formal ou Função, deve indicar erro
- [ ] Como armazenar o elemento da esquerda para fazer a comparação com o resultado da expressão. **Sugestão**: variável global l_elem.
 
### aula 7 - expressoes, verificar tipos
- [X] AMEN k
- [x] regras 25 a 29
- [x] CRVL

##### exp. booleanas (regras 25 e 26)
- [x] testar expressao_simples
    - [x] DIVI, SOMA
- [x] testar relacao 
    - [x] CMIG, CMMA, CMME, CMDG, etc
    - [x] CONJ (and)

- [ ] ser capaz de detectar erros varGlobaisInvalido.pas    
- [ ] ser capaz de detectar erros erroTipo.pas    
- [ ] regra 30

Dica: a regra 30 é a única que acessa a tabela de símbolos.
Nas demais, usa-se as construções (como pilha ou $$).


### aula 8  e 9
 - [ ] LEIT, IMPR
 - [ ] BUG: aula8 nao escreve variavel k na tabela
 - [x] while  
 - [ ] if
 - [ ] subrotina geradora do proximo rotulo
 - [ ] pilha de rotulos (padrao Rdd)

 - [ ] while aninhados, nao confundir rotulos
 


### aula 10
 - [ ] procedimentos 

















_____








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
 
