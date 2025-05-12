#ifndef A4_TRANSLATOR_H
#define A4_TRANSLATOR_H

#include <string>
#include <vector>
#include <map>
#include <iostream>

// Constants for data type sizes and alignment
const unsigned int SIZE_OF_INT = 4;
const unsigned int SIZE_OF_STR_PTR = 4;
const unsigned int ADDR_ALIGNMENT = 4;

// Forward declarations
class Quad;
class SymbolTableEntry;
class StringTableEntry;

// Symbol Table Entry class
class SymbolTableEntry {
public:
    std::string name;            // Name/lexeme of the symbol
    std::string type;            // Data type (INTEGER, STRING)
    std::string category;        // user-defined or compiler-generated
    std::string initialValue;    // Initial value if any
    int size;                    // Size in bytes
    int offset;                  // Offset from base

    SymbolTableEntry(const std::string& n, const std::string& t, const std::string& c, 
                    const std::string& iv = "", int s = 0, int o = 0)
        : name(n), type(t), category(c), initialValue(iv), size(s), offset(o) {}
};

// String Table Entry class
class StringTableEntry {
public:
    std::string name;     // Pseudo name (e.g., t_str1)
    std::string value;    // Actual string value
    int size;            // Size in bytes
    int offset;          // Aligned offset

    StringTableEntry(const std::string& n, const std::string& v, int s, int o)
        : name(n), value(v), size(s), offset(o) {}
};

// Quad class for Three Address Code
class Quad {
public:
    std::string op;      // Operator
    std::string arg1;    // First argument
    std::string arg2;    // Second argument (optional)
    std::string result;  // Result
    int index;          // Index in quad array

    Quad(const std::string& o, const std::string& r = "", 
         const std::string& a1 = "", const std::string& a2 = "", int i = -1)
        : op(o), arg1(a1), arg2(a2), result(r), index(i) {}

    std::string toString() const;  // Convert quad to string representation
};

// Symbol Table class
class SymbolTable {
private:
    std::vector<SymbolTableEntry> table;
    int tempCount;       // Counter for generating temporaries
    int currentOffset;   // Current offset for allocation

public:
    SymbolTable() : tempCount(0), currentOffset(0) {}

    SymbolTableEntry* lookup(const std::string& name);  // Lookup or create entry
    SymbolTableEntry* gentemp(const std::string& type = "INTEGER");  // Generate temporary
    void update(const std::string& name, const std::string& type, 
                const std::string& category, const std::string& initialValue = "");
    void print() const;  // Print table contents
    int getSize() const { return currentOffset; }  // Get total size of variables
};

// String Table class
class StringTable {
private:
    std::vector<StringTableEntry> table;
    int currentOffset;   // Current offset for allocation
    int stringCount;     // Counter for generating names

public:
    StringTable() : currentOffset(0), stringCount(0) {}

    StringTableEntry* addString(const std::string& value);  // Add new string
    StringTableEntry* lookup(const std::string& value);     // Lookup existing string
    void print() const;  // Print table contents
    int getSize() const { return currentOffset; }  // Get total size of strings
};

// QuadArray class
class QuadArray {
public:  // Made public for parser access
    std::vector<Quad> array;

    QuadArray() {}

    void emit(const std::string& op, const std::string& result = "",
              const std::string& arg1 = "", const std::string& arg2 = "");
    void print() const;  // Print all quads
    
    // Backpatching methods
    std::vector<int> makelist(int i);     // Create new list with index i
    std::vector<int> merge(const std::vector<int>& p1, const std::vector<int>& p2);  // Merge two lists
    void backpatch(const std::vector<int>& p, int l);  // Backpatch list p with label l
    
    int nextInstr() const { return array.size(); }  // Get next instruction number
    const std::vector<Quad>& getArray() const { return array; }  // Get quad array
};

// Global instances
extern SymbolTable symbolTable;
extern StringTable stringTable;
extern QuadArray quadArray;

#endif // A4_TRANSLATOR_H