/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     IDENTIFIER = 258,
     INTEGER_CONSTANT = 259,
     STRING_LITERAL = 260,
     INT = 261,
     VOID = 262,
     MINUS = 263,
     MULTIPLY = 264,
     DIVIDE = 265,
     MOD = 266,
     NE = 267,
     EQ = 268,
     GE = 269,
     GT = 270,
     LE = 271,
     NOT = 272,
     OR = 273,
     RETURN = 274,
     FOR = 275,
     ELSE = 276,
     CLOSE_PAREN = 277,
     OPEN_BRACE = 278,
     CLOSE_BRACE = 279,
     OPEN_BRACKET = 280,
     CLOSE_BRACKET = 281,
     COMMA = 282,
     QUESTION = 283,
     COLON = 284,
     CHAR = 285,
     PLUS = 286,
     LT = 287,
     AND = 288,
     ASSIGN = 289,
     IF = 290,
     OPEN_PAREN = 291,
     SEMICOLON = 292,
     PROGRAM = 293,
     END = 294,
     READ = 295,
     PRINT = 296,
     INTEGER = 297,
     TILDE = 298,
     ARROW = 299,
     LOWER_THAN_ELSE = 300
   };
#endif
/* Tokens.  */
#define IDENTIFIER 258
#define INTEGER_CONSTANT 259
#define STRING_LITERAL 260
#define INT 261
#define VOID 262
#define MINUS 263
#define MULTIPLY 264
#define DIVIDE 265
#define MOD 266
#define NE 267
#define EQ 268
#define GE 269
#define GT 270
#define LE 271
#define NOT 272
#define OR 273
#define RETURN 274
#define FOR 275
#define ELSE 276
#define CLOSE_PAREN 277
#define OPEN_BRACE 278
#define CLOSE_BRACE 279
#define OPEN_BRACKET 280
#define CLOSE_BRACKET 281
#define COMMA 282
#define QUESTION 283
#define COLON 284
#define CHAR 285
#define PLUS 286
#define LT 287
#define AND 288
#define ASSIGN 289
#define IF 290
#define OPEN_PAREN 291
#define SEMICOLON 292
#define PROGRAM 293
#define END 294
#define READ 295
#define PRINT 296
#define INTEGER 297
#define TILDE 298
#define ARROW 299
#define LOWER_THAN_ELSE 300




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

