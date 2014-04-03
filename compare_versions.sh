#!/bin/bash

#La funcion devuelve 0 si son compatibles, es decir si $version2 (compatible from) es menor o igual que $version1 (running version)



function compare_versions()
{
	y=0
	for x in $(echo $1 | tr "." " ") ; do 
		version_1[$y]=$x
		((y++))
	done
	y=0
	for x in $(echo $2 | tr "." " ") ; do 
		version_2[$y]=$x
		((y++))
	done
	
	#Check which version number is greater
	if [ "${#version_1[@]}" -le "${#version_2[@]}" ]
	then
		loop=${#version_1[@]}	
	else
		loop=${#version_2[@]}
	fi

	index=0
	let loop=loop-1
	while [ $index -le $loop ]
	do
 		if [ "${version_2[$index]}" -lt "${version_1[$index]}" ]; then
			return 1
		fi
		if  [ "${version_2[$index]}" -gt "${version_1[$index]}" ]; then
			return 0 #$2 is greater
		fi
		
		let index=index+1
		
	done
	if [ "${#version_1[@]}" -le "${#version_2[@]}" ]
	then
		return 0
	else
		return 1
	fi
}



version1="1.2" #New version compatible from
version2="1.3.1"  #Old running version 

compare_versions $version1 $version2
if [ $? -eq 0 ]
then
	echo "$version1 smaller/equal than $version2. Therefore compatible"
else
	echo "$version1 greater than $version2.Therefore not compatible"
fi
