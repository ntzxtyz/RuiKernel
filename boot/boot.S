#include "multiboot2.h"
#define STACK_SIZE	0x4000

	.intel_syntax noprefix
	.text
	.code32
	.globl	_start
_start:	jmp	multiboot_entry

	.align	8
multiboot_header:
        //识别头，魔数&体系&校验和
        .long   MULTIBOOT2_HEADER_MAGIC
        .long   MULTIBOOT_ARCHITECTURE_I386
        .long   multiboot_header_end - multiboot_header
        .long   -(MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (multiboot_header_end - multiboot_header))

#ifndef __ELF__
address_tag_start:
        //加载地址
        .short  MULTIBOOT_HEADER_TAG_ADDRESS
        .short  MULTIBOOT_HEADER_TAG_OPTIONAL
        .long   address_tag_end - address_tag_start

        .long   multiboot_header

        .long   _start

        .long   _edata

        .long   _end
address_tag_end:
entry_address_tag_start:
        .short  MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS
        .short  MULTIBOOT_HEADER_TAG_OPTIONAL
        .long   entry_address_tag_end - entry_address_tag_start
        .long   multiboot_entry
entry_address_tag_end:
#endif /*  __ELF__ */

framebuffer_tag_start:
        //视频缓冲区信息
        .short  MULTIBOOT_HEADER_TAG_FRAMEBUFFER
        .short  MULTIBOOT_HEADER_TAG_OPTIONAL
        .long   framebuffer_tag_end - framebuffer_tag_start
        .long   1024
        .long   768
        .long   32
framebuffer_tag_end:
        .short  MULTIBOOT_HEADER_TAG_END
        .short  0
        .long   0
multiboot_header_end:

multiboot_entry:
	
	mov	esp,	(stack + STACK_SIZE)
	push	0

        pop     ecx
        push    eax
        push    ebx
        call    init
	
.prepare_PAE:
        mov     dword   ptr     [0x90000],      0x91007
        mov     dword   ptr     [0x90004],      0x00000
        mov     dword   ptr     [0x90800],      0x91007
        mov     dword   ptr     [0x90804],      0x00000
        mov     dword   ptr     [0x91000],      0x92007
        mov     dword   ptr     [0x91004],      0x00000
        mov     dword   ptr     [0x92000],      0x000083
        mov     dword   ptr     [0x92004],      0x000000
        mov     dword   ptr     [0x92008],      0x200083
        mov     dword   ptr     [0x9200c],      0x000000
        mov     dword   ptr     [0x92010],      0x400083
        mov     dword   ptr     [0x92014],      0x000000
        mov     dword   ptr     [0x92018],      0x600083
        mov     dword   ptr     [0x9201c],      0x000000
        mov     dword   ptr     [0x92020],      0x800083
        mov     dword   ptr     [0x92024],      0x000000
        mov     dword   ptr     [0x92028],      0xa00083
        mov     dword   ptr     [0x9202c],      0x000000

	.byte	0x66
	lgdt	[GdtPtr]

.enter_ia32e:
	mov	eax,	0x18
	mov	ds,	eax
	mov	es,	eax
	mov	fs,	eax
	mov	ss,	eax

	mov	eax,	cr4
	bts	eax,	5
	mov	cr4,	eax

	mov	ecx,	0x0c0000080
	rdmsr
	
	mov	eax,	8
	wrmsr

	mov	eax,	cr0
	bts	eax,	0
	bts	eax,	31
	mov	cr0,	eax

	jmp	0x10:	start

GDT64:	.quad	0x0000000000000000
CODE:	.quad	0x0020980000000000
DATA:	.quad	0x0000920000000000
GdtEnd:

GdtPtr:	.word	GdtEnd - GDT64 - 1
	.long	GDT64

	.comm	stack,	STACK_SIZE

