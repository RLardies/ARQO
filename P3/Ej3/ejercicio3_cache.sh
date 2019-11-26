# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=4
Ninicio=$((256+256*$p))
Npaso=16
Nfinal=$((256+256*($p+1)))
rep=10
fCache=./cache.dat

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