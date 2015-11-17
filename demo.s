# HappyJon Demo
#
# Produced using "68k Mac boot floppy example" template
#
# Boot block header based on first/first.S
# from http://emile.sourceforge.net/
#

# The ROM loads this many bytes from the start of the disk.
.equ stage1_size, 1024

# Define ScrnBase, location in memory containing the start of video memory
.equ ScrnBase, 0x0824

# Macro to define a Pascal string
.macro pString string
pstring_begin_\@:
        .byte   pstring_end_\@ - pstring_string_\@ - 1
pstring_string_\@:
        .string "\string"
pstring_end_\@:
        .fill 16 - (pstring_end_\@ - pstring_begin_\@) , 1, 0
.endm

begin:

ID:          .short  0x4C4B              /* boot blocks signature */
Entry:       bra     start               /* entry point to bootcode */
Version:     .short  0x4418              /* boot blocks version number */
PageFlags:   .short  0x00                /* used internally */
SysName:     pString "Face Demo     "    /* System filename */
ShellName:   pString "Face Demo     "    /* Finder filename */
Dbg1Name:    pString "Face Demo     "    /* debugger filename */
Dbg2Name:    pString "Face Demo     "    /* debugger filename */
ScreenName:  pString "Face Screen   "    /* name of startup screen */
HelloName:   pString "Face          "    /* name of startup program */
ScrapName:   pString "Scrap         "    /* name of system scrap file */
CntFCBs:     .short  10                  /* number of FCBs to allocate */
CntEvts:     .short  20                  /* number of event queue elements */
Heap128K:    .long   0x00004300          /* system heap size on 128K Mac */
Heap256K:    .long   0x00008000          /* used internally */
SysHeapSize: .long   0x00020000          /* system heap size on all machines */

start:
	/* movel	#0x3FA700, %a0 */ /* Start of framebuffer on 4MB Plus */
	movel	(ScrnBase), %a0

	/* clear screen */
	movel	#0x00000000, %d0
	movel	#5472, %d1
clear_loop:
	movel	%d0, (%a0)+
	subi	#1, %d1
	bne	clear_loop

	/* Reset vars for image drawing: */
	lea	buffer, %a1 /* Image data */
	movel	(ScrnBase), %a0
	addal	#7388, %a0 /* Offset to place 64x64 image in center of display */
	movew	#127, %d1
fill_loop:

	movel	(%a1)+, %d0
	movel	%d0, (%a0)+

	/* mod buffer count to find offset and shift memory */
	movel	%d1, %d3
	divuw	#2, %d3
	andil	#0xFFFF0000, %d3
	bne	check_dec

	addal	#56, %a0	/* Move to next line */

check_dec:
	subi	#1, %d1
	bne	fill_loop

	/* One more time! */
	movel	(%a1)+, %d0
	movel	%d0, (%a0)+

	/* Set up an animation / prog indicator: */
	addal	#56, %a0	/* Move to next line */
	movel	#0xFF000000, %d0

end_loop:
	movel	%d0, (%a0)
	rorl	#1, %d0
	movel	#10000, %d1
delay_loop:
	nop
	subi	#1, %d1
	bne	delay_loop
	bra	end_loop
end:

buffer:
	dc.l 0b00000000000000000000000000100001
	dc.l 0b11111100000000000000000000000000
	dc.l 0b00000000000000000000000000000011
	dc.l 0b11111100000000000000000000000000
	dc.l 0b00000000000000000000000000111111
	dc.l 0b11111110000000000000000000000000
	dc.l 0b00000000000000000000000001110000
	dc.l 0b01111110000000000000000000000000
	dc.l 0b00000000000000000000000011110111
	dc.l 0b11111111111000000000000000000000
	dc.l 0b00000000000000000000000111010011
	dc.l 0b11111111111100000000000000000000
	dc.l 0b00000000000000000000001110000100
	dc.l 0b11111111111100000000000000000000
	dc.l 0b00000000000000000011111111111111
	dc.l 0b11111101111111100000000000000000
	dc.l 0b00000000000000000001111111111111
	dc.l 0b11111100001111110000000000000000
	dc.l 0b00000000000000000111111111111111
	dc.l 0b11111110000011100000000000000000
	dc.l 0b00000000000000001111111101111111
	dc.l 0b11111101001101111000000000000000
	dc.l 0b00000000000000001111111111111111
	dc.l 0b11111011010000011110000000000000
	dc.l 0b00000000000000001111111111111111
	dc.l 0b11111111111001011110000000000000
	dc.l 0b00000000000000011111111111111111
	dc.l 0b11111111110110011110000000000000
	dc.l 0b00000000000000011111011111111111
	dc.l 0b11111111111101100111000000000000
	dc.l 0b00000000000000011111111111111111
	dc.l 0b10111110111101110111000000000000
	dc.l 0b00000000000000111111011111110000
	dc.l 0b00000000001110111011000000000000
	dc.l 0b00000000000000111110111111000000
	dc.l 0b00000000000111110001000000000000
	dc.l 0b00000000000000100011111110000000
	dc.l 0b00000000000001111010000000000000
	dc.l 0b00000000000001101111111100000000
	dc.l 0b00000000000000111110000000000000
	dc.l 0b00000000000001100111110000000000
	dc.l 0b00000000000000111111000000000000
	dc.l 0b00000000000001011111000000000000
	dc.l 0b00000000000000011111000000000000
	dc.l 0b00000000000001011111000000000000
	dc.l 0b00000000000000011111100000000000
	dc.l 0b00000000000000101111000000000000
	dc.l 0b00000000000000011111000000000000
	dc.l 0b00000000000000111111100000000000
	dc.l 0b00000000000000011110100000000000
	dc.l 0b00000000000000110111100000000000
	dc.l 0b00000000000000011111100000000000
	dc.l 0b00000000000000110011100000000000
	dc.l 0b00000000000000001111100000000000
	dc.l 0b00000000000000111011100000000000
	dc.l 0b00000000000000011110000000000000
	dc.l 0b00000000000000111111100001000000
	dc.l 0b00000000000000011111000000000000
	dc.l 0b00000000000000111110011100101000
	dc.l 0b00000111000000110111000000000000
	dc.l 0b00000000000000111000110011111111
	dc.l 0b11100001000111111100000000000000
	dc.l 0b00000000000000111111011101101111
	dc.l 0b00100011110101101110000000000000
	dc.l 0b00000000000000111111000000000110
	dc.l 0b00110000000001001010000000000000
	dc.l 0b00000000000000010110100000000110
	dc.l 0b00000000000001001010000000000000
	dc.l 0b00000000000000010110110000000110
	dc.l 0b00010000000010001000000000000000
	dc.l 0b00000000000000000110000011110010
	dc.l 0b00001111111000010000000000000000
	dc.l 0b00000000000000001110000000000110
	dc.l 0b00000000000000010100000000000000
	dc.l 0b00000000000000010111000000001100
	dc.l 0b00000000000000010100000000000000
	dc.l 0b00000000000000010111000000001100
	dc.l 0b00000000000000010000000000000000
	dc.l 0b00000000000000010111000000001110
	dc.l 0b00000000000000010100000000000000
	dc.l 0b00000000000000001111000000000011
	dc.l 0b00000000000000010100000000000000
	dc.l 0b00000000000000000111000000000000
	dc.l 0b00000000000000010000000000000000
	dc.l 0b00000000000000000111000011000100
	dc.l 0b00000000000000010000000000000000
	dc.l 0b00000000000000000111000010111110
	dc.l 0b00000000000000110000000000000000
	dc.l 0b00000000000000000111000000110000
	dc.l 0b00000100000000110000000000000000
	dc.l 0b00000000000000000111000000001110
	dc.l 0b00001000000000110000000000000000
	dc.l 0b00000000000000000001100000000001
	dc.l 0b11100000000000100000000000000000
	dc.l 0b00000000000000000001100000000000
	dc.l 0b00000000000001100000000000000000
	dc.l 0b00000000000000000001110000000000
	dc.l 0b00000000000011100000000000000000
	dc.l 0b00000000000000000001111010000000
	dc.l 0b00000000000111000000000000000000
	dc.l 0b00000000000000000001111110000000
	dc.l 0b00000000000110000000000000000000
	dc.l 0b00000000000000000011111111000000
	dc.l 0b00000000000100000000000000000000
	dc.l 0b00000000000000000101111111100000
	dc.l 0b00000111001100000000000000000000
	dc.l 0b00000000000000001011111111110000
	dc.l 0b00001111111000100100000000000000
	dc.l 0b00000000000000010011011111110000
	dc.l 0b00001111110000100001000000000000
	dc.l 0b00000000000001000111011111111111
	dc.l 0b10111111100000000000000000000000
	dc.l 0b00000000000000000111011111111111
	dc.l 0b11111110000000100000000010000000
	dc.l 0b00000000000010001111001111111111
	dc.l 0b11111100000000100000000000000000
	dc.l 0b00000001001100001111000101111111
	dc.l 0b11111100000000100000000000000100
	dc.l 0b00001000011100001111000000111111
	dc.l 0b11110000000000000000001000000000
	dc.l 0b01000000111100000111000000000011
	dc.l 0b11000000000000000000000111000000
	dc.l 0b00000011111000000011100000000000
	dc.l 0b00000000000000000000000111111000
	dc.l 0b00000111111000000011100000000000
	dc.l 0b00000000000000000000000011111100
	dc.l 0b00011111110000000011100000000000
	dc.l 0b00000000000001010000000011111111

# repeated for padding:

	dc.l 0b00000000000000000000000000100001
	dc.l 0b11111100000000000000000000000000
	dc.l 0b00000000000000000000000000000011
	dc.l 0b11111100000000000000000000000000
	dc.l 0b00000000000000000000000000111111
	dc.l 0b11111110000000000000000000000000
	dc.l 0b00000000000000000000000001110000
	dc.l 0b01111110000000000000000000000000
	dc.l 0b00000000000000000000000011110111
	dc.l 0b11111111111000000000000000000000
	dc.l 0b00000000000000000000000111010011
	dc.l 0b11111111111100000000000000000000
	dc.l 0b00000000000000000000001110000100
	dc.l 0b11111111111100000000000000000000
	dc.l 0b00000000000000000011111111111111
	dc.l 0b11111101111111100000000000000000
	dc.l 0b00000000000000000001111111111111
	dc.l 0b11111100001111110000000000000000
	dc.l 0b00000000000000000111111111111111
	dc.l 0b11111110000011100000000000000000
	dc.l 0b00000000000000001111111101111111
	dc.l 0b11111101001101111000000000000000
	dc.l 0b00000000000000001111111111111111
	dc.l 0b11111011010000011110000000000000
	dc.l 0b00000000000000001111111111111111
	dc.l 0b11111111111001011110000000000000
	dc.l 0b00000000000000011111111111111111
	dc.l 0b11111111110110011110000000000000
	dc.l 0b00000000000000011111011111111111
	dc.l 0b11111111111101100111000000000000
	dc.l 0b00000000000000011111111111111111
	dc.l 0b10111110111101110111000000000000
	dc.l 0b00000000000000111111011111110000
	dc.l 0b00000000001110111011000000000000
	dc.l 0b00000000000000111110111111000000
	dc.l 0b00000000000111110001000000000000
	dc.l 0b00000000000000100011111110000000
	dc.l 0b00000000000001111010000000000000
	dc.l 0b00000000000001101111111100000000
	dc.l 0b00000000000000111110000000000000
	dc.l 0b00000000000001100111110000000000
	dc.l 0b00000000000000111111000000000000
	dc.l 0b00000000000001011111000000000000
	dc.l 0b00000000000000011111000000000000
	dc.l 0b00000000000001011111000000000000
	dc.l 0b00000000000000011111100000000000
	dc.l 0b00000000000000101111000000000000
	dc.l 0b00000000000000011111000000000000
	dc.l 0b00000000000000111111100000000000
	dc.l 0b00000000000000011110100000000000
	dc.l 0b00000000000000110111100000000000
	dc.l 0b00000000000000011111100000000000
	dc.l 0b00000000000000110011100000000000
	dc.l 0b00000000000000001111100000000000
	dc.l 0b00000000000000111011100000000000
	dc.l 0b00000000000000011110000000000000
	dc.l 0b00000000000000111111100001000000
	dc.l 0b00000000000000011111000000000000
	dc.l 0b00000000000000111110011100101000
	dc.l 0b00000111000000110111000000000000
	dc.l 0b00000000000000111000110011111111
	dc.l 0b11100001000111111100000000000000
	dc.l 0b00000000000000111111011101101111
	dc.l 0b00100011110101101110000000000000
	dc.l 0b00000000000000111111000000000110
	dc.l 0b00110000000001001010000000000000
	dc.l 0b00000000000000010110100000000110
	dc.l 0b00000000000001001010000000000000
	dc.l 0b00000000000000010110110000000110
	dc.l 0b00010000000010001000000000000000
	dc.l 0b00000000000000000110000011110010
	dc.l 0b00001111111000010000000000000000
	dc.l 0b00000000000000001110000000000110
	dc.l 0b00000000000000010100000000000000
	dc.l 0b00000000000000010111000000001100
	dc.l 0b00000000000000010100000000000000
	dc.l 0b00000000000000010111000000001100
	dc.l 0b00000000000000010000000000000000
	dc.l 0b00000000000000010111000000001110
	dc.l 0b00000000000000010100000000000000
	dc.l 0b00000000000000001111000000000011
	dc.l 0b00000000000000010100000000000000
	dc.l 0b00000000000000000111000000000000
	dc.l 0b00000000000000010000000000000000
	dc.l 0b00000000000000000111000011000100
	dc.l 0b00000000000000010000000000000000
	dc.l 0b00000000000000000111000010111110
	dc.l 0b00000000000000110000000000000000
	dc.l 0b00000000000000000111000000110000
	dc.l 0b00000100000000110000000000000000
	dc.l 0b00000000000000000111000000001110
	dc.l 0b00001000000000110000000000000000
	dc.l 0b00000000000000000001100000000001
	dc.l 0b11100000000000100000000000000000
	dc.l 0b00000000000000000001100000000000
	dc.l 0b00000000000001100000000000000000
	dc.l 0b00000000000000000001110000000000
	dc.l 0b00000000000011100000000000000000
	dc.l 0b00000000000000000001111010000000
	dc.l 0b00000000000111000000000000000000
	dc.l 0b00000000000000000001111110000000
	dc.l 0b00000000000110000000000000000000
	dc.l 0b00000000000000000011111111000000
	dc.l 0b00000000000100000000000000000000
	dc.l 0b00000000000000000101111111100000
	dc.l 0b00000111001100000000000000000000
	dc.l 0b00000000000000001011111111110000
	dc.l 0b00001111111000100100000000000000
	dc.l 0b00000000000000010011011111110000
	dc.l 0b00001111110000100001000000000000
	dc.l 0b00000000000001000111011111111111
	dc.l 0b10111111100000000000000000000000
	dc.l 0b00000000000000000111011111111111
	dc.l 0b11111110000000100000000010000000
	dc.l 0b00000000000010001111001111111111
	dc.l 0b11111100000000100000000000000000
	dc.l 0b00000001001100001111000101111111
	dc.l 0b11111100000000100000000000000100
	dc.l 0b00001000011100001111000000111111
	dc.l 0b11110000000000000000001000000000
	dc.l 0b01000000111100000111000000000011
	dc.l 0b11000000000000000000000111000000
	dc.l 0b00000011111000000011100000000000
	dc.l 0b00000000000000000000000111111000
	dc.l 0b00000111111000000011100000000000
	dc.l 0b00000000000000000000000011111100
	dc.l 0b00011111110000000011100000000000
	dc.l 0b00000000000001010000000011111111
