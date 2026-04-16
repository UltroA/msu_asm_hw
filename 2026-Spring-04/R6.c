#include <stdio.h>

unsigned f(unsigned n, int d) {
    if (d == 0) return 0;
    return (1 - (n & 1)) + f(n >> 1, d - 1);
}

// мы прост осчиатем нули в числе
int main(void) {
    unsigned a;
    scanf("%u", &a);
    printf("%d", f(a, 32));


    return 0;
}
