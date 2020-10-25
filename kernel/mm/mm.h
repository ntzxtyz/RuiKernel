//
// Created by taishang on 2020/10/24.
//
#include "Page.h"

#ifndef RUIOS_MM_H
#define RUIOS_MM_H

#ifndef MAXN
#define MAXN    32
#endif

#define Empty   1
#define Useless 0
#define Used    2
#define max(x, y)   ( x > y ? x : y )

namespace MM {
	
	extern unsigned kernel_end;
	unsigned char PhPg[MAXN * 1024 / 2] = {Useless};
	unsigned int maxn;
	
	PML4 FstTable;
	PDPTE SecTable[MAXN];
	PDE ThdTable[MAXN * 1024 / 2];
	
	int find(void) {
		for (int i = 0; i < maxn; i++)
			if (PhPg[i] == Empty) {
				PhPg[i] = Used;
				return i;
			}
		return 0;
	}
	
	void init(void) {
		Info *info = (Info *) 0x7200;
		int i, j;
		for (i = 0; i < 20; i++) {
			if (info[i].type == Empty) {
				maxn = max(maxn, info[i].addr + info[i].size);
				for (j = info[i].addr; j < info[i].addr + info[i].size; j++)
					PhPg[j >> 21] = Empty;
			}
		}
		
		CR3 cr3 = 0;
		PML4 Dict = 0;
		PDPTE Entry[MAXN];
		PDE Page[MAXN * 1024 / 2];
		
		for (i = 0; i < MAXN * 1024 / 2; i++) {
			Page[i] = 0;
			setbit(PDE_P, Page[i]);
			setbit(PDE_RW, Page[i]);
			setbit(PDE_PS, Page[i]);
			setaddr(PDE_Addr, find(), Page[i]);
		}
		
		unsigned addr = cut((unsigned long long) &Page[0]);
		
		for (i = 0; i < MAXN; i++) {
			Entry[i] = 0;
			setbit(PDPTE_P, Entry[i]);
			setbit(PDPTE_RW, Entry[i]);
			setaddr(PDPTE_Addr, addr + 512 * i, Entry[i]);
		}
		
		addr = cut((unsigned long long) &Entry[0]);
		setbit(PML4_P, Dict);
		setbit(PML4_RW, Dict);
		setaddr(PML4_Addr, addr, Dict);
		
		addr = cut((unsigned long long) &Dict);
		setaddr(CR3_Addr, addr, cr3);
		load_cr3(cr3);
	}
	
	void *malloc(int size);
	
	void free(void *pointer);
}

#endif //RUIOS_MM_H
