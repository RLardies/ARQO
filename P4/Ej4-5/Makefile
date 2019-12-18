LIBS =
LIB_DIR =
FLAGS = -g -lgomp -Wall -D_GNU_SOURCE -fopenmp

.PHONY: clean all

all: pi_par1 pi_par2 pi_par3 pi_par4 pi_par5 pi_par6 pi_par7 pi_serie clear

pi_par1: pi_par1.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
pi_par2: pi_par2.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
pi_par3: pi_par3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
pi_par4: pi_par4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
pi_par5: pi_par5.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
pi_par6: pi_par6.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
pi_par7: pi_par7.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
pi_serie: pi_serie.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)
clean:
	rm -f *.o *~ omp1 omp2 pescalar_serie pescalar_par1 pescalar_par2

clear:
	rm -f *.o *~