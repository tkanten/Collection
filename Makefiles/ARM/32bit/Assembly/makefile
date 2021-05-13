clean: assemb
	rm -f *.o *.s makefile

assemb:assemb.o
	ld assemb.o -o assemb


assemb.o:assemb.s
	as assemb.s -o assemb.o

