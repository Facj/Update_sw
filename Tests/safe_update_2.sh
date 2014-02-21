#!/bin/bash
cd /home/fatima/Raspi_sw/Facj/Repo1

#----------------------------------------------------------------------------------------------
#
# This script creates and commits to Github a safe update, changing its version number.
# It must be made sure that previous commit was safe or that reset_for_test was run before
#
# Parameters: No parameters
#
#-----------------------------------------------------------------------------------------------

read -p "Make sure you have run reset_for_test and press key..."

        
       #Update loop_2.c
        grep -Po 'Version \K[^ ]*' loop_2.c >/dev/null 2>&1
	current_version=$(grep -Po 'Version \K[^ ]*' loop_2.c)
        #echo $current_version
	last_dot=(${current_version//./ })
	sed -i 's/'$current_version'*./'${last_dot[0]}'.'${last_dot[1]}'.'$((last_dot[2]+1))' /' loop_2.c       
 


	#Update loop.c
	grep -Po 'Version \K[^ ]*' loop.c >/dev/null 2>&1
	current_version=$(grep -Po 'Version \K[^ ]*' loop.c)
        #echo $current_version
	last_dot=(${current_version//./ })
	sed -i 's/'$current_version'*./'${last_dot[0]}'.'${last_dot[1]}'.'$((last_dot[2]+1))' /' loop.c
        
	
	git add loop.c loop_2.c
	git commit -m "v.${last_dot[0]}.${last_dot[1]}.$((last_dot[2]+1))"
	git tag -s v.${last_dot[0]}.${last_dot[1]}.$((last_dot[2]+1)) -m "v.${last_dot[0]}.${last_dot[1]}.$((last_dot[2]+1))"


	#Push changes to the repository
	git push origin master
	git push --tags
