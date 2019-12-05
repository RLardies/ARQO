// ----------- Arqo P4-----------------------
// Genera matrices y vectores (ver enunciado P4)
//
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo4.h"

float ** generateMatrix(unsigned long long size)
{
	float *array=NULL;
	float **matrix=NULL;
	unsigned long long i=0,j=0;

	matrix=(float **)malloc(sizeof(float *)*size);
	array=(float *)malloc(sizeof(float)*size*size);
	if( !array || !matrix)
	{
		printf("Error when allocating matrix of size %llu.\n",size);
		if( array )
			free(array);
		if( matrix )
			free(matrix);
		return NULL;
	}

	srand(0);
	for(i=0;i<size;i++)
	{
		matrix[i] = &array[i*size];
		for(j=0;j<size;j++)
		{
			matrix[i][j] = (1.0*rand()) / (1.0*RAND_MAX);
		}
	}

	return matrix;
}

float ** generateEmptyMatrix(unsigned long long size)
{
	float *array=NULL;
	float **matrix=NULL;
	unsigned long long i=0;

	matrix=(float **)malloc(sizeof(float *)*size);
	array=(float *)malloc(sizeof(float)*size*size);
	if( !array || !matrix)
	{
		printf("Error when allocating matrix of size %llu.\n",size);
		if( array )
			free(array);
		if( matrix )
			free(matrix);
		return NULL;
	}

	for(i=0;i<size;i++)
	{
		matrix[i] = &array[i*size];
	}

	return matrix;
}


void freeMatrix(float **matrix)
{
	if( matrix && matrix[0] )
		free(matrix[0]);
	if( matrix )
		free(matrix);
	return;
}

float * generateVector(unsigned long long size)
{
	float *array=NULL;
	unsigned long long i=0;

	array=(float *)malloc(sizeof(float)*size);
	if( !array )
	{
		printf("Error when allocating vector of size %llu.\n",size);
		if( array )
			free(array);
		return NULL;
	}

	srand(0);
	for(i=0;i<size;i++)
	{
		array[i] = (1.0*rand()) / (100.0*RAND_MAX);
	}
	return array;
}

float * generateEmptyVector(unsigned long long size)
{
	float *array=NULL;

	array=(float *)malloc(sizeof(float)*size);
	if( !array )
	{
		printf("Error when allocating vector of size %llu.\n",size);
		if( array )
			free(array);
		return NULL;
	}
	return array;
}

void freeVector(void *array)
{
	if( array )
		free(array);
}

int * generateEmptyIntVector(unsigned long long size)
{
	int *array=NULL;

	array=(int *)malloc(sizeof(int)*size);
	if( !array )
	{
		printf("Error when allocating vector of size %llu.\n",size);
		if( array )
			free(array);
		return NULL;
	}
	return array;
}
