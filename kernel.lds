OUTPUT_FORMAT("elf64-x86-64")
OUTPUT_ARCH(i386:x86-64)
ENTRY(_start)
SECTIONS
{
    . = 0x100000;

    .text :
    {
        * (.text)
    }

    . = ALIGN(4);
    .data :
    {
        * (.data)
    }

    . = ALIGN(4);
    .rodata :
    {
        * (.rodata)
    }

    . = ALIGN(4);
    .bss :
    {
        * (.bss)
    }

    kernel_end = .;
}