/* MULTIBOOT CONSTANTS */
.set ALIGN, 1<<16  /* the 16th bit of the FLAGS is the alignment bit -
                      it makes sure that the modules are loaded at memories
                      divisible by 4K or are of 4096 bytes size */

.set MEMINFO, 1<<2 /* tells to give the complete memory map ( what all
                    memory in the system is free to use */

.set FLAGS, ALIGN|MEMINFO
.set MAGIC, 0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)

.section .multiboot
    .align 4 /* this makes sure that this section and values are
             loaded at addresses divisible by 4 */

    .long MAGIC /* .long means 32-bit values */
    .long FLAGS
    .long CHECKSUM

.section .bss /* This is the setting up of the stack for the kernel
                 so that it can store call back addresses and local
                 uninitialized variables */
    .align 16  /* aligns the stack bottom to multiple of 16 address */
    stack_bottom:
        .skip 16384 /* jumps 16 kbs upwards in memory and fill it with 0's */
    stack_top:


/* Kernel entry point */
.section .text
.global _start /* makes the _start variable visible to the outside world (linker file) */
.type _start,@function /* tells the assembler that _start is a function and not data */

_start:
    mov $stack_top,%esp /* copies the address of stack_top to esp register- aligns the register to our pre-defined stack */
    call kernel_main /* calls the main function */
    cli /* prevents hardware interrupts while the kernel is running */
1:  hlt /* puts the CPU in low power mode when nothing is to be performed */
    jmp 1b /* jumps back to label 1 backwards */

    size _start, . - _start /* tells the assembler the size of the _start function */
