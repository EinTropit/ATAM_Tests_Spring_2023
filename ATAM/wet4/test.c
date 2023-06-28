#include <stdio.h>
// #include "asmtest.h"

int comp(int x, int y);
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
    hash(7, 3);
    fact(0);
    fact(3);
    comp(3, 4);
    comp(6, 3);
    asm("mov $8, %%rax;"
        "mov $4, %%rdi;"
        "call uselessFunc;"
        "call uselessFunc;"
        "mov $2, %%rax;"
         : : :"rax", "rdi");
    uselessFunc(3);

    return 0;
}
