#include "mm/mm.h"

namespace main{
	extern "C" void Start_Kernel(){
		MM::init();
		while (1)
			;
	}
}
