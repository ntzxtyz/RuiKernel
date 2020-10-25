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
 * 我愿意将余生给黄瑞以快乐，但是……
 */

namespace kernel {
	
	extern "C" void Start_Kernel(void) {
		MM::init();
		IO::init();
		while (1);
	}
}