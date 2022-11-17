# Trabalho compiladores

## to do
 - [ ] Pilha genérica       //Arthur
 - [ ] Tabela simbolos      //Arthur

### aula 6
- [ ] ser capaz de traduzir varGlobais.pas             
- [x] CRCT
- [ ] ARMZ
- [X] DMEM
- [ ] atualizar tipo na TS

Desafios:
- [ ] não for um símbolo ∈ Variável Simples, Parâmetro formal ou Função, deve indicar erro
- [ ] Como armazenar o elemento da esquerda para fazer a comparação com o resultado da expressão. **Sugestão**: variável global l_elem.
 
### aula 7 - expressoes, verificar tipos
- [X] AMEN k
- [ ] ser capaz de detectar erros varGlobaisInvalido.pas    
- [ ] ser capaz de detectar erros erroTipo.pas    
- [ ] regras 25 a 30

Dica: a regra 30 é a única que acessa a tabela de símbolos.
Nas demais, usa-se as construções (como pilha ou $$).
##### exp. booleanas (regras 25 e 26)
- [ ] CMIG
- [ ] CMMA, CMME, CMDG, CONJ (and)
- [ ] DIVI, SOMA


### aual 8  e 9
 - [ ] while  
 - [ ] if
 - [ ] subrotina geradora do proximo rotulo
 - [ ] pilha de rotulos (padrao Rdd)

 - [ ] while aninhados, nao confundir rotulos
 
 - [ ] LEIT, IMPR
 - [ ] CRVL


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
 