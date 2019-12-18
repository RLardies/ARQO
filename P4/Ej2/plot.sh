#! /bin/bash

fDat=time_core_
fSerie=serie.dat
fPNG=tiempos.png
fPNG2=aceleracion.png

c=$(cat /proc/cpuinfo | grep siblings | head -1 | awk '{print $3}')

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Tiempos de ejecución"
set ylabel "Tiempo (s)"
set xlabel "Tamaño de vector"
set key left top
set grid
set term png
set output "$fPNG"
plot for [i=1:$c] "$fDat".i.".dat" using 1:2 with lines lw 2 title "".i." hilos", \
"$fSerie" using 1:2 with lines lw 2 lt rgb "#ff009b" title "serie"
replot
set title "Aceleración"
set ylabel "Aceleración"
set xlabel "Tamaño de vector"
set key right bottom
set grid
set term png
set output "$fPNG2"
plot for [i=1:$c] "$fDat".i.".dat" using 1:3 with lines lw 2 title "".i." hilos"
quit
END_GNUPLOT
