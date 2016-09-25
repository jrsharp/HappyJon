#!/bin/bash -xe

#m68k-unknown-elf-gcc -Os -o libchars.a chars.c syscalls.c -nostdlib -lc -lm -mno-rtd -m68000 -mpcrel -pie
#m68k-unknown-elf-gcc -Os -o demo demo.s -L./ -nostdlib -mno-rtd -m68000 -mpcrel -pie -lchars -static

m68k-elf-gcc -g -o demo demo.s chars.c syscalls.c screen.c -nostdlib -fomit-frame-pointer -lc -lm -mno-rtd -m68000 -msoft-float -mpcrel -T macplus.lds

#m68k-unknown-elf-gcc -Os -o chars chars.c -nostdlib -nodefaultlibs
#m68k-unknown-elf-objcopy --add-section .chars=chars demo

m68k-elf-objcopy -O binary demo floppy.img

#m68k-unknown-elf-objcopy -O binary chars chars.bin

# optionally fill img to full floppy img size:

# 400K:
#dd if=/dev/zero of=floppy.img bs=1 count=0 seek=409600

# 800K:
#dd if=/dev/zero of=floppy.img bs=1 count=0 seek=819200
