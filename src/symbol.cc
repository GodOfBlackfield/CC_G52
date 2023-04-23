#include "symbol.hh"

bool SymbolTable::contains(std::string key) {
    if (table.size() == 0) {
        std::unordered_map<std::string,std::string> m;
        table.push_back(m);
    }
    for (int i = scope; i >= 0; i--) {
        if (table[i].count(key)) {
            return true;
        }
    }
    return false;
}

int SymbolTable::type(std::string key) {
    if (table[scope][key] == "int") {
        return 1;
    }
    else if (table[scope][key] == "long") {
        return 2;
    }
    else if (table[scope][key] == "short") {
        return 3;
    }
    return 0;
}

void SymbolTable::insert(std::string key,std::string type) {
    if (table.size() == 0) {
        std::unordered_map<std::string,std::string> m;
        table.push_back(m);
    }
    table[scope].insert({key,type});
}

void SymbolTable::nextscope() {
    std::unordered_map<std::string,std::string> m;
    table.push_back(m);
    scope++;
}

void SymbolTable::prevscope() {
    if (scope > 0) {
        table.pop_back();
        scope--;
    }
}