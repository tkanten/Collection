#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include<time.h>
//USAGE:  -f lol.txt -o 30 -c 40

void errout(void) //general error function
{
	fprintf(stderr, "Critical Error!\nClosing program...\n");
	exit(-1);
}
//-----------------------------------------------------------------------------------
void findCLArgs(int argc, char* argv[], char* fileName, int* startPos, int* maxRead); //determining command line inputs
//-----------------------------------------------------------------------------------
void writeFile(const char* fileName);	//generating a file with random numbers
void readFileRaw(const char* fileName); //read files raw data
//-----------------------------------------------------------------------------------
void manipulateFile(const char* fileName, const int* startPos, const int* maxRead); //finding user's specified range, bringing values into memory
void sortData(int manipulatedData[], const int* maxRead);							//sort data, ascending or descending
void displayRes(int manipulatedData[], const int* maxRead);							//compute sum and average, display results

int main(int argc, char* argv[])
{
	if (argc > 7) //if too many arguments entered in terminal
	{
		fprintf(stderr, "Usage: ./(program_name) -f (file_name) -o (start_at_#) -c (count_until_#)\n");
		errout();
	}

	char f_fileName[40] = "\0";			//storing filename

	int o_startingPosition = 0;			//storing starting position
	int* startPos = &o_startingPosition;//ptr for starting position

	int c_maxRead = 0;					//storing max read position
	int* maxRead = &c_maxRead;			//ptr for max read position

	findCLArgs(argc, argv, f_fileName, startPos, maxRead); //pass to CLArgs

	writeFile(f_fileName); //generate numbers, stores in file + get/read numbers from files

	manipulateFile(f_fileName, startPos, maxRead); //manipulating number order/display to user's desire

	return 0;
}

void findCLArgs(int argc, char* argv[], char* fileName, int* startPos, int* maxRead)
{
	for (int i = 0; i < argc; i++)
	{
		if (!strncmp(argv[i], "-f", 2)) //finding -f specifier
			strncpy(fileName, argv[i + 1], strlen(argv[i + 1]));

		else if (!strncmp(argv[i], "-o", 2)) //finding -o specifier
		{
			*startPos = strtol(argv[i + 1], NULL, 10) - 1;
			if (*startPos == 0 || *startPos > 1000) //prevent overflow
				errout();
		}
		else if (!strncmp(argv[i], "-c", 2)) //finding -c specifier
		{
			*maxRead = strtol(argv[i + 1], NULL, 10);
			if (*maxRead == 0 || *maxRead > 50) //prevent overflow
				errout();
		}
	}
}

void writeFile(const char* fileName)
{

	printf("Would you like to generate new random numbers? (Y/N)\n"); //prompt for if user wants new numbers generated
	char writeResponse = '\0';
	scanf(" %1c", &writeResponse);

	if (writeResponse == 0x79 || writeResponse == 0x59) //if y/Y
	{
		FILE* fileptr_write = fopen(fileName, "w+"); //open file
		if (fileptr_write == NULL) //check if opened successfully
			errout();

		printf("\nGENERATING 1000 NUMBERS, STORING TO: %s......\n\n", fileName);
		srand(time(NULL));			 //generating time!!!
		int numbersIn[1000] = { 0 }; //where those shiny new numbers go
		int flag = 0;				 //flag val for putting 10 values on each line
		for (int i = 0; i < 1000; i++)
		{
			numbersIn[i] = rand() % 756 + 1;
			if (flag < 10)
			{
				fprintf(fileptr_write, "%d ", numbersIn[i]);
				flag++; //+1 to counter
			}
			else
			{
				fprintf(fileptr_write, "\n");
				flag = 0; //reset flag
				--i; //decrement counter by 1
			}
		}
		fclose(fileptr_write); //close file

		//check if user wants to read file contents
		printf("Would you like to read data from the new file? (Y/N)\n");
		char readResponse = '\0';
		scanf(" %1c", &readResponse);
		if (readResponse == 0x79 || readResponse == 0x59) //if y/Y
			readFileRaw(fileName);
		else
			printf("Moving on...\n\n");
	}
	else
		printf("Moving on...\n\n");
}

void readFileRaw(const char* fileName)
{
	printf("\n=======================================");
	printf("\nReading contents of %s...\n", fileName);
	printf("----------------------------------------\n");
	FILE* fileptr_read = fopen(fileName, "r");
	if (fileptr_read == NULL)
		errout();

	int buffer[1000] = { 0 };
	int flag = 0;
	for (int i = 0; fscanf(fileptr_read, "%d", &buffer[i]) != EOF; i++)
	{
		if (flag < 10)
		{
			printf("%3d ", buffer[i]);
			flag++;
		}
		else
		{
			printf("\n");
			flag = 0;
		}
	}
	printf("\n=======================================\n\n");
	fclose(fileptr_read);
}

void manipulateFile(const char* fileName, const int* startPos, const int* maxRead)
{
	printf("\n=================================================================\n");
	printf("Grabbing specified file data.. [OFFSET %d - READ %d from %s]\n", *startPos + 1, *maxRead, fileName);
	printf("=================================================================\n\n");
	FILE* fileptr_manip = fopen(fileName, "r");
	if (fileptr_manip == NULL)
		errout();

	//bringing file into memory
	int buffer[1000] = { '\0' };
	for (int i = 0; fscanf(fileptr_manip, " %d", &buffer[i]) != EOF; i++);
	fclose(fileptr_manip);

	//finding starting position (offsetFlag)
	//copy specified amount of numbers from file into arr
	int specifiedRange[1000] = { 0 };
	int offsetFlag = *startPos;
	for (int i = 0; i < *maxRead; i++)
	{
		specifiedRange[i] = buffer[offsetFlag];
		++offsetFlag;
	}

	sortData(specifiedRange, maxRead);
	displayRes(specifiedRange, maxRead);
}

void sortData(int manipulatedData[], const int* maxRead)
{
	printf("Sorting specified range...\n");
	printf("Type 'A' for Ascending Order, type 'D' for descending order, or anything else to not sort\n");
	char sortResponse = '\0';
	scanf(" %1c", &sortResponse);

	int temp = 0;
	//ascending order sort
	if (sortResponse == 0x41 || sortResponse == 0x61) //if A/a
	{
		for (int count = 0; count < *maxRead; count++)
		{
			for (int count2 = 0; count2 < *maxRead; count2++)
			{
				if (manipulatedData[count2] > manipulatedData[count2 + 1] && manipulatedData[count2 + 1] != 0)
				{
					temp = manipulatedData[count2];
					manipulatedData[count2] = manipulatedData[count2 + 1];
					manipulatedData[count2 + 1] = temp;
				}
			}
		}
	}
	//descending order sort
	else if (sortResponse == 0x44 || sortResponse == 0x64) //if D/d
	{
		for (int count = 0; count < *maxRead; count++)
		{
			for (int count2 = 0; count2 < *maxRead; count2++)
			{
				if (manipulatedData[count2] < manipulatedData[count2 + 1] && manipulatedData[count2 + 1] != 0)
				{
					temp = manipulatedData[count2];
					manipulatedData[count2] = manipulatedData[count2 + 1];
					manipulatedData[count2 + 1] = temp;
				}
			}
		}
	}
	else
		return;
}

void displayRes(int manipulatedData[], const int* maxRead)
{

	printf("\nEnter how many values to display per row:\n"); //let user decide how many values per row
	int maxRowCount = 0;
	scanf("%d", &maxRowCount);
	if (maxRowCount > *maxRead || maxRowCount < 1) //prevents logical errors
		errout();

	printf("\n========================================\n");
	printf("Your chosen range values are as follows:\n");

	int sum = 0;
	int flag = 0;
	for (int i = 0; i < *maxRead && manipulatedData[i] != 0; i++)
	{
		sum += manipulatedData[i];
		if (flag < maxRowCount)
		{
			printf("%3d\t", manipulatedData[i]);
			++flag;
		}
		else
		{
			printf("\n");
			flag = 0;
			--i;
		}
	}
	printf("\n========================================\n");
	int mean = sum / *maxRead;
	printf("The sum of your chosen numbers is:\t%d\n", sum);
	printf("The average of your chosen numbers is:\t%d", mean);
	printf("\n========================================\n");


}
