int recB(int x, int y);

int comp(int x, int y)
{
    return x > y;
}

int recA(int x)
{
    if (x <= 0)
        return 10;
    return recB(x-1, x+3) + 100;
}

int recB(int x, int y)
{
    if (x <= 0)
        return y;
    return recA(x-1) + 100;
}