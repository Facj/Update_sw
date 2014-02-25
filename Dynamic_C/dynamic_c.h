/**
 * @file Dynamic_c.h is a library that provides tools for a dynamic update of C programs
 */

#ifndef UPDATE_DYNAMIC_C
#define UPDATE_DYNAMIC_C

#include <signal.h>  
#include <stdlib.h>
#include<sys/msg.h>

int update_available=0;   /**< Flag that indicates if an update notification has been received */
int update_in_process=0;  /**< Flag that indicates if the running process is a dynamic update */
int updated_from=0;       /**< Identifier of the update point where the previous version stopped its execution */


char *PROGRAM_NAME="up2";


//No necessary, we can directly access to updated_from
//int  new_version





typedef struct
{
  void *data;
}message;


void receive_data(void **data){

  int msgid;
  //Get access to the queue
  
  msgid = msgget( (key_t)PROGRAM_NAME,0666 | IPC_CREAT);
  if (msgid == -1)
    {
      printf("failed to get:\n");
      return;
    }
      
  
  //Read message
  if(msgrcv(msgid,data,sizeof(data),0,IPC_NOWAIT)  == -1)
    
    {
      printf("failedto receive: \n");
      return;
    }
  
  
  //Delete queue
  if (msgctl(msgid, IPC_RMID, 0) == -1)
    {
      printf("failed to delete\n");
      return;
    }
  //Free memory containing message
  printf("Data received");
}


void send_data(void **data){
  






/*int msgid;
  //Create queue
  msgid = msgget( (key_t)PROGRAM_NAME,0666 | IPC_CREAT);
  if (msgid == -1)
    {
      fprintf(stderr, "failed to create:\n");
      return;
    }

  //Create message to send the pointer to the struct containing data about running version  
  //message *msg;
  //  data=(message *) malloc(sizeof(msg));
  //message->data=data; 
  
  //Send message
 
  if(msgsnd(msgid,data,sizeof(data), 0) == -1)
	{
	  fprintf(stderr, "msgsnd failed\n");
	  return;
	}
  printf("Data sent");*/
}

/*************************************************************************************************/
/**
  @brief Manages data so that it can be modified as necessary for the execution of the new version                              

  The prototype is defined here. However this function should be implemented by the developer.
  The function receives a pointer to the struct containing data of the running  version and returns a pointer to data necessary for the execution of the new version.
  Modifications could include adding/removing/modifying variables or could simply do nothing.

  @param old_data Pointer to the struct containing data of the running version

*/

void manage_data(void **data);


/*************************************************************************************************/
/**
  @brief Used as marker of safe update points                              
  
  If the running process is a dynamic update that continues from this point it sets update_in_process flag to 0.
  If the running process is not a dynamic update, checks if there is a new update available and prepares its execution. 

  @param up_id Identifier of the update point from where the function is called
  @param data Pointer to the struct containing the data of the old version 

  @returns 0 if update in progress, 1 if update available, 2 in any other case. 

*/

int update_point(int up_id, void **data){

  if(update_in_process) { //check if it's here correctly
    updated_from=0;
    update_in_process=0;
    receive_data(data);
    manage_data(data);  
    //take_data(); //?? 
    return 0;
  }
  else if(update_available){
    //manage_data(data);    //data is returned modified so it can be sent to the new version process
    send_data(data);
    receive_data(data);
    manage_data(data);    
    updated_from=up_id;
    update_in_process=1;
    update_available=0;
    //system("./up2 &");
    //start_new_version();
    //wait();
    return 1;  //and then process dies
  }
  else
    return 2;
}



/************************************************************************************************/
/**
  @brief Handles update notifications                              
  
  Signal handler for system signal used for update notifications (normally SIGUSR2 but it can be chosen by developer).
  It sets the flag that will be checked by update_point function so the update takes place at a safe moment of the execution.
  So as dynamic updates are available the following line should be included in the source code:
        
  signal(SIGUSR2,update_notification); 

*/


void update_notification(){
  update_available=1;
  printf("New update available\n");
}




#endif 
