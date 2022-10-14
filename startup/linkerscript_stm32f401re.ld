ENTRY(Reset_handler)

/** Define Top of Stack **/
__estack = 0x20000000 + 96K;

/** Memory **/
MEMORY
{
    SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 96K
    FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 512K 
}

/** Memory Sections **/
SECTIONS
{
    /**
    .isr_vector :
    {
        KEEP(*(.isr_vector))
    }> FLASH
    **/

    .text :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        *(.text)
        *(.text.*)
        *(.init)
        *(.fini)
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
        __etext = .;
    }> FLASH

    /** Load Real Address of .data **/
    __load_addr_data = LOADADDR(.data);
    .data :
    {
        . = ALIGN(4);
        __sdata = .;
        *(.data)
        *(.data.*)
        . = ALIGN(4);
        __edata = .;
    }> SRAM AT>FLASH

    .bss :
    {

        . = ALIGN(4);
        __sbss = .;
        __bss_start__ = __sbss;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        __ebss = .;
        __bss_end__ = __ebss;
        . = ALIGN(4);
        end = .;
        __end__ = .;
    }> SRAM
}
