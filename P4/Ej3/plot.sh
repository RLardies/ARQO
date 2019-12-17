#! /bin/bash

fDat=tiempos.dat
fPNG=tiempos.png
fPNG2=aceleracion.png

echo "Generating plot..."
# llamar a gnuplot para generar el gráfico y pasarle directamente por la entrada
# estándar el script que está entre "<< END_GNUPLOT" y "END_GNUPLOT"
gnuplot << END_GNUPLOT
set title "Tiempos de ejecución"
set ylabel "Tiempo (s)"
set xlabel "Tamaño de vector"
set key right bottom
set grid
set term png
set output "$fPNG"
plot "$fDat" using 1:3 with lines lw 2 title "paral", \
"$fDat" using 1:2 with lines lw 2 title "serie"
replot
set title "Aceleración"
set ylabel "Aceleración"
set xlabel "Tamaño de vector"
set key right bottom
set grid
set term png
set output "$fPNG2"
plot "$fDat" using 1:4 with lines lw 2 title "aceleracion"
quit
END_GNUPLOT