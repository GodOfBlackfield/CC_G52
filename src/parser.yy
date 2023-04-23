%define api.value.type { ParserValue }

%code requires {
#include <iostream>
#include <vector>
#include <string>

#include "parser_util.hh"
#include "symbol.hh"

}

%code {

#include <cstdlib>

extern int yylex();
extern int yyparse();

extern NodeStmts* final_values;

SymbolTable symbol_table;

int yyerror(std::string msg);

}

%token TPLUS TDASH TSTAR TSLASH
%token TTERN TTEREX
%token TIF TELSE
%token TFUNC
%token TINT TLONG TSHORT
%token <lexeme> TINT_LIT TIDENT
%token INT LONG SHORT TLET TDBG
%token TSCOL TLPAREN TRPAREN TEQUAL TLCB TRCB

%type <node> Expri Stmt
%type <node> Exprl
%type <node> Exprs
%type <node> Expra
%type <node> Exprb
%type <stmts> Program StmtList

%left TPLUS TDASH
%left TTERN TTEREX
%left TSTAR TSLASH

%%

Program :                
        { final_values = nullptr; }
        | StmtList TSCOL
        { final_values = $1; }
	    ;

StmtList : Stmt         
         { 
            $$ = new NodeStmts(); 
            $$->push_back($1); 
         }
	     | StmtList TSCOL Stmt
         { $$->push_back($3); }
	     ;

Stmt : TLET TIDENT TTEREX TINT TEQUAL Expri
     {
        if(symbol_table.contains($2)) {
            // tried to redeclare variable, so error
            yyerror("tried to redeclare variable.\n");
        } else {
            symbol_table.insert($2,"int");
            $$ = new NodeAssn($2,"int",$6);
        }
     }
     | TLET TIDENT TTEREX TLONG TEQUAL Exprl
     { 
        if(symbol_table.contains($2)) {
            // tried to redeclare variable, so error
            yyerror("tried to redeclare variable.\n");
        } else {
            symbol_table.insert($2,"long");
            $$ = new NodeAssn($2,"long",$6);
        }
     }
     | TLET TIDENT TTEREX TSHORT TEQUAL Exprs
     {
        if(symbol_table.contains($2)) {
            // tried to redeclare variable, so error
            yyerror("tried to redeclare variable.\n");
        } else {
            symbol_table.insert($2,"short");
            $$ = new NodeAssn($2,"short",$6);
        }
     }
     | TDBG Expri
     { 
        $$ = new NodeDebug($2);
     }
     | TDBG Exprl
     {
        $$ = new NodeDebug($2);
     }
     | TDBG Exprs
     {
        $$ = new NodeDebug($2);
     }
     | TIDENT TEQUAL Expri
     {
        if(symbol_table.contains($1)) {
            if (symbol_table.type($1) == 1 || symbol_table.type($1) == 2) {
                $$ = new NodeVAssn($1,$3);
            }
            else {
                yyerror("trying to fit larger type in int\n");
            }
        } else {
            //variable is not declared, so error
            yyerror("using undeclared variable.\n");
        }
     } 
     | TIDENT TEQUAL Exprl
     {
        if(symbol_table.contains($1)) {
            if (symbol_table.type($1) == 2) {
                $$ = new NodeVAssn($1,$3);
            }
        } else {
            //variable is not declared, so error
            yyerror("using undeclared variable.\n");
        }
     } 
     | TIDENT TEQUAL Exprs
     {
        if(symbol_table.contains($1)) {
            if (symbol_table.type($1) == 3) {
                $$ = new NodeVAssn($1,$3);
            }
            else {
                yyerror("trying to fit larger type in short\n");
            }
        } else {
            //variable is not declared, so error
            yyerror("using undeclared variable.\n");
        }
     } 
     | TIF Expri Expra StmtList TSCOL Exprb TELSE Expra StmtList TSCOL Exprb
     { 
        Node *exp = $2;
        NodeInt *e = dynamic_cast<NodeInt*>(exp);
        if (e) {
            if (e->value == 0) {
                $$ = new NodeIfElse($2,nullptr,$9);
            }
            else {
                $$ = new NodeIfElse($2,$4,nullptr);
            }
        }
        else {
            $$ = new NodeIfElse($2,$4,$9); 
        }
     }
     | TIF Exprl Expra StmtList TSCOL Exprb TELSE Expra StmtList TSCOL Exprb
     { 
        Node *exp = $2;
        NodeLong *e = dynamic_cast<NodeLong*>(exp);
        if (e) {
            if (e->value == 0) {
                $$ = new NodeIfElse($2,nullptr,$9);
            }
            else {
                $$ = new NodeIfElse($2,$4,nullptr);
            }
        }
        else {
            $$ = new NodeIfElse($2,$4,$9); 
        }
     }
     | TIF Exprs Expra StmtList TSCOL Exprb TELSE Expra StmtList TSCOL Exprb
     { 
        Node *exp = $2;
        NodeShort *e = dynamic_cast<NodeShort*>(exp);
        if (e) {
            if (e->value == 0) {
                $$ = new NodeIfElse($2,nullptr,$9);
            }
            else {
                $$ = new NodeIfElse($2,$4,nullptr);
            }
        }
        else {
            $$ = new NodeIfElse($2,$4,$9); 
        }
     }
     ;

Expra: TLCB
     {
        symbol_table.nextscope();
     }

Exprb: TRCB
     {
        symbol_table.prevscope();
     }
     ;

Expri: TINT_LIT               
     {
        long long x = stoll($1);
        if (x <= 2147483647 && x >= -2147483648) {
            $$ = new NodeInt(stoi($1));
        }
        else {
            yyerror("overflow of value for integer type\n");
        }
     }
     | TIDENT
     { 
        if(symbol_table.contains($1))
            $$ = new NodeIdent($1); 
        else
            yyerror("using undeclared variable.\n");
     }
     | Expri TPLUS Expri
     {
        Node *left = $1;
        Node *right = $3; 

        NodeInt *l = dynamic_cast<NodeInt*>(left);
        NodeInt *r = dynamic_cast<NodeInt*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeInt(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::PLUS, left, right);
        }
     }
     | Expri TDASH Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeInt *l = dynamic_cast<NodeInt*>(left);
        NodeInt *r = dynamic_cast<NodeInt*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeInt(l->value-r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::MINUS, left, right);
        }
     }
     | Expri TSTAR Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeInt *l = dynamic_cast<NodeInt*>(left);
        NodeInt *r = dynamic_cast<NodeInt*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeInt(l->value*r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::MULT, left, right);
        }
     }
     | Expri TSLASH Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeInt *l = dynamic_cast<NodeInt*>(left);
        NodeInt *r = dynamic_cast<NodeInt*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeInt(l->value/r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::DIV, left, right);
        }
     }
     | TLPAREN Expri TRPAREN 
     { $$ = $2; }
     | Expri TTERN Expri TTEREX Expri
     { $$ = new NodeTern($1,$3,$5); }
     ;

Exprl: TINT_LIT               
     {
        $$ = new NodeLong(stoll($1));
     }
     | TIDENT
     { 
        if(symbol_table.contains($1))
            $$ = new NodeIdent($1); 
        else
            yyerror("using undeclared variable.\n");
     }
     | Expri TPLUS Expri
     {
        Node *left = $1;
        Node *right = $3; 

        NodeLong *l = dynamic_cast<NodeLong*>(left);
        NodeLong *r = dynamic_cast<NodeLong*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeLong(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::PLUS, left, right);
        }
     }
     | Expri TDASH Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeLong *l = dynamic_cast<NodeLong*>(left);
        NodeLong *r = dynamic_cast<NodeLong*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeLong(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::MINUS, left, right);
        }
     }
     | Expri TSTAR Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeLong *l = dynamic_cast<NodeLong*>(left);
        NodeLong *r = dynamic_cast<NodeLong*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeLong(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::MULT, left, right);
        }
     }
     | Expri TSLASH Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeLong *l = dynamic_cast<NodeLong*>(left);
        NodeLong *r = dynamic_cast<NodeLong*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeLong(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::DIV, left, right);
        }
     }
     | TLPAREN Expri TRPAREN 
     { $$ = $2; }
     | Expri TTERN Expri TTEREX Expri
     { $$ = new NodeTern($1,$3,$5); }
     ;

Exprs: TINT_LIT               
     {
        long long x = stoll($1);
        if (x <= 32767 && x >= -32768) {
            $$ = new NodeShort(stoi($1));
        }
        else {
            yyerror("overflow of value for integer type\n");
        }
     }
     | TIDENT
     { 
        if(symbol_table.contains($1))
            $$ = new NodeIdent($1); 
        else
            yyerror("using undeclared variable.\n");
     }
     | Expri TPLUS Expri
     {
        Node *left = $1;
        Node *right = $3; 

        NodeShort *l = dynamic_cast<NodeShort*>(left);
        NodeShort *r = dynamic_cast<NodeShort*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeShort(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::PLUS, left, right);
        }
     }
     | Expri TDASH Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeShort *l = dynamic_cast<NodeShort*>(left);
        NodeShort *r = dynamic_cast<NodeShort*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeShort(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::MINUS, left, right);
        }
     }
     | Expri TSTAR Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeShort *l = dynamic_cast<NodeShort*>(left);
        NodeShort *r = dynamic_cast<NodeShort*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeShort(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::MULT, left, right);
        }
     }
     | Expri TSLASH Expri
     {
        Node *left = $1;
        Node *right = $3;

        NodeShort *l = dynamic_cast<NodeShort*>(left);
        NodeShort *r = dynamic_cast<NodeShort*>(right);
        // Constant folding
        if (l && r) {
            $$ = new NodeShort(l->value+r->value);
        } else {
            $$ = new NodeBinOp(NodeBinOp::DIV, left, right);
        }
     }
     | TLPAREN Expri TRPAREN 
     { $$ = $2; }
     | Expri TTERN Expri TTEREX Expri
     { $$ = new NodeTern($1,$3,$5); }
     ;

%%

int yyerror(std::string msg) {
    std::cerr << "Error! " << msg << std::endl;
    exit(1);
}