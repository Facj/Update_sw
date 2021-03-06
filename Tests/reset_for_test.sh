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
 cp ../start_files/loop_d.c /home/fatima/Raspi_sw/$USER1/Repo1/loop_d.c
 cp ../start_files/loop_d_2.c /home/fatima/Raspi_sw/$USER1/Repo1/loop_d_2.c
 cp ../start_files/Makefile /home/fatima/Raspi_sw/$USER1/Repo1/Makefile
 cp ../start_files/dynamic_c.h /home/fatima/Raspi_sw/$USER1/Repo1/dynamic_c.h



 cd /home/fatima/Raspi_sw/$USER1/Repo1
 rm loop_3.c
 touch loop_3.c
 rm new_doc.txt
 touch new_doc.txt 
 git add loop.c loop_2.c loop_3.c new_doc.txt
 git commit -m "Restart" >/dev/null 2>&1
 git push origin master >/dev/null 2>&1
  if [ $? -ne 0 ]
    then
	#echo "User2 will push"
        push=false
    else
	#echo "Pushed"
        push=true
    fi



 #Delete all tags
	
 	for t in `git tag`
	do
		git push origin :$t  >/dev/null 2>&1
		git tag -d $t  >/dev/null 2>&1
	done
        
	cd /home/fatima/Raspi_sw/$USER2/Repo1 

 	for t in `git tag`
	do
		git push origin :$t  >/dev/null 2>&1
		git tag -d $t  >/dev/null 2>&1
	done

 #Apply same changes to USER2

cd /home/fatima/Raspi_sw/Update_sw/Tests
cp ../start_files/loop.c /home/fatima/Raspi_sw/$USER2/Repo1/loop.c
cp ../start_files/loop_2.c /home/fatima/Raspi_sw/$USER2/Repo1/loop_2.c
cp ../start_files/loop_d.c /home/fatima/Raspi_sw/$USER2/Repo1/loop_d.c
cp ../start_files/loop_d_2.c /home/fatima/Raspi_sw/$USER2/Repo1/loop_d_2.c
cp ../start_files/Makefile /home/fatima/Raspi_sw/$USER2/Repo1/Makefile
cp ../start_files/dynamic_c.h /home/fatima/Raspi_sw/$USER2/Repo1/dynamic_c.h

if $push; then
	cd /home/fatima/Raspi_sw/$USER2/Repo1
	git fetch origin master >/dev/null 2>&1
        git merge FETCH_HEAD --no-edit  >/dev/null 2>&1
else
	cd /home/fatima/Raspi_sw/$USER2/Repo1 
	rm loop_3.c
	touch loop_3.c 
	git add loop.c loop_2.c loop_3.c loop_d.c loop_d_2.c Makefile dynamic_c.h 
	git commit -m "Restart"  >/dev/null 2>&1
	git push origin master >/dev/null 2>&1

	cd /home/fatima/Raspi_sw/$USER1/Repo1
	git fetch origin master >/dev/null 2>&1
        git merge FETCH_HEAD --no-edit  >/dev/null 2>&1

fi

#Check if the reset has finished correctly
cd /home/fatima/Raspi_sw
diff -rq --exclude '.git' Facj/Repo1 Facj2/Repo1 #>/dev/null 2>&1
if [ $? -ne 0 ]
    then
	echo "Error while reseting."
        
    else
	echo "Reset performed correctly."
fi  



	 

