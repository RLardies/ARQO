#! /bin/bash
fDat=time_core_

for (( i=1; i<=8; i++ )); do
	if [[ -e $fDat$i.dat~ ]];then
		rm $fDat$i.dat~
	fi
	for (( j=1; j<=15; j++ )); do
		n=$(head -$j $fDat$i.dat | tail -1 | awk '{print $1}')
		val1=$(head -$j $fDat$i.dat | tail -1 | awk '{print $2}')
		val2=$(head -$j $fDat$i.dat | tail -1 | awk '{print $3}')
		res=$(echo "scale=10; $val2/$val1" | bc)

		echo "$n	$val1	$res" >> $fDat$i.dat~
	done

	echo "`tail -208 $fDat$i.dat `" >> $fDat$i.dat~
done