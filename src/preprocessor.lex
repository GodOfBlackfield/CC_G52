/* just like Unix wc */
%option noyywrap
%option prefix="gee"
 
%x comment
%x comment2
%x DEFINE
%x DEFINE2
%x UNDEF
%x IFDEF
%x VAL
%x ENDIF
%x OVER
 
%{
#include <string>
#include<iostream>
#include <unordered_map>
#include<cstdio>
using namespace std;
 
string key;
unordered_map<string, string> map;
int f=0;
%}
%%
 
"#undef " {BEGIN(UNDEF); return 2;}
<UNDEF>[a-zA-Z][a-zA-Z0-9]* {map.erase(yytext); return 2;}
<UNDEF>[ \n]+ {BEGIN(INITIAL); return 2;}

"#def " {BEGIN(DEFINE); return 1;}
<DEFINE>[a-zA-Z][a-zA-Z0-9]* {key = yytext; map[key]="1"; return 1;}
<DEFINE>[\n]+ {BEGIN(INITIAL); return 1;}
<DEFINE>" " {BEGIN(DEFINE2); return 1;}
<DEFINE2>[^\\\n]+ {if(map[key] == "1") map[key] = ""; map[key] += yytext; return 5;}
<DEFINE2>"\\\n" {return 1;}
<DEFINE2>[\n]+ {BEGIN(INITIAL); return 1;}
 
"#ifdef "   { f=1;  BEGIN(IFDEF);  return 69;}
<IFDEF>[a-zA-Z][a-zA-Z0-9]* {
    printf("\n-------\n");
    key= yytext;
    if(map.find(yytext) != map.end()) {
        f=2;
        BEGIN(VAL);
    } else {
        BEGIN(ENDIF);
    }
    return 69;
}  
<IFDEF>[ \n]+ {BEGIN(INITIAL); return 69;}
<VAL>[ \n]+ {BEGIN(INITIAL);  return 69;}
<ENDIF>^[^#][^e][^l][^i][^f].*
<ENDIF>^[^#][^e][^n][^d][^i][^f].*
<ENDIF>^[^#][^e][^l][^s][^e].*
 
<ENDIF>"#elif "  {BEGIN(IFDEF); return 720;}
<ENDIF>"#endif" {BEGIN(INITIAL); return 720;}
<ENDIF>"#else" {BEGIN(INITIAL); return 720;}
 
"#endif"   {if(f==0)    return 99;   f=0;    BEGIN(INITIAL);}
 
"#elif"    {
    if(f==0)    return 88;  
    if(f==2){
        BEGIN(OVER);    return 100;
    }        
    BEGIN(INITIAL);}
 
"#else" {
    if(f==2){
        BEGIN(OVER);    return 100;
    }
    BEGIN(INITIAL);}
 
<OVER>^[^#][^e][^n][^d][^i][^f].* {printf("123 %s\n",yytext);return 44;}
<OVER>#endif {printf("22 %s\n",yytext); BEGIN(INITIAL);} 
 
"/*"         BEGIN(comment);
<comment>[^*]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/]*   /* eat up '*'s not followed by '/'s */
<comment>"*"+"/"        {BEGIN(INITIAL);}
 
"//"    BEGIN(comment2);
<comment2>. /* om nom */
<comment2>[ \n]+ {BEGIN(INITIAL);}
[\n ] {return 4;}
[a-zA-Z][a-zA-Z0-9]* {return 3;}
. {return 4;}
%%