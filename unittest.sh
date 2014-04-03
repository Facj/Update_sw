#!/bin/bash
cd /home/fatima/Raspi_sw/Update_sw/proof_files
function check_and_run_tests()
{

    for x in "${compiled_c_files[@]}"; do
	find "test_$x.c" >/dev/null 2>&1
   
	if [ $? -eq 0 ]; then    #If test available, it is run whether it is required or not
		./test_$x >/dev/null 2>&1
		if [ $? -ne 0 ]
		then 
			echo "Test failed"  " Test $x has been unsuccessful"
			return 1
		else
			echo "Test for $x has been SUCCESS"
		fi
	else
		if $require_test   #Test required but not available
		then
			echo "No test provided"  "Required test for $x is not provided"
			return 1
		fi
	fi
    done
  #The same with Python files

   for x in "${python_files[@]}"; do
        find "test_$x" >/dev/null 2>&1
   
	if [ $? -eq 0 ]; then    #If test available, it is run whether it is required or not
		python test_$x >/dev/null 2>&1
		if [ $? -ne 0 ]
		then 
			echo "Test failed"  " Test $x has been unsuccessful"
			return 1
		else
			echo "Test for $x has been SUCCESS"
		fi
	else
		if $require_test   #Test required but not available
		then
			echo "No test provided"  "Required test for $x is not provided"
			return 1
		fi
	fi
    done
}
require_test=false
typeset compiled_c_files
typeset python_files
compiled_c_files[1]="loop_v"
compiled_c_files[2]="loop_2"
python_files[1]="roman.py"

check_and_run_tests




