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
    return entry;
}

int registerNumber = 0;

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
    for (int i = 0; i <= scope; i++) {
        VariableEntry* entry = &symbolTable[scope][0];
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
        printf("Variable %s already exists in scope %d\n", identifier, scope);
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
    VariableEntry* entry = &symbolTable[scope][0];

    // Iterate through the variables in the scope
    for (int i = 0; i < MAX_VARIABLES; i++) {
        if (strcmp(entry->identifier, "") == 0) {
            return entry->type; // Return the type of the variable
        }
        entry++;
    }

    return -1; // Variable not found
}


typedef struct {
    int intValue;
    float floatValue;
    char charValue;
    char* stringValue;
    int boolValue;
} values;

values getVariableValue(int scope, char* identifier) {

    // Iterate through the variables in the scope
    for (int i = 0; i <= scope; i++) {
        VariableEntry* entry = &symbolTable[scope][0];
        for (int i = 0; i < MAX_VARIABLES; i++) {
            if (strcmp(entry->identifier, identifier) == 0) {
                values val;
                val.intValue = entry->intValue;
                val.floatValue = entry->floatValue;
                val.charValue = entry->charValue;
                val.stringValue = entry->stringValue;
                val.boolValue = entry->boolValue;
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
    return val; // Variable not found
}


// Function to print the symbol table
void printTable() {
    // fprintf("Symbol Table:\n");
    FILE* file = fopen("parseTable.txt", "w");
    if (file == NULL) {
        printf("Error opening file.\n");
        return;
    }

    // Iterate over the symbol table and write each entry to the file
    for (int i = 0; i < MAX_SCOPES; i++) {
        for (int j = 0; j < MAX_VARIABLES; j++) {
            VariableEntry* entry = &symbolTable[i][j];
            if (strcmp(entry->identifier, "") != 0) {
                fprintf(file, "Scope: %d, Identifier: %s, Type: %d, Value: ", i, entry->identifier, entry->type);
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
    }
    

    // Close the file
    fclose(file);
}


// -------------------------------- Quadruple Functions --------------------------------
// Function to allocate a variable in a register

// saving the quadruples in a fileis not correct CORRECT IT 
// FILE* qFile = fopen("quads.txt", "w");
// if (qFile == NULL) {
//     printf("Error opening file.\n");
//     return;
// }
// fprintf(qFile, "quadruples:\n");
// fclose(qFile);
void allocateRegister(char* id)
{
    FILE* qFile = fopen("quads.txt", "a");
    fprintf(qFile, "MOV R%d, Variable ID: %s\n", registerNumber++, id);
    fclose(qFile);
}
// Functions to allocate a variables in a register
void allocateIntValReg(char* id, int value)
{
    FILE* qFile = fopen("quads.txt", "a");
    fprintf(qFile, "ID: %s, Value: %d\n", id, value);
    fprintf(qFile, "MOV R%d, %s\n", registerNumber++, id);
    fclose(qFile);
}
void allocateFloatValReg(char* id, float value)
{
    FILE* qFile = fopen("quads.txt", "a");
    fprintf(qFile, "ID: %s, Value: %f\n", id, value);
    fprintf(qFile, "MOV R%d, %s\n", registerNumber++, id);
    fclose(qFile);
}
void allocateCharValReg(char* id, char value)
{   
    FILE* qFile = fopen("quads.txt", "a");
    fprintf(qFile, "ID: %s, Value: %c\n", id, value);
    fprintf(qFile, "MOV R%d, %s\n", registerNumber++, id);
    fclose(qFile);
}
void allocateStringValReg(char* id, char* value)
{
    FILE* qFile = fopen("quads.txt", "a");
    fprintf(qFile, "ID: %s, Value: %s\n", id, value);
    fprintf(qFile, "MOV R%d, %s\n", registerNumber++, id);
    fclose(qFile);
}
void allocateBoolValReg(char* id, int value)
{
    FILE* qFile = fopen("quads.txt", "a");
    fprintf(qFile, "ID: %s, Value: %d\n", id, value);
    fprintf(qFile, "MOV R%d, %s\n", registerNumber++, id);
    fclose(qFile);
}
void addTwoInts(int a, int b)
{

    FILE* qFile = fopen("quads.txt", "a");

    // fprintf("adding %d and %d\n", a, b);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber, b);
    fprintf(qFile, "ADD R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}
void addTwoFloats(float a, float b)
{
    FILE* qFile = fopen("quads.txt", "a");

    // fprintf(qFile, "adding %f and %f\n", a, b);
    fprintf(qFile, "MOV R%d, %f\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %f\n", registerNumber, b);
    fprintf(qFile, "ADD R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}
void subTwoInts(int a, int b)
{
    FILE* qFile = fopen("quads.txt", "a");

    // fprintf(qFile, "subtracting %d and %d\n", a, b);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber, b);
    fprintf(qFile, "SUB R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}
void subTwoFloats(float a, float b)
{
    FILE* qFile = fopen("quads.txt", "a");

    // fprintf(qFile, "subtracting %f and %f\n", a, b);
    fprintf(qFile, "MOV R%d, %f\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %f\n", registerNumber, b);
    fprintf(qFile, "SUB R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}
void mulTwoInts(int a, int b)
{
    FILE* qFile = fopen("quads.txt", "a");

    // fprintf(qFile, "multiplying %d and %d\n", a, b);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber, b);
    fprintf(qFile, "MUL R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}
void mulTwoFloats(float a, float b)
{
    FILE* qFile = fopen("quads.txt", "a");

    // fprintf(qFile, "multiplying %f and %f\n", a, b);
    fprintf(qFile, "MOV R%d, %f\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %f\n", registerNumber, b);
    fprintf(qFile, "MUL R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}
void divTwoInts(int a, int b)
{
    FILE* qFile = fopen("quads.txt", "a");

    // fprintf(qFile, "dividing %d and %d\n", a, b);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber, b);
    fprintf(qFile, "DIV R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}
void divTwoFloats(float a, float b)
{
    FILE* qFile = fopen("quads.txt", "a");

    // fprintf(qFile, "dividing %f and %f\n", a, b);
    fprintf(qFile, "MOV R%d, %f\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %f\n", registerNumber, b);
    fprintf(qFile, "DIV R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}
void modTwoInts(int a, int b)
{
    FILE* qFile = fopen("quads.txt", "a");

    // fprintf(qFile, "modding %d and %d\n", a, b);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber++, a);
    fprintf(qFile, "MOV R%d, %d\n", registerNumber, b);
    fprintf(qFile, "MOD R%d, R%d\n", registerNumber, registerNumber-1);

    fclose(qFile);
}

//Function that checks for the conditions
void consitionsQuad(char* symbol, int firstComparater, int secondComparater)
{
    if(symbol == ">=")
    {
        printf("CMP T,Value1: %d,Value2: %d\n", firstComparater, secondComparater);      
        printf("JNeg T,end \n");
    }

    else if(symbol == "<=")
    {
        printf("CMP T,Value1: %d,Value2: %d\n", firstComparater, secondComparater);      
        printf("JPos T,end \n");
    }

    else if(symbol == ">")
    {
        printf("CMP T,Value1: %d,Value2: %d\n", firstComparater, secondComparater);      
        printf("JZ T,end \n");
    }

    else if(symbol == "<")
    {
        printf("CMP T,Value1: %d,Value2: %d\n", firstComparater, secondComparater);      
        printf("JNZ T,end \n");
    }

    else if(symbol == "==")
    {
        printf("CMP T,Value1: %d,Value2: %d\n", firstComparater, secondComparater);      
        printf("JE T,end \n");
    }

    else if(symbol == "!=")
    {
        printf("CMP T,Value1: %d,Value2: %d\n", firstComparater, secondComparater);      
        printf("JNE T,end \n");
    }
}


















/////////////////////////------------ helper functions ------------------/////////////////////////
// void handleReturn(int ret, char* id, void* function){
//     switch (ret){
//         case 1:
//             function(id);
//             break;
//         case 2:                                                            
//             exit(0);
//             break;
//         case 3:
//             yyerror("Overflow in symbol table");
//             exit(0);
//             break;
//         default:
//             yyerror("Unknown error");
//             exit(0);
//             break;
//     }  
// }                                 ///// WRONG FUNCTION


#endif /* SYMBOL_TABLE_H */

