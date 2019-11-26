#! /bin/bash

TamInicio=1024
TamFinal=8192
fPNGW=fallosEscritura.png
fPNGR=fallosLectura.png
fDAT=cache.dat

for (( i=$TamInicio; i<=$TamFinal; i=$i*2 )); do
	if [ ! -d $i ]; then
		mkdir $i
	fi
    sh ejercicio2.sh $i &
    pids[$i]=$!
done

for pid in ${pids[*]}; do
	wait $pid
done

gnuplot << END_GNUPLOT
set title "Fallos de Lectura"
set ylabel "Numero de Fallos"
set xlabel "Tamaño de Matriz"
set key right bottom
set grid
set term png
set output "$fPNGR"
plot "1024/$fDAT" using 1:2 with lines lw 2 title "slow\\\\_1024", \
"1024/$fDAT" using 1:4 with lines lw 2 title "fast\\\\_1024", \
"2048/$fDAT" using 1:2 with lines lw 2 title "slow\\\\_2048", \
"2048/$fDAT" using 1:4 with lines lw 2 title "fast\\\\_2048", \
"4096/$fDAT" using 1:2 with lines lw 2 title "slow\\\\_4096", \
"4096/$fDAT" using 1:4 with lines lw 2 title "fast\\\\_4096", \
"8192/$fDAT" using 1:2 with lines lw 2 title "slow\\\\_8192", \
"8192/$fDAT" using 1:4 with lines lw 2 title "fast\\\\_8192"
replot
set title "Fallos de Escritura"
set ylabel "Numero de Fallos"
set xlabel "Tamaño de Matriz"
set key right bottom
set grid
set term png
set output "$fPNGW"
plot "1024/$fDAT" using 1:3 with lines lw 2 title "slow\\\\_1024", \
"1024/$fDAT" using 1:5 with lines lw 2 title "fast\\\\_1024", \
"2048/$fDAT" using 1:3 with lines lw 2 title "slow\\\\_2048", \
"2048/$fDAT" using 1:5 with lines lw 2 title "fast\\\\_2048", \
"4096/$fDAT" using 1:3 with lines lw 2 title "slow\\\\_4096", \
"4096/$fDAT" using 1:5 with lines lw 2 title "fast\\\\_4096", \
"8192/$fDAT" using 1:3 with lines lw 2 title "slow\\\\_8192", \
"8192/$fDAT" using 1:5 with lines lw 2 title "fast\\\\_8192"
quit
END_GNUPLOT