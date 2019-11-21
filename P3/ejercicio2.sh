# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=4

Ninicio=$((2000+512*$p))
Npaso=64
Nfinal=$((2000+512*($p+1)))
TamInicio=1024
TamFinal=8192
tam=0
rep=5

# borrar el fichero DAT y el fichero PNG
rm -f $fDAT fPNG fDATN

# generar el fichero DAT vacío
touch $fDAT

echo "Running slow and fast..."
# bucle para N desde P hasta Q
for ((tam = $TamInicio ; tam <= $TamFinal ; tam*=2;)) do

  for N in $(seq $Ninicio $(($Npaso*2)) $Nfinal); do

    N2=$(($N+$Npaso))

    valgrind --tool=cachegrind --cachegrind-out-file=slow_out_$tam_$N.dat --I1=$tam,1,64 --D1=$tam,1,64 --LL=8388608,1,64 ./slow $N
    D1mrSlow=cg_annotate slow_out_$tam_$N.dat |head -18 | tail -1 | awk '{print $5}'
    D1mwSlow=cg_annotate slow_out_$tam_$N.dat |head -18 | tail -1 | awk '{print $8}'

    valgrind --tool=cachegrind --cachegrind-out-file=slow_out_$tam_$N2.dat --I1=$tam,1,64 --D1=$tam,1,64 --LL=8388608,1,64 ./slow $N2
    D1mrSlow2=cg_annotate slow_out_$tam_$N2.dat |head -18 | tail -1 | awk '{print $5}'
    D1mwSlow2=cg_annotate slow_out_$tam_$N2.dat |head -18 | tail -1 | awk '{print $8}'

    valgrind --tool=cachegrind --cachegrind-out-file=fast_out_$tam_$N.dat --I1=$tam,1,64 --D1=$tam,1,64 --LL=8388608,1,64 ./fast $N
    D1mrFast=cg_annotate fast_out_$tam_$N.dat |head -18 | tail -1 | awk '{print $5}'
    D1mwFast=cg_annotate fast_out_$tam_$N.dat |head -18 | tail -1 | awk '{print $8}'

    valgrind --tool=cachegrind --cachegrind-out-file=fast_out_$tam_$N2.dat --I1=$tam,1,64 --D1=$tam,1,64 --LL=8388608,1,64 ./fast $N2
    D1mrFast2=cg_annotate fast_out_$tam_$N2.dat |head -18 | tail -1 | awk '{print $5}'
    D1mwFast2=cg_annotate fast_out_$tam_$N2.dat |head -18 | tail -1 | awk '{print $8}'

    echo "$N	$D1mrSlow	$D1mwSlow $D1mrFast $D1mwFast" >> $cache_$tam.dat
    echo "$N2	$D1mrSlow2	$D1mwSlow2 $D1mrFast2 $D1mwFast2" >> $fDAT
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
