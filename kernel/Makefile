all: entry.o kernel.o
	ld -b elf64-x86-64 -z muldefs -o system entry.o kernel.o -T kernel.ld
	rm *.o

entry.o: boot/entry64.S
	gcc -I boot/ -fno-stack-protector -c boot/entry64.S -o entry.o
	
kernel.o: kernel.cpp
	g++ -I . -fno-stack-protector -nostdlib -c kernel.cpp -o kernel.o

clean:
	rm *.o  
