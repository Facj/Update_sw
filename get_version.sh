#!/bin/bash

#exec="./start_files/loop"
exec="skype"
#./loop --version
$exec --version &
prid=$(pidof $exec)
case "$prid" in
	[0-9]*) #echo "$x running"
		kill $prid
		echo "version not provided";;
	*) echo "version provided"
	   version=$($exec --version) 
		;;
esac
echo $version
#      if [ $? -ne 0 ]
#	    then
#		current_c_versions[$y]=$x
 #            	((y++))

#		return 1
