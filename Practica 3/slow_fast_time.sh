# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
#1000+1024*p
Ninicio=1000
Npaso=20
#1000+1024*(p+1)
Nfinal=2000
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png
fDATN=slow_fast_N.dat
rep=20

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT fPNG fDATN

# generar el fichero DAT vacío
touch $fDAT

echo "Running slow and fast..."
# bucle para N desde P hasta Q 
for N in $(seq $Ninicio $(($Npaso*2)) $Nfinal); do
#for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do

	echo "N: $N / $Nfinal..."

	rm -f $fDATN
	touch $fDATN

	mediaFast1=0
	mediaFast2=0
	mediaSlow1=0
	mediaSlow2=0

	for i in $(seq 1 1 $rep); do


		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		N2=$(($N+$Npaso))


		slowTime2=$(./slow $N2 | grep 'time' | awk '{print $3}')
		mediaSlow2=$(echo "scale=10; $mediaSlow2+($slowTime2/$rep)" | bc)
		#slowTime=$(./slow $N | grep 'time' | awk '{print $3}')
		#mediaSlow1=$(echo "scale=10; $mediaSlow1+($slowTime/$rep)" | bc)
		fastTime=$(./fast $N | grep 'time' | awk '{print $3}')
		mediaFast1=$(echo "scale=10; $mediaFast1+($fastTime/$rep)" | bc)
		#fastTime2=$(./fast $N2 | grep 'time' | awk '{print $3}')
		#mediaFast2=$(echo "scale=10; $mediaFast2+($fastTime2/$rep)" | bc)

	done

	echo "$N	$mediaSlow2	$mediaFast1" >> $fDAT
	#echo "$N2	$mediaSlow2	$mediaFast2" >> $fDAT

done

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Slow-Fast Execution Time"
set ylabel "Execution time (s)"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
     "$fDAT" using 1:3 with lines lw 2 title "fast"
replot
quit
END_GNUPLOT
