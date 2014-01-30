#!/bin/bash

cd /home/fatima/Raspi_sw/Tests

#----------------------------------------------------------------------------------------------
#
# This script restores the conditions to start the update system testing.
# It restores v 1.0.0 in the repo folder of the user whose name is received as a parameter and
# deletes every tag in the repository
#
# Parameters: user_name
#
#-----------------------------------------------------------------------------------------------

USER=$1

if [ -z "$USER" ]
 then
    echo "USAGE: bash reset_for_test.sh  User"
else
 
 #Restore v 1.0.0 files in the repo folder of the given user
 cp ../start_files/loop.c ../$USER/Repo1/loop.c
 cp ../start_files/loop_2.c ../$USER/Repo1/loop_2.c

 #Delete all tags
	cd /home/fatima/Raspi_sw/$USER/Repo1
 	for t in `git tag`
	do
		git push origin :$t 
		git tag -d $t
	done
  
fi