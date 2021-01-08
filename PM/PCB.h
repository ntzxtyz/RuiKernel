//
// Created by taishang on 2021/1/5.
//

#ifndef RUIOS_PCB_H
#define RUIOS_PCB_H
#pragma pack(1)

struct mm_struct {
    unsigned long *pgd;
    unsigned long start_code, end_code;
    unsigned long start_data, end_data;
    unsigned long start_rodata, end_rodata;
    unsigned long start_brk, end_brk;
    unsigned long start_stack;
};

struct PCB {
    volatile long state;
    struct mm_struct mm;
    long auth;
    long pid;
    long counter;
    long signal;
};

#pragma pack()
#endif //RUIOS_PCB_H
