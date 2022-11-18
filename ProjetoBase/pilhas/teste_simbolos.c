#include "simbolos.h"

int main() {

    tabela_de_simbolos *t = init_tabela();

    for(int i=0; i<5; i++) {
        char *aux = malloc(2*sizeof(char));
        char *aux2 = malloc(2*sizeof(char));
        aux = "a";
        aux2 = "A";
        insere(t, aux, aux2);
    }

    print_tabela(t);

    char *aux = malloc(2*sizeof(char));
    aux = "a";
    printf("o ident a é da categoria %s\n", busca(t, aux)->cat);

    retira(t, 3);

    print_tabela(t);

}
