//
// Created by taishang on 2021/1/7.
//

#ifndef RUIOS_PAGE_STRUCT_H
#define RUIOS_PAGE_STRUCT_H


struct page_struct {
    unsigned long cr3;
    unsigned long pmld[1024];
    unsigned long pdptd[1024];
    unsigned long ptd[8 * 1024];
    void init(void) {

    };
};

#endif //RUIOS_PAGE_STRUCT_H
