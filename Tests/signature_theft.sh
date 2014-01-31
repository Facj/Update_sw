#!/bin/bash
cd /home/fatima/Raspi_sw/Facj2/Repo1

#----------------------------------------------------------------------------------------------
#
# This script creates and commits to Github an unsafe update, where an unser signs the update
# with a gpg signature that doesn't belong to him.
#
# Parameters: No parameters
#
#-----------------------------------------------------------------------------------------------

read -p "Make sure previous update was safe or reset_for_test was run and press key..."
git pull origin master
echo "Modification on loop_3 " >loop_3.c
git add loop_3.c
git commit -m "Loop3 signature theft"
git tag -u 6633D6E2 sign_theft -m "Signature theft"
git push origin master
git push --tags
