//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "../arqo3.h"

void computeTrans(tipo **m1, tipo **m2, tipo **mres, int n);
void compute(tipo **m1, tipo **m2, tipo **mres, int n);
void traspose(tipo **matrix, int n);
void printMatrix(tipo **m, int n);

int main( int argc, char *argv[])
{
	int n, i;
	tipo **m1 = NULL, **m2 = NULL,**mres = NULL, **mres2;
	struct timeval fin,ini;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	if( argc!=2 )
	{
		printf("Error: ./%s <matrix size>\n", argv[0]);
		return -1;
	}
	n = atoi(argv[1]);

	m1 = generateMatrix(n);
	if(m1 == NULL) return -1;

	printf("M1:\n");
	printMatrix(m1, n);
	printf("\n");

	m2 = generateMatrix(n);
	if(m2 == NULL) 
	{	
		freeMatrix(m1);
		return -1;
	}

	printf("M2:\n");
	printMatrix(m2, n);
	printf("\n");

	mres = generateEmptyMatrix(n);
	if (mres == NULL)
	{	
		freeMatrix(m1);
		freeMatrix(m2);
		return -1;
	}

	mres2 = generateEmptyMatrix(n);
	if (mres2 == NULL) return -1;

	gettimeofday(&ini,NULL);

	/* Main computation */
	compute(m1, m2, mres2, n);
	printf("ResNormal: \n");
	printMatrix(mres2, n);
	printf("\n");
	traspose(m2, n);
	computeTrans(m1, m2, mres, n);
	printf("ResTras: \n");
	printMatrix(mres, n);
	printf("\n");
	/* End of computation */

	freeMatrix(m1);
	freeMatrix(m2);
	freeMatrix(mres);
	freeMatrix(mres2);

	return 0;
}


void computeTrans(tipo **m1, tipo **m2, tipo **mres, int n)
{
	int i, j, z;
	
	for (i = 0; i < n; i++)
	{
		for (j = 0; j < n; j++)
		{	
			mres[i][j] = 0;

			for (z = 0; z < n; z++)
				mres[i][j] += m1[i][z] * m2[j][z];
		}
	}
}

void compute (tipo **m1, tipo **m2, tipo **mres, int n)
{
	int i, j, z;
	
	for (i = 0; i < n; i++)
	{
		for (j = 0; j < n; j++)
		{	
			mres[i][j] = 0;

			for (z = 0; z < n; z++)
			{
				mres[i][j] += m1[i][z] * m2[z][j];
			}
		}
	}
}


void traspose(tipo **matrix, int n)
{
	int i, j;

	for (i = 0; i < n; i++)
	{
		for (j = 0; j < i; j++)
		{	
			matrix[i][j] += matrix[j][i];
			matrix[j][i] = matrix[i][j] - matrix[j][i];
			matrix[i][j] -= matrix[j][i];
		}
	}
}

void printMatrix(tipo **m, int n)
{
	int i, j;

	for (i = 0; i < n; i++)
	{
		for (j = 0; j < n; j++)
		{
			printf("%lf\t", m[i][j]);
		}
		printf("\n");
	}
}