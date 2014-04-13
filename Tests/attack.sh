#!/bin/bash

cd /home/fatima/Raspi_sw/Facj/Repo1

#----------------------------------------------------------------------------------------------
#
# This script creates and commits to Github an unsigned update, which should be rejected by
# the Raspberry Pi updater.
#
# Parameters: No parameters
#
#-----------------------------------------------------------------------------------------------

current_version=$(grep -Po 'Version \K[^ ]*' loop_d.c)
last_dot=(${current_version//./ })
sed  -i 's/"Version .*"/"%s SYSTEM IS BEING ATTACKED  \n"/' loop_d.c
git add loop_d.c
git commit -m "Signature attack"
git tag attack_sign -m "Signature attack"
git push origin master
git push --tags
