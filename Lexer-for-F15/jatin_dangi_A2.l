%{
#include <stdio.h>
%}

%option noyywrap

%%
PROGRAM         { printf("PROGRAM keyword\n"); }
INTEGER         { printf("INTEGER keyword\n"); }
READ            { printf("READ keyword\n"); }
PRINT           { printf("PRINT keyword\n"); }
IF              { printf("IF keyword\n"); }
THEN            { printf("THEN keyword\n"); }
ELSE            { printf("ELSE keyword\n"); }
DO              { printf("DO keyword\n"); }
END             { printf("END keyword\n"); }
[a-z]+          { printf("Identifier: %s\n", yytext); }
[0-9]+          { printf("Number: %s\n", yytext); }
\"[^\"]*\"      { printf("String: %s\n", yytext); }
"+"             { printf("PLUS\n"); }
"-"             { printf("MINUS\n"); }
".GT."          { printf("GREATER THAN\n"); }
".LT."          { printf("LESS THAN\n"); }
".EQ."          { printf("EQUAL TO\n"); }
"="             { printf("=\n"); }
","             { printf(",\n"); }
"!"[^\n]*       { /* Ignore comments */ }
\n              { /* ignore newline */ }
[ \t]           { /* ignore whitespace */ }
%% 
