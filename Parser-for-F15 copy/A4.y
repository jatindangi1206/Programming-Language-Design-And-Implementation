%{
    #include <stdio.h>
    #include <string>
    #include "A4_translator.h"
    
    extern int yylex();
    void yyerror(const char* s);
    extern int line_num;
    
    // Global variables for tables
    extern SymbolTable symbolTable;
    extern StringTable stringTable;
    extern QuadArray quadArray;
%}

/* Union for semantic values */
%union {
    int integer;           // For integer constants
    char* string;         // For identifiers and strings
    struct {
        std::string place;
        std::vector<int> truelist;
        std::vector<int> falselist;
        std::vector<int> nextlist;
    } expr;              // For expressions and statements
}

/* Token declarations with types */
%token <string> IDENTIFIER STRING
%token <integer> NUMBER
%token PROGRAM END INTEGER READ PRINT
%token DO IF THEN ELSE END_DO END_IF
%token PLUS MINUS MULT DIV
%token LT GT LE GE EQ NE
%token ASSIGN COMMA LPAREN RPAREN

/* Type declarations for non-terminals */
%type <expr> expression term factor condition statement statements
%type <expr> if_statement do_statement io_statement assignment_statement

/* Operator precedence and associativity */
%left PLUS MINUS
%left MULT DIV
%nonassoc LT GT LE GE EQ NE

%%

program: 
    PROGRAM IDENTIFIER declarations statements END PROGRAM IDENTIFIER
    {
        quadArray.emit("end", "", "", "");
    }
    ;

declarations:
    /* empty */ 
    | declarations declaration
    ;

declaration:
    INTEGER IDENTIFIER
    {
        symbolTable.update($2, "INTEGER", "user-defined");
    }
    ;

statements:
    /* empty */
    {
        $$.nextlist.clear();
    }
    | statements statement
    {
        $$ = $2;  // Propagate nextlist from statement
    }
    ;

statement:
    assignment_statement
    | if_statement
    | do_statement
    | io_statement
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression
    {
        quadArray.emit("=", $1, $3.place, "");
        $$.nextlist.clear();
    }
    ;

expression:
    expression PLUS term
    {
        $$.place = symbolTable.gentemp()->name;
        quadArray.emit("+", $$.place, $1.place, $3.place);
    }
    | expression MINUS term
    {
        $$.place = symbolTable.gentemp()->name;
        quadArray.emit("-", $$.place, $1.place, $3.place);
    }
    | term
    {
        $$.place = $1.place;
    }
    ;

term:
    term MULT factor
    {
        $$.place = symbolTable.gentemp()->name;
        quadArray.emit("*", $$.place, $1.place, $3.place);
    }
    | term DIV factor
    {
        $$.place = symbolTable.gentemp()->name;
        quadArray.emit("/", $$.place, $1.place, $3.place);
    }
    | factor
    {
        $$.place = $1.place;
    }
    ;

factor:
    IDENTIFIER
    {
        $$.place = $1;
    }
    | NUMBER
    {
        auto temp = symbolTable.gentemp();
        temp->initialValue = std::to_string($1);
        $$.place = temp->name;
        quadArray.emit("=", $$.place, std::to_string($1), "");
    }
    | LPAREN expression RPAREN
    {
        $$.place = $2.place;
    }
    ;

if_statement:
    IF LPAREN condition RPAREN THEN statements
    {
        // Make fall through jump
        int fall_through = quadArray.nextInstr();
        quadArray.emit("goto", "", "", "");
        
        // Backpatch true list to start of then part
        quadArray.backpatch($3.truelist, quadArray.nextInstr());
        
        // Save nextlist and falselist
        $$.nextlist = quadArray.merge($6.nextlist, quadArray.makelist(fall_through));
        $$.falselist = $3.falselist;
    }
    ELSE statements END_IF
    {
        // Backpatch else part
        quadArray.backpatch($$.falselist, quadArray.nextInstr());
        
        // Merge nextlists
        $$.nextlist = quadArray.merge($$.nextlist, $9.nextlist);
    }
    ;

do_statement:
    DO IDENTIFIER ASSIGN expression COMMA expression
    {
        // Initialize loop variable
        quadArray.emit("=", $2, $4.place, "");
        
        // Save start of loop location
        $$.place = std::to_string(quadArray.nextInstr());
    }
    statements END_DO
    {
        // Generate loop control
        quadArray.emit("<=", "", $2, $6.place);
        int cond_loc = quadArray.nextInstr() - 1;
        
        // Increment loop variable
        quadArray.emit("+", $2, $2, "1");
        
        // Generate loop jump
        quadArray.emit("goto", $$.place, "", "");
        
        // Backpatch condition
        quadArray.backpatch(quadArray.makelist(cond_loc), quadArray.nextInstr());
    }
    ;

condition:
    expression LT expression
    {
        $$.truelist = quadArray.makelist(quadArray.nextInstr());
        $$.falselist = quadArray.makelist(quadArray.nextInstr() + 1);
        quadArray.emit("if<", "", $1.place, $3.place);
        quadArray.emit("goto", "", "", "");
    }
    | expression GT expression
    {
        $$.truelist = quadArray.makelist(quadArray.nextInstr());
        $$.falselist = quadArray.makelist(quadArray.nextInstr() + 1);
        quadArray.emit("if>", "", $1.place, $3.place);
        quadArray.emit("goto", "", "", "");
    }
    | expression LE expression
    {
        $$.truelist = quadArray.makelist(quadArray.nextInstr());
        $$.falselist = quadArray.makelist(quadArray.nextInstr() + 1);
        quadArray.emit("if<=", "", $1.place, $3.place);
        quadArray.emit("goto", "", "", "");
    }
    | expression GE expression
    {
        $$.truelist = quadArray.makelist(quadArray.nextInstr());
        $$.falselist = quadArray.makelist(quadArray.nextInstr() + 1);
        quadArray.emit("if>=", "", $1.place, $3.place);
        quadArray.emit("goto", "", "", "");
    }
    | expression EQ expression
    {
        $$.truelist = quadArray.makelist(quadArray.nextInstr());
        $$.falselist = quadArray.makelist(quadArray.nextInstr() + 1);
        quadArray.emit("if==", "", $1.place, $3.place);
        quadArray.emit("goto", "", "", "");
    }
    | expression NE expression
    {
        $$.truelist = quadArray.makelist(quadArray.nextInstr());
        $$.falselist = quadArray.makelist(quadArray.nextInstr() + 1);
        quadArray.emit("if!=", "", $1.place, $3.place);
        quadArray.emit("goto", "", "", "");
    }
    ;

io_statement:
    READ MULT IDENTIFIER
    {
        quadArray.emit("in", $3, "", "");
        $$.nextlist.clear();
    }
    | PRINT MULT expression
    {
        quadArray.emit("out", $3.place, "", "");
        $$.nextlist.clear();
    }
    | PRINT MULT STRING
    {
        quadArray.emit("out", $3, "", "");
        $$.nextlist.clear();
    }
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Error at line %d: %s\n", line_num, s);
}

int line_num = 1;