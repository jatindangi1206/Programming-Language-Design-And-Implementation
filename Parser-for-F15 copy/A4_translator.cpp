#include "A4_translator.h"
#include <iomanip>
#include <sstream>
#include <fstream>

// Global instances
SymbolTable symbolTable;
StringTable stringTable;
QuadArray quadArray;

// Forward declarations
extern FILE* yyin;
extern int yyparse();

// Convert quad to string representation
std::string Quad::toString() const {
    std::stringstream ss;
    ss << std::setw(4) << index << ": ";
    
    if (op == "=") {
        ss << result << " = " << arg1;
    } else if (op == "goto") {
        ss << "goto " << result;
    } else if (op.substr(0, 2) == "if") {
        ss << "if " << arg1 << " " << op.substr(2) << " " << arg2 << " goto " << result;
    } else if (op == "in") {
        ss << "in " << result;
    } else if (op == "out") {
        ss << "out " << result;
    } else if (op == "return") {
        ss << "return " << result;
    } else if (op == "param") {
        ss << "param " << result;
    } else if (op == "call") {
        ss << result << " = call " << arg1;
        if (!arg2.empty()) ss << " " << arg2;
    } else if (op == "=[]") {
        ss << result << " = " << arg1 << "[" << arg2 << "]";
    } else if (op == "[]=") {
        ss << result << "[" << arg1 << "] = " << arg2;
    } else {
        ss << result << " = " << arg1 << " " << op << " " << arg2;
    }
    
    return ss.str();
}

// Symbol Table methods
SymbolTableEntry* SymbolTable::lookup(const std::string& name) {
    // Search for existing entry
    for (auto& entry : table) {
        if (entry.name == name) {
            return &entry;
        }
    }
    
    // Create new entry with default values
    table.emplace_back(name, "", "user-defined");
    return &table.back();
}

SymbolTableEntry* SymbolTable::gentemp(const std::string& type) {
    std::string name = "t" + std::to_string(tempCount++);
    int size = (type == "INTEGER" ? SIZE_OF_INT : SIZE_OF_STR_PTR);
    
    // Create aligned offset
    int alignedOffset = ((currentOffset + ADDR_ALIGNMENT - 1) / ADDR_ALIGNMENT) * ADDR_ALIGNMENT;
    table.emplace_back(name, type, "compiler-generated", "", size, alignedOffset);
    currentOffset = alignedOffset + size;
    
    return &table.back();
}

void SymbolTable::update(const std::string& name, const std::string& type,
                        const std::string& category, const std::string& initialValue) {
    auto entry = lookup(name);
    entry->type = type;
    entry->category = category;
    entry->initialValue = initialValue;
    
    // Update size and offset
    if (type == "INTEGER") {
        entry->size = SIZE_OF_INT;
    } else if (type == "STRING") {
        entry->size = SIZE_OF_STR_PTR;
    }
    
    int alignedOffset = ((currentOffset + ADDR_ALIGNMENT - 1) / ADDR_ALIGNMENT) * ADDR_ALIGNMENT;
    entry->offset = alignedOffset;
    currentOffset = alignedOffset + entry->size;
}

void SymbolTable::print() const {
    std::cout << "\nSymbol Table\n";
    std::cout << std::setw(15) << "Name" 
              << std::setw(10) << "Type"
              << std::setw(20) << "Category"
              << std::setw(15) << "Initial Value"
              << std::setw(8) << "Size"
              << std::setw(8) << "Offset" << std::endl;
    std::cout << std::string(76, '-') << std::endl;
    
    for (const auto& entry : table) {
        std::cout << std::setw(15) << entry.name
                  << std::setw(10) << entry.type
                  << std::setw(20) << entry.category
                  << std::setw(15) << entry.initialValue
                  << std::setw(8) << entry.size
                  << std::setw(8) << entry.offset << std::endl;
    }
}

// String Table methods
StringTableEntry* StringTable::addString(const std::string& value) {
    std::string name = "str" + std::to_string(stringCount++);
    int size = value.length() + 1;  // +1 for null terminator
    
    // Align offset
    int alignedOffset = ((currentOffset + ADDR_ALIGNMENT - 1) / ADDR_ALIGNMENT) * ADDR_ALIGNMENT;
    table.emplace_back(name, value, size, alignedOffset);
    currentOffset = alignedOffset + size;
    
    return &table.back();
}

StringTableEntry* StringTable::lookup(const std::string& value) {
    for (auto& entry : table) {
        if (entry.value == value) {
            return &entry;
        }
    }
    return addString(value);
}

void StringTable::print() const {
    std::cout << "\nString Table\n";
    std::cout << std::setw(10) << "Name"
              << std::setw(30) << "Value"
              << std::setw(8) << "Size"
              << std::setw(8) << "Offset" << std::endl;
    std::cout << std::string(56, '-') << std::endl;
    
    for (const auto& entry : table) {
        std::cout << std::setw(10) << entry.name
                  << std::setw(30) << entry.value
                  << std::setw(8) << entry.size
                  << std::setw(8) << entry.offset << std::endl;
    }
}

// QuadArray methods
void QuadArray::emit(const std::string& op, const std::string& result,
                    const std::string& arg1, const std::string& arg2) {
    array.emplace_back(op, result, arg1, arg2, array.size());
}

void QuadArray::print() const {
    std::cout << "\nQuad Array\n";
    std::cout << std::string(50, '-') << std::endl;
    for (const auto& quad : array) {
        std::cout << quad.toString() << std::endl;
    }
}

std::vector<int> QuadArray::makelist(int i) {
    return std::vector<int>{i};
}

std::vector<int> QuadArray::merge(const std::vector<int>& p1, const std::vector<int>& p2) {
    std::vector<int> result = p1;
    result.insert(result.end(), p2.begin(), p2.end());
    return result;
}

void QuadArray::backpatch(const std::vector<int>& p, int l) {
    for (int i : p) {
        if (i < array.size()) {
            array[i].result = std::to_string(l);
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <input_file.f15>" << std::endl;
        return 1;
    }
    
    // Open input file
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        std::cerr << "Error: Could not open input file " << argv[1] << std::endl;
        return 1;
    }
    
    // Parse input and generate TAC
    if (yyparse()) {
        std::cerr << "Parsing failed!" << std::endl;
        return 1;
    }
    
    // Print tables and generated code
    symbolTable.print();
    stringTable.print();
    quadArray.print();
    
    fclose(yyin);
    return 0;
}