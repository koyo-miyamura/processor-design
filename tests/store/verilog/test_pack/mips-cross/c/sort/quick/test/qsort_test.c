#define STDOUT_ADDR 0xf0000000
#define EXIT_ADDR 0xff000000
#define MAX_SLENG 128
#define N 100

void quickSort(int a[], int left, int right);  // quick sort
inline void showData(int a[], int n);
inline int checkResult(int a[], int n);  // check and show result
inline int mul(int a, int b);  // kakezan
inline int div(int a, int b);  // warizan
inline int rem(int a, int b);  // zyouyozan
inline int numTostr(char *s, int n, int code);  // convert number to string.
inline void myputchar(const char c);  // print character
inline int myputs(const char *str);   // print string

int main(void)
{
  int a[N] = 
    { 383, 886, 777, 915, 793, 335, 386, 492, 649, 421,
      362, 27, 690, 59, 763, 926, 540, 426, 172, 736,
      211, 368, 567, 429, 782, 530, 862, 123, 67, 135,
      929, 802, 22, 58, 69, 167, 393, 456, 11, 42,
      229, 373, 421, 919, 784, 537, 198, 324, 315, 370,
      413, 526, 91, 980, 956, 873, 862, 170, 996, 281,
      305, 925, 84, 327, 336, 505, 846, 729, 313, 857,
      124, 895, 582, 545, 814, 367, 434, 364, 43, 750,
      87, 808, 276, 178, 788, 584, 403, 651, 754, 399,
      932, 60, 676, 368, 739, 12, 226, 586, 94, 539 };
  int f;

  myputs("Program Start !\n");
  myputs("Sorting ... \n");
  quickSort(a, 0, N-1);
  myputs("Complete !!\n");

  myputs("\nResult:\n");
  showData(a, N);

  f = checkResult(a, N);
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

void quickSort(int a[ ], int left, int right)
{
  int i, j, tmp;
  int pivot;

  i = left;
  j = right;

  pivot = a[(left + right) / 2];

  while (1) {

    while (a[i] < pivot)
      ++i;

    while (pivot < a[j])
      --j;

    if (i >= j)
      break;

    // swap
    tmp = a[i];
    a[i] = a[j];
    a[j] = tmp;

    ++i;
    --j;
  }

  if (left < i - 1)
    quickSort(a, left, i - 1);
  if (j + 1 <  right)
    quickSort(a, j + 1, right);
}

inline void showData(int a[], int n) {
  int i, j;
  char s[MAX_SLENG];

  j = 0;
  for (i = 0; i < n; ++i) {
    numTostr(s, a[i], 10);
    myputs(s);
    myputchar(' ');
    ++j;
    if (j == 10) {  // kaigyou per 10 output
      myputchar('\n');
      j = 0;
    }
  }

}

// if OK, return 0
inline int checkResult(int a[], int n) {
  int i;

  for (i = 0; i < n - 1; ++i) {
    if (a[i] > a[i+1])
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
inline int numTostr(char *s, int n, int code)
{
    int i;
    char tmp;
    char *s_orig = s;

    for (i = code; i <= n; i = mul(i, code));

    for (i = div(i, code); i != 0; i = div(i, code)){
	tmp = (char)div(n, i);
	n = rem(n, i);
	if (tmp < 10) {
	  *(s++) = tmp + '0';
	} else {
	  *(s++) = tmp - 10 + 'a';
        }
    }

    *s = '\0';

    return (int)(s - s_orig);
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
