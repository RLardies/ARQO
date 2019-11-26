# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=4
Ninicio=$((10000+1024*$p))
Npaso=64
Nfinal=$((Ninicio+1024))
fDAT=slow_fast_time.dat
fPNG=slow_fast_time.png
rep=20
mediaFast[0]=0
mediaSlow[0]=0

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT fPNG fDATN

# generar el fichero DAT vacío
touch $fDAT

echo "Running slow and fast..."
# bucle para N desde P hasta Q 
for i in $(seq 1 1 $rep); do
#for ((N = Ninicio ; N <= Nfinal ; N += Npaso)); do

	echo "N: $i / $rep..."

	for N in $(seq $Ninicio $(($Npaso*2)) $Nfinal); do

		# ejecutar los programas slow y fast consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		N2=$(($N+$Npaso))

		if [[ i -eq 1 ]]; then
			mediaSlow[$N]=0
			mediaFast[$N]=0
			mediaSlow[$N2]=0
			mediaFast[$N2]=0
		fi

		slowTime1=$(./slow $N | grep 'time' | awk '{print $3}')
		mediaSlow[$N]=$(echo "scale=10; ${mediaSlow[$N]}+($slowTime1/$rep)" | bc)
		slowTime2=$(./slow $N2 | grep 'time' | awk '{print $3}')
		mediaSlow[$N2]=$(echo "scale=10; ${mediaSlow[$N2]}+($slowTime2/$rep)" | bc)
		fastTime1=$(./fast $N | grep 'time' | awk '{print $3}')
		mediaFast[$N]=$(echo "scale=10; ${mediaFast[$N]}+($fastTime1/$rep)" | bc)
		fastTime2=$(./fast $N2 | grep 'time' | awk '{print $3}')
		mediaFast[$N2]=$(echo "scale=10; ${mediaFast[$N2]}+($fastTime2/$rep)" | bc)

		if [[ i -eq $rep ]]; then
			echo "$N	${mediaSlow[$N]}	${mediaFast[$N]}" >> $fDAT
			echo "$N2	${mediaSlow[$N2]}	${mediaFast[$N2]}" >> $fDAT
		fi

	done

done

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
export PATH=$PATH:/share/apps/tools/gnuplot/bin
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
