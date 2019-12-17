#! /bin/bash

fDat=tabla_tiempos_
fAcc=tabla_aceleracion_

if [ -e $fDat$1.dat ]; then
	rm $fDat$1.dat $fAcc$1.dat
fi

timepoSerie=$(./traspuesta_serie $1 | tail -1 | awk '{print $3}')
serie=$(echo "$timepoSerie	$timepoSerie	$timepoSerie	$timepoSerie")
echo $serie >> $fDat$1.dat
echo "1	1	1	1" >> $fAcc$1.dat

for (( i=1; i<=3; i++ )); do
	for (( j=1; j<=4; j++ )); do
		tiempoPar[$j]=$(./traspuesta_par$i $1 $j | tail -1 | awk '{print $3}')
	done
	echo "${tiempoPar[1]}	${tiempoPar[2]}	${tiempoPar[3]}	${tiempoPar[4]}" >> $fDat$1.dat
	
	tserie=$(echo $serie | cut -f1)
	for (( j=1; j<=4; j++ )); do
		acc[$j]=$(echo "scale=10; $tserie/${tiempoPar[$j]}" | bc)
	done
	echo "${acc[1]}	${acc[2]}	${acc[3]}	${acc[4]}" >> $fAcc$1.dat
done