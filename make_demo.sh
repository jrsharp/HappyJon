#!/bin/bash -xe

m68k-elf-gcc -o demo demo.s -nostdlib
m68k-elf-objcopy -O binary demo floppy.img
