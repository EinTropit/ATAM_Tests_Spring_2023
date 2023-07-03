#include <stdio.h>
// #include "asmtest.h"

int comp(int x, int y);
int recA(int x);
int recB(int x, int y);
int uselessFunc(int x);

int hash(int x, int y)
{
    return x % 11;
}

int fact(int n)
{
    if (n < 0 || n > 10)
        return -1;
    if (n <= 1)
    {
        hash(13, 4);
        return 1;
    }
    return n*fact(n-1);
}

int main() {
    int a;
    //printf("hi\n");
    //printf("hi\n");
    hash(101, 0);
    hash(11, 1);
    fact(5);
    hash(-15, 3);
    fact(0);
    fact(-2);
    comp(-1, 4);
    comp(6, -4);
    asm("mov $8, %%rax;"
        "mov $4, %%rdi;"
        "call uselessFunc;"
        "call uselessFunc;"
        "mov $2, %%rax;"
         : : :"rax", "rdi");
    uselessFunc(3);
    comp(9,9);
    recA(5);
    recB(5, 0);
    recA(7);

    return 0;
}
