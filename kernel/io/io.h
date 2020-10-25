//
// Created by taishang on 2020/10/25.
//
#include <io/GUI.h>
#ifndef RUIOS_IO_H
#define RUIOS_IO_H

namespace IO {
	Screen screen;
	void init(void){
		screen.init();
		screen.bg(0x00ee0000);
	}
}

#endif //RUIOS_IO_H
