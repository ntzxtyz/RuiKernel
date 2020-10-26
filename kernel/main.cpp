//
// Created by taishang on 2020/10/1.
//

#include <main.h>
#include <io/io.h>
#include "mm/mm.h"

/*
 * 和黄瑞并排的时间总是如此短暂
 * 黄瑞之可爱犹如数学之美丽
 * 从某种程度上说，黄瑞和我是一致的
 */

namespace kernel {
#pragma pack(1)
	struct Info {
		unsigned long long addr;
		unsigned int width, height;
	};
#pragma pack()
	extern "C" void Start_Kernel(void) {
	Info *info = (Info *) 0x7200;
	int *fb = (int *) (unsigned long) info->addr;
		for (int i = 0; i < info->height * info->width; i++)
			fb[i] = 0x00ee0000;
	
		MM::init();
//		IO::init();
		while (1);
	}
}
