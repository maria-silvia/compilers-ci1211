#include "pilha.h"
#define INIT_SIZE 1024

stack_t *init_pilha() {

    stack_t *s = malloc(sizeof(stack_t));

    s->p = (void **)malloc(INIT_SIZE*sizeof(void *));
    s->max_tam = INIT_SIZE;
    s->tam = 0;

    return s;
}

int push(stack_t *s, void *elem) {

    if (s->tam == s->max_tam) {
        s->p = realloc(s->p, 2*s->max_tam*sizeof(void*));
        s->max_tam = 2*s->max_tam;
    }

    s->p[s->tam] = elem;
    s->tam++;

    return 0;

}


void *pop(stack_t *s) {

    if (s->tam <= 0) {
        printf("ERROR: Trying to pop from empty stack\n");
        return NULL;
    }

    s->tam--;
    return s->p[s->tam];

}


void print_pilha(stack_t *s, void print_elem (void*)) {

    for (int i=0; i<s->tam; i++) {
        print_elem(s->p[i]);
        printf(" ");
    }
    printf("\n");

}


void *search(stack_t *s, int equal_func(void *, void *), void *elem) {

    if (s->tam == 0) {

        printf("ERROR: Trying to search on empty list\n");
        return NULL;

    }

    for (int i=s->tam-1; i>=0; i--) {
        if (equal_func(s->p[i], elem)) {
            return s->p[i];
        }
    }

    return NULL;
}
