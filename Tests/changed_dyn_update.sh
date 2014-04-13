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

        #Update loop_d.c with loop_d_2.c
	grep -Po 'Version \K[^ ]*' loop_d.c >/dev/null 2>&1
	current_version=$(grep -Po 'Version \K[^ ]*' loop_d.c)
        #echo $current_version
	last_dot=(${current_version//./ })
	cp ../../Update_sw/start_files/changed/loop_d.c loop_d.c ###########################
	sed -i 's/'$current_version'*./'${last_dot[0]}'.'$((last_dot[1]+1))' /' loop_d.c
        
	#Update loop_d_2.c
        grep -Po 'Version \K[^ ]*' loop_d_2.c >/dev/null 2>&1
	current_version=$(grep -Po 'Version \K[^ ]*' loop_d_2.c)
        echo $current_version
	last_dot=(${current_version//./ })
	sed -i 's/'$current_version'*./'${last_dot[0]}'.'$((last_dot[1]+1))' /' loop_d_2.c       
 

	git add loop_d.c Makefile structures.x dynamic_c.h test_loop_d.c loop_d_2.c test_loop_d_2.c
	git commit -m "v.${last_dot[0]}.$((last_dot[1]+1))"
	git tag -s v.${last_dot[0]}.$((last_dot[1]+1)) -m "v.${last_dot[0]}.$((last_dot[1]+1))"


	#Push changes to the repository
	git push origin master
	git push --tags
