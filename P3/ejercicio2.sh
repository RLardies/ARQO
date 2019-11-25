# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=4
Ninicio=$((2000+512*$p))
Npaso=64
Nfinal=$((2000+512*($p+1)))
rep=5
fDAT=./$1/cache.dat
fPNG=./$1/fallosLectura.png
fPNG2=./$1/fallosEscritura.png

echo "Running slow and fast..."
rm ./$1/*
touch $fDAT

for N in $(seq $Ninicio $Npaso $Nfinal); do

    valgrind --tool=cachegrind --cachegrind-out-file=./$1/slow_out_$N.dat --I1=$1,1,64 --D1=$1,1,64 --LL=8388608,1,64 ./slow $N
    D1mrSlow=$(cg_annotate ./$1/slow_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$5); print $5}')
    D1mwSlow=$(cg_annotate ./$1/slow_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$8); print $8}')

    valgrind --tool=cachegrind --cachegrind-out-file=./$1/fast_out_$N.dat --I1=$1,1,64 --D1=$1,1,64 --LL=8388608,1,64 ./fast $N
    D1mrFast=$(cg_annotate ./$1/fast_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$5); print $5}')
    D1mwFast=$(cg_annotate ./$1/fast_out_$N.dat | head -18 | tail -1 | awk '{gsub(",","",$8); print $8}')

    echo "$N    $D1mrSlow   $D1mwSlow   $D1mrFast   $D1mwFast" >> $fDAT
done

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
export PATH=$PATH:/share/apps/tools/gnuplot/bin
gnuplot << END_GNUPLOT
set title "Fallos de Lectura"
set ylabel "Numero de Fallos"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDAT" using 1:2 with lines lw 2 title "slow", \
"$fDAT" using 1:4 with lines lw 2 title "fast"
replot
set title "Fallos de Escritura"
set ylabel "Numero de Fallos"
set xlabel "Matrix Size"
set key right bottom
set grid
set term png
set output "$fPNG2"
plot "$fDAT" using 1:3 with lines lw 2 title "slow", \
"$fDAT" using 1:5 with lines lw 2 title "fast"
quit
END_GNUPLOT
