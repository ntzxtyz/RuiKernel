//
// Created by taishang on 2020/10/2.
//

#include "init.h"

void init(unsigned long magic, unsigned long addr) {
	
	if (magic != MULTIBOOT2_BOOTLOADER_MAGIC)
		return;
	
	struct multiboot_tag *tag;
	
	for (tag = (struct multiboot_tag *) (addr + 8);
	     tag->type != MULTIBOOT_TAG_TYPE_END;
	     tag = (struct multiboot_tag *) ((multiboot_uint8_t *) tag
	                                     + ((tag->size + 7) & ~7)))
		switch (tag->type) {
			case MULTIBOOT_TAG_TYPE_MMAP: {
				multiboot_memory_map_t *mmap;
				struct MMapInfo *info = (struct MMapInfo *) 0x7000;
				int i = 0;
				
				for (mmap = ((struct multiboot_tag_mmap *) tag)->entries;
				     (multiboot_uint8_t *) mmap
				     < (multiboot_uint8_t *) tag + tag->size;
				     mmap = (multiboot_memory_map_t *)
					     ((unsigned long) mmap
					      + ((struct multiboot_tag_mmap *) tag)->entry_size)) {
					info[i].addr = mmap->addr;
					info[i].size = mmap->len;
					info[i].type = mmap->type;
					i++;
				}
			}
				break;
			
			case MULTIBOOT_TAG_TYPE_FRAMEBUFFER: {
				struct multiboot_tag_framebuffer *tagfb = (struct multiboot_tag_framebuffer *) tag;
				struct BufferInfo *info = (struct BufferInfo *) 0x7200;
				if (tagfb->common.framebuffer_type == MULTIBOOT_FRAMEBUFFER_TYPE_RGB) {
					info->addr = tagfb->common.framebuffer_addr;
					info->width = tagfb->common.framebuffer_width;
					info->height = tagfb->common.framebuffer_height;
				}
				
				int *fb = (int *) (unsigned long) info->addr;
				for (int i = 0; i < info->height * info->width; i++)
					fb[i] = 0x0066ccff;
			}
			
			default:
				break;
		}
}

void test(void) {
	struct BufferInfo *info = (struct BufferInfo *) 0x7200;
	int *base = (int *) (unsigned long) info->addr;
	for (int i = 0; i < info->width * info->height; i++)
		base[i] = 0x00ffffff;
}