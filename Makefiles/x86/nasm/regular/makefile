clean:assemb
	rm *.o
	gdb ./assemb
	rm assemb

assemb:assemb.o
	ld  assemb.o -o assemb
	

assemb.o:assemb.nasm
	nasm -felf64 -g -o assemb.o assemb.nasm
