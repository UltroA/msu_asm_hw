#include <stdio.h>
#include <stdint.h>

typedef uint32_t u128[4];

int is_zero(u128 r)
{
    return r[0]==0 && r[1]==0 && r[2]==0 && r[3]==0;
}

uint32_t div128by10(u128 r)
{
    uint64_t cur;
    uint32_t rem = 0;

    for(int i=3;i>=0;i--)
    {
        cur = ((uint64_t)rem<<32) | r[i];
        r[i] = cur / 10;
        rem  = cur % 10;
    }
    return rem;
}

int main()
{
    uint32_t a,b,c;
    scanf("%u %u %u",&a,&b,&c);

    uint64_t t = (uint64_t)a * b;

    uint64_t p0 = (uint64_t)(uint32_t)t * c;
    uint64_t p1 = (uint64_t)(t>>32) * c;

    u128 r = {0};

    r[0] = (uint32_t)p0;
    r[1] = (uint32_t)(p0>>32) + (uint32_t)p1;
    r[2] = (uint32_t)(p1>>32);

    if(r[1] < (uint32_t)(p0>>32))
        r[2]++;

    char buf[50];
    int pos=49;
    buf[pos--]=0;

    if(is_zero(r)){
        printf("0\n");
        return 0;
    }

    while(!is_zero(r)){
        uint32_t rem = div128by10(r);
        buf[pos--] = '0' + rem;
    }

    printf("%s\n",&buf[pos+1]);
}
