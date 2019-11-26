# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=4
Ninicio=$((256+256*$p))
Npaso=16
Nfinal=$((256+256*($p+1)))
rep=10
fCache=./cache.dat
fTime=./time.dat
fMult=./mult.dat
fPNGC=./mult_cache.png
fPNGT=./mult_time.png

# Anadir valgrind al path
export PATH=$PATH:/share/apps/tools/valgrind/bin
# Indicar ruta librerías valgrind
export VALGRIND_LIB=/share/apps/tools/valgrind/lib/valgrind

echo "Running slow and fast..."

if [ -f $fCache ]; then
	rm $fCache
fi

if [ -f $fTime ]; then
	rm $fTime
fi

if [ -f $fMult ]; then
	rm $fMult
fi

for N in $(seq $Ninicio $Npaso $Nfinal); do

	echo "(Valgrind) $N / $Nfinal"

    valgrind --tool=cachegrind --cachegrind-out-file=./slow_out_$N.dat ./slow $N
    D1mrSlow=$(cg_annotate ./slow_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$5); print $5}')
    D1mwSlow=$(cg_annotate ./slow_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$8); print $8}')

    valgrind --tool=cachegrind --cachegrind-out-file=./fast_out_$N.dat ./fast $N
    D1mrFast=$(cg_annotate ./fast_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$5); print $5}')
    D1mwFast=$(cg_annotate ./fast_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$8); print $8}')

    echo "$N    $D1mrSlow   $D1mwSlow   $D1mrFast   $D1mwFast" >> $fCache

    rm ./slow_out_$N.dat ./fast_out_$N.dat
done

for i in $(seq 1 1 $rep); do

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
		mediaSlow[$N]=$(echo "scale=20; ${mediaSlow[$N]}+($slowTime1/$rep)" | bc)
		slowTime2=$(./slow $N2 | grep 'time' | awk '{print $3}')
		mediaSlow[$N2]=$(echo "scale=20; ${mediaSlow[$N2]}+($slowTime2/$rep)" | bc)
		fastTime1=$(./fast $N | grep 'time' | awk '{print $3}')
		mediaFast[$N]=$(echo "scale=20; ${mediaFast[$N]}+($fastTime1/$rep)" | bc)
		fastTime2=$(./fast $N2 | grep 'time' | awk '{print $3}')
		mediaFast[$N2]=$(echo "scale=20; ${mediaFast[$N2]}+($fastTime2/$rep)" | bc)

		if [[ i -eq $rep ]]; then
			echo $N	${mediaSlow[$N]}	`cat $fCache | grep $N | awk '{print $2"\t"$3}'`	\
			${mediaFast[$N]}	`cat $fCache | grep $N | awk '{print $4"\t"$5}'`>> $fTime
			echo $N2	${mediaSlow[$N2]}	`cat $fCache | grep $N2 | awk '{print $2"\t"$3}'`	\
			${mediaFast[$N2]}	`cat $fCache | grep $N2 | awk '{print $4"\t"$5}'`>> $fTime
		fi

	done

done

export PATH=$PATH:/share/apps/tools/gnuplot/bin

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Fallos de Caché"
set ylabel "Numero de Fallos"
set xlabel "Tamaño de Matriz"
set key right bottom
set grid
set term png
set output "$fPNGC"
plot "$fMult" using 1:3 with lines lw 2 title "D1mr_normal", \
"$fMult" using 1:4 with lines lw 2 title "D1mw_normal", \
"$fMult" using 1:6 with lines lw 2 title "D1mr_fast", \
"$fMult" using 1:7 with lines lw 2 title "D1mw_fast"
replot
set title "Tiempo de ejecución"
set ylabel "Numero de Fallos"
set xlabel "Tamaño de Matriz"
set key right bottom
set grid
set term png
set output "$fPNGT"
plot "$fMult" using 1:2 with lines lw 2 title "Normal", \
"$fMult" using 1:5 with lines lw 2 title "Traspuesto"
quit
END_GNUPLOT
