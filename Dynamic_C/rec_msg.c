//msgq1.c
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<errno.h>
#include<unistd.h>

#include<sys/msg.h>
#include "dynamic_c.h"
typedef struct{
  char *name;
  int  age;
  char *address;
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
  receive_data(point_data);
  printf("Out from receiving");
  manage_data(point_data);

  data=(container_2 *)point_data;
  
  printf("After update point \nage %i    name %s   address %s   option %d\n",data->age, data->name, data->address, data->option);
   
}

void manage_data(void **data){


  /*This way I can actually recover the data*/
  container *old_data;
  old_data=(container *)data;
  printf("From old version:\nage %f    name %s   address %s   option %d\n",old_data->age,old_data->name, old_data->address, old_data->option);

  container_2 *new_data;
  new_data=(container_2 *) malloc(sizeof(container_2));
  
  new_data->name=old_data->name;
  new_data->address=old_data->address;
  new_data->age=(int)old_data->age;
  new_data->option=old_data->option;

  free(old_data);
  data=(void *)new_data; 

}
