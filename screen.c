#include "screen.h"

void charout(char c) {
	drawchar(c, curs.x++, curs.y);
	if (curs.x == 101) { curs.y++; curs.x = 0;}
	if (curs.y == 26) { curs.y = 0;}
}
