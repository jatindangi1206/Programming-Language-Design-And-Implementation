CC=gcc
CFLAGS=-Werror -g
FLEX_LIB=$(shell brew --prefix flex)/lib

# Target executable
translator: lex.yy.c A4.tab.c A4_translator.c
	$(CC) $(CFLAGS) -o translator lex.yy.c A4.tab.c A4_translator.c -L$(FLEX_LIB) -lfl

# Bison parser generation
A4.tab.c A4.tab.h: A4.y
	bison -d -v A4.y

# Flex lexer generation
lex.yy.c: A4.l A4.tab.h
	flex A4.l

# Build target (as per assignment requirements)
build: translator

# Clean up generated files
clean:
	rm -f translator lex.yy.c A4.tab.c A4.tab.h A4.output

.PHONY: clean build