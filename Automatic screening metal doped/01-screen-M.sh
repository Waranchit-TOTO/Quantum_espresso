#!/bin/bash

#for i in $(awk '{print $3}' TS-screen.txt); do

mapfile -t Mpp < Mpp.txt
mapfile -t M < M.txt

for i in {0..5}; do
	#echo ${M[i]}
	#echo ${Mpp[i]}
	
	Mpp=$(echo "${Mpp[i]}" | sed "s/\r//g")
	M=$(echo "${M[i]}" | sed "s/\r//g")
	
	echo $Mpp
	echo $M

	bash make-screen-TS-Metal.sh "$M" "$Mpp" > $M-SnO2.in
	
	cp ./qe_run.sh ./loop.sh

	sed -i "s/screen/$M/g" ./loop.sh

	sbatch loop.sh $M-SnO2

	echo $M-done
done
