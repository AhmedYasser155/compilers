/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INT = 258,
    CHAR = 259,
    FLOAT = 260,
    STRING = 261,
    CONST = 262,
    BOOL = 263,
    VOID = 264,
    PLUS = 265,
    MINUS = 266,
    MULTIPLY = 267,
    DIVIDE = 268,
    MODULO = 269,
    INCREMENT = 270,
    DECREMENT = 271,
    GREATER = 272,
    LESS = 273,
    GREATER_EQUAL = 274,
    LESS_EQUAL = 275,
    EQUAL = 276,
    NOT_EQUAL = 277,
    AND = 278,
    OR = 279,
    NOT = 280,
    ASSIGN = 281,
    IF = 282,
    ELSE = 283,
    SWITCH = 284,
    CASE = 285,
    DEFAULT = 286,
    CONTINUE = 287,
    BREAK = 288,
    THEN = 289,
    WHILE = 290,
    DO = 291,
    FOR = 292,
    RETURN = 293,
    REPEAT = 294,
    UNTIL = 295,
    LEFT_CURLY_BRACE = 296,
    RIGHT_CURLY_BRACE = 297,
    LEFT_PARENTHESIS = 298,
    RIGHT_PARENTHESIS = 299,
    LEFT_SQUARE_BRACKET = 300,
    RIGHT_SQUARE_BRACKET = 301,
    ENUM = 302,
    FUNCTION = 303,
    MAIN = 304,
    PRINT = 305,
    SCAN = 306,
    COMMENT = 307,
    IDENTIFIER = 308,
    DIGIT = 309,
    FLOAT_LITERAL = 310,
    STRING_LITERAL = 311,
    CHAR_LITERAL = 312,
    BOOL_LITERAL = 313
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 14 "parser.y"

  int iVal;
  char* sVal;
  float fVal;
  char cVal;
  int bVal;  

#line 124 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
