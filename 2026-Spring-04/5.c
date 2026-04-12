#include <stdio.h>

int rotate(unsigned m) {
    unsigned rn = 0;
    do {
        rn = rn * 10 + (m % 10);
        m /= 10;
    } while ((m % 10) != (m / 10));
    return rn;
}

int main(void) {
    unsigned n, m;

    scanf("%d%d", &m, &n);

    while (n) {
        m += rotate(m);
        --n;
    }
    if (rotate(m) == m)
        printf("Yes\n%d", m);
    else
        printf("No");
    // printf("%d\n", rotate(n));
    // printf("%d", is_pol(n));

    return 0;
}
