#ifdef DEBUG
#include <stdio.h>
#endif

#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000

#define N_PRIME 40
#define N_NEWLINE 10  // insert newline per 10 number

int getPrimeNumbers(unsigned int a[], int n_max);
void showData(unsigned int a[], int n);
int checkResult(unsigned int a[], unsigned int ans[], int n);

inline int mul(int a, int b);  // kakezan
inline int div(int a, int b);  // warizan
inline int rem(int a, int b);  // zyouyozan
inline int numTostr(char *s, int n, int base);  // convert number to string.
inline void myputchar(const char c);  // print character
inline int myputs(const char *str);   // print string

int main(void)
{
  unsigned int prime_list[N_PRIME];
  int n, f;

  unsigned int prime_list_ans[N_PRIME] =
    {   2,   3,   5,   7,  11,  13,  17,  19,  23, 29,
       31,  37,  41,  43,  47,  53,  59,  61,  67, 71,
       73,  79,  83,  89,  97, 101, 103, 107, 109, 113,
      127, 131, 137, 139, 149, 151, 157, 163, 167, 173 };

  myputs("Program Start !\n");
  myputs("Obtaining Prime Numbers ... \n");
  n = getPrimeNumbers(prime_list, N_PRIME);
  myputs("Complete !!\n");

  //  myputs("\nResult:\n");
  //  showData(prime_list, n);

  f = checkResult(prime_list, prime_list_ans, n);
  if(f == 0) {
    myputs("\nCHECK PASSED !!\n");
  } else if (f == 1){
    myputs("\nCHECK FAILED !!\n");
  } else {
    myputs("\nINVALID ??\n");
  }

#ifndef DEBUG
  *(volatile int *)(EXIT_ADDR) = 0;
#endif
  return 0;

}

int getPrimeNumbers(unsigned int a[], int n_max)
{
  unsigned int i, j, n;

  /** initialize prime_list **/
  a[0] = 2;
  n = 1;

  /** get prime numbers **/
  for (i = 2; n < n_max && i <= 0xffffffff; ++i) {
    for (j = 0; j < n; ++j) {  // check
      if (rem(i, a[j]) == 0)
	break;
    }

    if (j == n)
      a[n++] = i;
  }

  return n;

}

void showData(unsigned int a[], int n)
{
  int i, j;
  char str[11];

  j = 0;
  for (i = 0; i < n; ++i) {
    numTostr(str, a[i], 10);
    myputs(str);
    myputchar(' ');
    ++j;
    if (j == N_NEWLINE) {
      myputchar('\n');
      j = 0;
    }
  }
}

int checkResult(unsigned int a[], unsigned int ans[], int n)
{
  int i;

  for (i = 0; i < n; ++i) {
    if (a[i] != ans[i])
      return 1;
  }

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
