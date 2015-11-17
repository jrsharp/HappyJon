# HappyJon
HappyJon demo for Mac Plus

This little demo leverages the template published by kmcallister ([https://gist.github.com/kmcallister/3236565ed7eb7b45cf99])
for the creation of Mac-bootable code *without* Mac OS.

My intention was simply to demonstrate something functional that fit within the 1024 bytes that the ROM loads into memory
from the floppy on startup.  The code itself is very simple and puts a 1-bit image in the center of the display.

It was tested using Mini vMac, (and you can run the resulting .img file yourself in Mini vMac) as well as a real Mac Plus.

You can use DiskDup+ to put this on a real floppy if you'd like to see it on your Plus.  (I presume it would run on a
128k/512k, as well... If you happen to test it there, let me know the results.)
