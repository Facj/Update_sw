#include <stdio.h>
#include <time.h>

int main(int argc, char **argv)
{
   time_t rawtime;
   struct tm *timeinfo;
   FILE *fp;
   
	char c;
	while ((c = getopt (argc, argv, "v")) != -1)
         switch (c)
           {
           case 'v':
		printf("Loop2 updated version 2.0\nDynamically updatable. Compatible from 1.4\n");
             return;
          
           default:
             return;
           }



   while(1)
  {
    sleep(5);
   time (&rawtime);
   timeinfo = localtime (&rawtime);
   fp=fopen("version_record_2.txt","a");
   +fprintf(fp,"Version 2.0 %s", asctime(timeinfo));
   fclose(fp);
   }
 
  return 0;
}
