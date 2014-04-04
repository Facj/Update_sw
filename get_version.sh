#!/bin/bash

cd /home/fatima/Raspi_sw/Update_sw/proof_files
y=0
typeset c_files
typeset prid1
typeset prid2
c_files[0]="loop_2"
c_files[1]="loop_v"
for x in "${c_files[@]}"; do
	prid1=( $(pidof $x) )
	ver=$(./$x -v) & #  >/dev/null 2>&1
	#skype --version &
	sleep 0.1
	prid2=( $(pidof $x) )
	echo "Before  ${#prid1[@]} After ${#prid2[@]}" 
	if [ ${#prid1[@]} -lt ${#prid2[@]} ]; then
		#echo "$x running"
		kill ${prid2[0]} 
		current_c_versions[$y]="No"
		#echo "version not provided"
		((y++))
	else
		 #echo "version provided"
   		output=$(./$x -v)
		version=$(echo $output | grep -Po '(version )\d+(?:\.\d+){1}')
		version=$(echo $version | grep -Po '\d+(?:\.\d+){1}')
                dyn=$(echo $output | grep "Dynamically updatable")
		compatible=$(echo $output | grep -Po '(Compatible from )\d+(?:\.\d+){1}')
		compatible=$(echo $compatible | grep -Po '\d+(?:\.\d+){1}')
		echo "Compatible with $compatible"
		echo $output
		if [ -n "$dyn" ] && [ -n "$version" ] 
		then
			current_c_versions[$y]=$version
		else
			current_c_versions[$y]="No"
		fi
		((y++))
			
	fi	
done

for x in "${current_c_versions[@]}"; do
	echo $x
done


