#!/bin/bash

mapfile -t TMpp < TMpp.txt
mapfile -t TM < TM.txt
#echo $TMpp
#echo $TM

for i in {0..29}; do
	Mpp=$(echo "${TMpp[i]}" | sed "s/\r//g")
	M=$(echo "${TM[i]}" | sed "s/\r//g")
	cp ./vasp-to-QE.py ./tmp-vasp-QE.py

	echo $Mpp
	echo $M
	sed -i "s/M/$M/g" ./tmp-vasp-QE.py
	sed -i "s/Tpp/$Mpp/g" ./tmp-vasp-QE.py
	sed -i "s/vaspname/$M.vasp/g" ./tmp-vasp-QE.py
	sed -i "s/QEname/$M-metal-relax/g" ./tmp-vasp-QE.py
	python tmp-vasp-QE.py
	cp ./qe_run.sh ./loop.sh

	sed -i "s/screen/$M/g" ./loop.sh

	sbatch loop.sh $M-metal-relax

	echo $M-done
done	
