/* Script for ld --shared: link shared library */
/* Copyright (C) 2014-2015 Free Software Foundation, Inc.
   Copying and distribution of this script, with or without modification,
   are permitted in any medium without royalty provided the copyright
   notice and this notice are preserved.  */
OUTPUT_FORMAT("elf32-m68k", "elf32-m68k",
	      "elf32-m68k")
OUTPUT_ARCH(m68k)
ENTRY(_start_fb)
SEARCH_DIR("=/home/chip/x-tools/m68k-unknown-elf/m68k-unknown-elf/lib"); SEARCH_DIR("=/usr/local/lib"); SEARCH_DIR("=/lib"); SEARCH_DIR("=/usr/lib");
/*
MEMORY {
	rom (rx) : org = 0x400000, l = 128k
	ram (!rx) : org = 0, l = 4M
}
*/
SECTIONS {
	_start_fb = 0x300400;
	. = 0x300000;
	.text : { *(.text) }
	.data : { *(.data) }
	.bss : {
		*(.bss)
		*(COMMON)
			end = ALIGN(0x8);
			_end = ALIGN(0x8);
			__end = ALIGN(0x8);
	}
}
