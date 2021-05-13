#include<wiringPi.h>
#include<stdio.h>
#include<stdlib.h>

int main(void){
    int pin = 7;
    int pin2 = 0;
    printf("Raspberry Pi wiringPi blink test\n");
    
    if(wiringPiSetup() == -1){
        printf("Setup didn't work, abouting...\n");
        exit(1);
    }
    
    pinMode(pin, OUTPUT); // set pin to an output device
    pinMode(pin2, OUTPUT);
    
    int i;
    for (i = 0; i<10; i++){
        digitalWrite(pin, 1);
        digitalWrite(pin2, 1);
        delay(250);
        digitalWrite(pin,0);
        digitalWrite(pin2,0);
    }
    
    return 0;
}
