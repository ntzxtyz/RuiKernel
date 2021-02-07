OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
OUTPUT_ARCH(i386:x86-64)
ENTRY(_start)

SECTIONS
{
	/* Link the kernel at this address: "." means the current address */
        /* Must be equal to KERNLINK */
	. = 0x100000; 

	.text : {
		*(.text)
	}

	.rodata : {
		*(.rodata .rodata.* .gnu.linkonce.r.*)
	}
	. = ALIGN(0x1000);

	/* The data segment */
	.data : {
		*(.data)
	}

	. = ALIGN(0x1000);

	.bss : {
		*(.bss)
		*(COMMON)
	}

	. = ALIGN(0x1000);
}
