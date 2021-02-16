#define ASM_FILE        1
#include <multiboot2.h>
#define STACK_SIZE                      0x40000

        .text
        .code32
        .globl  start, _start
start:
_start:
        jmp     multiboot_entry

        .align  8

        /*  Multiboot header. */
multiboot_header:
        
        .long   MULTIBOOT2_HEADER_MAGIC
        .long   MULTIBOOT_ARCHITECTURE_I386
        .long   multiboot_header_end - multiboot_header
        .long   -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))
#ifndef __ELF__
address_tag_start:
        .short MULTIBOOT_HEADER_TAG_ADDRESS
        .short MULTIBOOT_HEADER_TAG_OPTIONAL
        .long address_tag_end - address_tag_start
        .long   multiboot_header
        .long   _start
        .long   _edata
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
        .short  0
        .long   0
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

        /* make PAE page struction */
        movl    $0x91007,       0x90000
        movl    $0x00000,       0x90004

        movl    $0x92007,       0x91000
        movl    $0x00000,       0x91004

        movl    $0x000083,      0x92000
        movl    $0x000000,      0x92004

        movl    $0x200083,      0x92008
        movl    $0x000000,      0x9200c

        movl    $0x400083,      0x92010
        movl    $0x000000,      0x92014

        movl    $0x600083,      0x92018
        movl    $0x000000,      0x9201c

        movl    $0x800083,      0x92020
        movl    $0x000000,      0x92024

        movl    $0xa000083,     0x92028
        movl    $0x0000000,     0x9202c

        /* start to jump to mode 64 */

        lgdt    (gdtr64 - multiboot_header + _start)

        mov     $0x10,  %ax
        mov     %ax,    %ds
        mov     %ax,    %fs
        mov     %ax,    %gs
        mov     %ax,    %es
        mov     %ax,    %ss

        mov     %cr4,   %eax
        bts     $5,     %eax
        mov     %eax,   %cr4

        mov     $0x90000,       %eax
        mov     %cr3,    %eax

        mov     $0xc0000080,     %ecx
        rdmsr
        bts     $8,     %eax
        wrmsr

        mov     %cr0,   %eax
        bts     $0,     %eax
        bts     $31,    %eax
        mov     %eax,   %cr0

        ljmp    $8, $(entry64 - multiboot_header + _start)

.align  16
gdtr64:
        .word   gdt64_end - gdt64_begin - 1
        .quad   gdt64_begin - multiboot_header + _start

.align  16
gdt64_begin:
        .long   0x00000000
        .long   0x00000000
        .long   0x00000000
        .long   0x00209800
        .long   0x00000000
        .long   0x00009000
gdt64_end:

.align  16
.code64
entry64:
        mov     $kernel,        %rax
        jmp     *%rax

kernel:
        xor     %rax,   %rax
        mov     %ax,    %ss
        mov     %ax,    %ds
        mov     %ax,    %es
        mov     %ax,    %fs
        mov     %ax,    %gs

        jmp     Start_Kernel
        /*  Our stack area. */
        .comm   stack, STACK_SIZE
