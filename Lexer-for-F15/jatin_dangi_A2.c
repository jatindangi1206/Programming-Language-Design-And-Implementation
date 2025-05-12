#include <stdio.h>

extern int yylex();
extern FILE *yyin;

int main(int argc, char **argv) {
    printf("Starting lexer...\n");

    if (argc > 1) {
        printf("Opening input file: %s\n", argv[1]);
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error opening file");
            return 1;
        }
    }

    printf("Calling lexer...\n");
    yylex();  // Call the lexer

    printf("Finished lexing.\n");

    if (yyin) {
        fclose(yyin);
    }

    return 0;
}
