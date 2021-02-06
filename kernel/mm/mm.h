namespace MM{

    struct mm_struct
    {
        unsigned long code_start, code_end, data_start, data_end;
        unsigned long rodata_start, rodata_end, bss_start, bss_end;
        unsigned long stack_start, heap_start;
    };

    struct heap_manager
    {
        
    };

    struct MemoryManager
    {
        char PhMm[16 * 1024 / 2];
        void init(){
            
        }
    };
    
}