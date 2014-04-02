#!/bin/bash

typeset c_files
typeset compiled_c_files
c_files[1]="tip.c"
c_files[2]="tst_upooooooo.c"
c_files[3]="test_upp"
y=0

for x in "${c_files[@]}"; do
	#If the compiled file is not a test, it is saved in compiled_c_file
	name_start=$(echo ${x:0:4})
	echo $name_start
	if [ "$name_start" != "test" ]
	then		
		compiled_c_files[$y]=$x
 		((y++))
	fi
done

echo "Compiled_files"

for x in "${compiled_c_files[@]}"; do
	echo $x
done
