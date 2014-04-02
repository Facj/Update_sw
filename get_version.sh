#!/bin/bash

cd /home/fatima/Raspi_sw/Update_sw/proof_files
y=0
typeset c_files
c_files[0]="loop_2"
c_files[1]="loop_v"
for x in "${c_files[@]}"; do
	ver=$(./$x -v) & #  >/dev/null 2>&1
	#skype --version &
	sleep 0.1
	prid=$(pidof $x)
	case "$prid" in
		[0-9]*) #echo "$x running"
			kill $prid >/dev/null 2>&1
			current_c_versions[$y]="No"
			#echo "version not provided"
			((y++));;
		*) #echo "version provided"
	   		output=$(./$x -v)
			version=$(echo $output | awk -F' ' '/version/{print $3}')
                        dyn=$(echo $output | grep "Dynamically updatable")
			if [ -n "$dyn" ] && [ -n "$version" ] 
			then
				current_c_versions[$y]=$version
			else
				current_c_versions[$y]="No"
			fi
			((y++))
			;;
	esac
	
done

for x in "${current_c_versions[@]}"; do
	echo $x
done
