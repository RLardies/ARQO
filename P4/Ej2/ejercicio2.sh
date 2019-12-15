#! /bin/bash

tamIni=40000000
tamFinal=930000000
paso=44500000
rep=5
fDat=time_core_
fSerie=serie.dat
fPNG=tiempos.png

c=$(cat /proc/cpuinfo | grep siblings | head -1 | awk '{print $3}')

for (( j=1; j<=rep; j++ )); do
	echo "Serie : $j / $rep"
	if [[ -e  $fSerie ]]; then
		rm $fSerie
	fi
	for (( i=tamIni; i<=tamFinal; i+=paso )); do
		if [[ j -eq 1 ]]; then
			mediaSerie[$i]=0
		fi
		echo "   $i / $tamFinal"
		timeSerie=$(../pescalar_serie $i | tail -1 | awk '{print $2}')
		mediaSerie[$i]=$(echo "scale=10; ${mediaSerie[$i]}+($timeSerie/$rep)" | bc)
		if [[ j -eq rep ]]; then
			echo "$i	${mediaSerie[$i]}" >> $fSerie
		fi
	done
done

for (( j=1; j<=c; j++ )); do
	if [[ -e  $fDat$j.dat ]]; then
		rm $fDat$j.dat
	fi
	cont=1
	for (( i=1; i<=rep; i++ )); do
		echo "$j : $i / $rep"
		for (( k=tamIni; k<=tamFinal; k+=paso )); do
			if [[ i -eq 1 ]]; then
				mediaParal[$k]=0
			fi
			echo "   $k / $tamFinal"
			timeParal=$(../pescalar_par2 $k $j | tail -1 | awk '{print $2}')
			mediaParal[$k]=$(echo "scale=10; ${mediaParal[$k]}+($timeParal/$rep)" | bc)

			if [[ i -eq rep ]]; then
				aux=$(head -$cont $fSerie | tail -1 | awk '{print $2}')
				aceleracion=$(echo "scale=10; $aux/${mediaParal[$k]}" | bc)
				echo "$k	${mediaParal[$k]}	$aceleracion" >> $fDat$j.dat
				cont=$(($cont+1))
			fi
		done
	done
done


sh plot.sh
