
#define ASM_FILE        1
#include ”multiboot2.h“

/*  C symbol format. HAVE_ASM_USCORE is defined by configure. */
#ifdef HAVE_ASM_USCORE
# define EXT_C(sym)                     _ ## sym
#else
# define EXT_C(sym)                     sym
#endif

/*  The size of our stack (16KB). */
#define STACK_SIZE                      0x4000

/*  The flags for the Multiboot header. */
#ifdef __ELF__
# define AOUT_KLUDGE 0
#else
# define AOUT_KLUDGE MULTIBOOT_AOUT_KLUDGE
#endif

        .text

        .globl  start, _start
start:
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
        .long   -(MULTIBOOT2_HEADER_MAGIC + GRUB_MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))
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
        .long 8
multiboot_header_end:
multiboot_entry:
        /*  Initialize the stack pointer. */
        movl    $(stack + STACK_SIZE), %esp

        /*  Reset EFLAGS. */
        pushl   $0
        popf

        /*  Push the pointer to the Multiboot information structure. */
        pushl   %ebx
        /*  Push the magic value. */
        pushl   %eax

	xor	%eax,	%eax
	mov	$0x1000,	%edi
	mov	$0x5000,	%ecx
	rep	stosb

	mov	$(0x2000 | 3),	%eax
	mov	%eax,	0x1000

	mov	$(0x3000 | 3),	%eax
	mov	%eax,	0x2000
	
	mov	$(0x4000 | 3),	%eax
	mov	%eax,	0x3ff0

	mov	$0x83,	%eax
	mov	$0x4000,	%ebx
	mov	$512,	%ecx

ptbl_loop:
	mov	%eax,	(%ebx)
	add	$0x200000,	%eax
	add	$0x8,	%ebx
	dec	%ecx
	jnz	ptbl_loop
	
	xor	%ebx,	%ebx
	pop	%esi
	pop	%edi

.globl	entry32mp

entry32mp:
	mov	$0x1000,	%eax
	mov	%eax,	%cr3

	lgdt	(gdtr64 - multiboot2_header + multiboot2_

        /*  Now enter the C main function... */
        call    EXT_C(cmain)

        /*  Halt. */
        pushl   $halt_message
        call    EXT_C(printf)

loop:   hlt
        jmp     loop

halt_message:
        .asciz  "Halted."

        /*  Our stack area. */
        .comm   stack, STACK_SIZE
