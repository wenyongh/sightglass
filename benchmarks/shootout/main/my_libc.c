#include <stdio.h>

void *memset(void *s, int c, size_t n)
{
    if (s) {
        unsigned char *p = s, *p_end = p + n;
        unsigned char v = (unsigned char)c;
        while (p < p_end)
            *p++ = v;
    }
    return s;
}
