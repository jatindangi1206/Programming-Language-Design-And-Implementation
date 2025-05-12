CC=gcc
CFLAGS=-Werror
FLEX_LIB=$(shell brew --prefix flex)/lib

parser: lex.yy.c jatin_A3.tab.c
	$(CC) $(CFLAGS) -o parser lex.yy.c jatin_A3.tab.c -L$(FLEX_LIB) -lfl

jatin_A3.tab.c jatin_A3.tab.h: jatin_A3.y
	bison -d -v jatin_A3.y

lex.yy.c: jatin_A3.l jatin_A3.tab.h
	flex jatin_A3.l

clean:
	rm -f parser lex.yy.c jatin_A3.tab.c jatin_A3.tab.h jatin_A3.output

.PHONY: clean