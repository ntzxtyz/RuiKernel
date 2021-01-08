//
// Created by taishang on 2021/1/6.
//

#ifndef RUIOS_PAGE_H
#define RUIOS_PAGE_H
#define	MAXPHYADDR	52
#pragma pack(1)

struct CR3 {
    unsigned int	reserved1: 3,
            PWT: 1,
            PCD: 1,
            reserved2: 7,
            Base: MAXPHYADDR - 12;
};

struct PML4 {
    unsigned int	P: 1,
            RW: 1,
            US: 1,
            PWT: 1,
            PCD: 1,
            A: 1,
            reserved: 6,
            Base: MAXPHYADDR - 12;
};

struct PDPTE {
    unsigned int	P: 1,
            RW: 1,
            US: 1,
            PWT: 1,
            PCD: 1,
            A: 1,
            reserved: 6,
            Base: MAXPHYADDR - 12;
};

struct PDE {
    unsigned int	P: 1,
            RW: 1,
            US: 1,
            PWT: 1,
            PCD: 1,
            A: 1,
            D: 1,
            Page: 1,
            G: 1,
            reserved1: 3,
            PAT: 1,
            reserved2: 8,
            Frame: MAXPHYADDR - 21;
};

#define cr3_load(cr3)	\
	__asm__ __volatile__("	movq	%%rax,	%%cr3": : "a" (cr3))

#pragma pack()
#endif //RUIOS_PAGE_H
