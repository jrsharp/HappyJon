extern void drawchar(char c, int x, int y);
extern void drawstr(char *p, int x, int y);
void charout(char c);

struct cursor {
	int x;
	int y;
};

struct cursor curs;
