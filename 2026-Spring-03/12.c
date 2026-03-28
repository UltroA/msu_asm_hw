#include <stdio.h>

int main(void) {
    unsigned int n, k, c[32][32], l = 0, ex = 0, cnt0 = 0, a[32];

    for (int i = 0; i < 32; ++i) {
        for (int j = 0; j <= i; ++j) {
            c[i][j] = (!j || j == i ? 1
                        : c[i - 1][j] + c[i - 1][j - 1]);
        }
    }

    scanf("%u %u", &n, &k);

    if (k > 31) {
        printf("%d", 0);
        return 0;
    }

    unsigned int tmp = n;
    while (tmp) {
        a[l++] = tmp & 1;
        tmp >>= 1;
    }

    if (k > l - 1) {
        printf("%d", 0);
        return 0;
    }

    for (int i = k + 1; i < l; ++i) {
        ex += c[i - 1][k];
    }

    for (int i = l - 2; ~i; --i) {
        if (a[i]) {
            if (k - cnt0 - 1 >= 0)
                ex += c[i][k - cnt0 - 1];
        } else {
            cnt0++;
        }
    }

    if (cnt0 == k) ex++;

    printf("%d", ex);
    return 0;
}
