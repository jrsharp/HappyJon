#!/bin/bash -xe

m68k-elf-gcc -Os -o demo demo.s chars.c -nostdlib -mno-rtd
#m68k-elf-gcc -Os -o chars chars.c -nostdlib -nodefaultlibs
#m68k-elf-objcopy --add-section .chars=chars demo
m68k-elf-objcopy -O binary demo floppy.img
#m68k-elf-objcopy -O binary chars chars.bin

# optionally fill img to full floppy img size:

# 400K:
#dd if=/dev/zero of=floppy.img bs=1 count=0 seek=409600

# 800K:
#dd if=/dev/zero of=floppy.img bs=1 count=0 seek=819200
