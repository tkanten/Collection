#include<stdio.h>
#include<stdlib.h>

int additup(int vala, int valb, int valc)
{
	int sum = ((vala & 10) | (valb & 20) + (valc & 40));
	printf("sum = %d %d %d %d\n",sum,vala,valb,valc);
	return sum;
}

int main()
{
	int val1 = 60;
	int val2 = 170;
	int val3 = 54;
	int val4 = 200;
	
	val4 = additup(val2, val3, val1);
	
	printf("My answer is >> Dec: %d Hex: %#x\n", val4, val4);
	exit(10);
}
