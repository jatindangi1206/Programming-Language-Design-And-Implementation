%option noyywrap

%{
    #include <stdio.h>
    #include "jatin_A3.tab.h" // Include Bison-generated header
%}

/* Token declarations are in the Bison-generated header file */

/* Definitions of regular expressions */
CHAR        "char"
ELSE        "else"
FOR         "for"
IF          "if"
INT         "int"
RETURN      "return"
VOID        "void"

ID          [a-zA-Z][a-zA-Z0-9]*

OPEN_PAREN      "("
CLOSE_PAREN     ")"
OPEN_BRACE      "{"
CLOSE_BRACE     "}"
OPEN_BRACKET    "["
CLOSE_BRACKET   "]"
SEMICOLON       ";"
COMMA           ","
ASSIGN          "="
PLUS            "+"
MINUS           "-"
MULTIPLY        "*"
DIVIDE          "/"
MOD             "%"
LT              "<"
GT              ">"
LE              "<="
GE              ">="
EQ              "=="
NE              "!="
AND             "&&"
OR              "||"
NOT             "!"
QUESTION        "?"
COLON           ":"
TILDE           "~"
ARROW           "->"

%%

{CHAR}            { return CHAR; }
{ELSE}            { return ELSE; }
{FOR}             { return FOR; }
{IF}              { return IF; }
{INT}             { return INT; }
{RETURN}          { return RETURN; }
{VOID}            { return VOID; }
{ID}              { return IDENTIFIER; }
{OPEN_PAREN}      { return OPEN_PAREN; }
{CLOSE_PAREN}     { return CLOSE_PAREN; }
{OPEN_BRACE}      { return OPEN_BRACE; }
{CLOSE_BRACE}     { return CLOSE_BRACE; }
{OPEN_BRACKET}    { return OPEN_BRACKET; }
{CLOSE_BRACKET}   { return CLOSE_BRACKET; }
{SEMICOLON}       { return SEMICOLON; }
{COMMA}           { return COMMA; }
{ASSIGN}          { return ASSIGN; }
{PLUS}            { return PLUS; }
{MINUS}           { return MINUS; }
{MULTIPLY}        { return MULTIPLY; }
{DIVIDE}          { return DIVIDE; }
{MOD}             { return MOD; }
{LT}              { return LT; }
{GT}              { return GT; }
{LE}              { return LE; }
{GE}              { return GE; }
{EQ}              { return EQ; }
{NE}              { return NE; }
{AND}             { return AND; }
{OR}              { return OR; }
{NOT}             { return NOT; }
{QUESTION}        { return QUESTION; }
{COLON}           { return COLON; }
{TILDE}           { return TILDE; }
{ARROW}           { return ARROW; }

.                 { /* Ignore unrecognized characters */ }

%%