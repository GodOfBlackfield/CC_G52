/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
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
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_SRC_PARSER_HH_INCLUDED
# define YY_YY_SRC_PARSER_HH_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif
/* "%code requires" blocks.  */
#line 3 "src/parser.yy"

#include <iostream>
#include <vector>
#include <string>

#include "parser_util.hh"
#include "symbol.hh"


#line 59 "src/parser.hh"

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TPLUS = 258,                   /* TPLUS  */
    TDASH = 259,                   /* TDASH  */
    TSTAR = 260,                   /* TSTAR  */
    TSLASH = 261,                  /* TSLASH  */
    TTERN = 262,                   /* TTERN  */
    TTEREX = 263,                  /* TTEREX  */
    TIF = 264,                     /* TIF  */
    TELSE = 265,                   /* TELSE  */
    TFUNC = 266,                   /* TFUNC  */
    TINT = 267,                    /* TINT  */
    TLONG = 268,                   /* TLONG  */
    TSHORT = 269,                  /* TSHORT  */
    TINT_LIT = 270,                /* TINT_LIT  */
    TIDENT = 271,                  /* TIDENT  */
    INT = 272,                     /* INT  */
    LONG = 273,                    /* LONG  */
    SHORT = 274,                   /* SHORT  */
    TLET = 275,                    /* TLET  */
    TDBG = 276,                    /* TDBG  */
    TSCOL = 277,                   /* TSCOL  */
    TLPAREN = 278,                 /* TLPAREN  */
    TRPAREN = 279,                 /* TRPAREN  */
    TEQUAL = 280,                  /* TEQUAL  */
    TLCB = 281,                    /* TLCB  */
    TRCB = 282                     /* TRCB  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef  ParserValue  YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_SRC_PARSER_HH_INCLUDED  */
