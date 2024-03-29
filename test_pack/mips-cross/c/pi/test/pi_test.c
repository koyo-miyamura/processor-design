/* compute pi using Machin's formula */

/*  Machin's formula
  pi = 16 * arctan(1/5) - 4 * arctan(1/239)
*/

#ifdef DEBUG
#include <stdio.h>
#endif

#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000

#define RADIX 10000        // !do not change
#define RADIX_POW10 4      // !do not change

#define NUM_DEGITS 64             // syousuutenn NUM_DIGITS made motomeru
#define N_SPACE 4                 // insert space per 4 char
#define N_NEWLINE (N_SPACE * 4)   // insert newline per N_SPACE*1 char

#define WORK ((NUM_DEGITS / RADIX_POW10) + 2)

inline int mul(int a, int b);  // kakezan
inline int div(int a, int b);  // warizan
inline int rem(int a, int b);  // zyouyozan
inline void divrem(int a, int b, int *ans_div, int *ans_rem);  // warizan and zyouyozan
inline int numTostr(char *s, int n, int base);  // convert number to string.
inline void myputchar(const char c);  // print character
inline int myputs(const char *str);   // print string

inline void init(int a[], int n);
inline int top(int a[], int p);
inline void ladd(int a[], int b[], int c[]);  /* a = b + c */
inline void lsub(int a[], int b[], int c[]);  /* a = b - c */
inline void ldiv(int a[], int b[], int n, int p);  /* a = b/n */
inline void marctan(int a[], int n, int d);  /* a = n * arctan(1/d) */
inline void showData(int a[]);
inline int checkResult(int a[], int ans[]);

int main(void)
{
  int a[WORK], b[WORK], pi[WORK];
  int f;
  int pi_ans[WORK] =
    { 3,
      1415, 9265, 3589, 7932,
      3846, 2643, 3832, 7950,
      2884, 1971, 6939, 9375,
      1058, 2097, 4944, 5923,
      784 };

  myputs("Program Start !\n");
  myputs("Calculating pi ... \n");

  /*    Machin's formula
    pi = 16 * arctan(1/5) - 4 * arctan(1/239)
  */
  marctan(a, 16, 5);   // a <- 16 * arctan(1/5)
  marctan(b, 4, 239);  // b <- 4 * arctan(1/239)
  lsub(pi, a, b);      // pi = a - b

  myputs("Complete !!\n");

  /** print result **/
  myputs("\nResult:\n");
  showData(pi);

  f = checkResult(pi, pi_ans);
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

inline void init(int a[], int n)
{
  int i;

  a[0] = n;
  for (i = 1; i < WORK; ++i)
    a[i] = 0;
}

inline int top(int a[], int p)
{
  while (p < WORK && a[p] == 0)
    ++p;
  return(p);
}

inline void ladd(int a[], int b[], int c[]) /* a=b+c */
{
  int t, x, i;

  t = 0;
  for (i = WORK - 1; i >= 0; --i){
    x = b[i] + c[i] + t;
    divrem(x, RADIX, &t, &a[i]);
  }

#ifdef DEBUG
  if (t != 0)
    printf("overflow\n");
#endif

}

inline void lsub(int a[], int b[], int c[]) /* a=b-c */
{
  int t, x, i;

  t=1;
  for (i = WORK - 1; i >= 0; --i){
    x = b[i] + (RADIX - 1 - c[i]) + t;
    divrem(x, RADIX, &t, &a[i]);
  }

#ifdef DEBUG
  if (t != 1)
    printf("overflow\n");
#endif

}

inline void ldiv(int a[], int b[], int n, int p) /* a=b/n */
{
  int t, x, i;

  t = 0;
  for (i = p; i < WORK; ++i){
    x = mul(t, RADIX) + b[i];
    divrem(x, n, &a[i], &t);
  }
}

inline void marctan(int a[], int n, int d) /* a=n*arctan(1/d) */
{
  int e[WORK], f[WORK];
  int p, i;

  /** n*arctan(1/d) = n * (1/d) - n/3 * (1/d)^3 + n/5 * (1/d)^5 + ... + (-1)^(i%4 == 1) * n/i * (1/d)^i + ... ( i = 3, 5, 7, 9, 11, ...) **/

  //  a: n*arctan(1/d)
  //  e: n * (1/d)^i
  //  f: n/i * (1/d)^i

  init(a, 0);  // a = 0
  init(e, n);  // e = n
  ldiv(e, e, d, 0);  // e = e / d
  p = top(e, 0);
  for (i = 0; i < p; ++i) {  // initilize f
     f[i] = 0;
  }
  ladd(a, a, e);
  i = 3;
  while(1) {
    ldiv(e, e, d, p);  // e = e / d
    ldiv(e, e, d, p);  // e = e / d
    ldiv(f, e, i, p);  // f = e / i
    p = top(e, p);

    if (top(f, p) == WORK)  // if underflow of f occur
      break;

    if ((i & 3) == 1)  // i = 5, 9, 13, 17, ...
      ladd(a, a, f);
    else               // i = 7, 11, 15, 19, ...
      lsub(a, a, f);
    
    i += 2;
  }
}

inline void showData(int a[])
/*
  1. print seisuu-bu
    printf("%d.", a[0]);
  2. print shyousuu-bu
    print a[1]...a[WORK-2] in "%04d", inserting space(newline) per N_SPACE(N_NEWLINE) charactor.

  Example
   input:
     N_SPACE 5
     N_NEWLINE 10
     a[] = {3, 4, 135, 566, 234, 223, 334, 1345, 893, 13, 9847}

   stdout:
     3.
     00040 13505
     66023 40223
     03341 34508
     93001 39847
*/
{
  int i, c_sp, c_nl;
  char *p_str, str_real[2 * RADIX_POW10];
  char *str = &str_real[RADIX_POW10 - 1];

  for (i = 0; i < RADIX_POW10 - 1; i++) {
    str_real[i] = '0';
  }
  str_real[i] = '\0';

  /** print seisuu-bu **/
  numTostr(str, a[0], 10);
  myputs(str);
  myputchar('.');
  myputchar('\n');

  /** print shyousuu-bu **/
  c_sp = 0;
  c_nl = 0;
  for (i = 1; i < WORK - 1; ++i){
    for (p_str = str - RADIX_POW10 + numTostr(str, a[i], 10); *p_str; ++p_str) {
      myputchar(*p_str);
      ++c_sp;
      ++c_nl;

      if (c_sp == N_SPACE) {
	myputchar(' ');
	c_sp = 0;
      }

      if (c_nl == N_NEWLINE) {
	myputchar('\n');
	c_nl = 0;
      }
    }
  }
}

inline int checkResult(int a[], int ans[])
{
  int i;

  for (i = 0; i < WORK; ++i) {
    if (a[i] != ans[i])
      return 1;
  }

  return 0;
}
