#include "chars.h"
#include "screen.h"
#include <stdio.h>
#include <stdlib.h>

#define SCREEN_BASE         (*((volatile unsigned long *) 0x3FA700 + 64))

static char *foo = "hello";
extern struct cursor curs;

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
        /*
        drawstr(foo, 5, 7);
        drawstr(foo, 6, 8);
        */
	// start at the top:
	curs.x = 0;
	curs.y = 0;
        int i = 0;
	char c;
        for (i = 0; i < 5; i++) {
		//if (i % 2 == 0) { c = 'A'; } else { c = 'B'; }
		c = '0' + i;
                //drawchar('A' + i, 10 + i, 9);
		charout(c);
        }
	charout('A');
	charout('B');
	charout('C');
	charout('D');
	charout('E');
	//drawchar('i', 12, 1);
	puts("This is a longer string.");
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
