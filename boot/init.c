#include "multiboot2.h"
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
                                struct meminfo *info = (struct meminfo *) MEMMAP_ADDR;
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
                                struct bufferinfo *info = (struct bufferinfo *) BUFFER_ADDR;
                                if (tagfb->common.framebuffer_type == MULTIBOOT_FRAMEBUFFER_TYPE_RGB) {
                                        info->addr = tagfb->common.framebuffer_addr;
                                        info->width = tagfb->common.framebuffer_width;
                                        info->height = tagfb->common.framebuffer_height;
                                }

                                int *fb = (int *) (unsigned long) info->addr;
                                for (int i = 0; i < info->height * info->width; i++)
                                        fb[i] = 0x00ee0000;
                        }

                        default:
                                break;
                }
}