#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>


// Maximum number of scopes
#define MAX_SCOPES 10

// Maximum number of variables per scope
#define MAX_VARIABLES 100

// Struct representing a variable entry in the symbol table
// Struct representing a variable entry in the symbol table
// Maximum length for identifier and string values
#define MAX_NAME_LENGTH 50
#define MAX_STRING_LENGTH 100

typedef struct {
    char identifier[MAX_NAME_LENGTH];
    // char identifierName[MAX_NAME_LENGTH];
    bool isConst;
    int type;
    int intValue;
    float floatValue;
    char charValue;
    char stringValue[MAX_STRING_LENGTH];
    int boolValue;
    int reg;
} VariableEntry;

VariableEntry createDefaultVariableEntry() {
    VariableEntry entry;
    strncpy(entry.identifier, "\0", MAX_NAME_LENGTH-1);  // Empty string
    // entry.identifier[MAX_STRING_LENGTH - 1] = '\0';  // Manually null-terminate the string
    entry.isConst = 0;
    entry.type = -1;   // int: 1, float: 2, char: 3, string: 4, bool: 5
    entry.intValue = 0;
    entry.floatValue = 0.0f;
    entry.charValue = '\0';
    strncpy(entry.stringValue, "\0", MAX_STRING_LENGTH-1);  // Empty string
    // entry.stringValue[MAX_STRING_LENGTH - 1] = '\0';  // Manually null-terminate the string
    entry.boolValue = 0;
    entry.reg = -1;
    return entry;
}



// Array of hashes representing the symbol table
VariableEntry symbolTable[MAX_SCOPES][MAX_VARIABLES];

// default values for the symbol table
void initializeSymbolTable() {
    // printf("Initializing symbol table\n");
    for (int i = 0; i < MAX_SCOPES; i++) {
        for (int j = 0; j < MAX_VARIABLES; j++) {
            symbolTable[i][j] = createDefaultVariableEntry();
        }
    }
    // printf("Symbol table initialized\n");
}

// Function to check if a variable exists in the symbol table
int variableExists(int scope, const char* identifier) {
    for (int i = scope; i >= 0; i--) {
        VariableEntry* entry = &symbolTable[i][0];
        // Iterate through the variables in the scope
        for (int j = 0; j < MAX_VARIABLES; j++) {

            if (strcmp(entry->identifier, identifier) == 0) {
                return 1; // Variable found
            }
            entry++;
        }
    }

    return 0; // Variable not found
}

// Function to add a variable to the symbol table
// 1 for successful operation
// 2 for already declared variable
// 3 for scope overflow
int  addVariable(int scope, const char* identifier, bool isConst, int type, int intValue, float floatValue, char charValue, const char* stringValue, int boolValue) {
    if(variableExists(scope, identifier)==1) {
        // printf("Variable or Function %s already exists in scope %d\n", identifier, scope);
        return 2;
    }
    
    // printf("PRINTING INPUTS %d %s %d %d %d %f %c %s %d \n",scope, identifier, isConst, type, intValue, floatValue, charValue, stringValue, boolValue);
    VariableEntry* entry = &symbolTable[scope][0];
    // Find the first available slot in the scope
    int index = 0;
    
    while (strcmp(entry->identifier, "") != 0 && index < MAX_VARIABLES) {
        entry = &symbolTable[scope][index++];
    }

    // If the slot is available, add the variable entry
    if (index < MAX_VARIABLES) {
        // printf("Adding variable to symbol table\n");
        strncpy(entry->identifier, identifier, MAX_STRING_LENGTH - 1);
        entry->identifier[MAX_STRING_LENGTH - 1] = '\0';  // Manually null-terminate the string
        // strncpy(entry->identifierName, identifierName, MAX_NAME_LENGTH - 1);
        entry->type = type;
        entry->intValue = intValue;
        entry->floatValue = floatValue;
        entry->charValue = charValue;
        // printf("Adding variable to symbol table\n");
        strncpy(entry->stringValue, stringValue, MAX_STRING_LENGTH - 1);
        entry->stringValue[MAX_STRING_LENGTH - 1] = '\0';  // Manually null-terminate the string
        entry->boolValue = boolValue;
        entry->isConst= isConst;
    } else {
        // printf("Symbol table overflow: Maximum variables per scope exceeded.\n");
        return 3;
    }
    return 1;
}


// Function to get the type of a variable from the symbol table
int getVariableType(int scope, char* identifier) {

    for (int i = scope; i >= 0; i--) {
        VariableEntry* entry = &symbolTable[i][0];
        // Iterate through the variables in the scope
        for (int j = 0; j < MAX_VARIABLES; j++) {
                
            if (strcmp(entry->identifier, identifier) == 0) {
                return entry->type; // Variable found
            }
            entry++;
        }
    }

    return -1; // Variable not found
}

// update the value of a variable assumes that the variable exists, the type is correct
int updateVariable(int scope, const char* identifier, int intValue, float floatValue, char charValue, const char* stringValue, int boolValue) {
    // printf("Updating variable %s\n", identifier);
    for (int i = scope; i >= 0; i--) {
        VariableEntry* entry = &symbolTable[i][0];
        // Iterate through the variables in the scope
        for (int j = 0; j < MAX_VARIABLES; j++) {

            if (strcmp(entry->identifier, identifier) == 0) {
                // printf("Variable found\n");
                entry->intValue = intValue;
                entry->floatValue = floatValue;
                entry->charValue = charValue;
                strncpy(entry->stringValue, stringValue, MAX_STRING_LENGTH - 1);
                entry->stringValue[MAX_STRING_LENGTH - 1] = '\0';  // Manually null-terminate the string
                entry->boolValue = boolValue;
                return 1; // Variable found
            }
            entry++;
        }
    }

    return -1; // Variable not found
}


typedef struct {
    int intValue;
    float floatValue;
    char charValue;
    char* stringValue;
    int boolValue;
    int isConst;
    int reg;
} values;

values getVariableValue(int scope, char* identifier) {

    // Iterate through the variables in the scope
    for (int i = scope; i >= 0; i--) {
        VariableEntry* entry = &symbolTable[i][0];
        for (int i = 0; i < MAX_VARIABLES; i++) {
            if (strcmp(entry->identifier, identifier) == 0) {
                values val;
                val.intValue = entry->intValue;
                val.floatValue = entry->floatValue;
                val.charValue = entry->charValue;
                val.stringValue = entry->stringValue;
                val.boolValue = entry->boolValue;
                val.isConst = entry->isConst;
                val.reg = entry->reg;
                return val; // Return the type of the variable
            }
            entry++;
        }
    }

    values val;
    val.intValue = 0;
    val.floatValue = 0.0f;
    val.charValue = '\0';
    val.stringValue = "";
    val.boolValue = 0;
    val.isConst = 0;
    val.reg = -1;
    return val; // Variable not found
}
// update the variable register
int updateVariableReg(int scope, const char* identifier, int reg) {
    // printf("Updating variable %s\n", identifier);
    for (int i = scope; i >= 0; i--) {
        VariableEntry* entry = &symbolTable[i][0];
        // Iterate through the variables in the scope
        for (int j = 0; j < MAX_VARIABLES; j++) {

            if (strcmp(entry->identifier, identifier) == 0) {
                // printf("Variable found\n");
                entry->reg = reg;
                return 1; // Variable found
            }
            entry++;
        }
    }

    return -1; // Variable not found
}

// when leaving a scope, remove all variables in that scope use createDefaultVariableEntry
void removeScope(int scope) {
    VariableEntry* entry = &symbolTable[scope][0];
    for (int i = 0; i < MAX_VARIABLES; i++) {
        *entry = createDefaultVariableEntry();
        entry++;
    }
}



// Function to print the symbol table
void printTable(char* text, int scope) {
    // fprintf("Symbol Table:\n");
    FILE* file = fopen("parseTable.txt", "a");
    if (file == NULL) {
        // printf("Error opening file.\n");
        return;
    }
    fprintf(file, "%s\n", text);

    // Iterate over the symbol table and write each entry to the file
    // for (int i = 0; i < MAX_SCOPES; i++) {
        for (int j = 0; j < MAX_VARIABLES; j++) {
            VariableEntry* entry = &symbolTable[scope][j];
            if (strcmp(entry->identifier, "") != 0) {
                fprintf(file, "Scope: %d, Identifier: %s, Type: %d, Reg: %d, Value: ", scope, entry->identifier, entry->type, entry->reg);
                switch (entry->type) {// int: 1, float: 2, char: 3, string: 4, bool: 5
                    case 1:
                        fprintf(file, "%d", entry->intValue);
                        break;
                    case 2:
                        fprintf(file, "%f", entry->floatValue);
                        break;
                    case 3:
                        fprintf(file, "%c", entry->charValue);
                        break;
                    case 4:
                        fprintf(file, "%s", entry->stringValue);
                        break;
                    case 5:
                        fprintf(file, "%d", entry->boolValue);
                        break;
                    default:
                        fprintf(file, "Invalid type.");
                        break;
                }
                fprintf(file, ", isConst = %d\n", entry->isConst);

            }
        }   
    // }
    

    // Close the file
    fclose(file);
}

////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------- Quadruple Functions --------------------------------
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
// Function to allocate a variable in a register

// saving the quadruples in a fileis not correct CORRECT IT 
// FILE* qFile = fopen("quads.txt", "w");
// if (qFile == NULL) {
//     printf("Error opening file.\n");
//     return;
// }
// fprintf(qFile, "quadruples:\n");
// fclose(qFile);
typedef struct {
    char* identifier;
    int label;
} labelEntry;

#define MAX_LABELS 100

labelEntry labelTable[MAX_LABELS];

int registerNumber = 0;
int labelNumber = 0;
int firstIfLabel = -1;
int labelEntries = 0;
int conditionNumber = 0;
int caseCount = 0;

void initializeLabelTable() {
    for (int i = 0; i < MAX_LABELS; i++) {
        labelTable[i].identifier = "";
        labelTable[i].label = -1;
    }
}

void printLables() {
    // printf("Label Table:\n");
    for (int i = 0; i < labelEntries; i++) {
        if (labelTable[i].label == -1) {
            break;
        }
    }
}

labelEntry getLabel(char* name)
{
    for (int i = 0; i < labelEntries; i++) {
        if (strcmp(labelTable[i].identifier, name) == 0) {
            return labelTable[i];
        }
    }
    labelEntry entry;
    entry.identifier = "";
    entry.label = -1;
    return entry;
}

void endMainQuad() {
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MAIN_END:\n");
    fclose(qFile);
}

void createLabel(char* name)
{
    labelEntry entry;
    entry.identifier = name;
    entry.label = labelNumber;
    labelTable[labelEntries++] = entry;
    FILE* qFile = fopen("finalQuads.txt", "a");

    if (strcmp(name, "MAIN") == 0) {
        fprintf(qFile, "LABEL_%s:\n\n", name);
    } else {
        fprintf(qFile, "LABEL_%s_%d:\n\n", name, labelNumber++);
    }
    
    fclose(qFile);
}


int functionCallQuad(char* name) {
    labelEntry entry = getLabel(name);

    if (entry.label == -1) {
        return -1;
    }
    
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "JMP LABEL_%s_%d:\n\n", name, entry.label);
    // fprintf(qFile, "CALL_LABEL_%s_%d:\n\n", name, entry.label);
    

    fclose(qFile);

    return 1;
}

void functionEndQuad() {

    
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "JMP LINE_NO\n\n");    

    fclose(qFile);
}

////////////////////////////////////////////////////////////////////////////////////////
void allocateRegister(char* id, int currentScope)
{
    updateVariableReg(currentScope, id, registerNumber);
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, %s\n\n", registerNumber++, id);
    fclose(qFile);
}
// Functions to allocate a variables in a register
void allocateIntValReg(char* id, int currentScope)
{
    updateVariableReg(currentScope, id, registerNumber);
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", registerNumber, registerNumber-1); //CHECK: if we remove this
    fprintf(qFile, "MOV %s, R%d\n\n", id, registerNumber++);            // here use registerNumber-1
    fclose(qFile);
}
void allocateFloatValReg(char* id, int currentScope)
{
    updateVariableReg(currentScope, id, registerNumber);
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", registerNumber, registerNumber-1); //CHECK: if we remove this
    fprintf(qFile, "MOV %s, R%d\n\n", id, registerNumber++);            // here use registerNumber-1
    fclose(qFile);
}
void allocateCharValReg(char* id, int currentScope)
{   
    updateVariableReg(currentScope, id, registerNumber);
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", registerNumber, registerNumber-1); //CHECK: if we remove this
    fprintf(qFile, "MOV %s, R%d\n\n", id, registerNumber++);            // here use registerNumber-1
    fclose(qFile);
}
void allocateStringValReg(char* id, int currentScope)
{
    updateVariableReg(currentScope, id, registerNumber);
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", registerNumber, registerNumber-1); //CHECK: if we remove this
    fprintf(qFile, "MOV %s, R%d\n\n", id, registerNumber++);            // here use registerNumber-1
    fclose(qFile);
}
void allocateBoolValReg(char* id, int currentScope)
{
    updateVariableReg(currentScope, id, registerNumber);
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", registerNumber, registerNumber-1); //CHECK: if we remove this
    fprintf(qFile, "MOV %s, R%d\n\n", id, registerNumber++);            // here use registerNumber-1
    fclose(qFile);
}
////////////////////////////////////////////////////////////////////////////////////////
void assignIntValReg(int reg, char* id)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", reg, registerNumber-1);
    fprintf(qFile, "MOV %s, R%d\n\n", id, reg);
    fclose(qFile);
}
void assignFloatValReg(int reg, char* id)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", reg, registerNumber-1);
    fprintf(qFile, "MOV %s, R%d\n\n", id, reg);
    fclose(qFile);
}
void assignCharValReg(int reg, char* id)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", reg, registerNumber-1);
    fprintf(qFile, "MOV %s, R%d\n\n", id, reg);
    fclose(qFile);
}
void assignStringValReg(int reg, char* id)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", reg, registerNumber-1);
    fprintf(qFile, "MOV %s, R%d\n\n", id, reg);
    fclose(qFile);
}
void assignBoolValReg(int reg, char* id)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n", reg, registerNumber-1);
    fprintf(qFile, "MOV %s, R%d\n\n", id, reg);
    fclose(qFile);
}
////////////////////////////////////////////////////////////////////////////////////////
void allocateDigitReg(int value)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, %d\n\n", registerNumber++, value);
    fclose(qFile);
}
void allocateIdentifierReg(int reg)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n\n", registerNumber++, reg);
    fclose(qFile);
}
void allocateLastReg(){
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, R%d\n\n", registerNumber, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
void addTwoInts()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "ADD R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
void subTwoInts()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "SUB R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}

void mulTwoInts(){
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MUL R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
void divTwoInts(){
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "DIV R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
void modTwoInts()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "DIV R%d, R%d, R%d\n",registerNumber, registerNumber-2, registerNumber-1);
    fprintf(qFile, "MOD R%d, DX\n\n", registerNumber);
    registerNumber++;

    fclose(qFile);
}
void incQuad(int reg, char* id)
{
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "INC R%d\n", reg);
    fprintf(qFile, "MOV R%d, R%d\n", registerNumber, reg);
    fprintf(qFile, "MOV %s, R%d\n\n", id, registerNumber++);

    fclose(qFile);
}
void decQuad(int reg, char* id)
{
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "DEC R%d\n", reg);
    fprintf(qFile, "MOV R%d, R%d\n", registerNumber, reg);
    fprintf(qFile, "MOV %s, R%d\n\n", id, registerNumber++);

    fclose(qFile);
}

////////////////////////////////////////////////////////////////////////////////////////

void allocateFloatReg(float value)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, %f\n\n", registerNumber++, value);
    fclose(qFile);
}
void addTwoFloats()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "FADD R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
void subTwoFloats()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "FSUB R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
void mulTwoFloats()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "FMUL R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
void divTwoFloats()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "FDIV R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}

////////////////////////////////////////////////////////////////////////////////////////
void allocateStringReg(char* value)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, %s\n\n", registerNumber++, value);
    fclose(qFile);
}
void addTwoStrings()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "SADD R%d, R%d, R%d\n\n",registerNumber, registerNumber-2, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
////////////////////////////////////////////////////////////////////////////////////////
void allocateBoolReg(int value)
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "MOV R%d, %d\n\n", registerNumber++, value);
    fclose(qFile);
}
void orQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "OR R%d, R%d, R%d\n\n", registerNumber, registerNumber-1, registerNumber-2);
    registerNumber++;
    fclose(qFile);
}
void andQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "AND R%d, R%d, R%d\n\n", registerNumber, registerNumber-1, registerNumber-2);
    registerNumber++;
    fclose(qFile);
}
void notQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "NOT R%d, R%d\n\n", registerNumber, registerNumber-1);
    registerNumber++;
    fclose(qFile);
}
void greaterThanQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "CMP R%d, R%d\n", registerNumber-2, registerNumber-1);
    fprintf(qFile, "MOV R%d, %d \n",registerNumber, 1);
    fprintf(qFile, "JG S%d\n", conditionNumber);
    fprintf(qFile, "NS%d: MOV R%d, %d\n", conditionNumber, registerNumber, 0);
    fprintf(qFile, "S%d: \n\n", conditionNumber);

    conditionNumber++;
    registerNumber++;
    fclose(qFile);
}
void lessThanQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "CMP R%d, R%d\n", registerNumber-2, registerNumber-1);
    fprintf(qFile, "MOV R%d, %d \n",registerNumber, 1);
    fprintf(qFile, "JL S%d\n", conditionNumber);
    fprintf(qFile, "NS%d: MOV R%d, %d\n", conditionNumber, registerNumber, 0);
    fprintf(qFile, "S%d: \n\n", conditionNumber);

    conditionNumber++;
    registerNumber++;
    fclose(qFile);
}
void greaterThanEqualQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "CMP R%d, R%d\n", registerNumber-2, registerNumber-1);
    fprintf(qFile, "MOV R%d, %d \n",registerNumber, 1);
    fprintf(qFile, "JGE S%d\n", conditionNumber);
    fprintf(qFile, "NS%d: MOV R%d, %d\n", conditionNumber, registerNumber, 0);
    fprintf(qFile, "S%d: \n\n", conditionNumber);

    conditionNumber++;
    registerNumber++;
    fclose(qFile);
}
void lessThanEqualQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "CMP R%d, R%d\n", registerNumber-2, registerNumber-1);
    fprintf(qFile, "MOV R%d, %d \n",registerNumber, 1);
    fprintf(qFile, "JLE S%d\n", conditionNumber);
    fprintf(qFile, "NS%d: MOV R%d, %d\n", conditionNumber, registerNumber, 0);
    fprintf(qFile, "S%d: \n\n", conditionNumber);

    conditionNumber++;
    registerNumber++;
    fclose(qFile);
}
void equalEqualQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "CMP R%d, R%d\n", registerNumber-2, registerNumber-1);
    fprintf(qFile, "MOV R%d, %d \n",registerNumber, 1);
    fprintf(qFile, "JE S%d\n", conditionNumber);
    fprintf(qFile, "NS%d: MOV R%d, %d\n", conditionNumber, registerNumber, 0);
    fprintf(qFile, "S%d: \n\n", conditionNumber);

    conditionNumber++;
    registerNumber++;
    fclose(qFile);
}
void notEqualQuad()
{
    FILE* qFile = fopen("finalQuads.txt", "a");
    fprintf(qFile, "CMP R%d, R%d\n", registerNumber-2, registerNumber-1);
    fprintf(qFile, "MOV R%d, %d \n",registerNumber, 1);
    fprintf(qFile, "JNE S%d\n", conditionNumber);
    fprintf(qFile, "NS%d: MOV R%d, %d\n", conditionNumber, registerNumber, 0);
    fprintf(qFile, "S%d: \n\n", conditionNumber);

    conditionNumber++;
    registerNumber++;
    fclose(qFile);
}

////////////////////////////////////////////////////////////////////////////////////////
int checkWhileConditionQuad(){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "WHILE_LABEL_%d: \n", conditionNumber);
    fprintf(qFile, "CMP R%d, %d\n", registerNumber-1, 1);
    fprintf(qFile, "JNE WHILE_END_%d\n\n", conditionNumber);

    fclose(qFile);
    return conditionNumber++;
}
void endWhileQuad(int val){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "JMP WHILE_LABEL_%d:\n", val);
    fprintf(qFile, "WHILE_END_%d: \n\n", val);

    fclose(qFile);
}
int forCondNum = 0;
void forDeclareQuad(){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "FOR_LABEL_%d: \n", forCondNum);

    fclose(qFile);
}
int forStartQuad(){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "CMP R%d, %d\n", registerNumber-1, 1);
    fprintf(qFile, "JNE FOR_END_%d\n\n", forCondNum);

    fclose(qFile);
    return forCondNum++;
}
void forEndQuad(int val){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "JMP FOR_LABEL_%d:\n", val);
    fprintf(qFile, "FOR_END_%d: \n\n", val);

    fclose(qFile);
}

int openRepeatQuad(){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "REPEAT_LABEL%d:\n\n", conditionNumber);

    fclose(qFile);
    return conditionNumber++;
}
void endRepeatQuad(int condition){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "CMP R%d, %d\n", registerNumber-1, 1);
    fprintf(qFile, "JNE REPEAT_END_%d:\n", condition);
    fprintf(qFile, "JMP REPEAT_LABEL%d:\n", condition);
    fprintf(qFile, "REPEAT_END_%d: \n\n", condition);

    fclose(qFile);
}


////////////////////////////////////////////////////////////////////////////////////////
int getSwitchCondition(){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "SWITCH_START_%d: \n\n", conditionNumber);

    fclose(qFile);    

    return conditionNumber++;
}

void startCaseQuad(int type, int reg, int intVal, float floatVal, char charVal, char* stringVal, int boolVal){
    FILE* qFile = fopen("finalQuads.txt", "a");

    // printf("type INT: %d\n", intVal);
    // printf("type FLOAT: %f\n", floatVal);
    // printf("type CHAR: %c\n", charVal);
    // printf("type STRING: %s\n", stringVal);
    // printf("type BOOL: %d\n", boolVal);
    // printf("type: %d\n", type);

    switch (type)
    {
        case 1:
            fprintf(qFile, "MOV R%d, %d \n", registerNumber, intVal);
            break;
        case 2:
            fprintf(qFile, "MOV R%d, %f \n", registerNumber, floatVal);
            break;
        case 3:
            fprintf(qFile, "MOV R%d, %c \n", registerNumber, charVal);
            break;
        case 4:
            fprintf(qFile, "MOV R%d, %s \n", registerNumber, stringVal);
            break;
        case 5:
            fprintf(qFile, "MOV R%d, %d \n", registerNumber, boolVal);
            break;
        default:  
            // yyerror("Error: Unknown type");
            break;
    }

    fprintf(qFile, "CMP R%d, R%d\n", reg, registerNumber);
    fprintf(qFile, "JNE CASE_END_%d\n", caseCount);


    fclose(qFile);    
    registerNumber++;
}

void endCaseQuad(int condition){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "JMP SWITCH_END_%d\n", condition);
    fprintf(qFile, "CASE_END_%d: \n\n", caseCount);

    fclose(qFile);    
    caseCount++;
}


void endSwitchQuad(int condition){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "SWITCH_END_%d: \n\n", condition);

    fclose(qFile);    
}
////////////////////////////////////////////////////////////////////////////////////////
int ifCounter = 0;
int ifCondsCounter = 0;
int maxIf = 0;
int checkIfConditionQuad(){
    if (maxIf>ifCounter) ifCounter = maxIf;
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "IF_LABEL_%d: \n", ++ifCounter);
    fprintf(qFile, "CMP R%d, %d\n", registerNumber-1, 1);
    fprintf(qFile, "JNE IF_END_%d\n\n", ifCondsCounter);

    fclose(qFile);
    return ifCounter;
}
void endIfQuad(){
    FILE* qFile = fopen("finalQuads.txt", "a");


    fprintf(qFile, "JMP IF_FINISHED_%d:\n", ifCounter);
    fprintf(qFile, "IF_END_%d:\n\n", ifCondsCounter);

    fclose(qFile);

    ifCondsCounter++;
}
void finishIfQuad(){
    FILE* qFile = fopen("finalQuads.txt", "a");

    fprintf(qFile, "IF_FINISHED_%d: \n\n", ifCounter);

    fclose(qFile);
    maxIf = ifCounter--;
}
////////////////////////////////////////////////////////////////////////////////////////



#endif /* SYMBOL_TABLE_H */

