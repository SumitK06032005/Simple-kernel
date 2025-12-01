/* The kernel entry point that sets up the processor environment*/
/* MULTIBOOT CONSTANTS */

/* defines ALIGN as the value 1 (1<<0 means shifting the binary 1 to the left by 0 positions */
.set ALIGN, 1<<0

/* defines MEMINFO as 2 (left shifting 1 by 1 position resulting to 010(2))
flag requests the bootloader to provide a memory map when it passes control to the kernel, essential for memory management */
.set MEMINFO, 1<<1

/* defines FLAGS as the OR of ALIGN & MEMINFO that gives it the value 3 (001 OR 010 = 011(3)) */
.set FLAGS, ALIGN|MEMINFO

/* defines MAGIC as 0x1BADB002 - the bootloader searches for this exact 32-bit signature
to identify a multiboot-compliant kernel */
.set MAGIC, 0x1BADB002

/* defines CHECKSUM that the sum of the above stuff must be equal to 0 as another layer of checking
if its in multiboot or not */
.set CHECKSUM, -(MAGIC + FLAGS)


/* MULTIBOOT HEADER DEFINITION */

/* .section is like saying that this thing is like a file that is labelled
the name written after it */
.section .multiboot

/* Ensures that following data is aligned to a 4 byte or 32-bit boundary, which is a
requirement for the header fields */
.align 4

/* Places the MAGIC number into the file */
.long MAGIC

/* Places the FLAGS constant (3) into the file , declaring the kernel's requests */
.long FLAGS

/* Places the CHECKSUM into the file completing the integrity check */
.long CHECKSUM


/* STACK SETUP */

/* This section allocated the memory for the kernel's stack which is mandatory
before C code can execute */

/* Starts the BSS(Block starting by symbol) section. This section contains uninitialized
data that is stored in memory but not the final kernel file, saving space - ex. int x; (Here x will be stored in .bss)*/
.section .bss

/* VERY IMPORTANT : Aligns the following data on a 16-byte boundary (cause the standards require the stack to be 16-byte
aligned before any function call */
.align 16

/* Points to the lowest address of the stack */
stack_bottom:

/* reserves 16-byte space for the stack and also defines the base address of the stack
that is at the top and the addresses then go downwards till the last bit (the stack_top) */
    .skip 16384
stack_top:

/* KERNEL ENTRY POINT */

/* starts the .text section */
.section .text

/* makes _start a global symbol, making it the linker's entry point */
.global _start

/* Provides metadata to the assembler/linker that _start is a function */
.type _start, @function

/* Physical address where the CPU starts executing the kernel */
_start:

    /* Moves the address of the stack_top to esp register allowing C to start executing */
    mov $stack_top, %esp

    /* Transfers control to the C function kernel */
    call kernel_main

/* Clears interrupts, disables hardware interrupts - the first step towards halting the CPU */
    cli

    /* Stops the CPU when the kernel function has finished executing and the CPU has nothing new to
    do */
1:    hlt
    jmp 1b

/* A debugging directive that records the size of the _start function */
.size _start, . - _start
