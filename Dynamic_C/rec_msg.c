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
  char name[35];   //never pointers!!
  int  age;
  char address[100];
  int option;
}container_2;

typedef struct{
  char *name;
  float  age;
  char *address;
  int option;
}container;




int main()
{
  void *point_data;
  container_2 *data;
  container *old_data;
  old_data=(container *)malloc(sizeof(container));  
//receive_data(point_data);
    
  key_t ShmKEY=1234; //(key_t)"test_name";
  int ShmID;
  container *ShmPTR;
  ShmID = shmget(ShmKEY, sizeof(container), 0666);
  if(ShmID==-1) { printf("Error in shared memory access\n"); return;}
  printf("%d\n",ShmID);
  ShmPTR = (container *) shmat(ShmID, NULL, 0);
  if(ShmPTR==(void *)-1) { printf("Error in shared memory access(2)\n"); return;}
 printf("Just received \nage %f   name %s   address %s   option %d\n",ShmPTR->age,ShmPTR->name,ShmPTR->address,ShmPTR->option);
  *old_data=*ShmPTR;
  //old_data->age=ShmPTR->age;
  //old_data->option=ShmPTR->option;
  //old_data->address=ShmPTR->address;
  printf("After update point \nage %f   name %s   address %s   option %d\n",old_data->age,old_data->name,old_data->address,old_data->option);
  //Destroy shared memory
  shmdt((void *) ShmPTR);
  shmctl(ShmID, IPC_RMID, NULL);
  
  printf("Out from receiving");
  //manage_data(point_data);
  
  data=(container_2 *)point_data;
  
  //printf("After update point \nage %f   name %s   address %s   option %d\n",old_data->age,old_data->name,old_data->address,old_data->option);
   
}

void manage_data(void **data){


  /*This way I can actually recover the data*/
  container *old_data;
  old_data=(container *)data;
  printf("From old version:\nage %f    name %s   address %s   option %d\n",old_data->age,old_data->name, old_data->address, old_data->option);

  container_2 *new_data;
  new_data=(container_2 *) malloc(sizeof(container_2));
  
  /*new_data->name=old_data->name;
  new_data->address=old_data->address;
  new_data->age=(int)old_data->age;
  new_data->option=old_data->option;
  */
  free(old_data);
  ;  data=(void *)new_data; 

}
