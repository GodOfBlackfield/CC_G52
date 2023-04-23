#ifndef SYMBOL_HH
#define SYMBOL_HH

#include <unordered_map>
#include <string>
#include <vector>
#include "ast.hh"


// Basic symbol table, just keeping track of prior existence and nothing else
struct SymbolTable {
    std::vector<std::unordered_map<std::string,std::string>> table;
    int scope = 0;

    bool contains(std::string key);
    int type(std::string key);
    void insert(std::string key,std::string type);
    void nextscope();
    void prevscope();
};

#endif