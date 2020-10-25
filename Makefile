all: boot.o init.o main.o
	ld -m elf_x86_64 -T kernel.lds -o system boot.o init.o main.o
	objcopy -O binary system kernel.bin
	rm *.o system

boot.o: boot/boot.S
	gcc  -I . -m32 -nolibc -nostdlib -c boot/boot.S -o boot/boot.o
	objcopy -O elf64-x86-64 boot/boot.o boot.o
	rm boot/boot.o

init.o: boot/init.c
	gcc  -I . -m32 -nolibc -nostdlib -c boot/init.c -o boot/init.o
	objcopy -O elf64-x86-64 boot/init.o init.o
	rm boot/init.o

main.o: kernel/main.cpp
	gcc  -I . -m64 -nolibc -nostdlib -c kernel/main.cpp -o main.o

clean:
	rm *.o boot/*.o