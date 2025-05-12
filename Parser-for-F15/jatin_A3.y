%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern char* yytext;
void yyerror(char *s);
%}

%token IDENTIFIER
%token INTEGER_CONSTANT
%token STRING_LITERAL
%token INT
%token VOID
%token MINUS
%token MULTIPLY
%token DIVIDE
%token MOD
%token NE
%token EQ
%token GE
%token GT
%token LE
%token NOT
%token OR
%token RETURN
%token FOR
%token ELSE
%token CLOSE_PAREN
%token OPEN_BRACE
%token CLOSE_BRACE
%token OPEN_BRACKET
%token CLOSE_BRACKET
%token COMMA
%token QUESTION
%token COLON
%token CHAR
%token PLUS 
%token LT    
%token AND
%token ASSIGN
%token IF  
%token OPEN_PAREN
%token SEMICOLON
%token PROGRAM
%token END
%token READ
%token PRINT
%token INTEGER
%token TILDE
%token ARROW

%left OR
%left AND
%left EQ NE
%left LT LE GT GE
%left PLUS MINUS
%left MULTIPLY DIVIDE MOD
%right NOT
%right ASSIGN

%start program
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program:
    PROGRAM IDENTIFIER declarations statements END PROGRAM IDENTIFIER
    {
        printf("Program parsed successfully!\n");
    }
    ;

declarations:
    /* empty */
    | declarations declaration
    ;

declaration:
    INTEGER IDENTIFIER SEMICOLON
    {
        printf("Declared integer variable: %s\n", yytext);
    }
    ;

statements:
    /* empty */
    | statements statement
    ;

statement:
    expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    | io_statement
    ;

io_statement:
    READ OPEN_PAREN CLOSE_PAREN SEMICOLON
    {
        printf("Read statement\n");
    }
    | PRINT OPEN_PAREN STRING_LITERAL CLOSE_PAREN SEMICOLON
    {
        printf("Print statement: %s\n", yytext);
    }
    ;

expression_statement:
    SEMICOLON
    | expression SEMICOLON
    {
        printf("Expression statement\n");
    }
    ;

selection_statement:
    IF OPEN_PAREN expression CLOSE_PAREN statement %prec LOWER_THAN_ELSE
    | IF OPEN_PAREN expression CLOSE_PAREN statement ELSE statement
    {
        printf("Selection statement\n");
    }
    ;

iteration_statement:
    FOR OPEN_PAREN expression_statement expression_statement CLOSE_PAREN statement
    {
        printf("For loop statement\n");
    }
    | FOR OPEN_PAREN expression_statement expression_statement expression CLOSE_PAREN statement
    {
        printf("For loop with iteration expression\n");
    }
    ;

jump_statement:
    RETURN SEMICOLON
    | RETURN expression SEMICOLON
    {
        printf("Return statement\n");
    }
    ;

expression:
    assignment_expression
    ;

assignment_expression:
    IDENTIFIER ASSIGN expression
    {
        printf("Assignment statement\n");
    }
    | conditional_expression
    ;

conditional_expression:
    logical_or_expression
    | logical_or_expression QUESTION expression COLON conditional_expression
    ;

logical_or_expression:
    logical_and_expression
    | logical_or_expression OR logical_and_expression
    ;

logical_and_expression:
    equality_expression
    | logical_and_expression AND equality_expression
    ;

equality_expression:
    relational_expression
    | equality_expression EQ relational_expression
    | equality_expression NE relational_expression
    ;

relational_expression:
    additive_expression
    | relational_expression LT additive_expression
    | relational_expression GT additive_expression
    | relational_expression LE additive_expression
    | relational_expression GE additive_expression
    ;

additive_expression:
    multiplicative_expression
    | additive_expression PLUS multiplicative_expression
    | additive_expression MINUS multiplicative_expression
    ;

multiplicative_expression:
    unary_expression
    | multiplicative_expression MULTIPLY unary_expression
    | multiplicative_expression DIVIDE unary_expression
    | multiplicative_expression MOD unary_expression
    ;

unary_expression:
    postfix_expression
    | unary_operator unary_expression
    ;

postfix_expression:
    primary_expression
    | postfix_expression OPEN_BRACKET expression CLOSE_BRACKET
    | postfix_expression OPEN_PAREN argument_expression_list_opt CLOSE_PAREN
    | postfix_expression ARROW IDENTIFIER
    ;

argument_expression_list_opt:
    /* empty */
    | argument_expression_list
    ;

argument_expression_list:
    assignment_expression
    | argument_expression_list COMMA assignment_expression
    ;

primary_expression:
    IDENTIFIER
    | constant
    | STRING_LITERAL
    | OPEN_PAREN expression CLOSE_PAREN
    ;

constant:
    INTEGER_CONSTANT
    | CHAR
    ;

unary_operator:
    AND
    | MULTIPLY
    | PLUS
    | MINUS
    | NOT
    | TILDE
    ;

%%

void yyerror(char *s) {
    printf("Error: %s at '%s'\n", s, yytext);
}