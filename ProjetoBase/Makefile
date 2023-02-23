 # -------------------------------------------------------------------
 #            Arquivo: Makefile
 # -------------------------------------------------------------------
 #              Autor: Bruno Müller Junior
 #               Data: 08/2007
 #      Atualizado em: [09/08/2020, 19h:01m]
 #
 # -------------------------------------------------------------------

$DEPURA=1

compilador: lex.yy.c compilador.tab.c compilador.o compilador.h simbolos.o desloc.o rotulos.o pilha.o utils.o
	gcc lex.yy.c compilador.tab.c compilador.o simbolos.o desloc.o rotulos.o pilha.o utils.o -o compilador -ll -ly -lc

lex.yy.c: compilador.l compilador.h
	flex compilador.l

compilador.tab.c: compilador.y compilador.h
	bison compilador.y -d -v

compilador.o : compilador.h compiladorF.c 
	gcc -c compiladorF.c -o compilador.o

desloc.o : pilhas/desloc.h pilhas/desloc.c
	gcc -c pilhas/desloc.c -o desloc.o

rotulos.o : pilhas/rotulos.h pilhas/rotulos.c 
	gcc -c pilhas/rotulos.c  -o rotulos.o

simbolos.o : pilhas/simbolos.h pilhas/simbolos.c 
	gcc -c pilhas/simbolos.c  -o simbolos.o

pilha.o : pilhas/pilha.h pilhas/pilha.c
	gcc -c pilhas/pilha.c -o pilha.o

utils.o : utils.h utils.c
	gcc -c utils.c -o utils.o


clean :
	rm -f compilador.tab.* lex.yy.c ;
	rm -f compilador.o compilador compilador.output *.o;
