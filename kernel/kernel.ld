OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
OUTPUT_ARCH(i386:x86-64)
ENTRY(_start)

SECTIONS
{
	. = 0x100000; 
	.text : {
		*(.text)
	}
	. = ALIGN(0x1000);

	.rodata : {
		*(.rodata .rodata.* .gnu.linkonce.r.*)
	}
	. = ALIGN(0x1000);

	_edata = .;
	.data : {
		*(.data)
	}
	. = ALIGN(0x1000);

	.bss : {
		*(.bss)
		*(COMMON)
	}
	_end = .;
}
