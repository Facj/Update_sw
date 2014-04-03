/**
 * @file Dynamic_c.h is a library that provides tools for a dynamic update of C programs.
 */ 

#ifndef UPDATE_DYNAMIC_C
#define UPDATE_DYNAMIC_C

#include <signal.h>  
#include <stdlib.h>
#include <rpc/xdr.h>
#include <string.h>
#include <unistd.h>
#include "structures.h"
//#include <argrp.h>


char *PROGRAM_NAME="updatable";
update_variables *up_var;
char ser_up_var[100];
char ser_process_var[100];
int up_system_pid;
int update_successful;




/************************************************************************************************/
/**
  @brief Handles update notifications                              
  
  Signal handler for system signal used for update notifications (normally SIGUSR2 but it can be chosen by developer).
  It sets the flag that will be checked by update_point function so the update takes place at a safe moment of the execution.
  So as dynamic updates are available the following line should be included in the source code:
        
  signal(SIGUSR2,update_notification); 

*/


void signal_handler(int sig, siginfo_t *siginfo, void *context)
{
	if(up_system_pid == 0){

		//Signal has been sent by the update sytem to notify an update
		up_var->update_available=1;

	  	//Get the pid of the update system that has just sent a signal
		up_system_pid=(int)siginfo->si_pid;
		printf("New update available\n");
	}
 	
	else {
               //The signal has been sent by the new version process
	       update_successful=1;
		
	}


}



void set_signal_handler(){

	struct sigaction act;
 	memset (&act, '\0', sizeof(act));
 	act.sa_sigaction = &signal_handler;
	/* The SA_SIGINFO flag tells sigaction() to use the sa_sigaction field, not sa_handler. */
	act.sa_flags = SA_SIGINFO;
 	sigaction(SIGUSR2,&act,NULL);
}




void check_update_status(){

  //Build names of serialization files
  sprintf(ser_up_var,"up_%s.ser",PROGRAM_NAME);
  sprintf(ser_process_var,"pr_%s.ser",PROGRAM_NAME);
 
  //Initialization
   up_system_pid=0;  

  printf("PN: %s Up: %s   Process: %s\n",PROGRAM_NAME,ser_up_var,ser_process_var);

  //Deserialization of update_variables.If not available, them initialize all
  up_var=(update_variables *)malloc(sizeof(update_variables));
  FILE *fp;
  XDR xdrs;

  fp=fopen(ser_up_var,"r");
  if(fp==NULL)
    {
      printf("No information from previous version\n"); 
      up_var->update_available=0;   
      up_var->update_in_progress=0;  
      up_var->updated_from=0;

    }
  else
    {
      xdrstdio_create(&xdrs,fp, XDR_DECODE);

      if(!xdr_update_variables(&xdrs,up_var)) 
	{
	  printf("Up_var deserialization error\n"); 
	  up_var->update_available=0;   
	  up_var->update_in_progress=0;  
	  up_var->updated_from=0;    
	}
      else printf("Up_var correctly deserialized\n"); 
      xdr_destroy (&xdrs); //Delete .ser?
      fclose (fp);
    }


 set_signal_handler();  
}


void save_update_status(){


  printf("Up: %s   Process: %s\n",ser_up_var,ser_process_var);

  //Serialization of update_variables.
  FILE *fp;
  XDR xdrs;
  fp=fopen(ser_up_var,"w");
  xdrstdio_create(&xdrs,fp, XDR_ENCODE);
  if(!xdr_update_variables(&xdrs,up_var)) 
    {
      printf("Up_var serialization error\n");     
    }

  else printf("Up_var correctly serialized\n"); 
  xdr_destroy (&xdrs);
  fclose (fp);

}






/*************************************************************************************************/
/**
  @brief Manages data so that it can be modified as necessary for the execution of the new version                              

  The prototype is defined here. However this function should be implemented by the developer.
  The function receives a pointer to the struct containing data of the running  version and returns a pointer to data necessary for the execution of the new version.
  Modifications could include adding/removing/modifying variables or could simply do nothing.

  @param old_data Pointer to the struct containing data of the running version

*/

void *restore_data(void *data);


int save_data(void *data);

/*************************************************************************************************/
/**
  @brief Used as marker of safe update points                              
  
  If the running process is a dynamic update that continues from this point it sets update_in_progress flag to 0.
  If the running process is not a dynamic update, checks if there is a new update available and prepares its execution. 

  @param up_id Identifier of the update point from where the function is called
  @param data Pointer to the struct containing the data of the old version 

  @returns 0 if update in progress, 1 if update available, 2 in any other case. 

*/

void *update_point(int up_id, void **data){

  char exec_new[100];

  if(up_var->update_in_progress) { //check if it's here correctly, in this point 
    up_var->updated_from=0;
    up_var->update_in_progress=0;
    //receive_data(data);
    data=restore_data(data); 
   //if ok then
    kill(up_var->old_version_pid,SIGUSR2); 
    return data;
  }
  else if(up_var->update_available){
    save_data(data);    
    up_var->updated_from=up_id;
    up_var->update_in_progress=1;
    up_var->update_available=0;
    up_var->old_version_pid=getpid();
    update_successful=0;
    save_update_status();
    sprintf(exec_new,"gnome-terminal -x ./%s",PROGRAM_NAME);
    printf("start new version\n");
    system(exec_new);
    sleep(1);
    if(update_successful) return NULL;  //and then process dies or continues. Distinguish!!!
    else return data;  
  }
  else
    return data;  //need another code for that???
}



#endif 
