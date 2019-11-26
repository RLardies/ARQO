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


if [ -f $fMult ]; then
 rm $fMult
fi

for (( i=1; i<=$((($Nfinal-$Ninicio)/$Npaso + 1)); i++ )); do
 echo `head -$i $fTime | tail -1 | awk '{print $1"\t"$2}'` \
 `head -$i $fCache | tail -1 | awk '{print $2"\t"$3}'` \
 `head -$i $fTime | tail -1 | awk '{print $3}'` `head -$i $fCache | tail -1 | awk '{print $4"\t"$5}'` >> $fMult
done

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
plot "$fMult" using 1:3 with lines lw 2 title "D1mr\\\\_normal", \
"$fMult" using 1:4 with lines lw 2 title "D1mw\\\\_normal", \
"$fMult" using 1:6 with lines lw 2 title "D1mr\\\\_traspuesta", \
"$fMult" using 1:7 with lines lw 2 title "D1mw\\\\_traspuesta"
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
