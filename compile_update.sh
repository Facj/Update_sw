#!/bin/bashn

source /home/fatima/Repo1/func.cfg


function compile_update()
{
               
    #Check if updated files are C source files
    for x in "${changed_files[@]}"; do
        arr=$(echo $x | awk -F'.' '{print ""$2}') 
        if [ "$arr" == "c" ]
        then
            exec=$(echo $x | awk -F'.' '{print ""$1}')
	    gcc $x -o $exec  >/dev/null 2>&1
	    echo "Compile $x"
	    if [ $? -ne 0 ]
	    then
		echo "loop compile failed"
		update_failed $1 "Compilation error"  "in $x"
		return 1
	    fi
	    
	fi 
    done
    return 0
    
}

export typeset changed_files
echo "check files"
check_changed_files 5df7083f74c5ae08cfe692240a1cb5a702eec486
echo ${changed_files[*]}

compile_update c66d00c82270066d14e0d0697fafe2ef3bf37cb3
if [ $? -ne 0 ]
     then
        echo "Update compile failed"
      else 
        echo "Update compile correct"

fi

