struct TIME
{
   int seconds;
   int minutes;
   int hours;
};

void differenceBetweenTimePeriod(struct TIME t1,
                                 struct TIME t2,
                                 struct TIME *diff);

int main()
{
   struct TIME startTime, stopTime, diff;

   printf("Enter the start time. \n");
   printf("Enter hours, minutes and seconds: ");
   scanf("%d %d %d", &startTime.hours,
         &startTime.minutes,
         &startTime.seconds);

   printf("Enter the stop time. \n");
   printf("Enter hours, minutes and seconds: ");
   scanf("%d %d %d", &stopTime.hours,
         &stopTime.minutes,
         &stopTime.seconds);

   // Difference between start and stop time
   differenceBetweenTimePeriod(startTime, stopTime, &diff);
   printf("\nTime Difference: %d:%d:%d - ", startTime.hours,
          startTime.minutes,
          startTime.seconds);
   printf("%d:%d:%d ", stopTime.hours,
          stopTime.minutes,
          stopTime.seconds);
   printf("= %d:%d:%d\n", diff.hours,
          diff.minutes,
          diff.seconds);
   return 0;
}

// Computes difference between time periods
void differenceBetweenTimePeriod(struct TIME start,
                                 struct TIME stop,
                                 struct TIME *diff)
{
   while (stop.seconds > start.seconds)
   {
      --start.minutes;
      start.seconds += 60;
   }
   diff->seconds = start.seconds - stop.seconds;
   while (stop.minutes > start.minutes)
   {
      --start.hours;
      start.minutes += 60;
   }
   diff->minutes = start.minutes - stop.minutes;
   diff->hours = start.hours - stop.hours;
}

struct course
{
   int marks;
   char subject[30];
};

int main()
{
   struct course *ptr;
   int noOfRecords;
   int i;
   printf("Enter the number of records: ");
   scanf("%d", &noOfRecords);

   // Memory allocation for noOfRecords structures
   ptr = (struct course *)malloc(noOfRecords * sizeof(struct course));
   for (int i = 0; i < noOfRecords; ++i)
   {
      printf("Enter subject and marks:\n");
      scanf("%s %d", (ptr + i)->subject, &(ptr + i)->marks);
   }

   printf("Displaying Information:\n");
   for (i = 0; i < noOfRecords; ++i)
   {
      printf("%s\t%d\n", (ptr + i)->subject, (ptr + i)->marks);
   }

   free(ptr);

   return 0;
}