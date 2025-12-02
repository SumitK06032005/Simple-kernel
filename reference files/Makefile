# Makefile — perfect for your current kernel (tested with gcc 15.2.0 + binutils 2.45)

# Tools
CC      = i686-elf-gcc
AS      = i686-elf-as
LD      = i686-elf-gcc
OBJCOPY = i686-elf-objcopy

# Flags
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib -lgcc

# Files
BOOT    = boot.s
KERNEL  = kernel.c
OBJS    = boot.o kernel.o

# Default target (run "make" with no argument)
all: myos.bin

# Build the final kernel image
myos.bin: $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS)

# Assemble the bootloader
boot.o: $(BOOT)
	$(AS) $(BOOT) -o boot.o

# Compile the C kernel
kernel.o: $(KERNEL)
	$(CC) $(CFLAGS) -c $(KERNEL) -o kernel.o

# Run in QEMU (i386, 32-bit)
run: myos.bin
	qemu-system-i386 -kernel myos.bin

# Run with extra debugging options (serial output + gdb server)
debug: myos.bin
	qemu-system-i386 -kernel myos.bin -s -S -serial stdio

# Clean everything
clean:
	rm -f myos.bin *.o

# Optional: rebuild everything from scratch
rebuild: clean all

# Tell make that these are not real files
.PHONY: all run debug clean rebuild
