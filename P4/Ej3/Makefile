LIBS = 
LIB_DIR =  
FLAGS = -g -lgomp -Wall -D_GNU_SOURCE -fopenmp

.PHONY: clean all

all: traspuesta_par1 traspuesta_par2 traspuesta_par3 traspuesta_serie clear


traspuesta_serie: traspuesta_serie.c ../arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

traspuesta_par1: traspuesta_par1.c ../arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

traspuesta_par2: traspuesta_par2.c ../arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

traspuesta_par3: traspuesta_par3.c ../arqo3.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ traspuesta_serie traspuesta_par1 traspuesta_par2 traspuesta_par3
	
clear:
	rm -f *.o *~
