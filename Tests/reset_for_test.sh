#!/bin/bash

cd /home/fatima/Raspi_sw/Update_sw/Tests

#----------------------------------------------------------------------------------------------
#
# This script restores the conditions to start the update system testing.
# It restores v 1.0.0 in the repo folder of the both users whose name is received as a parameter and
# deletes every tag in the repository
#
# Parameters: No parameters
#
#-----------------------------------------------------------------------------------------------

USER1=Facj
USER2=Facj2

 #Change to repo folder and commit the changes
 #cd /home/fatima/Raspi_sw/$USER1/Repo1

 #Restore v 1.0.0 files in the repo folder of the first user
 cd /home/fatima/Raspi_sw/Update_sw/Tests
 cp ../start_files/loop.c /home/fatima/Raspi_sw/$USER1/Repo1/loop.c
 cp ../start_files/loop_2.c /home/fatima/Raspi_sw/$USER1/Repo1/loop_2.c

  cd /home/fatima/Raspi_sw/$USER1/Repo1 
 git add loop.c loop_2.c
 git commit -m "Restart"
 git push origin master

 #Delete all tags
	
 	for t in `git tag`
	do
		git push origin :$t 
		git tag -d $t
	done
        

 #Apply same changes to USER2

 cd /home/fatima/Raspi_sw/$USER2/Repo1
 git pull origin master #--no-edit  #>/dev/null 2>&1


