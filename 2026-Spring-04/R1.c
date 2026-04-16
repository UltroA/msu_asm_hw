#include <stdio.h>

unsigned f(unsigned n) {
    if (n != 0) return f(n - 1) * 3;
    return 1;
}

int main(void) {
    unsigned a;
    scanf("%u", &a);
    printf("%u", f(a));
    return 0;
}
