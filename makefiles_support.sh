#!/bin/bash

cd /home/fatima/Raspi_sw/Update_sw/

#Check if a certain C source file is included in a provided makefile

makefiles=( $(find -name Makefile | sed -e 's/.\///' ) )
typeset used_makefiles
typeset c_files
c_files[0]="updatable.c"
c_files[1]="loop_v.c"
c_files[2]="up_2.c"

y=0
while [ $y -lt ${#makefiles[@]} ]; do
	used_makefiles[$y]=false
	echo $y	
	((y++))
done


t=0
for z in "${c_files[@]}"; do

	y=0
	compiled=false
	for x in "${makefiles[@]}"; do
		echo $x 
		exec=$(grep $z $x)
		if [ $? -eq 0 ];then
			echo "Hay $z"
			if ! "${used_makefiles[$y]}" ; then
				echo "No exec_before"			
				path=$(echo $x | sed -e 's/\/Makefile//')
				#echo $path
				make -C $path >/dev/null 2>&1
				if [ $? -ne 0 ];then 
					echo "Error"
					#return 1
					fi
				used_makefiles[$y]=true
				
			fi
			#If the compiled file is not a test, it is saved in compiled_c_filese
			compiled=true
			name_start=$(echo ${exec:0:4})
			if [ "$name_start" != "test" ]
			then		
				exec=$(echo $exec | grep -Po '(.*)(:)')			
				compiled_c_files[$t]=$(echo $exec | sed 's/://')
				((t++))
			fi
				
		else
				echo "No hay $z"
		fi
		((y++))
	done

	if ! "$compiled"; then
		exec=$(echo $z | awk -F'.' '{print ""$1}')
		echo "compile $exec"
		gcc $z -o $exec  >/dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo $x "compile failed"
			#update_failed $1 "Compilation error"  " in $x" 
			#return 1
		else
			#If the compiled file is not a test, it is saved in compiled_c_files
			name_start=$(echo ${exec:0:4})
			if [ "$name_start" != "test" ]
			then		
				compiled_c_files[$t]=$exec
 				((t++))
			fi
		fi 	
	fi
done	

#If no return before then, gcc compilation	

for x in "${compiled_c_files[@]}"; do
	echo $x
done


