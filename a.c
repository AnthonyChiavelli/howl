#include<stdio.h>

              #include<stdlib.h>

              main() {
 
              char *ptr = malloc(5000);
ptr++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
while (*ptr) {
ptr--;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
(*ptr)++;
ptr++;
(*ptr)--;
}
ptr--;
putchar(*ptr);
}