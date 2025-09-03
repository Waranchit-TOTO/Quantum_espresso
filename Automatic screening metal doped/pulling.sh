mapfile -t TM < TM.txt

for i in {0..29};do
        echo $i
	M=$(echo "${TM[i]}" | sed "s/\r//g")
        echo $M
        f=$(grep "Total force" $M-* | tail -n 1)
        echo $f
	n=$(echo $f | grep -oE '[0-9]+([.][0-9]+)?')
        #echo $n

        n=$(echo "$n" | awk '{for(i=1;i<=NF;i++){if($i ~ /^0\.00/){print $i; exit}}}')
	echo $n

        #if [$n -le 0.004]; then
        grep "End final" $M-*
        grep "Final energy" $M-*
        grep "Total force =     0.00" $M-* | tail -n 1
        #else
        #echo "$M not relaxed"
        #fi
        echo #########################
done

