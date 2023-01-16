#include "rotulos.h"

int main() {

    pilha_de_rotulos *s = init_rotulos();

    gera_rotulos(s, 2);

    print_rotulos(s);

    pop_rot(s, 2);

    print_rotulos(s);

}
