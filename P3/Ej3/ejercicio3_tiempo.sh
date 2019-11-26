# Ejemplo script, para P3 arq 2019-2020

#!/bin/bash

# inicializar variables
p=4
Ninicio=$((256+256*$p))
Npaso=16
Nfinal=$((256+256*($p+1)))
rep=10
fTime=./time.dat

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
		medianormal[$N]=$(echo "scale=10; ${medianormal[$N]}+($normalTime1/$rep)" | bc)
		normalTime2=$(./normal $N2 | grep 'time' | awk '{print $3}')
		medianormal[$N2]=$(echo "scale=10; ${medianormal[$N2]}+($normalTime2/$rep)" | bc)
		traspuestaTime1=$(./traspuesta $N | grep 'time' | awk '{print $3}')
		mediatraspuesta[$N]=$(echo "scale=10; ${mediatraspuesta[$N]}+($traspuestaTime1/$rep)" | bc)
		traspuestaTime2=$(./traspuesta $N2 | grep 'time' | awk '{print $3}')
		mediatraspuesta[$N2]=$(echo "scale=10; ${mediatraspuesta[$N2]}+($traspuestaTime2/$rep)" | bc)

		if [[ i -eq $rep ]]; then
			echo $N	${medianormal[$N]}	${mediatraspuesta[$N]}	>> $fTime
			echo $N2	${medianormal[$N2]}	${mediatraspuesta[$N2]}	>> $fTime
		fi

	done

done