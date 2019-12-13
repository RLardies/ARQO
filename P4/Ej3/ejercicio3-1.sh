#! /bin/bash

fDat=data.dat

if [ -e $fDat ]; then
	rm $fDat
fi

timepoSerie=$(./traspuesta_serie 1000 | tail -1 | awk '{print $3}')
echo "$timepoSerie	$timepoSerie	$timepoSerie	$timepoSerie" >> $fDat

for (( i=1; i<=3; i++ )); do
	for (( j=1; j<=4; j++ )); do
		tiempoPar[$j]=$(./traspuesta_par$i 1000 $j | tail -1 | awk '{print $3}')
	done
	echo "${tiempoPar[1]}	${tiempoPar[3]}	${tiempoPar[3]}	${tiempoPar[4]}" >> $fDat
done