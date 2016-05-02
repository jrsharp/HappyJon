#include "chars.h"
//#include <stdio.h>

void doSomething() {
	int x = 2;
	int y = 8;
	int z = x + y;
	return;
}

int getOffset(char charValue) {
	return (charValue - 32) * (16 * 4);
}

int* getChar(char charValue) {
//	puts("Hello.");
	return &font_data[(charValue - 32) * 16];
}
