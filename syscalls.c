#include <sys/stat.h>
#include <errno.h>
#include "screen.h"

extern caddr_t _end;
extern char getkeychar();
//extern void draw_char(char c, int x, int y);

#ifndef RAMSIZE
#define	RAMSIZE	(caddr_t)0x200000
#endif

#define STDIN 0
#define STDOUT 1
#define STDERR 2

int close(int file) { return 1; }

int stat(const char *file, struct stat *st) {
	st->st_mode = S_IFCHR;
	return 0;
}

int fstat(int file, struct stat *st) {
	st->st_mode = S_IFCHR;
	return 0;
}

int fork(void) { return -1; }

int isatty(int file) {
	if (file == 0 || file == 1 || file == 2) {
		return 1;
	} else {
		return 0;
	}
}

int lseek(int file, int ptr, int dir) { return 0; }

int open(const char *name, int flags, int mode) { return -1; }

int read(int file, char *ptr, int len) {
	if (file == STDIN) {
		*ptr++ = getkeychar();
	}
	return 1;
}

int write(int file, char *ptr, int len) {
	int i;
	//charout(0x30 + file);
	if (file == STDOUT || file == STDERR) {	// terminal I/O
		for (i = 0; i < len; i++) {
			charout(*ptr++);
		}
	}
	//return len;
	return -1;
}

int unlink(char *name) { return -1; }

/* 0x14000002 -- start of ApplZone on 4MB Plus */
caddr_t sbrk(int incr) {
	static caddr_t heap_ptr = NULL;
	caddr_t base;
	if (heap_ptr == NULL) {
		heap_ptr = (caddr_t)&_end;
	}
	if ((RAMSIZE - heap_ptr) >= 0) {
		base = heap_ptr;
		heap_ptr += incr;
		return (base);
	} else {
		errno = ENOMEM;
		return ((caddr_t)-1);
	}
}
