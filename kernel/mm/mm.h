//SystemRuiProject
//@author: taishang
//#email: tuyanzheng@gmail.com
//阿黄是最可爱的！！！！

#include "amd64.h"

namespace	MM {

	CR3	cr3;
	PML4	pml4;
	PDPTE	dict[8];
	PDE	entry[4096];

	void	init(){
		for (int i = 0; i < 4096; i++) {
			entry[i].P = 1;;
			entry[i].Frame = PhMnMngr.getEmptyFrame();
			entry[i].G = 1;
			entry[i].PAT = 0;
			entry[i].US = 0;
			entry[i].RW = 1;
		}

		for (int i = 0; i < 8; i++) {
			dict[i].P = 1;
			dict[i].RW = 1;
			dict[i].US = 0;
			dict[i].Base = (unsigned long long)(&(entry[0]) + i * 512 * sizeof(PDE)) >> 32;
		}

		pml4.P = 1;
		pml4.RW = 1;
		pml4.US = 0;
		pml4.Base = (unsigned long long)(&(dict[0])) >> 32;

		cr3.Base = (unsigned long long)(&(pml4)) >> 32;
		cr3_load(cr3);
	}
};

