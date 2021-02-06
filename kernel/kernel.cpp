#include <system.h>
#include <mm/mm.h>
#include <pm/pm.h>
#include <io/io.h>

PUBLIC void Start_Kernel(){
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