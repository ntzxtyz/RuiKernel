all: boot.o init.o main.o head.o
	ld -m elf_x86_64 -T kernel.lds -o system boot.o init.o main.o head.o
	rm *.o

boot.o: boot/boot.S
	gcc  -fno-builtin -m32 -o boot/boot.o -c boot/boot.S
	objcopy -O elf64-x86-64 boot/boot.o boot.o

init.o: boot/init.c
	gcc  -fno-builtin -m32 -o boot/init.o -c boot/init.c
	objcopy -O elf64-x86-64 boot/init.o init.o

head.o: kernel/head.S
	gcc -m64 -c kernel/head.S 

main.o: kernel/main.cpp
	g++ -mcmodel=large -fno-builtin -m64 -c kernel/main.cpp

clean:
	rm *.o */*.o */*.swp
