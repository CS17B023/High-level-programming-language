
checkPal(int num)
{
    int n = num;
    int reversedN = 0, remainder, originalN;
    originalN = n;

 
    while (n != 0)
    {
        remainder = n % 10;
        reversedN = reversedN * 10 + remainder;
        n = n/10;
    }

    if (originalN == reversedN)
    {
        return 1;
    }
    return 0;
}

{
    int res = checkPal(123321);
}
