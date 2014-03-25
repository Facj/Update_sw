#!/bin/sh

source /home/pi/git/func.cfg
source /home/pi/git/update.cfg
#source /home/pi/git/check_wifi.sh
cd /home/pi/git/Repo1
#source /home/fatima/Raspi_sw/func.cfg
usage () {
	echo -e "Automatic software updater for Raspberry Pi that provides secure and dynamic features by default.\n"
	echo -e "Usage:  bash update.sh [options] \n"
	echo  "Options for disabling features:"
	echo "-c			Disable compilation check."
	echo "-d                      Disable dynamic update.If the processes are running they will not be subsituted."
	echo "-k                      Disable key-authenticity check."
	echo "-t                      Disable unittest check."
	echo -e "-a                      Disable all checks.\n"
	echo "More options:"
	echo "-f <minutes>   [m <minutes>] [h <hours>] [d <days>] "
	echo -e "Change update-check frequency to the value given.It takes minutes by default."
	echo "If the value is 0 automatic update check is disabled."
	echo "-r			  Rollback to previous version."
	echo "-x                        Force dynamic update, even if not supported."
	echo "-s                        Reject the update if not unittest is provided"			
	echo "-h                        Help on the usage"
}

#Secure feature enabled by default
#compile=true
#dynamic=true
#key_check=true;


#Check parameters
while getopts ":hcdtarkxsf:" option; do
    case "$option" in
	h)  usage
            exit 0 
            ;;
	c)  compile=false
            ;;
	d)  dynamic=false
            ;;
        k)  key_check=false
            ;;
 	t)  test=false
            ;;
        a)  dynamic=false
            compile=false
            key_check=false
            test=false
            force=false
            require_test=false
	    ;;
	x)  forced=true
            ;;
	t)  require_test=true
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

#Check if network connection is available and fix it if possible.
bash ../check_wifi.sh
if [ $? -ne 0 ]
then
    exit 1
fi

#Check for updates of the update system and install them if available.
#self_update

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
    fi
    
    #Compilation
    if $compile; then
	check_updated_files $new_v #Not necessary if you are not going to compile
	echo ${changed_files[*]}
    	compile_update $new_v

	if [ $? -ne 0 ]; then 
        	echo "Compilation error"
        else
		if $test;then
			check_for_tests
			if [ $? -ne 0 ]; then 
				echo "Tests not available."
				if $require_test; then
					echo "Test required and not available. Send issue."
                        	        exit 1
				fi
			else
	        		echo "Tests available"		
		        	run_tests
				if [ $? -ne 0 ]; then
					echo "Test failed. Issue sent"
				        exit 1
				fi
			fi
		fi
	fi 
                   
        successful_update
        #Change running version
	if $dynamic; then
	 	change_running_version
	fi
	    
    else
      successful_update
    fi
    
       
    
fi

        
