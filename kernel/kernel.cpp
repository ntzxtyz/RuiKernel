#include <mm/mm.h>
#include <pm/pm.h>
#include <io/io.h>

extern"C" void Start_Kernel(){
    while(1)
        ;
    //init memory struction
    MM::MemoryManager mm;
    mm.init();
    /*

    //init io port and interrupt
    IO::DeviceManager dm;
    
    //make higher process manage
    PM::ProcessManager pm;
    */
}
