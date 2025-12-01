/* Prints something on the screen */

// command to compile it using the cross compiler : i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

#include <stdbool.h> // Includes standard boolen types
#include <stddef.h> // Includes standard definitions (most importantly size_t - unsigned type used for sizes and counts)
#include <stdint.h> // Includes fixed-width integer types (uint8_t, uint16_t,etc.) used for low level memory access

// Compiler check - Check if the compiler thinks you are targeting the wrong operating system
// Basically I am using a cross compiler and we dont want the compiler to compile my host system's kernel!
#if defined(__linux__)
#error "You are not using a cross-compiler...."
#endif

// Checks if the target arch is not 32-bit x86
#if !defined(__i386__)
#error "This is only for 32-bit x86 arch!"
#endif


// VGA COLOR DEFINITIONS
// Hardware text mode color constants
// enum is a user-defined data type that contains a set of named constants
// a variable can only have a single value out of all the defined constants (prevents giving undefined values)
enum vga_color {
    VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

// A utility function that combines the foreground(text) and background colors
// into a single 8-bit value (The Attribute byte)
static inline uint8_t vga_entry_color(enum vga_color fg,enum vga_color bg)
{
    return fg | bg << 4; // VGA bit layout - the lower bits are for foregrond and the
                         // upper bits are for bg (thus we use bg<<4 to push it to the upper bits)
}

// VGA ENTRY CONSTRUCTIONS AND STD LIBRARY
// Function to combine char and its color into a 16 bit value , this is what is stored in VGA memory
static inline uint16_t vga_entry(unsigned char uc, uint8_t color)
{
    return (uint16_t) uc | (uint16_t) color << 8; // VGA lower 8 bits are the char and upper 8 bits are the color (attribute 8 bits)
}

// Calculates the length of a null-terminated string(str)
size_t strlen(const char* str)
{
    size_t len=0;
    while (str[len]) // iterates till it encounters the null operator
        len++;
    return len;
}

// TERMINAL STATE AND VARIABLES
// Global variables used to manage the terminal state

// Defines constants standard VGA dimensions width and height as 80 and 25 respectively
static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

// Current Y coordinate
size_t terminal_row;

// Current X coordinate
size_t terminal_column;

// Stores the attribute 8-bit value
uint8_t terminal_color;

// IMPORTANT : a pointer to the base address of VGA memory
uint16_t* terminal_buffer;

// TERMINAL DRIVER FUNCTIONS
// Functions for initializing,setting color, and printing single characters/strings

void terminal_initialize(void)
{
    terminal_row=0;
    terminal_column=0;
    terminal_color=vga_entry_color(VGA_COLOR_LIGHT_GREY,VGA_COLOR_BLACK); // Sets the values for the color when it starts
    terminal_buffer = (uint16_t*) 0xB8000; // sets the base address of the VGA memory

    for (size_t y=0;y<VGA_HEIGHT;y++){ // For looping through all the vertical coordinates
        for (size_t x=0;x<VGA_WIDTH;x++){ // For looping throught all the horizontal coordinates
            const size_t index = x + (y*VGA_WIDTH);
            terminal_buffer[index] = vga_entry(' ',terminal_color); // Writes the space character in every cell to clear the screen
        }
    }
}

void terminal_setcolor(uint8_t color){ // Updates the terminal_color var for future chars
    terminal_color = color;
}

// Writes a single char at a specific coordinate
void terminal_putentryat(char c, uint8_t color,size_t x, size_t y){
    const size_t index = x+y*VGA_WIDTH;
    terminal_buffer[index] = vga_entry(c,color);
}

// Writes a single char at the current cursor position and moves the cursor
void terminal_putchar(char c){
    terminal_putentryat(c,terminal_color, terminal_column, terminal_row);
    if (++terminal_column == VGA_WIDTH){
        terminal_column=0;
        if (++terminal_row == VGA_HEIGHT){
            terminal_row=0;
        }
    }
}

void terminal_write(const char* data, size_t size){
    for (size_t i=0;i<size;i++){
        terminal_putchar(data[i]);
    }
}

void terminal_writestring(const char* data){
    terminal_write(data, strlen(data));
}

void kernel_main(void){
    terminal_initialize();
    terminal_writestring("Hello World");
}
