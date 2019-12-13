#! /bin/bash

tamIni=40000000
tamFinal=930000000
paso=1000
rep=5
fDat=time_core_
fSerie=serie.dat

c=$(cat /proc/cpuinfo | grep siblings | head -1 | awk '{print $3}')

for (( j=1; j<=rep; j++ )); do
	echo "Serie : $j / $rep"
	if [[ -e  $fSerie ]]; then
		rm $fSerie
	fi
	for (( i=tamIni; i<=tamFinal; i+=paso )); do
		if [[ j -eq 1 ]]; then
			mediaSerie=0
		fi
		timeSerie=$(../pescalar_serie $i | tail -1 | awk '{print $2}')
		mediaSerie=$(echo "scale=10; $mediaSerie+($timeSerie/$rep)" | bc)
		if [[ i -eq rep ]]; then
			echo "$k	$mediaSerie" >> $fSerie
		fi
	done
done

for (( j=1; j<=c; j++ )); do
	if [[ -e  $fDat$j.dat ]]; then
		rm $fDat$j.dat
	fi
	for (( i=1; i<=rep; i++ )); do
		echo "$j : $i / $rep"
		for (( k=tamIni; k<=tamFinal; k+=paso )); do
			if [[ i -eq 0 ]]; then
				mediaParal[j][k]=0
			fi
			timeParal=$(../pescalar_par2 $k | tail -1 | awk '{print $2}')
			mediaParal[j][k]=$(echo "scale=10; ${mediaParal[j][k]}+($timeParal/$rep)" | bc)

			if [[ i -eq rep ]]; then
				echo "$k	${mediaParal[j][k]}" >> $fDat$j.dat
			fi
		done
	done
done

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
plot for [i=1:$c] "$fDat$".i.".dat" using 1:2 with lines lw 2 title i." hilos" \
"$fSerie" using 1:2 with lines lw 2 title "serie"
quit
END_GNUPLOT
