#include "chars.h"
#include "screen.h"
#include <stdio.h>
#include <stdlib.h>

#define SCREEN_BASE         (*((volatile unsigned long *) 0x3FA700 + 64))

static char *foo = "hello";

void doSomething() {
        /*
        char *p = (char*)0x3FA700 + 64;
        int i = 0;
        for (i = 0; i < 32; i++) {
                p[0] = 0xFF;
        }
        SCREEN_BASE = 0xFFFF;
        */
        //while (1==1) {};
        //putchar(0x66);
        //draw_char(0x55, 0, 0);
        drawstr(foo, 5, 7);
        drawstr(foo, 6, 8);
	puts("foobar");
		return;
}

int getOffset(char charValue) {
	return (charValue - 32) * (16 * 4);
}

int* getChar(char charValue) {
	return &font_data[(charValue - 32) * 16];
}

int getNumber() {
        return abs(-0x66);
}
