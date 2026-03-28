#include <stdio.h>

int main(void) {
    int n, k;
    int a[21] = {0};
    int b[21] = {0};

    scanf("%d%d", &n, &k);

    a[0] = 1;

    // .1
    for (int i = 1; i <= n; ++i) {
        b[0] = 1;
        // .2
        for (int j = 1; j < i; ++j) {
            b[j] = a[j] + a[j - 1];
        }
        // .3
        b[i] = 1;
        for(int j = 0; j <= i; ++j) {
            a[j] = b[j];
        }
    }

    // .4
    printf("%d\n", a[k]);
    return 0;
}
