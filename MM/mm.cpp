//
// Created by taishang on 2021/1/5.
//
#include "page_struct.h"
#define PGMM 16 * 1024 / 2

namespace MM {
    unsigned char pages[PGMM];
    struct page_struct pageStruct;
    void init(unsigned long addr, unsigned long size) {
        unsigned long start, end;
        if (addr % 0x80000000 == 0)
            start = addr << 31;
        else
            start = (addr << 31) + 1;
        if ((addr + size) % 0x80000000 == 0)
            end = (addr + size) << 31;
        else
            end = ((addr + size) << 31) + 1;
        for (; start <= end; start ++)
            pages[start] = 1;
    }
    unsigned long malloc_page(void) {
        for (int i = 0; i < PGMM; i ++)
            if (pages[i] == 1) {
                pages[i] = 0;
                return i;
            }
        return 0x00000000;
    }
}