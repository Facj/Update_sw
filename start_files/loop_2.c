#include <stdio.h>
#include <time.h>

int main()
{
    time_t rawtime;
   struct tm *timeinfo;
   FILE *fp;
   
   while(1)
  {
    sleep(5);
   time (&rawtime);
   timeinfo = localtime (&rawtime);
   fp=fopen("version_record_2.txt","a");
   +fprintf(fp,"Version 1.0.0 %s", asctime(timeinfo));
   fclose(fp);
   }
 
  return 0;
}
