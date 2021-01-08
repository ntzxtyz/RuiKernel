//
// Created by taishang on 2021/1/5.
//
#include "PCB.h"
#define MAXN 65536
namespace PM {
    struct PCB *process[MAXN];
    PCB system;
    void switch_to(long pid);
    void init(unsigned long *p){
        system.auth = 0x00000000;
        system.pid = 0;
        system.mm.pgd = p;
    }
}