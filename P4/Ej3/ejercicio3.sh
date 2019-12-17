#! /bin/bash
P=3
tamIni=$((512*$P))
tamFinal=$((2048+512*$P))
paso=64
rep=5
fDat=tiempos.dat
fPNG=tiempos.png
fPNG2=aceleracion.png

for(( j=1; j<=rep; j++));do
	echo "$j / $rep"
	for (( i=tamIni; i<=tamFinal; i+=paso )); do

		if [[ j -eq 1 ]]; then
			mediaSerie[$i]=0
			mediaParal[$i]=0
		fi

		timeSerie=$(./traspuesta_serie $i | tail -1 | awk '{print $3}')
		mediaSerie[$i]=$(echo "scale=10; ${mediaSerie[$i]}+($timeSerie/$rep)" | bc)

		timeParal=$(./traspuesta_par3 $i 4 | tail -1 | awk '{print $3}')
		mediaParal[$i]=$(echo "scale=10; ${mediaParal[$i]}+($timeParal/$rep)" | bc)

		if [[ j -eq rep ]]; then
			aceleracion=$(echo "scale=10; ${mediaSerie[$i]}/${mediaParal[$i]}" | bc)
			echo "$i	${mediaSerie[$i]}	${mediaParal[$i]}	$aceleracion" >> $fDat
		fi
	done
done

bash plot.sh