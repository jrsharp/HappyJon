#!/bin/bash -xe

m68k-elf-gcc -o demo demo.s -nostdlib
m68k-elf-objcopy -O binary demo floppy.img

# optionally fill img to full floppy img size:

# 400K:
#dd if=/dev/zero of=floppy.img bs=1 count=0 seek=409600

# 800K:
#dd if=/dev/zero of=floppy.img bs=1 count=0 seek=819200
