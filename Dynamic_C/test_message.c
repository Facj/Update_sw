//msgq1.c
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<errno.h>
#include<unistd.h>

#include<sys/msg.h>
#include <sys/shm.h>
#include "dynamic_c.h"

typedef struct{
  char name[35];
  float  age;
  char address[100];
  int option;
}container;


int main()
{
  container *data;
  data=(container *) malloc(sizeof(container)); 
  sprintf(data->name,"Fatima");
  data->age=12;
  sprintf(data->address,"Oulu");
  data->option=1;

  //send_data((void*)data);
 
  //Create shared memory
  key_t ShmKEY=1234; //(key_t)"test_name"; //here program name
  int ShmID, i;
  container *ShmPTR;
  ShmID = shmget(ShmKEY, sizeof(container),IPC_CREAT | 0666);
  ShmPTR = (container *) shmat(ShmID, NULL, 0);
  printf("%d\n",ShmID);
  *ShmPTR=*data;
  //ShmPTR->age=data->age;
  //ShmPTR->address=data->address;
  //ShmPTR->option=data->option;
  printf("BEFORE \nage %f   name %s   address %s   option %d\n",ShmPTR->age,ShmPTR->name,ShmPTR->address,ShmPTR->option);



  // sleep(30);

}

void manage_data(void **data){


  /*This way I can actually recover the data*/
  /*container *old_data;
  old_data=(container *)data;
  printf("From old version:\nage %f    name %s   address %s   option %d\n",old_data->age,old_data->name, old_data->address, old_data->option);

  container_2 *new_data;
  new_data=(container_2 *) malloc(sizeof(container_2));
  
  new_data->name=old_data->name;
  new_data->address=old_data->address;
  new_data->age=(int)old_data->age;
  new_data->option=old_data->option;

  free(old_data);
  data=(void *)new_data;*/ 

}
