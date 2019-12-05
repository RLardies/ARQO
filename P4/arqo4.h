#ifndef _ARQO_P4_H_
#define _ARQO_P4_H_

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define N 1000ull
#define M 1000000ull

float ** generateMatrix(unsigned long long);
float ** generateEmptyMatrix(unsigned long long);
void freeMatrix(float **);
float * generateVector(unsigned long long);
float * generateEmptyVector(unsigned long long);
int * generateEmptyIntVector(unsigned long long);
void freeVector(void *);

#endif /* _ARQO_P4_H_ */
