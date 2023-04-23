#include "ast.hh"

#include <string>
#include <vector>

NodeBinOp::NodeBinOp(NodeBinOp::Op ope, Node *leftptr, Node *rightptr) {
    type = BIN_OP;
    op = ope;
    left = leftptr;
    right = rightptr;
}

std::string NodeBinOp::to_string() {
    std::string out = "(";
    switch(op) {
        case PLUS: out += '+'; break;
        case MINUS: out += '-'; break;
        case MULT: out += '*'; break;
        case DIV: out += '/'; break;
    }

    out += ' ' + left->to_string() + ' ' + right->to_string() + ')';

    return out;
}

NodeInt::NodeInt(int val) {
    type = INT_LIT;
    value = val;
}

std::string NodeInt::to_string() {
    return std::to_string(value);
}

NodeLong::NodeLong(long long val) {
    type = LONG_LIT;
    value = val;
}

std::string NodeLong::to_string() {
    return std::to_string(value);
}

NodeShort::NodeShort(short val) {
    type = SHORT_LIT;
    value = val;
}

std::string NodeShort::to_string() {
    return std::to_string(value);
}

NodeStmts::NodeStmts() {
    type = STMTS;
    list = std::vector<Node*>();
}

void NodeStmts::push_back(Node *node) {
    list.push_back(node);
}

std::string NodeStmts::to_string() {
    std::string out = "(begin";
    for(auto i : list) {
        out += " " + i->to_string();
    }

    out += ')';

    return out;
}

NodeAssn::NodeAssn(std::string id, std::string dtype, Node *expr) {
    type = ASSN;
    identifier = id;
    expression = expr;
    datatype = dtype;
}

std::string NodeAssn::to_string() {
    return "(let "+ datatype + " " + identifier + " " + expression->to_string() + ")";
}

NodeDebug::NodeDebug(Node *expr) {
    type = DBG;
    expression = expr;
}

std::string NodeDebug::to_string() {
    return "(dbg " + expression->to_string() + ")";
}

NodeIdent::NodeIdent(std::string ident) {
    identifier = ident;
}
std::string NodeIdent::to_string() {
    return identifier;
}

NodeTern::NodeTern(Node* expression,Node *leftptr,Node *rightptr) {
    type = TERN;
    exp = expression;
    left = leftptr;
    right = rightptr;
}
std::string NodeTern::to_string() {
    return "(?: "+exp->to_string()+" "+left->to_string()+" "+right->to_string()+")";
}

NodeVAssn::NodeVAssn(std::string id,Node *ptr) {
    type = VASSN;
    identifier = id;
    expression = ptr;
}
std::string NodeVAssn::to_string() {
    return "(assign "+identifier+" = "+expression->to_string()+")";
}

NodeIfElse::NodeIfElse(Node *expression,Node *expression_if,Node *expression_else) {
    type = IF_ELSE;
    exp = expression;
    exp_if = expression_if;
    exp_else = expression_else;
}
std::string NodeIfElse::to_string() {
    if (!exp_if && exp_else) {
        return exp_else->to_string();
    }
    else if (exp_if && !exp_else) {
        return exp_if->to_string();
    }
    return "(if "+exp->to_string()+" then "+exp_if->to_string()+" else "+exp_else->to_string()+")";
}