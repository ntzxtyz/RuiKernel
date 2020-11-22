//SystemRuiProject
//祈瑞
//惊鸿回眸动琴心，倩兮巧笑近有情
//白雁难托寄红豆，青鸾无语赠紫荆
//清婉无需羡周南，溯洄未敢效长卿
//远望山林祈瑞瑷，君不念我仍思君
//@author:taishang
//@email:tuyanzheng@gmail.com

#define	MAXPHYADDR	52

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
