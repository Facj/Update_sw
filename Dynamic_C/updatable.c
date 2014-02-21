#include <stdio.h>
#include "dynamic_c.h"



/**
 * Basic struct for updatable.c
 */
typedef struct{
  char *name;
  float age;
  char *address;
  int option;
}container;


typedef struct{
  char *name;
  int  age;
  char *address;
  int option;
}container_2;


int main(){
 signal(SIGUSR2,update_notification);

 container *data;
 data=(container *) malloc(sizeof(container)); 

 if(updated_from==0){
    
    data->option=1;
 }
 if(updated_from<=1){    //Every if starts with the update_point function
   printf("Now up1\n");
   //update_point(1,&data);
   data->name="Fatima1";
   printf("Before up2\n");
 }
 if(updated_from<=2){
   printf("Up2\n");   
   update_point(2,(void *)data);
   data->address="Tirolintie 2A Oulu";
   printf("Before up3\n");
 }
 if(updated_from<=3){
   printf("Up3\n");   
   update_point(3,(void *)data);
   data->age=12;
   printf("Before up4\n");
 }
 printf("From now:\nage %f    name %s   address %s   option %d\n",data->age, data->name, data->address, data->option);
 sleep(100);
 printf("After update instruction \nage %f    name %s   address %s   option %d\n",data->age, data->name, data->address, data->option);
 if(updated_from<=4){
   printf("Up4\n");
   update_point(4,(void *)data);
   printf("After update point \nage %f    name %s   address %s   option %d\n",data->age, data->name, data->address, data->option);
   
 }
 //free(data);
 return 0; 
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

