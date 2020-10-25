//
// Created by taishang on 2020/10/24.
//

#ifndef RUIOS_PAGE_H
#define RUIOS_PAGE_H
#define MAXPHYADDR  36

typedef unsigned long long CR3;
typedef unsigned long long PML4;
typedef unsigned long long PDPTE;
typedef unsigned long long PDE;

#define setbit(flag, desc)      ( desc |= (1 << flag))
#define clrbit(flag, desc)      ( desc &= (1 << flag))
#define getbit(flag, desc)      ((desc) >> (flag) & 1)

static inline void setaddr(unsigned int flag, unsigned int addr, unsigned long long desc) {
	for (int i = flag; i <= MAXPHYADDR; i++)
		if (getbit(i - flag, addr))
			setbit(i, desc);
		else
			clrbit(i, desc);
	return;
}

void load_cr3(CR3 cr3) {
	__asm__ __volatile__ ( "movq %%rax, %%cr3": : "a"(cr3) :);
}

#define CR3_PWT         2
#define CR3_PCD         3
#define CR3_Addr        12

#define PML4_P          0
#define PML4_RW         1
#define PML4_US         2
#define PML4_PWT        3
#define PML4_PCD        4
#define PML4_A          5
#define PML4_Addr       12

#define PDPTE_P         0
#define PDPTE_RW        1
#define PDPTE_US        2
#define PDPTE_PWT       3
#define PDPTE_PCD       4
#define PDPTE_A         5
#define PDPTE_Addr      12

#define PDE_P           0
#define PDE_RW          1
#define PDE_US          2
#define PDE_PWT         3
#define PDE_PCD         4
#define PDE_A           5
#define PDE_D           6
#define PDE_PS          7
#define PDE_G           8
#define PDE_PAT         12
#define PDE_Addr        21

#pragma pack(1)
struct Info {
	unsigned long long addr, size;
	unsigned int type;
};
union kit {
	struct {
		unsigned low, high;
	} target;
	unsigned long long origin;
};

unsigned cut(unsigned long long origin) {
	kit Kit;
	Kit.origin = origin;
	return Kit.target.low;
}

#pragma pack()

#endif //RUIOS_PAGE_H
