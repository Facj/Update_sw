#!/bin/sh

source /home/pi/git/func.cfg
source /home/pi/git/update.cfg
#source /home/pi/git/check_wifi.sh
cd /home/pi/git/Repo1
#source /home/fatima/Raspi_sw/func.cfg
usage () {
    echo -e "Automatic software updater for Raspberry Pi that provides secure features by default.\n"
    echo -e "Usage:  bash update.sh [options] \n"
    echo  "Options for disabling features:"
    echo "-c			Disable compilation check"
    echo "-m                    Disable automatic update.If the processes are running they won't be killed"
    echo "-k                    Disable key-authenticity check"
    echo -e "-a                    Disable all checks\n"
    echo "More options:"
    echo "-f <minutes>   [m <minutes>] [h <hours>] [d <days>] "
    echo -e "Change update-check frequency to the value given.It takes minutes by default"
    echo "If the value is 0 automatic update check is disabled"
    echo "-r			Rollback to previous version. what includes??"			
    echo "-h        Help on the usage"
}

#Secure feature enabled by default
#compile=true
#automatic=true
#key_check=true;


#Check parameters
while getopts ":hcmarkf:" option; do
    case "$option" in
	h)  usage
            exit 0 
            ;;
	c)  compile=false
            ;;
	m)  automatic=false
            ;;
        k)  key_check=false
            ;;
        a)  automatic=false
            compile=false
            key_check
	    ;;
        r)  rollback_update
            exit 1
	    ;;
        f)
	    case "$2" in
		[0-9]*)  change_frequency m $2 
                        exit 1;;
		h|d|m) 
		    case "$3" in
			[0-9]*)  change_frequency $2 $3
			    exit 0
			    ;;
			*) echo "Value must be an integer"
			    exit 1;;  
		    esac;;
		
		*)  echo "Use -h for help on the usage"
		    exit 1;;        
		
	    esac
	    ;;
	:)  echo "Error: -$OPTARG requires an argument

" 	    usage
	    exit 1
	    ;;
	?)  echo "Error: unknown option -$OPTARG" 
	    echo "Use -h for help on the usage"
	    exit 1
	    ;;
    esac
done    



#Update process
echo "SOFTWARE UPDATE"
date

bash ../check_wifi.sh
if [ $? -ne 0 ]
then
    exit 1
fi

check_available_update $key_check
if [ $? -ne 0 ]
then
    echo "Not update available"
    #return 1
else
   echo "Available update" $new_v        
   #New commitment
    git merge FETCH_HEAD --no-edit  >/dev/null 2>&1
    if [ $? -ne 0 ]
    then
	echo "git merge failed"
        update_failed $new_v "Merging conflict"  #Only if files are modified in Raspberry Pi?
        #return 1 
    else
	check_updated_files $new_v
	echo ${changed_files[*]}
    fi
    
    #Compilation
    if $compile; then
    	compile_update $new_v
	if [ $? -ne 0 ]; then 
        	echo "Compilation error"
        else
            	#echo ${compiled_files[*]}

                successful_update
            	#Change running version
	    	if $automatic; then
			change_running_version
	    	fi
	    
	fi
    else
      successful_update
    fi
    
       
	
	
    
fi

        
