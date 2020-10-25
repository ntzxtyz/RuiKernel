//
// Created by taishang on 2020/10/25.
//

#ifndef RUIOS_GUI_H
#define RUIOS_GUI_H
#pragma pack(1)
struct BufferInfo {
	unsigned int addr;
	unsigned int width, height;
};
#pragma pack()
struct Screen {
	unsigned *fb, width, height;
	void init(void) {
		BufferInfo *info = (BufferInfo *) 0x7000;
		fb = (unsigned *) info->addr;
		width = info->width;
		height = info->height;
	}
	void paint(unsigned x, unsigned y, unsigned color) {
		fb[x * width + y] = color;
	}
	void bg(unsigned color) {
		for (int i = 0; i < width * height; i ++)
			fb[i] = color;
	}
};

#endif //RUIOS_GUI_H
