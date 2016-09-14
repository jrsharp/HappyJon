# HappyJon Demo
#
# Produced using "68k Mac boot floppy example" template
#
# Boot block header based on first/first.S
# from http://emile.sourceforge.net/
#

# The ROM loads this many bytes from the start of the disk.
.equ stage1_size, 1024
.equ sector_size, 512
.equ first_level_size, sector_size * 2

.include "macos.i"

# Define ScrnBase, location in memory containing the start of video memory
.equ ScrnBase, 0x0824

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

/* Include driver for floppy drive access */
.include "floppy.i"

/* link to C lib */
.extern	getChar
.extern	getOffset
.extern	doSomething
.extern	font_data
.extern	rand
.extern	abs
.extern	getNumber
.global draw_char
.global drawstr

.align	4
start:

	moveal SysZone,%a0
	addal %pc@(SysHeapSize),%a0
	SetApplBase
	movel SysZone,TheZone

	/* buffer size to store second stage booter */

	get_second_size %d0

	/* Allocate Memory for second stage loader */

/*
	add.l	#4, %d0
	NewPtr
	move.l	%a0, %d0
	bne	malloc_ok
	move.l	#1, %d0
	SysError
malloc_ok:
*/
	move.l	0x300000, %a0
	add.l	#3, %d0
	and.l	#0xFFFFFFFC.l, %d0

	/* load second stage */
	load_second

	/* call second stage bootloader */
	/*move.l	0x300400, %a0*/
	move.l	%a0, %d0
	swap	%d0
	/*
	SysError
	*/
	jmp	(%a0)

PRAM_buffer:
	.long	0
end:

# pad:
	.fill first_level_size - (end - begin), 1, 0xda

/* Start the framebuffer stuff: */
start_fb:

/*
	move.l	#0xFF, %d0
	SysError
	*/

	/* movel	#0x3FA700, %a0 */ /* Start of framebuffer on 4MB Plus */
	movel	(ScrnBase), %a0

	/*
	movel	(ApplZone), %a0
	movel	%a0, %d0
	swap %d0
	SysError
	*/

	/* clear screen */
	movel	#0x00000000, %d0
	movel	#5472, %d1
clear_loop:
	movel	%d0, (%a0)+
	subi	#1, %d1
	bne	clear_loop

	lea	message2(%pc), %a3
	movel	#24, %d1
	movel	#12, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#1, %d1
	movel	#2, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#0, %d1
	movel	#18, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#40, %d1
	movel	#19, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#10, %d1
	movel	#3, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#30, %d1
	movel	#5, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#40, %d1
	movel	#6, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#32, %d1
	movel	#7, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#20, %d1
	movel	#4, %d2
	jsr	draw_string

	lea	message3(%pc), %a3
	movel	#25, %d1
	movel	#8, %d2
	jsr	draw_string

	movel	#'a', %d0
	movel	#0, %d1
	movel	#0, %d2
	jsr	draw_char

	movel	#'b', %d0
	movel	#0, %d1
	movel	#25, %d2
	jsr	draw_char

	movel	#'c', %d0
	movel	#101, %d1
	movel	#0, %d2
	jsr	draw_char

/*
	move.l	#0x00002468, %d0
	SysError

*/
/*
	jsr getNumber(%pc)
	movel	#'d', %d0
*/
	movel	#101, %d1
	movel	#25, %d2
	jsr	draw_char

	jsr doSomething(%pc)

	movel	#3, %d7
end_loop:
	movel	(ScrnBase), %a2
	addal	#30, %a2
	/*
	movel	keymap, -(%sp)
	GetKeys
	movel	(keymap), %d0
	*/
	movel	(0x0174), %d0
	notl	%d0
	movel	%d0, (%a2)
	addal	#64, %a2
	movel	(0x0175), %d0
	notl	%d0
	movel	%d0, (%a2)
	addal	#64, %a2
	movel	(0x0176), %d0
	notl	%d0
	movel	%d0, (%a2)
	addal	#64, %a2
	movel	(0x0177), %d0
	notl	%d0
	movel	%d0, (%a2)

	nop
	nop
	nop
	nop

	jsr	get_key
	tst	%d0

	beq	no_key

	movel	%d7, %d1
	movel	#25, %d2
	jsr	draw_char
no_key:

	nop
	nop
	nop
	nop
	nop
	jmp	end_loop

keymap:
	dc.l 0x00000000
	dc.l 0x00000000
	dc.l 0x00000000
	dc.l 0x00000000

/* draw_char: draws an ASCII char at x/y loc in framebuffer using 5x13 font:
 *
 *   params:
 * 	d0 - char value
 *	d1 - x value
 *	d2 - y value
 */

draw_char:
	movel	%d7, -(%sp)
	movel	%d2, -(%sp)
	movel	%d1, -(%sp)

	movel	(ScrnBase), %a0
	mulsw	#(13 * 64), %d2

	movel	%d1, %d5
	mulsw	#5, %d5
	divuw	#8, %d5
	movew	%d5, %d6
	addal	%d6, %a0

	lsrl	#8, %d5
	lsrl	#8, %d5

	cmp	#0, %d5
	beq	even_stevens
	/*addal	#1, %a0*/

even_stevens:
	addal	%d2, %a0

	sub	#32, %d0
	mulsw	#64, %d0

	/* Reset vars for image drawing: */
	lea	font_data(%pc), %a1 /* font data */
	addal	%d0, %a1 /* offset for font_data */

	movel	%d0, %d3

	movew	#13, %d1
fill_loop:

	movel	(%a1)+, %d0
	moveb	(%a0), %d7
	moveb	#0x80, %d2
	lsrb	%d5, %d0
	subb	#1, %d5
	asrb	%d5, %d2
	add	#1, %d5
	andb	%d2, %d7
	orb	%d7, %d0
	/*not	%d0*/
	moveb	%d0, (%a0)+
	/*moveb	%d0, (%a0)+*/

	addal	#63, %a0	/* Move to next line */

check_dec:
	subi	#1, %d1
	bne	fill_loop

check_overflow:
	cmp	#3, %d5
	blt	draw_done
	movew	#8, %d4
	sub	%d5, %d4
	
	sub	#((13 * 64) - 1), %a0

	lea	font_data(%pc), %a1 /* font data */
	addal	%d3, %a1 /* offset for font_data */

	movew	#13, %d1
fill_loop2:

	movel	(%a1)+, %d0
	moveb	(%a0), %d7
	moveb	#1, %d2
	aslb	%d4, %d2
	lslb	%d4, %d0
	andb	%d2, %d7
	orb	%d7, %d0
	/*not	%d0*/
	moveb	%d0, (%a0)+
	/*moveb	%d0, (%a0)+*/

	addal	#63, %a0	/* Move to next line */

check_dec2:
	subi	#1, %d1
	bne	fill_loop2

draw_done:

	movel	(%sp)+, %d1
	movel	(%sp)+, %d2
	movel	(%sp)+, %d7

	rts

/*
 * drawstr
 *
 * params:
 *	a0 - pointer to string
 *	d0 - x value
 *	d1 - y value
 */
drawstr:

	movel	(%sp)+, %a4
	movel	(%sp)+, %a3
	movel	(%sp)+, %d1
	movel	(%sp)+, %d2

drawstr_loop:
	moveb	(%a3)+, %d0
	andi	#0x000000FF, %d0
	movel	%d2, -(%sp)
	movel	%d1, -(%sp)
	movel	%d0, -(%sp)

	jsr	draw_char
	movel	(%sp)+, %d0
	movel	(%sp)+, %d1
	movel	(%sp)+, %d2
	add.l	#1, %d1
	cmp	#0, %d0
	bne	drawstr_loop
	
	movel	%a4, -(%sp)
	rts

/* draw_string: draws an ASCII char at x/y loc in framebuffer using 5x13 font:
 *
 *   params:
 *   	a3 - pointer to string
 *	d1 - x value
 *	d2 - y value
 */

draw_string:

draw_str_loop:
	movew	(%a3)+, %d0
	movel	%d2, -(%sp)
	movel	%d1, -(%sp)
	movel	%d0, -(%sp)

	jsr	draw_char
	movel	(%sp)+, %d0
	movel	(%sp)+, %d1
	movel	(%sp)+, %d2
	add.l	#1, %d1
	cmp	#0, %d0
	bne	draw_str_loop

	rts

/* check_bit: check the bit value of the KeyMap regs
 *
 * params:
 *
 *
 * returns:
 *	
 *	d0 - contains key (char) value matched. (0x00 for no match)
 */

get_key:
	movel	%d4, -(%sp)
	movel	%d3, -(%sp)
	movel	%d2, -(%sp)
	movel	%d1, -(%sp)
	movel	%a0, -(%sp)

	movel	#127, %d0
get_key_loop:
	movel	%d0, %d1
	divu	#8, %d1
	movel	%d1, %d3
	andl	#0x0000FFFF, %d3	/* d3 holds quotient */
	lsrl	#8, %d1
	lsrl	#8, %d1			/* d1 holds remainder */

r15:
	moveb	(KeyMap+15), %d2
	cmp	#15, %d3
	beq	token1
r14:
	moveb	(KeyMap+14), %d2
	cmp	#14, %d3
	beq	token1
r13:
	moveb	(KeyMap+13), %d2
	cmp	#13, %d3
	beq	token1
r12:
	moveb	(KeyMap+12), %d2
	cmp	#12, %d3
	beq	token1
r11:
	moveb	(KeyMap+11), %d2
	cmp	#11, %d3
	beq	token1
r10:
	moveb	(KeyMap+10), %d2
	cmp	#10, %d3
	beq	token1
r9:
	moveb	(KeyMap+9), %d2
	cmp	#9, %d3
	beq	token1
r8:
	moveb	(KeyMap+8), %d2
	cmp	#8, %d3
	beq	token1
r7:
	moveb	(KeyMap+7), %d2
	cmp	#7, %d3
	beq	token1
r6:
	moveb	(KeyMap+6), %d2
	cmp	#6, %d3
	beq	token1
r5:
	moveb	(KeyMap+5), %d2
	cmp	#5, %d3
	beq	token1
r4:
	moveb	(KeyMap+4), %d2
	cmp	#4, %d3
	beq	token1
r3:
	moveb	(KeyMap+3), %d2
	cmp	#3, %d3
	beq	token1
r2:
	moveb	(KeyMap+2), %d2
	cmp	#2, %d3
	beq	token1
r1:
	moveb	(KeyMap+1), %d2
	cmp	#1, %d3
	beq	token1
r0:
	moveb	(KeyMap), %d2

token1:
	movel	(ScrnBase), %a1
	movel	%d2, (%a1)
	addal	#64, %a1
	movel	%d1, (%a1)

/*
	andb	%d0, %d2
	cmp	#0, %d2
	*/
	btst	%d1, %d2
	bne	found_key

	subi	#1, %d0
	bne	get_key_loop

	movew	#0x0, %d0
	jmp	didnt_find_key

found_key:
	lea	scancodes, %a0
	mulsw	#2, %d1
	mulsw	#2, %d0
	add	%d1, %d0
	addal	%d0, %a0
	movew	(%a0), %d0
	
didnt_find_key:

	movel	(%sp)+, %a0
	movel	(%sp)+, %d1
	movel	(%sp)+, %d2
	movel	(%sp)+, %d3
	movel	(%sp)+, %d4

	rts

scancodes:
	dc.w 'a'
	dc.w 's'
	dc.w 'd'
	dc.w 'f'
	dc.w 'h'
	dc.w 'g'
	dc.w 'z'
	dc.w 'x'
	dc.w 'c'
	dc.w 'v'
	dc.w 'b'
	dc.w 'q'
	dc.w 'w'
	dc.w 'e'
	dc.w 'r'
	dc.w 'y'
	dc.w 't'
	dc.w '1'
	dc.w '2'
	dc.w '3'
	dc.w '4'
	dc.w '6'
	dc.w '5'
	dc.w '='
	dc.w '9'
	dc.w '7'
	dc.w '-'
	dc.w '8'
	dc.w '0'
	dc.w '}'
	dc.w 'o'
	dc.w 'u'
	dc.w '{'
	dc.w 'i'
	dc.w 'p'
	dc.w '\r'
	dc.w 'l'
	dc.w 'j'
	dc.w '"'
	dc.w 'k'
	dc.w ':'
	dc.w '\\'
	dc.w ','
	dc.w '/'
	dc.w 'n'
	dc.w 'm'
	dc.w '\s'
	dc.w '\t'
	dc.w ' '
	dc.w '~'
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '
	dc.w ' '

message:
	dc.w 0x48
	dc.w 0x65
	dc.w 0x6c
	dc.w 0x6c
	dc.w 0x6f
	dc.w 0x20
	dc.w 0x57
	dc.w 0x6f
	dc.w 0x72
	dc.w 0x6c
	dc.w 0x64
	dc.w 0x2e
	dc.w 0x00

message2:
	dc.w 0x57
	dc.w 0x65
	dc.w 0x6c
	dc.w 0x63
	dc.w 0x6f
	dc.w 0x6d
	dc.w 0x65
	dc.w 0x2e
	dc.w 0x20
	dc.w 0x54
	dc.w 0x6f
	dc.w 0x20
	dc.w 0x74
	dc.w 0x68
	dc.w 0x69
	dc.w 0x73
	dc.w 0x20
	dc.w 0x62
	dc.w 0x61
	dc.w 0x72
	dc.w 0x65
	dc.w 0x2d
	dc.w 0x6d
	dc.w 0x65
	dc.w 0x74
	dc.w 0x61
	dc.w 0x6c
	dc.w 0x20
	dc.w 0x4d
	dc.w 0x61
	dc.w 0x63
	dc.w 0x69
	dc.w 0x6e
	dc.w 0x74
	dc.w 0x6f
	dc.w 0x73
	dc.w 0x68
	dc.w 0x20
	dc.w 0x64
	dc.w 0x65
	dc.w 0x6d
	dc.w 0x6f
	dc.w 0x2e
	dc.w 0

/* Zelda might fix the job growth plans very quickly on Monday. */

message3:
	dc.w 0x5a
	dc.w 0x65
	dc.w 0x6c
	dc.w 0x64
	dc.w 0x61
	dc.w 0x20
	dc.w 0x6d
	dc.w 0x69
	dc.w 0x67
	dc.w 0x68
	dc.w 0x74
	dc.w 0x20
	dc.w 0x66
	dc.w 0x69
	dc.w 0x78
	dc.w 0x20
	dc.w 0x74
	dc.w 0x68
	dc.w 0x65
	dc.w 0x20
	dc.w 0x6a
	dc.w 0x6f
	dc.w 0x62
	dc.w 0x20
	dc.w 0x67
	dc.w 0x72
	dc.w 0x6f
	dc.w 0x77
	dc.w 0x74
	dc.w 0x68
	dc.w 0x20
	dc.w 0x70
	dc.w 0x6c
	dc.w 0x61
	dc.w 0x6e
	dc.w 0x73
	dc.w 0x20
	dc.w 0x76
	dc.w 0x65
	dc.w 0x72
	dc.w 0x79
	dc.w 0x20
	dc.w 0x71
	dc.w 0x75
	dc.w 0x69
	dc.w 0x63
	dc.w 0x6b
	dc.w 0x6c
	dc.w 0x79
	dc.w 0x20
	dc.w 0x6f
	dc.w 0x6e
	dc.w 0x20
	dc.w 0x4d
	dc.w 0x6f
	dc.w 0x6e
	dc.w 0x64
	dc.w 0x61
	dc.w 0x79
	dc.w 0x2e
	dc.w 0x0a

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

end_fb:

doSomething2:
	linkw %fp,#0
	unlk %fp
	rts

PRAM_buffer2:
	.long	0
end2:
