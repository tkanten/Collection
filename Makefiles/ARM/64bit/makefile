transport:assemb
	sshpass -p '<password>' scp assemb <username>@<address>:/home/<username>/Assembly
	rm -f assemb *.o 

assemb:assemb.o
	aarch64-linux-gnu-gcc -static assemb.o -o assemb

assemb.o: assemb.s
	aarch64-linux-gnu-as -c assemb.s -o assemb.o

