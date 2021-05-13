#include<stdio.h>

int func(int num1, int num2, int num3)
{
	printf("Nums passed: %d %d %d\n",num1,num2,num3);
	return(num1+num2+num3);
}



int main()
{
	int index, num=1;
	for(index = 1; index<3; index++)
	{
		num = num*index;
	}
	
	index = func(num, num*2, num*3);
	printf("value of num: %d and index = %d\n", num, index);
}

