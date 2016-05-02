#include <sys/stat.h>

int close(int file) { return 1; }

int fstat(int file, struct stat *st) {
	st->st_mode = S_IFCHR;
	return 0;
}

int isatty(int file) { return 1; }

int lseek(int file, int ptr, int dir) { return 0; }

int open(const char *name, int flags, int mode) { return -1; }

int read(int file, char *ptr, int len) { return -1; }

int write(int file, char *ptr, int len) { return -1; }

caddr_t sbrk(int incr) { return (caddr_t) 0; }
