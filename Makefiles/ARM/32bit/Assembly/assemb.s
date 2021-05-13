//r0,r1,r2,r3 for passing registers
//r7 usually passes the syscall numbers (3 = read, 4 = write)

.global _start

_start:
mov r5, #1 //loop counter

loop:
cmp r5, #5	// if looped 5 times, go to exit
bgt exit

add r5, #1	// increment counter

 //read system call
mov r7, #3 @ read syscall to read from keyboard
mov r0, #0 @ read STDIN
mov r2, #2 @ number of characters to read
ldr r3, =character
swi 0 @ syscal interrupt


ldr r0, [r3]
adds r0, #1
str r0, [r3]

 //write system call
mov r7, #4 @ write system call
mov r0, #1 @ write to STDOUT
mov r2, #2 @ number of characters to print
ldr r1, =character
swi 0

b loop 	//unconditional loop

exit:
mov r7, #1
swi 0

.data
character: .asciz " \n"
.align 4

