ENTRY(_start)

SECTIONS
{
    . = 2M; // sets the offset at 2MB address for the kernel

    .text BLOCK(4K):ALIGN(4K) { /* makes sure that block is of 4 kb and aligned with 4096 bytes */
        *(.multiboot) /* this makes sure that the multiboot header is at the starting of the file */
        *(.text) /* this is section is where the kernel is called and all */
    }

    /* read-only data */
    .rodata BLOCK(4K):ALIGN(4K){
        *(.rodata) /* section where read-only data is stored */
    }

    /* read-write data */
    .data BLOCK(4K):ALIGN(4K){
        *(.data)
    }

    .bss BLOCK(4K):ALIGN(4K){
        *(COMMON)
        *(.bss)
    }
}
