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

        #Create text file and write on it
        echo "Text file including nothing" >>new_doc.txt
             
	git add new_doc.txt
	git commit -m "Doc not to be compiled"
	git tag -s v.not_compiled -m "nothing to be compiled"


	#Push changes to the repository
	git push origin master
	git push --tags
