clean:assemb
	rm *.o
	gdb ./assemb
	rm assemb

assemb:assemb.o
	ld -melf_x86_64 -o assemb assemb.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
	

assemb.o:assemb.asm
	nasm -felf64 -g -o assemb.o assemb.asm
