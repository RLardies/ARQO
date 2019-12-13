//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "../arqo3.h"

void compute(tipo **m1, tipo **m2, tipo **mres, int n, int cores);
void traspose(tipo **matrix, int n);

int main( int argc, char *argv[])
{
	int n;
	tipo **m1 = NULL, **m2 = NULL,**mres = NULL;
	struct timeval fin,ini;

	int cores;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	if( argc!=3 )
	{
		printf("Error: ./%s <matrix size>\n", argv[0]);
		return -1;
	}
	n = atoi(argv[1]);
	cores = atoi(argv[2]);

	m1 = generateMatrix(n);
	if(m1 == NULL) return -1;

	m2 = generateMatrix(n);
	if(m2 == NULL) 
	{	
		freeMatrix(m1);
		return -1;
	}

	mres = generateEmptyMatrix(n);
	if (mres == NULL)
	{	
		freeMatrix(m1);
		freeMatrix(m2);
		return -1;
	}

	gettimeofday(&ini,NULL);

	/* Main computation */
	traspose(m2, n);
	compute(m1, m2, mres, n, cores);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", 
		((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);	

	freeMatrix(m1);
	freeMatrix(m2);
	freeMatrix(mres);
	return 0;
}


void compute(tipo **m1, tipo **m2, tipo **mres, int n, int cores)
{
	int i, j, z;
	
	
	for (i = 0; i < n; i++)
	{
		#pragma omp parallel for num_threads(cores) private(j,z)
		for (j = 0; j < n; j++)
		{	
			mres[i][j] = 0;

			for (z = 0; z < n; z++)
				mres[i][j] += m1[i][z] * m2[j][z];
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
