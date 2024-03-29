/* compute Napier's constant */

#ifdef DEBUG
#include <stdio.h>
#endif

#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000

#define RADIX 10000        // !do not change
#define RADIX_POW10 4      // !do not change

#define NUM_DEGITS 64            // syousuutenn NUM_DIGITS made motomeru
#define N_SPACE 4                // insert space per 4 char
#define N_NEWLINE (N_SPACE * 4)  // insert newline per N_SPACE*4 char

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
inline void ldiv(int a[], int b[], int n, int p);  /* a = b/n */
inline void napier(int e[]);  /* get Napier's constant */
inline void showData(int a[]);
inline int checkResult(int a[], int ans[]);

int main(void)
{
  int e[WORK];
  int f;
  int e_ans[WORK] =
    { 2,
      7182, 8182, 8459,  452,
      3536,  287, 4713, 5266,
      2497, 7572, 4709, 3699,
      9595, 7496, 6967, 6277,
      2386 };

  myputs("Program Start !\n");
  myputs("Calculating Napier's constant ... \n");

  napier(e);

  myputs("Complete !!\n");

  /** print result **/
  myputs("\nResult:\n");
  showData(e);

  f = checkResult(e, e_ans);
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

inline void ldiv(int a[], int b[], int n, int p) /* a=b/n */
{
  int t, x, i;

  t = 0;
  for (i = p; i < WORK; ++i){
    x = mul(t, RADIX) + b[i];
    divrem(x, n, &a[i], &t);
  }
}

inline void napier(int e[]) /* get Napier's constant */
{
  int a[WORK];
  int p, i;

  //  a: 1/(i!)

  init(e, 2);  // e = 2
  init(a, 1);  // a = 0
  p = 0;
  i = 2;
  while(1) {
    ldiv(a, a, i, p);  // a = a / i
    p = top(a, p);

    if (p == WORK)  // if underflow of a occur
      break;

    ladd(e, e, a);     // e = e + a

    ++i;
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
