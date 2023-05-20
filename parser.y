%{
    #include<stdio.h>
    #include "symbol_table.h"
    int yylex(void);
    int yyerror(const char* s);
    int main(void);
    int scope = 0;
    int whileConditionNum = 0;
    int forConditionNum = 0;
    int repeatConditionNum = 0;
    int switchIdentifierReg = 0;
    int switchCondition = 0;
    int switchIdentifierType = 0;
%}

%debug

//Tokens Definition
%union {
  int iVal;
  char* sVal;
  float fVal;
  char cVal;
  int bVal;
  struct {
    int intValue;
    float floatValue;
    char charValue;
    char* stringValue;
    int boolValue;
    int isConst;
    int reg;
} values;  
}
%token INT CHAR FLOAT STRING CONST BOOL VOID
%token PLUS MINUS MULTIPLY  DIVIDE  MODULO  INCREMENT  DECREMENT  GREATER  LESS  GREATER_EQUAL  LESS_EQUAL  EQUAL  NOT_EQUAL  AND  OR  NOT  ASSIGN  IF  ELSE  SWITCH  CASE  DEFAULT  CONTINUE   BREAK  THEN  WHILE  DO  FOR  RETURN  REPEAT  UNTIL  LEFT_CURLY_BRACE  RIGHT_CURLY_BRACE  LEFT_PARENTHESIS  RIGHT_PARENTHESIS  LEFT_SQUARE_BRACKET  RIGHT_SQUARE_BRACKET  ENUM  FUNCTION  MAIN  PRINT  SCAN  COMMENT 

%token <sVal> IDENTIFIER
%token <iVal> DIGIT
%token <fVal> FLOAT_LITERAL
%token <sVal> STRING_LITERAL
%token <cVal> CHAR_LITERAL
%token <bVal> BOOL_LITERAL
%type <iVal> intMathExpression
%type <iVal> intMathTerm
%type <iVal> intMathFactor
%type <iVal> intMathPrimary
%type <fVal> floatMathExpression
%type <fVal> floatMathTerm
%type <fVal> floatMathFactor
%type <sVal> stringExpression
%type <bVal> logicalExpression
%type <bVal> logicalTerm
%type <bVal> logicalFactor
%type <bVal> logicalPrimary
%type <values> values
%type <iVal> types


%%

program                         :   statement
                                |   program statement
                                
statement                       :   blockStatements
                                |   functionStatement
                                |   main

blockStatements                 :   blockStatement
                                |   blockStatements blockStatement

blockStatement                  :   variableDeclarationStatement
                                |   constDeclarationStatement
                                |   assignmentStatement
                                |   incStatement
                                |   decStatement
                                |   ifStatement
                                |   switchStatement
                                |   whileStatement
                                |   forStatement
                                |   repeatStatement
                                |   enumStatement
                                |   returnStatement
                                |   printStatement
                                |   continueBreakStatement
                                |   functionCallStatement
                                |   comment

types                           :   INT { $$ = 1; }
                                |   CHAR { $$ = 3; }
                                |   FLOAT { $$ = 2; }
                                |   STRING { $$ = 4; }
                                |   BOOL { $$ = 5; }


values                          :   DIGIT { $$.intValue = $1; printf("values int value %d\n", $$.intValue); }
                                |   FLOAT_LITERAL { $$.floatValue = $1; printf("values float value %f\n", $$.floatValue); }
                                |   STRING_LITERAL { $$.stringValue = $1; printf("values string value %s\n", $$.stringValue); }
                                |   CHAR_LITERAL { $$.charValue = $1; printf("values char value %c\n", $$.charValue); }
                                |   BOOL_LITERAL { $$.boolValue = $1; printf("values bool value %d\n", $$.boolValue); }


expression                      : intMathExpression
                                | floatMathExpression
                                | stringExpression
                                | logicalExpression

variableDeclarationStatement    :  assignVariableDeclaration
                                |  nonAssignVariableDeclaration

noSemiColumnVariableDeclarationStatement :  noSemiColumnAssignVariableDeclaration
                                          |  noSemiColumnNonAssignVariableDeclaration


assignVariableDeclaration           :  noSemiColumnAssignVariableDeclaration ';' {printf("variableDeclaration with semiColun \n");} ;



noSemiColumnAssignVariableDeclaration :  CHAR IDENTIFIER ASSIGN CHAR_LITERAL {
                                                                            printf("variableDeclaration with char \n");
                                                                            int ret = addVariable(scope, $2, 0, 3, 0, 0.0, $4, "", 0);
                                                                            
                                                                            switch (ret){
                                                                              case 1:
                                                                                allocateCharValReg($2, scope);
                                                                                break;
                                                                              case 2:                                                            
                                                                                yyerror("Variable already declared");
                                                                                break;
                                                                              case 3:
                                                                                yyerror("Overflow in symbol table");
                                                                                break;  
                                                                              default:
                                                                                yyerror("Unknown error");
                                                                                break;
                                                                            }   
                                                                          } ;
                                    | INT IDENTIFIER ASSIGN intMathExpression {
                                                                                printf("variableDeclaration with intMathExpression \n");
                                                                                int ret = addVariable(scope, $2, 0, 1, $4, 0.0, '\0', "", 0);

                                                                                  switch (ret){
                                                                                    case 1:
                                                                                      allocateIntValReg($2, scope);
                                                                                      break;
                                                                                    case 2:                                                            
                                                                                      yyerror("Variable already declared");
                                                                                      break;
                                                                                    case 3:
                                                                                      yyerror("Overflow in symbol table");
                                                                                      break;
                                                                                    default:
                                                                                      yyerror("Unknown error");
                                                                                      break;
                                                                                  }   
                                                                              } ;
                                    | FLOAT IDENTIFIER ASSIGN floatMathExpression {
                                                                                    printf("variableDeclaration with floatMathExpression \n");
                                                                                    int ret = addVariable(scope, $2, 0, 2, 0, $4, '\0', "", 0);

                                                                                    switch (ret){
                                                                                      case 1:
                                                                                        allocateFloatValReg($2, scope);
                                                                                        break;
                                                                                      case 2:                                                            
                                                                                        yyerror("Variable already declared");
                                                                                        break;
                                                                                      case 3:
                                                                                        yyerror("Overflow in symbol table");
                                                                                        break;
                                                                                      default:
                                                                                        yyerror("Unknown error");
                                                                                        break;
                                                                                    }   
                                                                                  } ;
                                    | STRING IDENTIFIER ASSIGN stringExpression {
                                                                                  printf("variableDeclaration with stringExpression \n");
                                                                                  int ret = addVariable(scope, $2, 0, 4, 0, 0.0, '\0', $4, 0);

                                                                                  switch (ret){
                                                                                    case 1:
                                                                                      allocateStringValReg($2, scope);
                                                                                      break;
                                                                                    case 2:                                                            
                                                                                      yyerror("Variable already declared");
                                                                                      break;
                                                                                    case 3:
                                                                                      yyerror("Overflow in symbol table");
                                                                                      break;
                                                                                    default:
                                                                                      yyerror("Unknown error");
                                                                                      break;
                                                                                  } 
                                                                                } ;
                                    | BOOL IDENTIFIER ASSIGN logicalExpression {
                                                                                printf("variableDeclaration with logicalExpression \n");
                                                                                int ret = addVariable(scope, $2, 0, 5, 0, 0.0, '\0', "", $4);

                                                                                switch (ret){
                                                                                  case 1:
                                                                                    allocateBoolValReg($2, scope);
                                                                                    break;
                                                                                  case 2:                                                            
                                                                                    yyerror("Variable already declared");
                                                                                    break;
                                                                                  case 3:
                                                                                    yyerror("Overflow in symbol table");
                                                                                    break;
                                                                                  default:
                                                                                    yyerror("Unknown error");
                                                                                    break;
                                                                                }   
                                                                              } ;


nonAssignVariableDeclaration        :  noSemiColumnNonAssignVariableDeclaration ';' {printf("variableDeclaration with semiColun \n");} ;

noSemiColumnNonAssignVariableDeclaration : INT IDENTIFIER {
                                                            printf("variableDeclaration with int \n");
                                                            int ret = addVariable(scope, $2, 0, 1, 0, 0.0, '\0', "", 0);

                                                            switch (ret){
                                                              case 1:
                                                                allocateRegister($2, scope);
                                                                break;
                                                              case 2:                                                            
                                                                yyerror("Variable already declared");
                                                                break;
                                                              case 3:
                                                                yyerror("Overflow in symbol table");
                                                                break;
                                                              default:
                                                                yyerror("Unknown error");
                                                                break;
                                                            }                                                            
                                                          } ;
                                    | CHAR IDENTIFIER {
                                                        printf("variableDeclaration with char \n");
                                                        int ret = addVariable(scope, $2, 0, 3, 0, 0.0, '\0', "", 0);

                                                        switch (ret){
                                                          case 1:
                                                            allocateRegister($2, scope);
                                                            break;
                                                          case 2:                                                            
                                                            yyerror("Variable already declared");
                                                            break;
                                                          case 3:
                                                            yyerror("Overflow in symbol table");
                                                            break;
                                                          default:
                                                            yyerror("Unknown error");
                                                            break;
                                                        }  
                                                      } ;
                                    | FLOAT IDENTIFIER {
                                                          printf("variableDeclaration with float \n");
                                                          int ret = addVariable(scope, $2, 0, 2, 0, 0.0, '\0', "", 0);

                                                          switch (ret){
                                                              case 1:
                                                                allocateRegister($2, scope);
                                                                break;
                                                              case 2:                                                            
                                                                yyerror("Variable already declared");
                                                                break;
                                                              case 3:
                                                                yyerror("Overflow in symbol table");
                                                                break;
                                                              default:
                                                                yyerror("Unknown error");
                                                                break;
                                                            }  
                                                        } ;
                                    | STRING IDENTIFIER {
                                                          printf("variableDeclaration with string \n");
                                                          int ret = addVariable(scope, $2, 0, 4, 0, 0.0, '\0', "", 0);

                                                          switch (ret){
                                                              case 1:
                                                                allocateRegister($2, scope);
                                                                break;
                                                              case 2:                                                            
                                                                yyerror("Variable already declared");
                                                                break;
                                                              case 3:
                                                                yyerror("Overflow in symbol table");
                                                                break;
                                                              default:
                                                                yyerror("Unknown error");
                                                                break;
                                                            }  
                                                        } ;
                                    | BOOL IDENTIFIER {
                                                          printf("variableDeclaration with bool \n");
                                                          int ret = addVariable(scope, $2, 0, 5, 0, 0.0, '\0', "", 0);

                                                          switch (ret){
                                                              case 1:
                                                                allocateRegister($2, scope);
                                                                break;
                                                              case 2:                                                            
                                                                yyerror("Variable already declared");
                                                                break;
                                                              case 3:
                                                                yyerror("Overflow in symbol table");
                                                                break;
                                                              default:
                                                                yyerror("Unknown error");
                                                                break;
                                                            }  
                                                      } ;


constDeclarationStatement           : noSemiColumnConstDeclaration ';' {printf("ConstDeclaration with int \n");} ;

noSemiColumnConstDeclaration        : CONST CHAR IDENTIFIER ASSIGN CHAR_LITERAL {
                                                                                  printf("ConstDeclaration with char \n");
                                                                                  int ret = addVariable(scope, $3, 1, 3, 0, 0.0, $5, "", 0);
                                                                                  
                                                                                  switch (ret){
                                                                                    case 1:
                                                                                      allocateCharValReg($3, scope);
                                                                                      break;
                                                                                    case 2:                                                            
                                                                                      yyerror("Variable already declared");
                                                                                      break;
                                                                                    case 3:
                                                                                      yyerror("Overflow in symbol table");
                                                                                      break;
                                                                                    default:
                                                                                      yyerror("Unknown error");
                                                                                      break;
                                                                                  }  
                                                                                } ;
                                    | CONST INT IDENTIFIER ASSIGN intMathExpression {
                                                                                      printf("ConstDeclaration with intMathExpression \n");
                                                                                      int ret = addVariable(scope, $3, 1, 1, $5, 0.0, '\0', "", 0);

                                                                                      switch (ret){
                                                                                        case 1:
                                                                                          allocateIntValReg($3, scope); 
                                                                                          break;
                                                                                        case 2:                                                            
                                                                                          yyerror("Variable already declared");
                                                                                          break;
                                                                                        case 3:
                                                                                          yyerror("Overflow in symbol table");
                                                                                          break;
                                                                                        default:
                                                                                          yyerror("Unknown error");
                                                                                          break;
                                                                                      }   
                                                                                    } ;
                                    | CONST FLOAT IDENTIFIER ASSIGN floatMathExpression {
                                                                                          printf("ConstDeclaration with floatMathExpression \n");
                                                                                          int ret = addVariable(scope, $3, 1, 2, 0, $5, '\0', "", 0);

                                                                                          switch (ret){
                                                                                            case 1:
                                                                                              allocateFloatValReg($3, scope);
                                                                                              break;
                                                                                            case 2:                                                            
                                                                                              yyerror("Variable already declared");
                                                                                              break;
                                                                                            case 3:
                                                                                              yyerror("Overflow in symbol table");
                                                                                              break;
                                                                                            default:
                                                                                              yyerror("Unknown error");
                                                                                              break;
                                                                                          } 
                                                                                        } ;
                                    | CONST STRING IDENTIFIER ASSIGN stringExpression {
                                                                                        printf("ConstDeclaration with stringExpression \n");
                                                                                        int ret = addVariable(scope, $3, 1, 4, 0, 0.0, '\0', $5, 0);

                                                                                        switch (ret){
                                                                                          case 1:
                                                                                            allocateStringValReg($3, scope);
                                                                                            break;
                                                                                          case 2:                                                            
                                                                                            yyerror("Variable already declared");
                                                                                            break;
                                                                                          case 3:
                                                                                            yyerror("Overflow in symbol table");
                                                                                            break;
                                                                                          default:
                                                                                            yyerror("Unknown error");
                                                                                            break;
                                                                                        } 
                                                                                      } ;
                                    | CONST BOOL IDENTIFIER ASSIGN logicalExpression {
                                                                                        printf("ConstDeclaration with logicalExpression \n");
                                                                                        int ret = addVariable(scope, $3, 1, 5, 0, 0.0, '\0', "", $5);

                                                                                        switch (ret){
                                                                                          case 1:
                                                                                            allocateBoolValReg($3, scope);
                                                                                            break;
                                                                                          case 2:                                                            
                                                                                            yyerror("Variable already declared");
                                                                                            break;
                                                                                          case 3:
                                                                                            yyerror("Overflow in symbol table");
                                                                                            break;
                                                                                          default:
                                                                                            yyerror("Unknown error");
                                                                                            break;
                                                                                        } 
                                                                                      } ;

assignmentStatement                 : IDENTIFIER ASSIGN intMathExpression ';' {
                                                                                printf("assignmentStatement \n");
                                                                                int typeVar = getVariableType(scope, $1);
                                                                                if (typeVar != 1){
                                                                                  if (typeVar == -1){
                                                                                    yyerror("Variable not found");
                                                                                  }
                                                                                  yyerror("Type mismatch in int");
                                                                                }
                                                                                else{
                                                                                  values val = getVariableValue(scope, $1);
                                                                                  if (val.isConst == 1){
                                                                                    yyerror("Cannot assign to a constant");
                                                                                  }
                                                                                  else{
                                                                                      int update = updateVariable(scope, $1, $3, 0.0, '\0', "", 0);
                                                                                      assignIntValReg(val.reg, $1);
                                                                                      if (update == -1){
                                                                                        yyerror("Variable not found");
                                                                                      }
                                                                                  }
                                                                                }

                                                                              } ;
                                    | IDENTIFIER ASSIGN floatMathExpression ';' {
                                                                                printf("assignmentStatement \n");
                                                                                int typeVar = getVariableType(scope, $1);
                                                                                if (typeVar != 2){
                                                                                  if (typeVar == -1){
                                                                                    yyerror("Variable not found");
                                                                                  }
                                                                                  yyerror("Type mismatch in float ");
                                                                                }
                                                                                else{
                                                                                  values val = getVariableValue(scope, $1);
                                                                                  if (val.isConst == 1){
                                                                                    yyerror("Cannot assign to a constant");
                                                                                  }
                                                                                  else{
                                                                                      int update = updateVariable(scope, $1, 0, $3, '\0', "", 0);
                                                                                      assignFloatValReg(val.reg, $1);
                                                                                      if (update == -1){
                                                                                        yyerror("Variable not found");
                                                                                      }
                                                                                  }
                                                                                }
                                                                                printf("assignmentStatement \n");
                                                                               } ;
                                    | IDENTIFIER ASSIGN stringExpression ';' {
                                                                                printf("assignmentStatement \n");
                                                                                int typeVar = getVariableType(scope, $1);
                                                                                if (typeVar != 4){
                                                                                  if (typeVar == -1){
                                                                                    yyerror("Variable not found");
                                                                                  }
                                                                                  yyerror("Type mismatch");
                                                                                }
                                                                                else{
                                                                                  values val = getVariableValue(scope, $1);
                                                                                  if (val.isConst == 1){
                                                                                    yyerror("Cannot assign to a constant");
                                                                                  }
                                                                                  else{
                                                                                      int update = updateVariable(scope, $1, 0, 0.0, '\0', $3, 0);
                                                                                      assignStringValReg(val.reg, $1);
                                                                                      if (update == -1){
                                                                                        yyerror("Variable not found");
                                                                                      }
                                                                                  }
                                                                                }
                                                                              } ;
                                    | IDENTIFIER ASSIGN logicalExpression ';' {
                                                                                printf("assignmentStatement \n");
                                                                                int typeVar = getVariableType(scope, $1);
                                                                                if (typeVar != 5){
                                                                                  if (typeVar == -1){
                                                                                    yyerror("Variable not found");
                                                                                  }
                                                                                  yyerror("Type mismatch");
                                                                                }
                                                                                else{
                                                                                  values val = getVariableValue(scope, $1);
                                                                                  if (val.isConst == 1){
                                                                                    yyerror("Cannot assign to a constant");
                                                                                  }
                                                                                  else{
                                                                                      int update = updateVariable(scope, $1, 0, 0.0, '\0', "", $3);
                                                                                      assignBoolValReg(val.reg, $1);
                                                                                      if (update == -1){
                                                                                        yyerror("Variable not found");
                                                                                      }
                                                                                  }
                                                                                }
                                                                              } ;
                                    | IDENTIFIER ASSIGN CHAR_LITERAL ';' {
                                                                             printf("assignmentStatement \n");
                                                                            int typeVar = getVariableType(scope, $1);
                                                                            if (typeVar != 3){
                                                                              if (typeVar == -1){
                                                                                yyerror("Variable not found");
                                                                              }
                                                                              yyerror("Type mismatch");
                                                                            }
                                                                            else{
                                                                              values val = getVariableValue(scope, $1);
                                                                              if (val.isConst == 1){
                                                                                yyerror("Cannot assign to a constant");
                                                                              }
                                                                              else{
                                                                                  int update = updateVariable(scope, $1, 0, 0.0, $3, "", 0);
                                                                                  assignCharValReg(val.reg, $1);
                                                                                  if (update == -1){
                                                                                    yyerror("Variable not found");
                                                                                  }
                                                                              }
                                                                            }
                                                                            printf("assignmentStatement \n");
                                                                            };
                            
incStatement                        : IDENTIFIER INCREMENT ';' {
                                                                  printf("incStatement \n");
                                                                  int typeVar = getVariableType(scope, $1);
                                                                  if (typeVar != 1){
                                                                    if (typeVar == -1){
                                                                      yyerror("Variable not found");
                                                                    }
                                                                    yyerror("Type mismatch");
                                                                  }
                                                                  else{
                                                                    values val = getVariableValue(scope, $1);
                                                                    if (val.isConst == 1){
                                                                      yyerror("Cannot increment a constant");
                                                                    }
                                                                    else{
                                                                        int update = updateVariable(scope, $1, val.intValue + 1, 0.0, '\0', "", 0);
                                                                        incQuad(val.reg, $1);
                                                                        if (update == -1){
                                                                          yyerror("Variable not found");
                                                                        }
                                                                    }
                                                                  }
                                                                } ; 

decStatement                        : IDENTIFIER DECREMENT ';' {
                                                                  printf("decStatement \n");
                                                                  int typeVar = getVariableType(scope, $1);
                                                                  if (typeVar != 1){
                                                                    if (typeVar == -1){
                                                                      yyerror("Variable not found");
                                          
                                                                    }
                                                                    yyerror("Type mismatch");
                                        
                                                                  }
                                                                  else{
                                                                    values val = getVariableValue(scope, $1);
                                                                    if (val.isConst == 1){
                                                                      yyerror("Cannot decrement a constant");
                                          
                                                                    }
                                                                    else{
                                                                        int update = updateVariable(scope, $1, val.intValue - 1, 0.0, '\0', "", 0);
                                                                        decQuad(val.reg, $1);
                                                                        if (update == -1){
                                                                          yyerror("Variable not found");
                                              
                                                                        }
                                                                    }
                                                                  }
                                                                } ;

intMathExpression : intMathExpression PLUS intMathTerm {
                                                        printf("intMathExpression PLUS intMathExpression \n");
                                                        $$ = $1 + $3; addTwoInts();
                                                      }
                  | intMathExpression MINUS intMathTerm {
                                                          printf("intMathExpression MINUS intMathExpression \n");
                                                          $$ = $1 - $3; subTwoInts();
                                                        }
                  | intMathTerm;

intMathTerm : intMathTerm MULTIPLY intMathFactor {
                                                    printf("intMathExpression MULTIPLY intMathExpression \n");
                                                    $$ = $1 * $3; mulTwoInts();
                                                 }
            | intMathTerm DIVIDE intMathFactor {
                                                  printf("intMathExpression DIVIDE intMathExpression \n");
                                                  $$ = $1 / $3; divTwoInts();
                                                }
            | intMathTerm MODULO intMathFactor {
                                                  printf("intMathExpression MODULO intMathExpression \n");
                                                  $$ = $1 % $3; modTwoInts();
                                               }
            | intMathFactor;


intMathFactor : intMathPrimary
              | IDENTIFIER INCREMENT {
                                        printf("incStatement \n");
                                        int typeVar = getVariableType(scope, $1);
                                        if (typeVar != 1){
                                          if (typeVar == -1){
                                            yyerror("Variable not found");
                                          }
                                          yyerror("Type mismatch");
              
                                        }
                                        else{
                                          values val = getVariableValue(scope, $1);
                                          if (val.isConst == 1){
                                            yyerror("Cannot increment a constant");
                                          }
                                          else{
                                              int update = updateVariable(scope, $1, val.intValue + 1, 0.0, '\0', "", 0);
                                              incQuad(val.reg, $1);
                                              if (update == -1){
                                                yyerror("Variable not found");
                                              }
                                          }
                                        }
                                     } ;
              | IDENTIFIER DECREMENT {
                                        printf("decStatement \n");
                                        int typeVar = getVariableType(scope, $1);
                                        if (typeVar != 1){
                                          if (typeVar == -1){
                                            yyerror("Variable not found");
                
                                          }
                                          yyerror("Type mismatch");
                                        }
                                        else{
                                          values val = getVariableValue(scope, $1);
                                          if (val.isConst == 1){
                                            yyerror("Cannot decrement a constant");
                                          }
                                          else{
                                              int update = updateVariable(scope, $1, val.intValue - 1, 0.0, '\0', "", 0);
                                              decQuad(val.reg, $1);
                                              if (update == -1){
                                                yyerror("Variable not found");
                                              }
                                          }
                                        }
                                     } ;

intMathPrimary : IDENTIFIER {
                              values val = getVariableValue(scope, $1);
                              $$ = val.intValue; allocateIdentifierReg(val.reg);
                            }
               | DIGIT { $$ = $1; allocateDigitReg($1); }
               | LEFT_PARENTHESIS intMathExpression RIGHT_PARENTHESIS {
                                                                        printf("LEFT_PARENTHESIS intMathExpression RIGHT_PARENTHESIS \n");
                                                                        $$ = $2; 
                                                                      };



                                    
floatMathExpression : floatMathExpression PLUS floatMathTerm {
                                                              printf("floatMathExpression PLUS floatMathExpression \n");
                                                              $$ = $1 + $3; addTwoFloats();
                                                            }
                    | floatMathExpression MINUS floatMathTerm {
                                                                printf("floatMathExpression MINUS floatMathExpression \n");
                                                                $$ = $1 - $3; subTwoFloats();
                                                              }
                    | floatMathTerm;

floatMathTerm : floatMathTerm MULTIPLY floatMathFactor {
                                                          printf("floatMathExpression MULTIPLY floatMathExpression \n");
                                                          $$ = $1 * $3; mulTwoFloats();
                                                        }
              | floatMathTerm DIVIDE floatMathFactor { 
                                                        printf("floatMathExpression DIVIDE floatMathExpression \n");
                                                        $$ = $1 / $3; divTwoFloats();
                                                     }
              | floatMathFactor;

floatMathFactor : IDENTIFIER {  
                                printf("floatMathFactorIDENTIFIER \n");
                                values val = getVariableValue(scope, $1);
                                $$ = val.floatValue; allocateIdentifierReg(val.reg);
                              }
                 | FLOAT_LITERAL { $$ = $1; allocateFloatReg($1); }
                 | LEFT_PARENTHESIS floatMathExpression RIGHT_PARENTHESIS {
                                                                            printf("LEFT_PARENTHESIS floatMathExpression RIGHT_PARENTHESIS \n");
                                                                            $$ = $2; 
                                                                          };

                                            
                                
stringExpression : STRING_LITERAL {
                      char* result = NULL;
                      if ($1[0] == '"' && $1[strlen($1) - 1] == '"') {
                          /* Remove the quotes */
                          result = malloc(strlen($1) - 1);
                          strncpy(result, $1 + 1, strlen($1) - 2);
                          result[strlen($1) - 2] = '\0';
                      }
                      $$ = result;
                      allocateStringReg($1);
                  }
                  | IDENTIFIER {
                      printf("stringExpression \n");
                      values val = getVariableValue(scope, $1);
                      $$ = val.stringValue;
                      allocateIdentifierReg(val.reg);
                  }
                  | stringExpression PLUS stringExpression {
                      printf("stringExpression PLUS stringExpression \n");
                      char* str1 = $1;
                      char* str2 = $3;
                      char* combined = malloc(strlen(str1) + strlen(str2) + 1);
                      strcpy(combined, str1);
                      strcat(combined, str2);
                      $$ = combined;
                      addTwoStrings();
                  }
                  | LEFT_PARENTHESIS stringExpression RIGHT_PARENTHESIS {
                      printf("LEFT_PARENTHESIS stringExpression RIGHT_PARENTHESIS \n");
                      $$ = $2;
                      printf("after parentheses %s \n", $2);
                  };



logicalExpression : logicalTerm { $$ = $1; }
                  | logicalExpression OR logicalTerm {
                      $$ = $1 || $3;
                      printf("logicalExpression OR logicalTerm %d, %d, %d\n", $1, $3, $$);
                      orQuad();
                      printf("Logical: logicalExpression OR logicalTerm \n");
                  };

logicalTerm : logicalFactor { $$ = $1; }
            | logicalTerm AND logicalFactor {
                $$ = $1 && $3;
                andQuad();
                printf("Logical: logicalTerm AND logicalFactor \n");
            };

logicalFactor : logicalPrimary { $$ = $1; }
              | NOT logicalFactor {
                  $$ = !$2;
                  notQuad();
                  printf("NOT logicalFactor \n");
              };

logicalPrimary : intMathExpression GREATER intMathExpression {
                    $$ = $1 > $3;
                    greaterThanQuad();
                    printf("Logical: intMathExpression GREATER intMathExpression \n");
                }
              | intMathExpression LESS intMathExpression {
                    $$ = $1 < $3;
                    lessThanQuad();
                    printf("Logical: intMathExpression LESS intMathExpression \n");
                }
              | intMathExpression GREATER_EQUAL intMathExpression {
                    $$ = $1 >= $3;
                    greaterThanEqualQuad();
                    printf("Logical: intMathExpression GREATER_EQUAL intMathExpression \n");
                }
              | intMathExpression LESS_EQUAL intMathExpression {
                    $$ = $1 <= $3;
                    lessThanEqualQuad();
                    printf("Logical: intMathExpression LESS_EQUAL intMathExpression \n");
                }
              | intMathExpression EQUAL intMathExpression {
                    $$ = $1 == $3;
                    equalEqualQuad();
                    printf("Logical: intMathExpression EQUAL intMathExpression \n");
                }
              | intMathExpression NOT_EQUAL intMathExpression {
                    $$ = $1 != $3;
                    notEqualQuad();
                    printf("Logical: intMathExpression NOT_EQUAL intMathExpression \n");
                }
              | floatMathExpression GREATER floatMathExpression {
                    $$ = $1 > $3;
                    greaterThanQuad();
                    printf("Logical: floatMathExpression GREATER floatMathExpression \n");
                }
              | floatMathExpression LESS floatMathExpression {
                    $$ = $1 < $3;
                    lessThanQuad();
                    printf("Logical: floatMathExpression LESS floatMathExpression \n");
                }
              | floatMathExpression GREATER_EQUAL floatMathExpression {
                    $$ = $1 >= $3;
                    greaterThanEqualQuad();
                    printf("Logical: floatMathExpression GREATER_EQUAL floatMathExpression \n");
                }
              | floatMathExpression LESS_EQUAL floatMathExpression {
                    $$ = $1 <= $3;
                    lessThanEqualQuad();
                    printf("Logical: floatMathExpression LESS_EQUAL floatMathExpression \n");
                }
              | floatMathExpression EQUAL floatMathExpression {
                    $$ = $1 == $3;
                    equalEqualQuad();
                    printf("Logical: floatMathExpression EQUAL floatMathExpression \n");
                }
              | floatMathExpression NOT_EQUAL floatMathExpression {
                    $$ = $1 != $3;
                    notEqualQuad();
                    printf("Logical: floatMathExpression NOT_EQUAL floatMathExpression \n");
                }
              | LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS {
                    $$ = $2;
                    printf("Logical: LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS \n");
                }
              | BOOL_LITERAL {
                    $$ = $1;
                    printf("Logical: BOOL_LITERAL \n");
                    allocateBoolReg($1);
                }
              | IDENTIFIER {
                    printf("logicalExpression \n");
                    values val = getVariableValue(scope, $1);
                    printf("VALUE: %d \n", val.boolValue);
                    $$ = val.boolValue; allocateIdentifierReg(val.reg);
                };


ifStatement : IF LEFT_PARENTHESIS logicalExpression {checkIfConditionQuad();} RIGHT_PARENTHESIS 
              LEFT_CURLY_BRACE { scope += 1; } blockStatements RIGHT_CURLY_BRACE {
                                                                                    printTable("\nIF STATEMENT ENDED", scope);
                                                                                    removeScope(scope);
                                                                                    scope -= 1;
                                                                                    endIfQuad();
                                                                                    printf("ifStatement \n");
                                                                                 }
              elsePart {finishIfQuad();}

elsePart : ELSE ifStatement 
         | ELSE LEFT_CURLY_BRACE { scope += 1; } blockStatements RIGHT_CURLY_BRACE {
                                                                                      printTable("\nELSE STATEMENT ENDED", scope);
                                                                                      removeScope(scope);
                                                                                      scope -= 1;
                                                                                      printf("if-else-Statement \n");
                                                                                    }
         | /* empty */




whileStatement  : WHILE LEFT_PARENTHESIS logicalExpression {whileConditionNum = checkWhileConditionQuad();} RIGHT_PARENTHESIS LEFT_CURLY_BRACE {scope+=1;} blockStatements 
                  RIGHT_CURLY_BRACE {printTable("\nWHILE STATEMENT ENDED", scope); endWhileQuad(whileConditionNum); removeScope(scope); scope-=1; printf("whileStatement \n");}

repeatStatement : REPEAT LEFT_CURLY_BRACE {repeatConditionNum = openRepeatQuad(); scope+=1;} blockStatements RIGHT_CURLY_BRACE UNTIL LEFT_PARENTHESIS logicalExpression {endRepeatQuad(repeatConditionNum);}
                  RIGHT_PARENTHESIS {printTable("\nREPEAT STATEMENT ENDED", scope); removeScope(scope); scope-=1; printf("repeatStatement \n");}

forAssignment   : IDENTIFIER ASSIGN expression { printf("forAssignment \n"); }
                | IDENTIFIER INCREMENT { printf("forAssignment \n"); }
                | IDENTIFIER DECREMENT { printf("forAssignment \n"); }

forDeclaration  : IDENTIFIER ASSIGN expression ';' { printf("forDeclaration \n"); }
                | assignVariableDeclaration

forStatement    : FOR LEFT_PARENTHESIS { scope += 1; }
                  forDeclaration {forDeclareQuad();} logicalExpression {forConditionNum = forStartQuad();} ';' forAssignment RIGHT_PARENTHESIS 
                  LEFT_CURLY_BRACE blockStatements RIGHT_CURLY_BRACE { forEndQuad(forConditionNum); printTable("\nFOR STATEMENT ENDED", scope); removeScope(scope); scope -= 1; printf("forStatement \n"); }


switchStatement : SWITCH LEFT_PARENTHESIS IDENTIFIER {
                      values val = getVariableValue(scope, $3);
                      switchIdentifierReg = val.reg;
                      switchIdentifierType = getVariableType(scope, $3);
                      switchCondition = getSwitchCondition();
                  } RIGHT_PARENTHESIS LEFT_CURLY_BRACE {
                      scope += 1;
                      printf("switchStatement \n");
                  } caseList RIGHT_CURLY_BRACE {
                      printTable("\nSWITCH STATEMENT ENDED", scope);
                      endSwitchQuad(switchCondition);
                      removeScope(scope);
                      scope -= 1;
                  }

caseList : caseStatement caseList
        | DEFAULT ':' blockStatements BREAK ';'
        | /* empty */

caseStatement : CASE values { startCaseQuad(switchIdentifierType, switchIdentifierReg, $2.intValue, $2.floatValue, $2.charValue, $2.stringValue, $2.boolValue);}
                              ':' blockStatements BREAK ';' {endCaseQuad(switchCondition);}


enumIdentifiers : IDENTIFIER ',' enumIdentifiers
                | IDENTIFIER
                

enumStatement   : ENUM IDENTIFIER LEFT_CURLY_BRACE {scope+=1;} enumIdentifiers RIGHT_CURLY_BRACE {printTable("\nENUM STATEMENT ENDED", scope); removeScope(scope); scope-=1; printf("enumStatement \n");}


functionStatement : types FUNCTION IDENTIFIER {
                                                int ret = addVariable(scope, $3, 0, $1, 0, 0.0, '\0', "", 0);
                                                                            
                                                switch (ret){
                                                  case 1:
                                                    createLabel($3); 
                                                    break;
                                                  case 2:                                                            
                                                    yyerror("Function already declared");
                                                    break;
                                                  case 3:
                                                    yyerror("Overflow in symbol table");
                                                    break;  
                                                  default:
                                                    yyerror("Unknown error");
                                                    break;
                                                }   

                                              } 
                    LEFT_PARENTHESIS {scope+=1;} parameter RIGHT_PARENTHESIS LEFT_CURLY_BRACE blockStatements RIGHT_CURLY_BRACE
                    {printTable("\nFUNCTION ENDED", scope); functionEndQuad(); removeScope(scope); scope-=1; printf("functionStatement \n");}



parameter       : noSemiColumnVariableDeclarationStatement ',' parameter
                | noSemiColumnVariableDeclarationStatement
                | noSemiColumnConstDeclaration ',' parameter
                | noSemiColumnConstDeclaration
                | /* empty */

returnStatement : RETURN argument ';' {printf("returnStatement \n");}
                | RETURN ';' {printf("returnStatement \n");}

continueBreakStatement  : BREAK ';' {printf("breakStatement1 \n");}
                | BREAK IDENTIFIER ';' {printf("breakStatement \n");}
                | BREAK {printf("breakStatement2 \n");}
                | CONTINUE ';' {printf("continueStatement \n");}
                | CONTINUE IDENTIFIER ';' {printf("continueStatement \n");}
                | CONTINUE {printf("continueStatement \n");}
               


printStatement  : PRINT LEFT_PARENTHESIS argument RIGHT_PARENTHESIS ';' {printf("printStatement \n");}
                | PRINT LEFT_PARENTHESIS RIGHT_PARENTHESIS ';' {printf("printStatement \n");}

functionCallStatement   : IDENTIFIER { 

                                        int typeVar = getVariableType(scope, $1);
                                        printf("typeVar: %d, %s\n", typeVar, $1);
                                        if (typeVar == -1){
                                          yyerror("Function not found");
                                        }
                                        else{
                                          values val = getVariableValue(scope, $1);
                                          if (val.isConst == 1){
                                            yyerror("Cannot assign to a constant");
                                          }
                                          else{
                                              int update = updateVariable(scope, $1, 0, 0.0, '\0', "", 0);
                                               int ret = functionCallQuad($1);
                                              if(ret == -1){
                                                  yyerror("Function not found");
                                              }
                                              if (update == -1){
                                                yyerror("Function not found");
                                              }
                                          }
                                        }
                                     } LEFT_PARENTHESIS argument RIGHT_PARENTHESIS ';' {printf("functionCall \n");}
                       /* | IDENTIFIER ASSIGN IDENTIFIER LEFT_PARENTHESIS argument RIGHT_PARENTHESIS { 
                                                          int typeVar = getVariableType(scope, $1);
                                                          int typefunc = getVariableType(scope, $3);
                                                          if (typefunc != typeVar) {
                                                            yyerror("Function type does not match variable type");
                                                          }
                                                          else{
                                                            values val = getVariableValue(scope, $1);
                                                            if (val.isConst == 1){
                                                              yyerror("Cannot assign to a constant");
                                                            }
                                                            else{
                                                              int update = updateVariable(scope, $1, 0, 0.0, '\0', "", 0);
                                                              if (update == -1){
                                                                yyerror("Function not found");
                                                              }
                                                            }
                                                          }
 
                                                       }*/
argument        : expression ',' argument
                | expression
                | /* empty */


comment         : COMMENT {printf("comment \n");}

main            : MAIN {createLabel("MAIN");} LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_CURLY_BRACE {scope+=1;} blockStatements RIGHT_CURLY_BRACE { endMainQuad(); printTable("\nMAIN FUNCTION ENDED", scope); removeScope(scope); scope-=1; printf("main \n");}

%%

int yyerror(const char* s)
{
  fprintf(stderr, "%s\n",s);
  FILE *file = fopen("errors.txt", "a");
  if (file == NULL) {
      printf("Failed to open the file.\n");
      return 1;
  }
  fprintf(file, "%s\n",s);
  fclose(file);
  exit(0);
  return 1;
}

int main(void)
{
  FILE *file = fopen("finalQuads.txt", "w");
  if (file == NULL) {
      printf("Failed to open the file.\n");
      return 1;
  }
  fprintf(file, "JMP LABEL_MAIN\n\n");
  fclose(file);
  FILE *pfile = fopen("parseTable.txt", "w");
  if (pfile == NULL) {
      printf("Failed to open the file.\n");
      return 1;
  }
  fclose(pfile);
  FILE *efile = fopen("errors.txt", "w");
  if (efile == NULL) {
      printf("Failed to open the file.\n");
      return 1;
  }
  fclose(efile);
  // Close the file to clear its contents
  
  initializeSymbolTable();
  initializeLabelTable();

  yyparse();
  
  printTable("\nPROGRAM ENDED", 0);
  return 0;
}