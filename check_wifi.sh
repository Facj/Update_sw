#!/bin/bash


function check_wifi(){
echo "Establishing internet connection..."

for i in 1 2 3 4 5
do
	ping -c 4 www.google.com >/dev/null 2>&1
	if [ "$?" -eq 0 ]
	then
		echo "Internet connection ready"
		return 0	
	else
		echo "....";
        	sudo ifdown wlan0 >/dev/null 2>&1
        	sudo ifup wlan0 >/dev/null 2>&1
	fi
done

echo "Impossible to connect. Check network configuration"
return 1
}

check_wifi
