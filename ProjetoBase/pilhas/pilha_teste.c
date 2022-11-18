#include "pilha.h"

void print_int(void *x) {
    printf("%d", *((int *)x));
}

int igual_int(void *a, void *b) {
    return (*(int*)a == *(int*)b);
}

int main () {

    stack_t *s = init_pilha();

    for (int i=0; i<14; i++) {
        int *p = malloc(sizeof(int));
        *p = i;
        push(s, p);
    }

    print_pilha(s, print_int);

    int aux=3;

    if (busca(s, igual_int, &aux) != NULL)
        printf("encontrado 3\n");
    else
        printf("n encontrado 3\n");

    for (int i=0; i<8; i++) {
        printf("%d\n", *(int*)pop(s));
    }

}
