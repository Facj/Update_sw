#!bin/bash

cd /home/fatima/Raspi_sw/Update_sw/Dynamic_C

trap dynamically_updated SIGUSR2

function dynamically_updated()
{
	((updated_processes ++))

}

function change_running_version()
{
    signaled_processes=0
    updated_processes=0
    index=0
    temp=0
    for x in "${compiled_c_files[@]}"; do
	exec=$x
    	prid=$(pidof $x)
	 case "$prid" in
             [0-9]*) echo "$x running index $index"
	        	dynamic_update_supported $index #check if dynamic updates are supported by both old and new version
	                 if [ $? -eq 0 ]
		          then
				kill -s SIGUSR2 $prid
	                        ((signaled_processes++))
				temp=$(date --date="+60 second" +%s)
			else
				echo "Dynamic update not supported" 
				if $forced; then
				kill $prid
				echo "Forcd $exec update"
			 	./$exec & 
				
			        fi
			fi
			;;
	             *) echo "$x not running";;
		 esac
	((index++))	
	done

now=$(date +%s)
echo "Waiting for updated processes..."
while [ "$now" -lt "$temp" ] && [ $updated_processes -lt $signaled_processes ]; do
	now=$(date +%s)	
	
done

if [ $updated_processes -lt $signaled_processes ]; then
	echo "update_failed" $1 "Dynamic update failure"
	return 1
else
	echo "Dynamic update successful"
	return 0
fi

}

#-----------------------------------------------------------------------------------------------------------
#
# This function cheks if a running process support dynamic updates. Both the old and the new must support them
# and must be compatible for data conversion
#
# Parameters: exec_file_index
#
#------------------------------------------------------------------------------------------------------------
function dynamic_update_supported()
{
       exec=${compiled_c_files[$1]}
	echo $exec
        echo "Get version of $exec"
	#Check if current version supports dynamic updates
        echo "Running version ${current_c_versions[$1]}"
	if [ "${current_c_versions[$1]}" == "No" ]
	then
		return 1 
	else
		prid1=( $(pidof $exec) )
		ver=$(./$exec -v) &
		sleep 0.1
		prid2=( $(pidof $exec) )
		if [ ${#prid1[@]} -lt ${#prid2[@]} ]; then
			#echo "$x running"
			kill ${prid2[0]} 
			current_c_versions[$y]="No"
			#echo "version not provided"
			((y++))
		else
			output=$(./$x -v)
			version=$(echo $output | grep -Po '(version )\d+(?:\.\d+){1}')
			version=$(echo $version | grep -Po '\d+(?:\.\d+){1}')
                        dyn=$(echo $output | grep "Dynamically updatable")
			compatible=$(echo $output | grep -Po '(Compatible from )\d+(?:\.\d+){1}')
			compatible=$(echo $compatible | grep -Po '\d+(?:\.\d+){1}')
			echo "version $version compatible from $compatible"	
			if [ -n "$compatible" ] && [ -n "$dyn" ] && [ -n "$version" ]
			then
				compare_versions $compatible ${current_c_versions[$1]}
				return $?
			else
				return 1

			fi


			
		fi	
	fi       

}

#-----------------------------------------------------------------------------------------------------------
#
# This function compares to version numbers to find out if they are compatible for data conversion.
# If compatible, it returns 0. If not, it returns 1.
#
# Parameters: $version_from_which_new_compatibility_starts $running_version
#
#------------------------------------------------------------------------------------------------------------

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

typeset compiled_c_files
typeset current_c_versions
compiled_c_files[0]="updatable"
compiled_c_files[1]="up_2"
current_c_versions[0]="4.8"
current_c_versions[1]="1.9"
forced=false
change_running_version


