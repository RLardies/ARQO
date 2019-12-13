#! /bin/bash
tamIni=515
tamFinal=1539
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
plot "$fDat" using 1:3 with lines lw 2 title "paral", \
"$fDat" using 1:2 with lines lw 2 title "serie"
replot
set title "Aceleración"
set ylabel "Aceleración"
set xlabel "Tamaño de vector"
set key right bottom
set grid
set term png
set output "$fPNG2"
plot "$fDat" using 1:4 with lines lw 2 title "aceleracion"
quit
END_GNUPLOT