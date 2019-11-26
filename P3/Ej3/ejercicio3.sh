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

echo "Running normal and traspuesta..."

if [ -f $fCache ]; then
	rm $fCache
fi

if [ -f $fTime ]; then
	rm $fTime
fi

if [ -f $fMult ]; then
	rm $fMult
fi

touch $fCache $fTime $fMult

for N in $(seq $Ninicio $Npaso $Nfinal); do

	echo "(Valgrind) $N / $Nfinal"

    valgrind --tool=cachegrind --cachegrind-out-file=./normal_out_$N.dat ./normal $N
    D1mrNormal=$(cg_annotate ./normal_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$5); print $5}')
    D1mwNormal=$(cg_annotate ./normal_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$8); print $8}')

    valgrind --tool=cachegrind --cachegrind-out-file=./traspuesta_out_$N.dat ./traspuesta $N
    D1mrTraspuesta=$(cg_annotate ./traspuesta_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$5); print $5}')
    D1mwTraspuesta=$(cg_annotate ./traspuesta_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$8); print $8}')

    echo "$N    $D1mrNormal   $D1mwNormal   $D1mrTraspuesta   $D1mwTraspuesta" >> $fCache

    rm ./normal_out_$N.dat ./traspuesta_out_$N.dat
done

for i in $(seq 1 1 $rep); do

	echo "N: $i / $rep..."

	for N in $(seq $Ninicio $(($Npaso*2)) $Nfinal); do

		# ejecutar los programas normal y traspuesta consecutivamente con tamaño de matriz N
		# para cada uno, filtrar la línea que contiene el tiempo y seleccionar la
		# tercera columna (el valor del tiempo). Dejar los valores en variables
		# para poder imprimirlos en la misma línea del fichero de datos
		N2=$(($N+$Npaso))

		if [[ i -eq 1 ]]; then
			medianormal[$N]=0
			mediatraspuesta[$N]=0
			medianormal[$N2]=0
			mediatraspuesta[$N2]=0
		fi

		normalTime1=$(./normal $N | grep 'time' | awk '{print $3}')
		medianormal[$N]=$(echo "scale=20; ${medianormal[$N]}+($normalTime1/$rep)" | bc)
		normalTime2=$(./normal $N2 | grep 'time' | awk '{print $3}')
		medianormal[$N2]=$(echo "scale=20; ${medianormal[$N2]}+($normalTime2/$rep)" | bc)
		traspuestaTime1=$(./traspuesta $N | grep 'time' | awk '{print $3}')
		mediatraspuesta[$N]=$(echo "scale=20; ${mediatraspuesta[$N]}+($traspuestaTime1/$rep)" | bc)
		traspuestaTime2=$(./traspuesta $N2 | grep 'time' | awk '{print $3}')
		mediatraspuesta[$N2]=$(echo "scale=20; ${mediatraspuesta[$N2]}+($traspuestaTime2/$rep)" | bc)

		if [[ i -eq $rep ]]; then
			echo $N	${medianormal[$N]}	`cat $fCache | grep $N | awk '{print $2"\t"$3}'`	\
			${mediatraspuesta[$N]}	`cat $fCache | grep $N | awk '{print $4"\t"$5}'`>> $fTime
			echo $N2	${medianormal[$N2]}	`cat $fCache | grep $N2 | awk '{print $2"\t"$3}'`	\
			${mediatraspuesta[$N2]}	`cat $fCache | grep $N2 | awk '{print $4"\t"$5}'`>> $fTime
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
"$fMult" using 1:6 with lines lw 2 title "D1mr_traspuesta", \
"$fMult" using 1:7 with lines lw 2 title "D1mw_traspuesta"
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
