%{
    #include<stdio.h>
    #include "symbol_table.h"
    int yylex(void);
    int yyerror(const char* s);
    int main(void);
    int scope = 0;
%}

//Tokens Definition
%union {
  int iVal;
  char* sVal;
  float fVal;
  char cVal;
  int bVal;  
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
%type <fVal> floatMathExpression
%type <sVal> stringExpression
%type <bVal> logicalExpression
%type <bVal> boolLogicalExpression
%type <bVal> intLogicalExpression
%type <bVal> floatLogicalExpression
%type <bVal> stringLogicalExpression
%type <bVal> parenLogicalExpression


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

/*types                           :   INT
                                |   CHAR
                                |   FLOAT
                                |   STRING
                                |   BOOL*/


values                          :  DIGIT
                                |   FLOAT_LITERAL
                                |   STRING_LITERAL
                                |   CHAR_LITERAL
                                |   BOOL_LITERAL


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
                                                                                allocateCharValReg($2);
                                                                                break;
                                                                              case 2:                                                            
                                                                                exit(0);
                                                                                break;
                                                                              case 3:
                                                                                yyerror("Overflow in symbol table");
                                                                                exit(0);
                                                                                break;  
                                                                              default:
                                                                                yyerror("Unknown error");
                                                                                exit(0);
                                                                                break;
                                                                            }   
                                                                          } ;
                                    | INT IDENTIFIER ASSIGN intMathExpression {
                                                                                printf("variableDeclaration with intMathExpression \n");
                                                                                int ret = addVariable(scope, $2, 0, 1, $4, 0.0, '\0', "", 0);

                                                                                  switch (ret){
                                                                                    case 1:
                                                                                      allocateIntValReg($2);
                                                                                      break;
                                                                                    case 2:                                                            
                                                                                      exit(0);
                                                                                      break;
                                                                                    case 3:
                                                                                      yyerror("Overflow in symbol table");
                                                                                      exit(0);
                                                                                      break;
                                                                                    default:
                                                                                      yyerror("Unknown error");
                                                                                      exit(0);
                                                                                      break;
                                                                                  }   
                                                                              } ;
                                    | FLOAT IDENTIFIER ASSIGN floatMathExpression {
                                                                                    printf("variableDeclaration with floatMathExpression \n");
                                                                                    int ret = addVariable(scope, $2, 0, 2, 0, $4, '\0', "", 0);

                                                                                    switch (ret){
                                                                                      case 1:
                                                                                        allocateFloatValReg($2);
                                                                                        break;
                                                                                      case 2:                                                            
                                                                                        exit(0);
                                                                                        break;
                                                                                      case 3:
                                                                                        yyerror("Overflow in symbol table");
                                                                                        exit(0);
                                                                                        break;
                                                                                      default:
                                                                                        yyerror("Unknown error");
                                                                                        exit(0);
                                                                                        break;
                                                                                    }   
                                                                                  } ;
                                    | STRING IDENTIFIER ASSIGN stringExpression {
                                                                                  printf("variableDeclaration with stringExpression \n");
                                                                                  int ret = addVariable(scope, $2, 0, 4, 0, 0.0, '\0', $4, 0);

                                                                                  switch (ret){
                                                                                    case 1:
                                                                                      allocateStringValReg($2);
                                                                                      break;
                                                                                    case 2:                                                            
                                                                                      exit(0);
                                                                                      break;
                                                                                    case 3:
                                                                                      yyerror("Overflow in symbol table");
                                                                                      exit(0);
                                                                                      break;
                                                                                    default:
                                                                                      yyerror("Unknown error");
                                                                                      exit(0);
                                                                                      break;
                                                                                  } 
                                                                                } ;
                                    | BOOL IDENTIFIER ASSIGN logicalExpression {
                                                                                printf("variableDeclaration with logicalExpression \n");
                                                                                int ret = addVariable(scope, $2, 0, 5, 0, 0.0, '\0', "", $4);

                                                                                switch (ret){
                                                                                  case 1:
                                                                                    allocateBoolValReg($2);
                                                                                    break;
                                                                                  case 2:                                                            
                                                                                    exit(0);
                                                                                    break;
                                                                                  case 3:
                                                                                    yyerror("Overflow in symbol table");
                                                                                    exit(0);
                                                                                    break;
                                                                                  default:
                                                                                    yyerror("Unknown error");
                                                                                    exit(0);
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
                                                                exit(0);
                                                                break;
                                                              case 3:
                                                                yyerror("Overflow in symbol table");
                                                                exit(0);
                                                                break;
                                                              default:
                                                                yyerror("Unknown error");
                                                                exit(0);
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
                                                            exit(0);
                                                            break;
                                                          case 3:
                                                            yyerror("Overflow in symbol table");
                                                            exit(0);
                                                            break;
                                                          default:
                                                            yyerror("Unknown error");
                                                            exit(0);
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
                                                                exit(0);
                                                                break;
                                                              case 3:
                                                                yyerror("Overflow in symbol table");
                                                                exit(0);
                                                                break;
                                                              default:
                                                                yyerror("Unknown error");
                                                                exit(0);
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
                                                                exit(0);
                                                                break;
                                                              case 3:
                                                                yyerror("Overflow in symbol table");
                                                                exit(0);
                                                                break;
                                                              default:
                                                                yyerror("Unknown error");
                                                                exit(0);
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
                                                                exit(0);
                                                                break;
                                                              case 3:
                                                                yyerror("Overflow in symbol table");
                                                                exit(0);
                                                                break;
                                                              default:
                                                                yyerror("Unknown error");
                                                                exit(0);
                                                                break;
                                                            }  
                                                      } ;


constDeclarationStatement           : noSemiColumnConstDeclaration ';' {printf("ConstDeclaration with int \n");} ;

noSemiColumnConstDeclaration        : CONST CHAR IDENTIFIER ASSIGN CHAR_LITERAL {
                                                                                  printf("ConstDeclaration with char \n");
                                                                                  int ret = addVariable(scope, $3, 1, 3, 0, 0.0, $5, "", 0);
                                                                                  
                                                                                  switch (ret){
                                                                                    case 1:
                                                                                      allocateCharValReg($3);
                                                                                      break;
                                                                                    case 2:                                                            
                                                                                      exit(0);
                                                                                      break;
                                                                                    case 3:
                                                                                      yyerror("Overflow in symbol table");
                                                                                      exit(0);
                                                                                      break;
                                                                                    default:
                                                                                      yyerror("Unknown error");
                                                                                      exit(0);
                                                                                      break;
                                                                                  }  
                                                                                } ;
                                    | CONST INT IDENTIFIER ASSIGN intMathExpression {
                                                                                      printf("ConstDeclaration with intMathExpression \n");
                                                                                      int ret = addVariable(scope, $3, 1, 1, $5, 0.0, '\0', "", 0);

                                                                                      switch (ret){
                                                                                        case 1:
                                                                                          allocateIntValReg($3); 
                                                                                          break;
                                                                                        case 2:                                                            
                                                                                          exit(0);
                                                                                          break;
                                                                                        case 3:
                                                                                          yyerror("Overflow in symbol table");
                                                                                          exit(0);
                                                                                          break;
                                                                                        default:
                                                                                          yyerror("Unknown error");
                                                                                          exit(0);
                                                                                          break;
                                                                                      }   
                                                                                    } ;
                                    | CONST FLOAT IDENTIFIER ASSIGN floatMathExpression {
                                                                                          printf("ConstDeclaration with floatMathExpression \n");
                                                                                          int ret = addVariable(scope, $3, 1, 2, 0, $5, '\0', "", 0);

                                                                                          switch (ret){
                                                                                            case 1:
                                                                                              allocateFloatValReg($3);
                                                                                              break;
                                                                                            case 2:                                                            
                                                                                              exit(0);
                                                                                              break;
                                                                                            case 3:
                                                                                              yyerror("Overflow in symbol table");
                                                                                              exit(0);
                                                                                              break;
                                                                                            default:
                                                                                              yyerror("Unknown error");
                                                                                              exit(0);
                                                                                              break;
                                                                                          } 
                                                                                        } ;
                                    | CONST STRING IDENTIFIER ASSIGN stringExpression {
                                                                                        printf("ConstDeclaration with stringExpression \n");
                                                                                        int ret = addVariable(scope, $3, 1, 4, 0, 0.0, '\0', $5, 0);

                                                                                        switch (ret){
                                                                                          case 1:
                                                                                            allocateStringValReg($3);
                                                                                            break;
                                                                                          case 2:                                                            
                                                                                            exit(0);
                                                                                            break;
                                                                                          case 3:
                                                                                            yyerror("Overflow in symbol table");
                                                                                            exit(0);
                                                                                            break;
                                                                                          default:
                                                                                            yyerror("Unknown error");
                                                                                            exit(0);
                                                                                            break;
                                                                                        } 
                                                                                      } ;
                                    | CONST BOOL IDENTIFIER ASSIGN logicalExpression {
                                                                                        printf("ConstDeclaration with logicalExpression \n");
                                                                                        int ret = addVariable(scope, $3, 1, 5, 0, 0.0, '\0', "", $5);

                                                                                        switch (ret){
                                                                                          case 1:
                                                                                            allocateBoolValReg($3);
                                                                                            break;
                                                                                          case 2:                                                            
                                                                                            exit(0);
                                                                                            break;
                                                                                          case 3:
                                                                                            yyerror("Overflow in symbol table");
                                                                                            exit(0);
                                                                                            break;
                                                                                          default:
                                                                                            yyerror("Unknown error");
                                                                                            exit(0);
                                                                                            break;
                                                                                        } 
                                                                                      } ;

assignmentStatement                 : IDENTIFIER ASSIGN intMathExpression ';' {
                                                                                printf("assignmentStatement \n");
                                                                                int typeVar = getVariableType(scope, $1);
                                                                                if (typeVar != 1){
                                                                                  if (typeVar == -1){
                                                                                    yyerror("Variable not found");
                                                                                    exit(0);
                                                                                  }
                                                                                  yyerror("Type mismatch in int");
                                                                                  exit(0);
                                                                                }
                                                                                else{
                                                                                  values val = getVariableValue(scope, $1);
                                                                                  if (val.isConst == 1){
                                                                                    yyerror("Cannot assign to a constant");
                                                                                    exit(0);
                                                                                  }
                                                                                  else{
                                                                                      int update = updateVariable(scope, $1, $3, 0.0, '\0', "", 0);
                                                                                      assignIntValReg(val.reg, $1);
                                                                                      if (update == -1){
                                                                                        yyerror("Variable not found");
                                                                                        exit(0);
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
                                                                                    exit(0);
                                                                                  }
                                                                                  yyerror("Type mismatch in float ");
                                                                                  exit(0);
                                                                                }
                                                                                else{
                                                                                  values val = getVariableValue(scope, $1);
                                                                                  if (val.isConst == 1){
                                                                                    yyerror("Cannot assign to a constant");
                                                                                    exit(0);
                                                                                  }
                                                                                  else{
                                                                                      int update = updateVariable(scope, $1, 0, $3, '\0', "", 0);
                                                                                      assignFloatValReg(val.reg, $1);
                                                                                      if (update == -1){
                                                                                        yyerror("Variable not found");
                                                                                        exit(0);
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
                                                                                    exit(0);
                                                                                  }
                                                                                  yyerror("Type mismatch");
                                                                                  exit(0);
                                                                                }
                                                                                else{
                                                                                  values val = getVariableValue(scope, $1);
                                                                                  if (val.isConst == 1){
                                                                                    yyerror("Cannot assign to a constant");
                                                                                    exit(0);
                                                                                  }
                                                                                  else{
                                                                                      int update = updateVariable(scope, $1, 0, 0.0, '\0', $3, 0);
                                                                                      assignStringValReg(val.reg, $1);
                                                                                      if (update == -1){
                                                                                        yyerror("Variable not found");
                                                                                        exit(0);
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
                                                                                    exit(0);
                                                                                  }
                                                                                  yyerror("Type mismatch");
                                                                                  exit(0);
                                                                                }
                                                                                else{
                                                                                  values val = getVariableValue(scope, $1);
                                                                                  if (val.isConst == 1){
                                                                                    yyerror("Cannot assign to a constant");
                                                                                    exit(0);
                                                                                  }
                                                                                  else{
                                                                                      int update = updateVariable(scope, $1, 0, 0.0, '\0', "", $3);
                                                                                      assignBoolValReg(val.reg, $1);
                                                                                      if (update == -1){
                                                                                        yyerror("Variable not found");
                                                                                        exit(0);
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
                                                                                exit(0);
                                                                              }
                                                                              yyerror("Type mismatch");
                                                                              exit(0);
                                                                            }
                                                                            else{
                                                                              values val = getVariableValue(scope, $1);
                                                                              if (val.isConst == 1){
                                                                                yyerror("Cannot assign to a constant");
                                                                                exit(0);
                                                                              }
                                                                              else{
                                                                                  int update = updateVariable(scope, $1, 0, 0.0, $3, "", 0);
                                                                                  assignCharValReg(val.reg, $1);
                                                                                  if (update == -1){
                                                                                    yyerror("Variable not found");
                                                                                    exit(0);
                                                                                  }
                                                                              }
                                                                            }
                                                                            printf("assignmentStatement \n");
                                                                            } ;
                              

intMathExpression                   :    IDENTIFIER  {
                                                        values val = getVariableValue(scope, $1);
                                                        $$ = val.intValue;
                                                        allocateLastReg();
                                                      }
                                    |    DIGIT  { $$ = $1; allocateDigitReg($1); }
                                    |   intMathExpression PLUS intMathExpression {
                                                                                    printf("intMathExpression PLUS intMathExpression \n");
                                                                                    $$ = $1 + $3;
                                                                                    addTwoInts();
                                                                                  }
                                    |   intMathExpression MINUS intMathExpression {
                                                                                    printf("intMathExpression MINUS intMathExpression \n");
                                                                                    $$ = $1 - $3;
                                                                                    subTwoInts();
                                                                                  }
                                    |   intMathExpression MULTIPLY intMathExpression {
                                                                                      printf("intMathExpression MULTIPLY intMathExpression \n");
                                                                                      $$ = $1 * $3;
                                                                                      mulTwoInts();
                                                                                      }
                                    |   intMathExpression DIVIDE intMathExpression {
                                                                                      printf("intMathExpression DIVIDE intMathExpression \n");
                                                                                      $$ = $1 / $3;
                                                                                      divTwoInts();
                                                                                    }
                                    |   intMathExpression MODULO intMathExpression {
                                                                                      printf("intMathExpression MODULO intMathExpression \n");
                                                                                      $$ = $1 % $3;
                                                                                      modTwoInts($1, $3);
                                                                                    }
                                    |   intMathExpression INCREMENT {
                                                                      printf("intMathExpression INCREMENT \n");
                                                                      $$ = $1 + 1;
                                                                      addTwoInts($1, 1);   /* TODO: from add to INC*/
                                                                    }
                                    |   intMathExpression DECREMENT {
                                                                      printf("intMathExpression DECREMENT \n");
                                                                      $$ = $1 - 1;
                                                                      subTwoInts($1, 1);   /* TODO: from add to INC*/  
                                                                    }
                                    |   LEFT_PARENTHESIS intMathExpression RIGHT_PARENTHESIS {
                                                                                                printf("LEFT_PARENTHESIS intMathExpression RIGHT_PARENTHESIS \n");
                                                                                                $$ = $2;
                                                                                                /* TODO: ADD quad */
                                                                                             }

/*intMathExpression : intMathExpression PLUS intMathTerm
                  | intMathExpression MINUS intMathTerm
                  | intMathTerm
                  ;

intMathTerm : intMathTerm MULTIPLY intMathFactor
            | intMathTerm DIVIDE intMathFactor
            | intMathTerm MODULO intMathFactor
            | intMathFactor
            ;

intMathFactor : intMathPrimary
              | intMathFactor INCREMENT
              | intMathFactor DECREMENT
              ;

intMathPrimary : IDENTIFIER
               | DIGIT
               | LEFT_PARENTHESIS intMathExpression RIGHT_PARENTHESIS
               ;*/



                                    
floatMathExpression                 :   IDENTIFIER  {
                                                      printf("floatExpression \n");
                                                      values val = getVariableValue(scope, $1);
                                                      $$ = val.floatValue;
                                                    }
                                    |   FLOAT_LITERAL { $$ = $1; }
                                    |   floatMathExpression PLUS floatMathExpression {
                                                                                        printf("floatMathExpression PLUS floatMathExpression \n");
                                                                                        $$ = $1 + $3;
                                                                                        addTwoFloats($1, $3);  
                                                                                      }
                                    |   floatMathExpression MINUS floatMathExpression {
                                                                                        printf("floatMathExpression MINUS floatMathExpression \n");
                                                                                        $$ = $1 - $3;
                                                                                        subTwoFloats($1, $3);  
                                                                                      }
                                    |   floatMathExpression MULTIPLY floatMathExpression {
                                                                                          printf("floatMathExpression MULTIPLY floatMathExpression \n");
                                                                                          $$ = $1 * $3;
                                                                                          mulTwoFloats($1, $3);
                                                                                        }
                                    |   floatMathExpression DIVIDE floatMathExpression {
                                                                                        printf("floatMathExpression DIVIDE floatMathExpression \n");
                                                                                        $$ = $1 / $3;
                                                                                        divTwoFloats($1, $3);
                                                                                      }
                                    |   LEFT_PARENTHESIS floatMathExpression RIGHT_PARENTHESIS {
                                                                                                printf("LEFT_PARENTHESIS floatMathExpression RIGHT_PARENTHESIS \n");
                                                                                                $$ = $2;
                                                                                                // TODO: ADD quad 
                                                                                              }

stringExpression                    :   STRING_LITERAL {
                                            char* result = NULL;
                                            if ($1[0] == '"' && $1[strlen($1) - 1] == '"') {
                                            /* Remove the quotes*/
                                            result = $1 + 1;
                                                result[strlen(result) - 1] = '\0';
                                            }
                                            $$ = result;

                                        }
                                        |IDENTIFIER  {
                                            printf("stringExpression \n");
                                            values val = getVariableValue(scope, $1);
                                            $$ = val.stringValue;
                                        }
                                    |   stringExpression PLUS stringExpression {
                                                                                printf("stringExpression PLUS stringExpression \n");
                                                                                char* str1 = $1;
                                                                                char* str2 = $3;
                                                                                strcat(str1, str2);
                                                                                $$ = str1;
                                                                                
                                                                                // TODO: ADD quad
                                                                              }
                                    |   LEFT_PARENTHESIS stringExpression RIGHT_PARENTHESIS {
                                                                                printf("LEFT_PARENTHESIS stringExpression RIGHT_PARENTHESIS \n");
                                                                                $$ = $2;
                                                                                              printf("after parantheses %s \n",$2);
                                                                                              // TODO: ADD quad  
                                                                            }


logicalExpression           : boolLogicalExpression
                            | intLogicalExpression
                            | floatLogicalExpression
                            | stringLogicalExpression
                            | parenLogicalExpression
                            | NOT logicalExpression { $$ = !$2; printf("NOT logicalExpression \n"); }

boolLogicalExpression       : BOOL_LITERAL { $$ = $1; }
intLogicalExpression        : intMathExpression GREATER intMathExpression { $$ = $1 > $3; printf("Logical: intMathExpression GREATER intMathExpression \n"); }
                            | intMathExpression LESS intMathExpression { $$ = $1 < $3; printf("Logical: intMathExpression LESS intMathExpression \n"); }
                            | intMathExpression GREATER_EQUAL intMathExpression { $$ = $1 >= $3; printf("Logical: intMathExpression GREATER_EQUAL intMathExpression \n"); }
                            | intMathExpression LESS_EQUAL intMathExpression { $$ = $1 <= $3; printf("Logical: intMathExpression LESS_EQUAL intMathExpression \n"); }
                            | intMathExpression EQUAL intMathExpression { $$ = $1 == $3; printf("Logical: intMathExpression EQUAL intMathExpression \n"); }
                            | intMathExpression NOT_EQUAL intMathExpression { $$ = $1 != $3; printf("Logical: intMathExpression NOT_EQUAL intMathExpression \n"); }

floatLogicalExpression      : floatMathExpression GREATER floatMathExpression { $$ = $1 > $3; printf("Logical: floatMathExpression GREATER floatMathExpression \n"); }
                            | floatMathExpression LESS floatMathExpression { $$ = $1 < $3; printf("Logical: floatMathExpression LESS floatMathExpression \n"); }
                            | floatMathExpression GREATER_EQUAL floatMathExpression { $$ = $1 >= $3; printf("Logical: floatMathExpression GREATER_EQUAL floatMathExpression \n"); }
                            | floatMathExpression LESS_EQUAL floatMathExpression { $$ = $1 <= $3; printf("Logical: floatMathExpression LESS_EQUAL floatMathExpression \n"); }
                            | floatMathExpression EQUAL floatMathExpression { $$ = $1 == $3; printf("Logical: floatMathExpression EQUAL floatMathExpression \n"); }
                            | floatMathExpression NOT_EQUAL floatMathExpression { $$ = $1 != $3; printf("Logical: floatMathExpression NOT_EQUAL floatMathExpression \n"); }

stringLogicalExpression     : stringExpression EQUAL stringExpression { $$ = (strcmp($1, $3) == 0); printf("Logical: stringExpression EQUAL stringExpression \n"); }
                            | stringExpression NOT_EQUAL stringExpression { $$ = (strcmp($1, $3) != 0); printf("Logical: stringExpression NOT_EQUAL stringExpression \n"); }

parenLogicalExpression      : LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS { $$ = $2; printf("Logical: LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS \n"); }


ifStatement                           : IF {ifStatementBegin();} LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS 
                                        LEFT_CURLY_BRACE {scope+=1;} blockStatements RIGHT_CURLY_BRACE {printTable("\nIF STATEMENT ENDED", scope); removeScope(scope); scope-=1; ifStatementEnd(); printf("ifStatement \n");}
                                      | IF {ifStatementBegin();} LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS 
                                        LEFT_CURLY_BRACE {scope+=1;} blockStatements RIGHT_CURLY_BRACE {printTable("\nIF STATEMENT ENDED", scope); removeScope(scope); scope-=1; ifStatementEnd();} 
                                        ELSE {ifStatementElseBegin();} LEFT_CURLY_BRACE {scope+=1;} blockStatements RIGHT_CURLY_BRACE {printTable("\nELSE STATEMENT ENDED", scope); removeScope(scope); scope-=1; ifStatementElseEnd(); printf("if-else-Statement \n");}
                                    
                                    /* TODO: ifelse expression??*/
    



whileStatement  : WHILE LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS LEFT_CURLY_BRACE {scope+=1;} blockStatements RIGHT_CURLY_BRACE {printTable("\nWHILE STATEMENT ENDED", scope); removeScope(scope); scope-=1; printf("whileStatement \n");}

repeatStatement : REPEAT LEFT_CURLY_BRACE {scope+=1;} blockStatements RIGHT_CURLY_BRACE UNTIL LEFT_PARENTHESIS logicalExpression RIGHT_PARENTHESIS {printTable("\nREPEAT STATEMENT ENDED", scope); removeScope(scope); scope-=1; printf("repeatStatement \n");}

forAssignment   : IDENTIFIER ASSIGN intMathExpression {printf("forAssignment \n");}
                | IDENTIFIER ASSIGN floatMathExpression {printf("forAssignment \n");}
                | IDENTIFIER ASSIGN stringExpression {printf("forAssignment \n");}
                | IDENTIFIER ASSIGN BOOL_LITERAL {printf("forAssignment \n");}
                | IDENTIFIER INCREMENT
                | IDENTIFIER DECREMENT

forDeclaration  : IDENTIFIER ASSIGN intMathExpression ';' {printf("forDeclaration \n");}
                | IDENTIFIER ASSIGN floatMathExpression ';' {printf("forDeclaration \n");}
                | IDENTIFIER ASSIGN stringExpression ';' {printf("forDeclaration \n");}
                | IDENTIFIER ASSIGN BOOL_LITERAL ';' {printf("forDeclaration \n");}
                | assignVariableDeclaration

forStatement    : FOR LEFT_PARENTHESIS {scope+=1;} forDeclaration logicalExpression ';' forAssignment RIGHT_PARENTHESIS LEFT_CURLY_BRACE blockStatements RIGHT_CURLY_BRACE {printTable("\nFOR STATEMENT ENDED", scope); removeScope(scope); scope-=1; printf("forStatement \n");}


switchStatement : SWITCH LEFT_PARENTHESIS IDENTIFIER RIGHT_PARENTHESIS LEFT_CURLY_BRACE {scope+=1;} caseStatement RIGHT_CURLY_BRACE {printTable("\nSWITCH STATEMENT ENDED", scope); removeScope(scope); scope-=1; printf("switchStatement \n");} 


caseStatement   : CASE values ':' blockStatements BREAK ';' caseStatement 
                | CASE values ':' blockStatements BREAK ';'
                | DEFAULT ':' blockStatements BREAK ';'
                | /* empty */


enumIdentifiers : IDENTIFIER ',' enumIdentifiers
                | IDENTIFIER
                

enumStatement   : ENUM IDENTIFIER LEFT_CURLY_BRACE {scope+=1;} enumIdentifiers RIGHT_CURLY_BRACE {printTable("\nENUM STATEMENT ENDED", scope); removeScope(scope); scope-=1; printf("enumStatement \n");}


functionStatement : FUNCTION IDENTIFIER LEFT_PARENTHESIS {scope+=1;} parameter RIGHT_PARENTHESIS LEFT_CURLY_BRACE blockStatements RIGHT_CURLY_BRACE {printTable("\nFUNCTION ENDED", scope); removeScope(scope); scope-=1; printf("functionStatement \n");}
//                  | FUNCTION IDENTIFIER LEFT_PARENTHESIS {scope+=1;} RIGHT_PARENTHESIS LEFT_CURLY_BRACE blockStatements RIGHT_CURLY_BRACE {printTable("\nFUNCTION ENDED", scope); removeScope(scope); scope-=1; printf("functionStatement \n");}


parameter       : noSemiColumnVariableDeclarationStatement ',' parameter
                | noSemiColumnVariableDeclarationStatement
                | noSemiColumnConstDeclaration ',' parameter
                | noSemiColumnConstDeclaration
                | /* empty */

returnStatement : RETURN argument ';' {printf("returnStatement \n");}
                | RETURN ';' {printf("returnStatement \n");}

continueBreakStatement  : BREAK ';' {printf("breakStatement \n");}
                | BREAK IDENTIFIER ';' {printf("breakStatement \n");}
                | BREAK {printf("breakStatement \n");}
                | CONTINUE ';' {printf("continueStatement \n");}
                | CONTINUE IDENTIFIER ';' {printf("continueStatement \n");}
                | CONTINUE {printf("continueStatement \n");}
               


printStatement  : PRINT LEFT_PARENTHESIS argument RIGHT_PARENTHESIS ';' {printf("printStatement \n");}
                | PRINT LEFT_PARENTHESIS RIGHT_PARENTHESIS ';' {printf("printStatement \n");}

functionCallStatement   : IDENTIFIER LEFT_PARENTHESIS argument RIGHT_PARENTHESIS ';' {printf("functionCall \n");}
                | IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS ';' {printf("functionCall \n");}

argument        : expression ',' argument
                | expression


comment         : COMMENT {printf("comment \n");}

main            : MAIN {createLabel("MAIN");} LEFT_PARENTHESIS RIGHT_PARENTHESIS LEFT_CURLY_BRACE {scope+=1;} blockStatements RIGHT_CURLY_BRACE {printTable("\nMAIN FUNCTION ENDED", scope); removeScope(scope); scope-=1; printf("main \n");}

%%

int yyerror(const char* s)
{
  fprintf(stderr, "%s\n",s);
  return 1;
}

int main(void)
{
  FILE *file = fopen("finalQuads.txt", "w");
  if (file == NULL) {
      printf("Failed to open the file.\n");
      return 1;
  }
  fclose(file);
  FILE *pfile = fopen("parseTable.txt", "w");
  if (pfile == NULL) {
      printf("Failed to open the file.\n");
      return 1;
  }
  fclose(pfile);
  // Close the file to clear its contents
  
  initializeSymbolTable();
  yyparse();
//  printTable();
  return 0;
}