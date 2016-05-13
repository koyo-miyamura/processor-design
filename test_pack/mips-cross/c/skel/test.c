#ifdef DEBUG
#include <stdio.h>
#endif

#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000

inline int mul(int a, int b);  // kakezan
inline int div(int a, int b);  // warizan
inline int rem(int a, int b);  // zyouyozan
inline void divrem(int a, int b, int *ans_div, int *ans_rem);  // warizan and zyouyozan
inline int numTostr(char *s, int n, int base);  // convert number to string.
inline void myputchar(const char c);  // print character
inline int myputs(const char *str);   // print string

int main(void)
{

  /** main program **/

#ifndef DEBUG
  *(volatile int *)(EXIT_ADDR) = 0;
#endif
  return 0;

}

// kakezan
inline int mul(int a, int b)
{
  int tmp, ans = 0;

  if (a < b) {
    tmp = a;
    a = b;
    b = tmp;
  }

  for (; b != 0; b = b >> 1) {
    if (b & 1)
      ans += a;
    a = a << 1;
  }

  return ans;
}

// warizan
inline int div(int a, int b)
{
  int ans = 0, pos = 1;

  for (; a >= b; b = b << 1) {
    pos = pos << 1;
  }

  pos = pos >> 1;
  b = b >> 1;
  while(pos) {
    if (a >= b) {
      ans |= pos;
      a -= b;
    }
    pos = pos >> 1;
    b = b >> 1;
  }

  return ans;
}

// zyouyozan
inline int rem(int a, int b)
{
  int pos = 1;

  for (; a >= b; b = b << 1) {
    pos = pos << 1;
  }

  pos = pos >> 1;
  b = b >> 1;
  while(pos) {
    if (a >= b) {
      a -= b;
    }
    pos = pos >> 1;
    b = b >> 1;
  }

  return a;
}

// warizan and zyouyozan
inline void divrem(int a, int b, int *ans_div, int *ans_rem)
{
  int ans = 0, pos = 1;

  for (; a >= b; b = b << 1) {
    pos = pos << 1;
  }

  pos = pos >> 1;
  b = b >> 1;
  while(pos) {
    if (a >= b) {
      ans |= pos;
      a -= b;
    }
    pos = pos >> 1;
    b = b >> 1;
  }

  *ans_div = ans;
  *ans_rem = a;
}

// convert number to string. return string size
inline int numTostr(char *s, int n, int base)
{
  int i;
  char tmp;
  char *p = s;

  for (i = base; i <= n; i = mul(i, base));

  for (i = div(i, base); i != 0; i = div(i, base)) {
    tmp = (char)div(n, i);
    n = rem(n, i);
    if (tmp < 10) {
      *(p++) = tmp + '0';
    } else {
      *(p++) = tmp - 10 + 'a';
    }
  }

  *p = '\0';

  return (int)(p - s);
}

inline void myputchar(const char c)
{
#ifdef DEBUG
  putchar(c);
#else
  *(volatile char *)(STDOUT_ADDR) = c;
#endif
}

inline int myputs(const char *str)
{
  int i;

  for (i = 0; str[i] != '\0'; ++i) {
    myputchar(str[i]);
  }

  return i;
}
