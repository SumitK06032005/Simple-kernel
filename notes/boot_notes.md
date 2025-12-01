### Notes for the multiboot header file while I research about it and how to write it 

When we turn on the PC a special software automatically runs - BIOS.  
BIOS comes bundled with the computer and is located in ROM. The BIOS and the computer are hardwired to each other and the BIOS cannot be changed or modified.  

There are 3 files in the kernel:
- kernel.c 
- boot.S  
- multiboot.h  

The main difference in boot.S and multiboot.h is that boot.S is in assembly and is the entry point for the kernel as it takes the end point of the bootloader and attaches that to the kernel to make the env ready for high languages.  
Whereas the file multiboot.h is a header file written in c or a higher language that attaches to the kernel file while compiling and linking to tell the bootloader that this is the kernel and to run it.  

##### The booting process:  

- The first thing that the BIOS does is run a 'POST' or power-on self test - this checks whether all the hardware(BIOS itself,CPU registers,RAM,etc) that the computer needs are available and run together well.  
- The BIOS then automatically starts the booting process after everything is working according to the POST.It finds a "bootable drive" that can complete the booting process in certain pre-defined places(the first sector of the drives), checks the size of it (512kb) and looks for a magic number in it(0xaa00).  
- The program that boots the PC is called the bootloader. It's main function is to take the kernel, put it into memory and transfer control to it.  

##### GRUB and Multiboot:
- GRUB stands for "grand unified bootloader". It implements a specification called multiboot. It is a set of conventions for how a kernel should get loaded into memory.  

##### The code :
- The header file contains only data and not code.  
- The magic number - 0xe85250d6 - it is declared using the syntax - dd 0xe85250d6  
- dd 0 - declares the mode as protected (32-bit mode).  
- dd header_end - header_start - stores the length of the header (header_start and header_end are labels that define the start and end of the header file).  

- dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start)) - it checks the sum of some numbers and then use that to check that they're all what we expected things to be.  
- The ending tag - after checksum we list a series of "tags", which is a way for the OS to tell the bootloader to do some extra things before handing control over to the OS, or to give the OS some extra info once started (like memory info, sys info etc.).  
- example of end tag : dw 0 ;type, dw 0 ;flags, dd 8 ; size  

- The section - add a section annotation.



