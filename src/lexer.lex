%option noyywrap

%{
#include "parser.hh"
#include <string>

extern int yyerror(std::string msg);
%}

%%

"+"       { return TPLUS; }
"-"       { return TDASH; }
"*"       { return TSTAR; }
"/"       { return TSLASH; }
";"       { return TSCOL; }
"("       { return TLPAREN; }
")"       { return TRPAREN; }
"="       { return TEQUAL; }
"?"       { return TTERN; }
":"       { return TTEREX; }
"{"       { return TLCB; }
"}"       { return TRCB; }
"dbg"     { return TDBG; }
"let"     { return TLET; }
"int"     { return TINT; }
"long"    { return TLONG; }
"short"   { return TSHORT; }
"if"      { return TIF; }
"else"    { return TELSE; }  
"fun"     { return TFUNC; }
[0-9]+    { yylval.lexeme = std::string(yytext); return TINT_LIT; }
[a-zA-Z]+ { yylval.lexeme = std::string(yytext); return TIDENT; }
[ \t\n]   { /* skip */ }
.         { yyerror("unknown char"); }

%%

std::string token_to_string(int token, const char *lexeme) {
    std::string s;
    switch (token) {
        case TPLUS: s = "TPLUS"; break;
        case TDASH: s = "TDASH"; break;
        case TSTAR: s = "TSTAR"; break;
        case TSLASH: s = "TSLASH"; break;
        case TSCOL: s = "TSCOL"; break;
        case TLPAREN: s = "TLPAREN"; break;
        case TRPAREN: s = "TRPAREN"; break;
        case TEQUAL: s = "TEQUAL"; break;
        case TTERN: s = "TTERN"; break;
        case TDBG: s = "TDBG"; break;
        case TLET: s = "TLET"; break;
        case TINT: s = "TINT"; break;
        case TLCB: s = "TLCB"; break;
        case TRCB: s = "TRCB"; break;
        case TIF: s = "TIF"; break;
        case TELSE: s = "TELSE"; break;
        case TLONG: s = "TLONG"; break;
        case TSHORT: s = "TSHORT"; break;
        case TTEREX: s = "TTEREX"; break;
        case TFUNC: s = "TFUNC"; break;
        case TINT_LIT: s = "TINT_LIT"; s.append("  ").append(lexeme); break;
        case TIDENT: s = "TIDENT"; s.append("  ").append(lexeme); break;
    }

    return s;
}