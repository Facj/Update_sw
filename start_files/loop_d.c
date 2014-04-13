#include <stdio.h>
#include "structures.c"
#include "dynamic_c.h"
#include <time.h>

int main(int argc, char *argv[]){

	char c;
	time_t rawtime;
	struct tm *timeinfo;
	FILE *fp;
	c = getopt (argc, argv, "v");
         switch (c)
           {
           case 'v':
		printf("Updatable version 4.0 extended\nDynamically updatable. Compatible from 1.2\n");
             return 0;
         
           }	
       
 	 sprintf(PROGRAM_NAME,"loop_d");
         
	 check_update_status();
        

	 container *data;
	 data=(container *) malloc(sizeof(container)); 
 
	 if(up_var->updated_from==0){
   
	   data->num_executions=0;
           if(argc>1) data->name=argv[1];
	    else data->name="user";
	 }
	 if(up_var->updated_from<=1){    //Every if starts with the update_point function
	   update_point(1,(void *)data);
	 }
	
	while(1)
	  {
		sleep(5);
		data->num_executions++;
		data=update_point(3,(void *)data);
		if(data==NULL) { return 0;}
	   	time (&rawtime);
	   	timeinfo = localtime (&rawtime);
	   	fp=fopen("version_record.txt","a");
	   	fprintf(fp,"Version 4.0 .Executed on %s's device %f times on %s ",data->name,data->num_executions,asctime(timeinfo));
	   	fclose(fp);
	   }


 //free(data);
 return 0; 
}


int save_data(void *data){
  
  container *old_data;
  old_data=(container *)data;
  //printf("Before serialization: %s\n",old_data->name);
  XDR xdrs;
  //Serialization
  FILE *fp;
  fp=fopen(ser_process_var,"w");
  xdrstdio_create(&xdrs,fp, XDR_ENCODE);
  if(!xdr_container(&xdrs,old_data)) {printf("Serialization error\n"); return 1;}
  //else printf("Data saved\n"); 
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
  if(!xdr_container(&xdrs,old_data)) printf("Deserialization error\n"); //Do sth!!! 
  //else printf("Data restored\n"); 

  xdr_destroy (&xdrs);
  fclose (fp);
//  printf("From old version:\nage %f    name %s   address %s   option %d\n",old_data->age,old_data->name, old_data->address, old_data->option);
  
  container *new_data;
  new_data=(container *) malloc(sizeof(container));
  
  new_data->name=old_data->name;
  new_data->num_executions=old_data->num_executions;
//  printf("Restored :\nage %d    name %s   address %s   option %d\n",new_data->age,new_data->name, new_data->address, new_data->option);
  
  free(old_data);
  return (void *)new_data;

}

