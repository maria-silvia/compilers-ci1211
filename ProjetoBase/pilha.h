#ifndef __STACK__
#define __STACK__

#include <stdio.h>
#include <stdlib.h>

typedef struct stack_t {
    void **p;
    int tam;
    int max_tam;
} stack_t;

stack_t *init_pilha();
int push(stack_t *s, void *elem);
void *pop(stack_t *s);
void print_pilha(stack_t *s, void print_elem (void*));
void *search(stack_t *s, int equal_func(void *, void *), void *elem);

#endif
