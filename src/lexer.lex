%option noyywrap

%{
#include <string>
#include "parser.hh"

extern int yyerror(std::string msg);
%}

%%

"("       { return TLPAREN; }
")"       { return TRPAREN; }
"="       { return TEQUAL; }
"+"       { return TPLUS; }
"/"       { return TSLASH; }
"-"       { return TDASH; }
"*"       { return TSTAR; }
";"       { return TSCOL; }
"dbg"     { return TDBG; }
"let"     { return TLET; }

"#def"     { return TDEF; }
"#undef"     { return TUNDEF; }

[a-zA-Z]+ { yylval.lexeme = std::string(yytext); return TIDENT; }
[0-9]+    { yylval.lexeme = std::string(yytext); return TINT_LIT; }
[ \t\n]   { /* skip */ }
.         { yyerror("unknown char"); }

%%

std::string token_to_string(int token, const char *lexeme) {
    std::string s;
    
    if(token==(int)TLPAREN)
    {
        s = "TLPAREN"; 
    }
    else if(token==(int)TRPAREN)
    {
        s = "TRPAREN"; 
    }
    else if(token==(int)TEQUAL)
    {
        s = "TEQUAL"; 
    }
    else if(token==(int)TPLUS)
    {
        s = "TPLUS"; 
    }
    else if(token==(int)TDASH)
    {
        s = "TDASH"; 
    }
    else if(token==(int)TSTAR)
    {
        s = "TSTAR"; 
    }
    else if(token==(int)TSCOL)
    {
        s = "TSCOL"; 
    }
    else if(token==(int)TDBG)
    {
        s = "TDBG"; 
    }
    else if(token==(int)TLET)
    {
        s = "TLET"; 
    }
    else if (token==(int)TDEF)
    {
        s = "TDEF";
    }
    else if (token==(int)TUNDEF)
    {
        s = "TUNDEF";
    }
    else if(token==(int)TINT_LIT)
    {
        s = "TINT_LIT"; 
        s.append("  ").append(lexeme);
    }
    else if(token==(int)TIDENT)
    {
        s = "TIDENT"; 
        s.append("  ").append(lexeme);
    }

    return s;
}