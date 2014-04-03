#include <stdio.h>
#include "structures.c"
#include "dynamic_c.h"


int main(){

	
	 check_update_status();

	 container *data;
	 data=(container *) malloc(sizeof(container)); 
 
	 if(up_var->updated_from==0){
   
	   data->option=1;
	 }
	 if(up_var->updated_from<=1){    //Every if starts with the update_point function
	   printf("Now up1\n");
	   update_point(1,(void *)data);
	   data->name="Fatima1";
	   printf("Before up2\n");
	 }
	 if(up_var->updated_from<=2){
	   printf("Up2\n");   
	   update_point(2,(void *)data);
	   data->address="Tirolintie 2A Oulu";
	   printf("Before up3\n");
	 }
	 if(up_var->updated_from<=3){
	   printf("Up3\n");   
	   update_point(3,(void *)data);
	   data->age=12;
	   printf("Before up4\n");
	 }
	 printf("From now:\nage %f    name %s   address %s   option %d\n",data->age, data->name, data->address, data->option);
	 //save_data((void *)data);
	 // restore_data((void *)data);
	 sleep(20);
	 printf("After update instruction \nage %f    name %s   address %s   option %d\n",data->age, data->name, data->address, data->option);
	 if(up_var->updated_from<=4){
	   printf("Up4\n");
	   data=update_point(4,(void *)data);
   	//data=(container *)data;   
   	if(data==NULL) return 0;
   	else printf("After update point \nage %f    name %s   address %s   option %d\n",data->age, data->name, data->address, data->option);
   	sleep(20);
 	}
 //free(data);
 return 0; 
}


int save_data(void *data){
  
  container *old_data;
  old_data=(container *)data;
  printf("Before serialization: %s\n",old_data->name);
  XDR xdrs;
  //Serialization
  FILE *fp;
  fp=fopen(ser_process_var,"w");
  xdrstdio_create(&xdrs,fp, XDR_ENCODE);
  if(!xdr_container(&xdrs,old_data)) {printf("Serialization error\n"); return 1;}
  else printf("Data saved\n"); 
  xdr_destroy (&xdrs);
  fclose (fp);
  return 0;
}


void *restore_data(void *data){


//Deserialization

  /*This way I can actually recover the data in the same process*/
  container *old_data;
  old_data=(container *) malloc(sizeof(container));
  FILE *fp;
  XDR xdrs;
  fp=fopen(ser_process_var,"r");
  xdrstdio_create(&xdrs,fp, XDR_DECODE); 
  if(!xdr_container(&xdrs,old_data)) printf("Deserialization error\n"); 
  else printf("Data restored\n"); 

  xdr_destroy (&xdrs);
  fclose (fp);
  printf("From old version:\nage %f    name %s   address %s   option %d\n",old_data->age,old_data->name, old_data->address, old_data->option);
  
  container_2 *new_data;
  new_data=(container_2 *) malloc(sizeof(container_2));
  
  new_data->name=old_data->name;
  new_data->address=old_data->address;
  new_data->age=(int)old_data->age;
  new_data->option=old_data->option;

  free(old_data);
  return (void *)new_data; 

}

