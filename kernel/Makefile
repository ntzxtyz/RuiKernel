all: system
	objcopy -I elf64-x86-64 -S -R ".eh_frame" -R ".comment" -O binary system kernel.bin

system: entry.o kernel.o
	ld -b elf64-x86-64 -z muldefs -o system entry.o kernel.o -T kernel.ld

entry.o: entry.S
	gcc -fno-stack-protector -c entry.S -o entry.o
	
kernel.o: kernel.cpp
	g++ -I . -fno-stack-protector -nostdlib -c kernel.cpp -o kernel.o

clean:
	rm *.o system
