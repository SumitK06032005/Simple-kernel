/* The command to link the kernel is : i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc */
/* The command for running the image on qemu is :qemu-system-i386 -kernel myos.bin */
/* The bootloader looks at this image and start exection at the symbol
designated as the entry point */

ENTRY(_start)
/* Tells where the various sections will be put in the final kernel image*/
SECTIONS
{
    /* setting the start offset */
    . = 0x200000;
    /* specifies starting address of section as 2MB from the beginning of the memory region */

    /* First put the multiboot header, as it is required to be put very early
    , otherwise the bootloader won't recognize the file format, next will be the .text section */

    .text BLOCK(4K) : ALIGN(4K)
    {
        *(.multiboot)
        *(.text)
    }

    /* read-only data */
    .rodata BLOCK(4K) : ALIGN(4K)
    {
        *(.rodata)
    }

    /* read-write data (initilaized) */
    .data BLOCK(4K) : ALIGN(4K)
    {
        *(.data)
    }

    /* read-write data (uninitialized) */
    .bss BLOCK(4K) : ALIGN(4K)
    {
        *(COMMON)
        *(.bss)
    }

}
