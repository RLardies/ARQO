#! /bin/bash

rep=10
media1=0
media2=0
media4=0
media6=0
media7=0
media8=0
media9=0
media10=0
media12=0

if [[ -e tiempos_4-5.dat ]]; then
	rm tiempos_4-5.dat
fi

for (( i=0; i<=rep; i++)); do
	time1=$(./pi_par3 1 | grep Tiempo | awk '{print $2}')
	media1=$(echo "scale=10; $media1+($time1/$rep)" | bc)

	time2=$(./pi_par3 2 | grep Tiempo | awk '{print $2}')
	media2=$(echo "scale=10; $media2+($time2/$rep)" | bc)

	time4=$(./pi_par3 4 | grep Tiempo | awk '{print $2}')
	media4=$(echo "scale=10; $media4+($time4/$rep)" | bc)

	time6=$(./pi_par3 6 | grep Tiempo | awk '{print $2}')
	media6=$(echo "scale=10; $media6+($time6/$rep)" | bc)

	time7=$(./pi_par3 7 | grep Tiempo | awk '{print $2}')
	media7=$(echo "scale=10; $media7+($time7/$rep)" | bc)

	time8=$(./pi_par3 8 | grep Tiempo | awk '{print $2}')
	media8=$(echo "scale=10; $media8+($time8/$rep)" | bc)

	time9=$(./pi_par3 9 | grep Tiempo | awk '{print $2}')
	media9=$(echo "scale=10; $media9+($time9/$rep)" | bc)

	time10=$(./pi_par3 10 | grep Tiempo | awk '{print $2}')
	media10=$(echo "scale=10; $media10+($time10/$rep)" | bc)

	time12=$(./pi_par3 12 | grep Tiempo | awk '{print $2}')
	media12=$(echo "scale=10; $media12+($time12/$rep)" | bc)
done

echo -e "1: $media1 \n2: $media2 \n4: $media4 \n6: $media6 \n7: $media7 \n8: $media8 \n9: $media9 \n10: $media10 \n12: $media12" >> tiempos_4-5.dat