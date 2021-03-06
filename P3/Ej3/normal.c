//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "../arqo3.h"

void compute (tipo **m1, tipo **m2, tipo **mres, int n);

int main( int argc, char *argv[])
{
	int n;
	tipo **m1 = NULL, **m2 = NULL,**mres = NULL;
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
	compute(m1, m2, mres, n);
	/* End of computation */

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", 
		((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);	

	freeMatrix(m1);
	freeMatrix(m2);
	freeMatrix(mres);
	return 0;
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
