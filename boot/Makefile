all: boot.o init.o
	rm *.o

boot.o: boot.S
	gcc -m32 -I . -c boot.S -o boot.o
	objcopy	-O elf64-x86-64 boot.o ../boot.o

init.o: init.c
	gcc -m32 -I . -c init.c -o init.o
	objcopy -O elf64-x86-64 init.o ../init.o
