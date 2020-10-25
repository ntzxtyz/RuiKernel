#define ASM_FILE        1
#include "multiboot.h"

/*  C symbol format. HAVE_ASM_USCORE is defined by configure. */
#ifdef HAVE_ASM_USCORE
# define EXT_C(sym)                     _ ## sym
#else
# define EXT_C(sym)                     sym
#endif

/*  The size of our stack (16KB). */
#define STACK_SIZE                      0x40000

/*  The flags for the Multiboot header. */
#ifdef __ELF__
# define AOUT_KLUDGE 0
#else
# define AOUT_KLUDGE MULTIBOOT_AOUT_KLUDGE
#endif
	    .intel_syntax noprefix
        .text
        .code32

        .globl  _start

_start:
        jmp     multiboot_entry

        /*  Align 64 bits boundary. */
        .align  8

        /*  Multiboot header. */
multiboot_header:
        /*  magic */
        .long   MULTIBOOT2_HEADER_MAGIC
        /*  ISA: i386 */
        .long   MULTIBOOT_ARCHITECTURE_I386
        /*  Header length. */
        .long   multiboot_header_end - multiboot_header
        /*  checksum */
        .long   -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))
#ifndef __ELF__
address_tag_start:
        .short MULTIBOOT_HEADER_TAG_ADDRESS
        .short MULTIBOOT_HEADER_TAG_OPTIONAL
        .long address_tag_end - address_tag_start
        /*  header_addr */
        .long   multiboot_header
        /*  load_addr */
        .long   _start
        /*  load_end_addr */
        .long   _edata
        /*  bss_end_addr */
        .long   _end
address_tag_end:
entry_address_tag_start:
        .short MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS
        .short MULTIBOOT_HEADER_TAG_OPTIONAL
        .long entry_address_tag_end - entry_address_tag_start
        /*  entry_addr */
        .long multiboot_entry
entry_address_tag_end:
#endif /*  __ELF__ */
framebuffer_tag_start:
        .short MULTIBOOT_HEADER_TAG_FRAMEBUFFER
        .short MULTIBOOT_HEADER_TAG_OPTIONAL
        .long framebuffer_tag_end - framebuffer_tag_start
        .long 1024
        .long 768
        .long 32
framebuffer_tag_end:
        .short MULTIBOOT_HEADER_TAG_END
        .short 0
        .long 0
multiboot_header_end:
multiboot_entry:
	    mov	esp,	(stack + STACK_SIZE)
	    push	0

	    push	ebx
	    push	eax
	    call	EXT_C(init)

	    lgdt	[reg]

	    mov	eax,	0x18
    	mov	ds,	eax
    	mov	gs,	eax
    	mov	fs,	eax
    	mov	es,	eax

    	mov	eax,	0x10
    	mov	cs,	eax

    	jmp	tmp

tmp:

    	mov	dword	ptr	[0x90000],	0x91007
    	mov	dword	ptr	[0x90004],	0x00000
    	mov	dword	ptr	[0x90800],	0x91007
    	mov	dword	ptr	[0x90804],	0x00000

    	mov	dword	ptr	[0x91000],	0x92007
    	mov	dword	ptr	[0x91004],	0x00000

    	mov	dword	ptr	[0x92000],	0x000083
    	mov	dword	ptr	[0x92004],	0x000000

    	mov	dword	ptr	[0x92008],	0x200083
    	mov	dword	ptr	[0x9200c],	0x000000

    	mov	dword	ptr	[0x92010],	0x400083
    	mov	dword	ptr	[0x92014],	0x000000

    	mov	dword	ptr	[0x92018],	0x600083
    	mov	dword	ptr	[0x9201c],	0x000000

    	mov	dword	ptr	[0x92020],	0x800083
    	mov	dword	ptr	[0x92024],	0x000000

    	mov	dword	ptr	[0x92028],	0xa00083
    	mov	dword	ptr	[0x9202c],	0x000000

    	mov	eax,	cr4

    	mov	eax,	cr4
    	bts	eax,	5
    	mov	cr4,	eax

    	mov	eax,	0x90000
    	mov	cr3,	eax

	    mov	ecx,	0x0C0000080		//IA32_EFER
	    rdmsr

	    bts	eax,	8
	    wrmsr

	    mov	eax,	cr0
	    bts	eax,	0
	    bts	eax,	31
	    mov	cr0,	eax

	    jmp	0x10:	sysinit

table:  .quad    0x0000000000000000    /* NULL descriptor */
        .quad    0x00af9a000000ffff    /* __KERNEL_CS */
        .quad    0x00cf92000000ffff    /* __KERNEL_DS */
        .quad    0x0080890000000000    /* TS descriptor */
end:    .quad    0x0000000000000000    /* TS continued */

reg:    .word    end - table - 1
        .long    table

	    .comm	stack,	STACK_SIZE
