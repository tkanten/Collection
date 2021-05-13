.data
.align 4

setup: .asciz "raspberry pi setup \n"
ErrMsg: .asciz "Error \n"
pinblue: .int 7
pinred: .int 0
delayMs: .int 500
OUTPUT = 1

.text
.global main
.extern printf
.extern wiringPisetup
.extern delay
.extern digitalWrite
.extern pinMode

main:
	push {ip, lr}
	ldr r0, =setup
	bl printf
	bl wiringPiSetup 	@ initalize wiringPiSetup
	mov r1, #-1
	cmp r0, r1
	bne PINMODE
	ldr r0, =ErrMsg		@ error checking for wiringPi
	bl printf
	b exit
	
PINMODE:
	ldr r0, =pinblue	@ loading wPi 7 (yellow LED)
	ldr r0, [r0]		
	
	mov r1, #OUTPUT		@ setting pinMode to Output
	bl pinMode			@ pinMode function
	
	ldr r2, =pinred		@ loading wPi 0 (red LED)
	ldr r2, [r2]		
	
	mov r2, #OUTPUT		@ setting pinMode to Output
	bl pinMode			@ pinMode function
	
	mov r5, #1			@ loop counter

TurnOn:
	cmp r5, #5
	bgt exit
	
	add r5, #1

	ldr r0, =pinblue	@ turning wPi 7 (yellow LED) on
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite
	
Delay:
	ldr r0, =delayMs	@ delay turn off 500 ms
	ldr r0, [r0]
	bl delay
	
Turnoff:
	ldr r0, =pinblue	@ turning wPi 7 (yellow LED) off
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite
	
Delay2:					

	ldr r0, =delayMs	@ 500ms delay in b/w wPi 7 and wPi 0
	ldr r0, [r0]
	bl delay
	
	ldr r0, =pinred		@ turning wPi 0 (red LED) on
	ldr r0, [r0]
	mov r1, #1
	bl digitalWrite
	
	ldr r0, =delayMs	@ delay turn off 500ms
	ldr r0, [r0]
	bl delay
	
	ldr r0, =pinred		@ turning wPi 0 (red LED) off
	ldr r0, [r0]
	mov r1, #0
	bl digitalWrite
	
	ldr r0, =delayMs	@ delay 500ms
	ldr r0, [r0]
	bl delay
	b TurnOn
	
exit:
	pop {ip, pc}

