%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>
    #include "A4_translator.h"
    #include "A4.tab.h"
    extern int line_num;
%}

%%

"PROGRAM"                    { return PROGRAM; }
"END"                       { return END; }
"INTEGER"                   { return INTEGER; }
"READ"                      { return READ; }
"PRINT"                     { return PRINT; }
"DO"                        { return DO; }
"IF"                        { return IF; }
"THEN"                      { return THEN; }
"ELSE"                      { return ELSE; }
"END DO"                    { return END_DO; }
"END IF"                    { return END_IF; }

".LT."                      { return LT; }
".GT."                      { return GT; }
".LE."                      { return LE; }
".GE."                      { return GE; }
".EQ."                      { return EQ; }
".NE."                      { return NE; }

"+"                         { return PLUS; }
"-"                         { return MINUS; }
"*"                         { return MULT; }
"/"                         { return DIV; }
"="                         { return ASSIGN; }
","                         { return COMMA; }
"("                         { return LPAREN; }
")"                         { return RPAREN; }

[0-9]+                      { 
                             yylval.integer = atoi(yytext);
                             return NUMBER; 
                           }

[a-zA-Z][a-zA-Z0-9_]*      { 
                             yylval.string = strdup(yytext);
                             return IDENTIFIER; 
                           }

\"[^\"]*\"                  {
                             // Remove quotes and create a new string entry
                             std::string str(yytext + 1);
                             str = str.substr(0, str.length() - 1);
                             StringTableEntry* entry = stringTable.lookup(str);
                             yylval.string = strdup(entry->name.c_str());
                             return STRING;
                           }

"!"[^\n]*                   ; /* Ignore comments */
[ \t]+                      ; /* Ignore whitespace */
[\n]                        { line_num++; }
.                           { printf("Unexpected character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}